Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A998C515304
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 19:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbiD2R5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 13:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiD2R5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 13:57:08 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC451D371C
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:53:49 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id g6so16859177ejw.1
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=VeSwcADp1d8CjPJu4kTyhteU3/qgNEdJx6FEacbXpkx/q9V5m71C4DAclWj9MTxckw
         hPhpuQEiSzh4GJi2IpzIHYkNf90UqLpLDxBk9viGG0JoLAHwBmrlBQ9+01tS2LzoA/TE
         PUer8SGL2hjsKQRZ19ZsLqK/mg082O3Twi5bntnJWr/VXMM/l6ZeiiXTnFphYoj1vWCc
         LgmWJmxuLBfvnDlhq1WjrjoKlVGM14LsTSuMfsVzhQbEkS+fPZNVvjZa1MLN2Qchk5rM
         ITYbFpnAew38tsb1hEjA838YrC0dgI3z4bxyFJbv1+Srd7GrLcdvo9v6CVIPLwg/uiue
         Q1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=DxNazIRDiReUR7cyw2qQWXw5tgJtuBGm2+84DlwpyMZJHgEDlkWAD69nPmNxp0VbAd
         8lvIskWt0XtzgWrZvnwvcuzykaeYeGut7SwC5/64hOAWJQ47BGrmBRvuF0Qdu7lwXZJB
         mqR1Kxn+BjIWFwaXy5wYe4GatOgr7c2Vb7npPO01pg9QPOGg8DQloxP2yVd9zxJxiMDq
         pWEdk1bqyzleJLtT33GA7naMV5zRnupyRc4o1156YM/cVQXFZD10+XMWOnT83UYKQb3B
         uwR9Qj1P4rKJ4de2hcOsjYla/27HDhmMXm3eJ6AprQju3G7u46cqxK5adsdjk4on2Y5h
         1DAw==
X-Gm-Message-State: AOAM5326TL1hTImiTwfqAnkp77f0dHRgBKCVTvT8GwWsTkB+rzwKs2i3
        Vd6nWckAjvEzEFL2sPFTMNwWUOOT8nczstr+itc=
X-Google-Smtp-Source: ABdhPJwvnJrAcOpf4cIvA3Q8IO4irkURlNw+Ho5oGMVwphZ6ybPYeEfyK5T5aFN3ZYwkJ/WjwZBHfhmaQuhZnqyN+6M=
X-Received: by 2002:a17:906:a089:b0:6ef:e9e6:1368 with SMTP id
 q9-20020a170906a08900b006efe9e61368mr456088ejy.626.1651254828583; Fri, 29 Apr
 2022 10:53:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a741:0:0:0:0:0 with HTTP; Fri, 29 Apr 2022 10:53:48
 -0700 (PDT)
Reply-To: abrahamamesse@outlook.com
From:   Abraham Amesse <gmark3575@gmail.com>
Date:   Fri, 29 Apr 2022 17:53:48 +0000
Message-ID: <CAPG1wpMRTz280idYXZeUqQf+60H096hsaSgRs+LyekY=RnD19w@mail.gmail.com>
Subject: //////////Greeting,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have very important information to give you, but first I must tell
with your confidence before reviewing it because it can cause my work,
so I need someone I can trust to I can check the secret
