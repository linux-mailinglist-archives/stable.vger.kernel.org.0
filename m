Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EFE53C96C
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbiFCLc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 07:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiFCLcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 07:32:25 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EC56568
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 04:32:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id p10so10019688wrg.12
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 04:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=PaEzrm9U0WjJMxkE+zbw8yGRv0uhjcRl9sFl9vmbKpk=;
        b=FCV+OIy/Wx2HQfBelSHclCEHrmLV1q9nPsd3TSpRNimW2BmY1dOG4/RHKkp1vD4Rqw
         5eEZka5uCgLjEsXbWmtv82/O6sT3WikdNNZY2eybINdHx6yL3ceQTa+pMz3GVAjRKUvs
         M8leXmdb2eKa5Mz9PjXXEc0P5s35MQEVV3jOddL35uBz36qBeoyDKVfFhWrjXrhixvsO
         VGS3CZJQl6izb7l+pjeGWiqAmP0iKNiGvmdp+ibDgKpljDB8kbDZCptl5SR8USV21yxt
         uJOY7wlxFeKjBr38v+yZWKeV6sm4ykhDVFaIY6JvehEmAcE5tqGpkiJFFzH9Iwt8E1cW
         hklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=PaEzrm9U0WjJMxkE+zbw8yGRv0uhjcRl9sFl9vmbKpk=;
        b=gDs2kNet4uGckas4PKM4Q8Zk+ezrODY9bn4YPgYE50pGkblgAGgNoDUogqxP2ju16T
         BpmjbwsFUg0TMZCrtehiByX+pq8q+o95gIlW4kORVsb7qIOEcwFda8BZXoG5obFYXaUb
         3A/st/DpB4LIG03djLDO2881RzqlQA6FTXZAls+LN1JMRs8irAwbDNhkOuwrwWlJ86E6
         oxLQwRXDRDK/OqiJnDWJz3JkeiSfuOSeIzCqUDTtN2Vs98Vo70fsWXOxX1TSp/cht0tJ
         GlpliTTEUjfyh0MlX1QaAx4mYrJnL2svu+dD73CfggHbfiqLER49hn+Y88xTQBINofTw
         dBew==
X-Gm-Message-State: AOAM5324L5bo+CDpTGsN4G3uPVy+G/jrsY5QaTemBs7GVwjqUqm2pCLb
        rHArBHNLB23mEupDn7pB4d5YLnma2wjZbz5b0Lo=
X-Google-Smtp-Source: ABdhPJyKgPPNMVB71hHJRoVYAa8Kclk/q5M7fup49P1QOB3alKBq34ochdNydWy9CbxOZmqCKteIeMDHSqDEKHTL2gc=
X-Received: by 2002:adf:d1e9:0:b0:211:7ef1:5ace with SMTP id
 g9-20020adfd1e9000000b002117ef15acemr8143647wrd.282.1654255942613; Fri, 03
 Jun 2022 04:32:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64ed:0:0:0:0:0 with HTTP; Fri, 3 Jun 2022 04:32:22 -0700 (PDT)
Reply-To: markwillima00@gmail.com
From:   Mark <mariamabdul888@gmail.com>
Date:   Fri, 3 Jun 2022 04:32:22 -0700
Message-ID: <CAP9xyD14e6O4QLfyHcQS-bN=o2cRYkuCKt_0K=NoeJmky9FAMw@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Good day,

The HSBC Bank is a financial institution in United Kingdom. We
promotes long-term,sustainable and broad-based economic growth in
developing and emerging countries by providing financial support like
loans and investment to large, small and
medium-sized companies (SMEs) as well as fast-growing enterprises
which in turn helps to create secure and permanent jobs and reduce
poverty.

If you need fund to promotes your business, project(Project Funding),
Loan, planning, budgeting and expansion of your business(s) , do not
hesitate to indicate your interest as we are here to serve you better
by granting your request.


Thank you
Mr:Mark
