Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C825B599F
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 13:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiILLtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 07:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiILLtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 07:49:10 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF033CBDA
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 04:49:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id lc7so19638867ejb.0
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 04:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=qSiHGQwSF4H1acppqgRl/aDkcrn+tJIfteGYGTldDX0=;
        b=LLYlpAXH6Wwmrs9tBy//FpwRO/Bxg89/e4np+Da5QLTbSFfm5rLv8XRSe51uqnzJYX
         2Hc4lBFDAi3vh5t9auiWvB6wFSbENeTP8vwBKcGRuNI8YIqR0qgyb+kxwibuht2hNORE
         FnY1uoeH0l/iMOneEAFQG+c6mtESJh1GTp91RzBvXInha9A75GkTj6PiKZ4jfEn35mlH
         oDvqG9F9hlBv8rtAQY16rUnYzn6mGMZep7WZKhrzhTf248EBgXrFfDEYT+m2Kq6mK1ac
         50wCtsx2vJCbdILarryLN7QxaAi7+IZSr3qmUPA4of/sNxGDbBqznn7TZ38n1uxVukwb
         y8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=qSiHGQwSF4H1acppqgRl/aDkcrn+tJIfteGYGTldDX0=;
        b=VdNY4mk5vVLfqsck30kzkBVkItvwHVbLVjsOG8vN39l/9aQukAiVRQv7ZpdTvR0niM
         c1/aUOjsx7MA9KOeiuCR0WPyz2MgXkx5ftewHAdyTdM665V/toVKlGAa9ukWGcncpXvo
         PEXS8wuPcd4VWEDSheB5DiZ9hm+HKpEM+x9Tm0bBBVboppGQUBj6EgiDlu8FN6R+ZEFd
         fEcrLj3HvwYyZdcv3tCAyIVdM4ip1eVNjxfgxygWRtSeIdwxlEvHzwajoeFKdd6jtS5/
         v84T/eoKRPc4w+d8TWMIka6tmRaczLIvlKN6KWBnj2gUOo886Uuh3z/pvbsfL4tbhEZE
         pC0w==
X-Gm-Message-State: ACgBeo1Dn3RolSuUH5UW/tMvdHyWbJ2IdLrNbnamVHK7WTv6SAa3e8dz
        wD4lx1cYHTU7774pEyZ3+JSZ+VGNOpI=
X-Google-Smtp-Source: AA6agR4vcMbfVP7AaP2bLIxrGMjCe+/kp0Us3qxGZ1HFiDD/pMJ6Qe6DJxZA7N19GW5NFHL4FNAKAg==
X-Received: by 2002:a17:907:80d:b0:73d:1e3f:3d83 with SMTP id wv13-20020a170907080d00b0073d1e3f3d83mr17833056ejb.372.1662983347426;
        Mon, 12 Sep 2022 04:49:07 -0700 (PDT)
Received: from caracal.museclub.art (erm103.goemobile.de. [134.76.0.103])
        by smtp.googlemail.com with ESMTPSA id p1-20020a17090653c100b0077f5e96129fsm436135ejo.158.2022.09.12.04.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 04:49:06 -0700 (PDT)
From:   Eugene Shalygin <eugene.shalygin@gmail.com>
To:     stable@vger.kernel.org
Cc:     Eugene Shalygin <eugene.shalygin@gmail.com>
Subject: [PATCH 0/1] hwmon: (asus-ec-sensors) autoload module via DMI data
Date:   Mon, 12 Sep 2022 13:48:41 +0200
Message-Id: <20220912114842.762355-1-eugene.shalygin@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport of the 99abb0468cc8 onto the 5.19 branch.

Eugene Shalygin (1):
  hwmon: (asus-ec-sensors) autoload module via DMI data

 drivers/hwmon/asus-ec-sensors.c | 341 +++++++++++++++++---------------
 1 file changed, 187 insertions(+), 154 deletions(-)

-- 
2.37.3

