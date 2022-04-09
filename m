Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A214FA762
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 13:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbiDILyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 07:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiDILyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 07:54:40 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A233158DB7
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 04:52:34 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y6so10116473plg.2
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 04:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=EB0VDLQnK4rBfy75FPB4DVCcWN6Hyg1TKeO7Xd8MjJ6Jp2GahurSL91zmIkqtjbVEP
         Zt28Vg9BjnEkrURektLsj9GdJCTueRNDd9pj+oXIwrrdL6Mm2YdtjyZzArmmyJ1zlGY1
         IdtHCxPDFD6B+eQEzLibdesb4OY8c8K5yR4eSzcauyeyBpBbXm79Uiy6Jj5gWE2rKgFN
         kvLHhcSPdwyuLEV6j/gyqEjxbQwet117mtjuO4s574PDTJmK1Tat8FlD4kp9SbtvaNsY
         BCEJWSPUqzYB/6NSbZC1LUhRFRd1OzLTTZv0LewTWUK2Qkjr/LHMgrjz5dcfEeLOJxcv
         mZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=4OuxIGSRE3ZhkPPMtJri1QnP41C/nrAhyPXbjSWs0/LHXCqDIzedYCstsG9iIYPRta
         E0pNATuVEdRUe7fmNkfoZDwobOO/0iWLdwNceCrQKiG99IRycAp5m0zf0CvBkV6tWGQb
         vk0cO+2AJu/hvS/Dy1wtRPG9upUWxbjloHiK/JxaEkRivQJjqPUyHGMbrpG9lwtQsQ/q
         0uNVNeX2D/TOGE4j1XmSUwsG1HC55bjDR9NQ46J907713WQ8uydUtX6/NkJ37JIRqAPs
         Mvr6wbedznD8SyxvsfAebLfPUPCVf/C5sx9wO/fyEYLQvpJkRBFcQR0ZNmVhszYQvUST
         61VQ==
X-Gm-Message-State: AOAM532XwCGqa7ERbKO0kEO6y2OnxPeXG8wbIGGSRlXPMxf0PRFQupbF
        yRzd4YqvG6uKuIguKcfsQTAQYBMR7Pqv9FwI0g==
X-Google-Smtp-Source: ABdhPJyP6+Xg3SF5h0lU5YmJNIh8if6S07U4i3/GgD6Qsi519fok8dDboJ1KzXg4sFjneG402w8Bi6D1Zn86q86y1wU=
X-Received: by 2002:a17:90a:9294:b0:1b9:48e9:a030 with SMTP id
 n20-20020a17090a929400b001b948e9a030mr26615884pjo.200.1649505153500; Sat, 09
 Apr 2022 04:52:33 -0700 (PDT)
MIME-Version: 1.0
Sender: alamsalman2000@gmail.com
Received: by 2002:a05:6a20:b713:b0:7b:8f60:6112 with HTTP; Sat, 9 Apr 2022
 04:52:32 -0700 (PDT)
From:   Miss Qing Yu <qing9560yu@gmail.com>
Date:   Sat, 9 Apr 2022 11:52:32 +0000
X-Google-Sender-Auth: 2AXdcUGyM8_PHhn0MOnjTfk1gls
Message-ID: <CALH+dLBYEjXxONBGtgf2wytgB9C_xEqGQQEPkCknAfJYiHRC0A@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MILLION_USD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it with the critical condition am in because all
vaccines has been given to me but to no avian, am a China woman but I
base here in France because am married here and I have no child for my
late husband and now am a widow. My reason of communicating you is
that i have $9.2million USD which was deposited in BNP Paribas Bank
here in France by my late husband which am the next of kin to and I
want you to stand as the replacement beneficiary beneficiary.

Can you handle the process?

Mrs Yu. Ging Yunnan.
