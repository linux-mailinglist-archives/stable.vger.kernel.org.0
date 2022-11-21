Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17077631D05
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 10:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKUJle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 04:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiKUJld (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 04:41:33 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C67492B62
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:41:32 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id io19so10079022plb.8
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBmVpxWlFwz71LnJc5cnHgJ90wlsg+VB/8BW+pshAAQ=;
        b=WYZMKxVd3zy9KIZ5y7QKsE3uZWM/MBJlzwhyRuKczyyggckB+9stzIpBloyceL6div
         CmB/N4imuF/AaV8oJEPGA1iMEGfWxgVaHVtXL/ibE/IROiHxrwjzX8rYUkHxkYbUkK1y
         a3Plf6lJLD49kOlPnZTXz7pl/zSU1ATNf5t747SyeWAwQlTPdusIJlxIFQRrvGh9xIwu
         61C+KfY4pMkCXfFf4EnIuGBb8c7ZckHLfTjJ/Tr62t8pEjrIwJ+C+SasoS9U6toK+qe6
         29mjxV5ewwxPE+1BEjs4pRutVE2SYde52WPt4BryPRD+rNvNdORjnq0Rhgc59i3IE2ax
         3WnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BBmVpxWlFwz71LnJc5cnHgJ90wlsg+VB/8BW+pshAAQ=;
        b=1o/u8IxW2ynY9lowlFLtiMIIjY7RSu82zf2mDBQ0AQVZI8wjlLeNvmQQfeFCMsRIYt
         xakM+7/jo+FSnopMaTqSWFai6BDKhdDT/iza75nGLj1Axf0Q75ltzcLbhr2N2qaAs4i5
         l9hphWULjlq50p0UQ5qsB5l1QBu8cSZT5UeZm0eeFituRH3gkLBQzq/Zc1C2TPVctqBy
         7rpqU5cl0Hzit97KXhwQA9LdcMrKyOQGxIzp2L5AHnqJK40k2G0yZo7j6zGIlUkn8QYB
         KLsaGUwdd/zZ9wW56GO3CXPGtE/wVHACDT5yxHTbcwGUAziz5OOCTl/IA+nEGpqn1rbA
         tH+w==
X-Gm-Message-State: ANoB5pk2FwJw/F0CrejUcj0hFhntvFHG+aTkfNOLX/Su2SY/S5wrIeAd
        OLCcj83rcdnOmyjZT0KIs/sb81e3SEiwjQF/Sto=
X-Google-Smtp-Source: AA0mqf6Jsa1q3CgbiW2pFvROdLHLGKRKGCohX+6V6jDAfK398xzIQ5QEML2QVNcw/NIR2eoZt2ty16WNSQm1ZCBk7Yg=
X-Received: by 2002:a17:902:7683:b0:186:9fc8:6672 with SMTP id
 m3-20020a170902768300b001869fc86672mr1402450pll.65.1669023692141; Mon, 21 Nov
 2022 01:41:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7022:323:b0:46:da2f:f579 with HTTP; Mon, 21 Nov 2022
 01:41:31 -0800 (PST)
Reply-To: sgtkaylla202@gmail.com
From:   Kayla Manthey <gnidignonvalentin7@gmail.com>
Date:   Mon, 21 Nov 2022 09:41:31 +0000
Message-ID: <CAOcq9doJZdaj9YOWy5QjGeaiMHF322+926YXJ_sRS1=T4h1_jQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo schat, heb je mijn vorige bericht ontvangen, dank je.
