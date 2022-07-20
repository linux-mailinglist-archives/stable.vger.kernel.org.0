Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4F657B077
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 07:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiGTFoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 01:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGTFn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 01:43:59 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C624B6C114
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:43:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id os14so31132990ejb.4
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dbyswNwIjdAqkYgJsBmWX4vhM+Drfb0+RLc9y4Y7d4U=;
        b=ATRQyWwrL/262JK7axSJbKWvHJPj7MwZM3y5om5qv4mXL0i0aAg+gc7Y8rKdPoaKIc
         Ig/wfWnX1DpB3bFTmaTU/D9nW4NBnJEXjhh9gF3WcnKOC7Wtasf5BWJNG6vZjAe7DnFI
         d2yb6TF8vDv8Mz/UchSyWet+aPUWVks2UA2GDsWYTxayGXhnpotUfXXRT1pPl5lvTUW6
         nFgftBdK5XLsN7YR7yIyL5YJ927Up7fI8vyZRtS8+tzluEFBri8fRDTaSQzob6c4KxzV
         Qp7eCp9UolhgEgb/WIQaZGtA3pnl5vPK3CXW61QCRhbcEO1ICGs8ZuNpriIhnUmkKDY0
         vkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dbyswNwIjdAqkYgJsBmWX4vhM+Drfb0+RLc9y4Y7d4U=;
        b=dC4jHnFRVHBXVzfjjfFu/mmZozM2nCKUZwfw6oFT6k5e6dEClBcpGoF0p/vWSM9BYm
         ED9PG+AqloTPa5wE8o+ksjxwChuHkt1fFWHIlMKCCfX5Ii6Qyp1WxUZfsK2z7T/jZ/Z0
         W1CfKLh198lLYC8diV2dRPR6R3xqqVkmIGUC2xIi8ihKd64bOiO/CWx9z79fbf7QKi2g
         opv9AGaHe0vUVXFvikebLADVPW0xJMSna1BXbBP2glVeyI8nlHnLVN56vRYLRw8HKVVV
         pje+AXxQQrO4AWKwm14h1W9aHSmZAzXSADA2vv2GhzyH5Fas7ZUGANClqIJ9WBjks0Ym
         kbpA==
X-Gm-Message-State: AJIora/KxpjEd+6CPhFVu2WjXGMNWuJ9xpWwxhCmpd3tRj/C60dHA7Cv
        MXJii+MuSiU7tWTQfg2koDH3XUMxwxY=
X-Google-Smtp-Source: AGRyM1tGKmM5KgAuER+Q5fb4nEXezfbTezzrXwR5v9rg3lRMxsmNfsWUD3LOIzycdeMVY6zhlvG2Zw==
X-Received: by 2002:a17:906:98c9:b0:72b:40de:9afe with SMTP id zd9-20020a17090698c900b0072b40de9afemr34580786ejb.620.1658295836994;
        Tue, 19 Jul 2022 22:43:56 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id dy20-20020a05640231f400b0043ba1798785sm1776144edb.57.2022.07.19.22.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 22:43:56 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH v3 5.18 0/2] Backport support for Telit FN980 v1 and FN990
Date:   Wed, 20 Jul 2022 07:43:39 +0200
Message-Id: <20220720054341.542391-1-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
these two patches are the backport for 5.18.y of the following commits:

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2
    bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revisio

commit 77fc41204734042861210b9d05338c9b8360affb
    bus: mhi: host: pci_generic: add Telit FN990

The cherry-pick of the original commits don't apply because the commit
89ad19bea649 (bus: mhi: host: pci_generic: Sort mhi_pci_id_table based
on the PID, 2022-04-11) was not cherry-picked. Another solution is to
cherry-pick those three commits all togheter.

Thanks!

v3:
- fixed typo in the cover letter 3.18.y -> 5.18.y
v2:
- fixed my email

Daniele Palmas (2):
  bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
  bus: mhi: host: pci_generic: add Telit FN990

 drivers/bus/mhi/pci_generic.c | 79 +++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

-- 
2.37.1

