Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D916AAAF3
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 16:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCDPyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 10:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDPyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 10:54:06 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B101B1026E
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 07:54:05 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id k37so3282463wms.0
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 07:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677945244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jsepL0tvWvLyn3/LsFMVSsF0JgTexm6WZnv5HSKWLi8=;
        b=bq3hRRdhVN4W4S3cGVUc48hBUnT+7mQMay/c5pNi1PHnFBgN7UIqFOs/zycE437s0x
         xEjvJEz+PGysoUNpLmGy4opiDWbcEaCH6393n0T3hCHWX0F1GHAr4EFPD8bQeKeqFdIb
         YZFuRCAJbM9dTvho8GgafJvY5vAhnw15FGWO23Ifjji3QKBmbH/gVW1WKBfuPpWMwMkv
         ulWT/vrLkHewlB69uF39AVNb3/vmbQBCqScZ4B5G6UVBNB1pZgq1+u6zkWNJ6UcBMZT8
         5yPp9dxZvFGrIY60nY4tP/3JHCZe/Bf/2sUOi81RDsq2Zz3TYKCY8/rYxC/yBm5pRNgJ
         p3xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677945244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jsepL0tvWvLyn3/LsFMVSsF0JgTexm6WZnv5HSKWLi8=;
        b=JWucabMaMFkp5BcHeAgf+UBu6bI55jismFwJ5idcxWThc+oTCnXOE3LsjqE+XDtOfV
         yOzeUhr271ns7NnSnJY6n8dJLof97zuMNs+KUwnqmiP48o8aPtblD0jQr0Kdi/I8s9AQ
         h0H7b5MDw80hTMx4np6lG31TnMu4wjUnxcdw77/l2+x7Rlshxburd3H0t7PD9fNJ5GC4
         +2nYMCA9JNuS+XKgA1y+Gr5/7HAYPm+WCiWaFp7RPtwpD2FAc41QrO8XZfrjfanXfPhv
         FYuqPFzNL1ImnCsjZa1EHKoffkeBp7NiJSFL+OmqUNZQlepCHbXbAT7G1HXj0iB75xQg
         ePiQ==
X-Gm-Message-State: AO0yUKWgT5d6sQXEbGBeJ/3Tsgoxt80Xp7dup4PJycIOyXKCkojO58+9
        rXfR4gR7DNID1hzNEikgrbganV9FGG76D355bZZnO2PdHiA=
X-Google-Smtp-Source: AK7set8ps9y5m4K1FLPZRrU0txATHmkv/mGn81Up3y4JGYSyi54mASm1sWXN4KfwTD9pMM6P4j+vKsAeIKG0aMp42bI=
X-Received: by 2002:a05:600c:181d:b0:3e1:bfc:d1c3 with SMTP id
 n29-20020a05600c181d00b003e10bfcd1c3mr1028824wmp.5.1677945243872; Sat, 04 Mar
 2023 07:54:03 -0800 (PST)
MIME-Version: 1.0
References: <CAB1LBmv1kY+kuUBWvXRoe+mbQBjtJOFvZB8Smmbcuy2MdvgJnA@mail.gmail.com>
In-Reply-To: <CAB1LBmv1kY+kuUBWvXRoe+mbQBjtJOFvZB8Smmbcuy2MdvgJnA@mail.gmail.com>
From:   Laurent Lyaudet <laurent.lyaudet@gmail.com>
Date:   Sat, 4 Mar 2023 16:53:53 +0100
Message-ID: <CAB1LBmsBGFDLoKZHUZCLHDvHb68eOfc-W+W9hQXbXkqRB7Uykw@mail.gmail.com>
Subject: Re: Too many BDL entries regression
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I filled a bug report to Ubuntu also :
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2009271
It should contain all the data about my hardware :)

Best regards,
    Laurent Lyaudet




Le sam. 4 mars 2023 =C3=A0 16:41, Laurent Lyaudet
<laurent.lyaudet@gmail.com> a =C3=A9crit :
>
> Hello,
>
> Thanks for your hard work :)
> Ubuntu 22.10 shipped kernel 5.19.0-35 thursday.
> And some people started having syslogs :
> "Too many BDL entries"
> https://askubuntu.com/questions/1457367/snd-hda-intel-0000001f-3-too-many=
-bdl-entries-messages-in-system-log
>
> I looked here how to report it :
> https://docs.kernel.org/admin-guide/reporting-issues.html
> and searched for "Too many BDL entries" but found nothing
>
> I looked at versions here :
> https://kernel.org/
> but I don't know if version 5.19 should be reported at
> stable@vger.kernel.org
> since it is in between
> 5.15.98
> and 6.1.15
> or maybe Ubuntu does some renumbering ?
>
> Excuse me if my report does not contain all needed data,
> or should be addressed elsewhere.
> Sorry if I cannot do all the checks with latest kernel ;
> my current laptop is my only PC for work,
> and I would prefer to avoid breaking it, even for a day or two.
>
> Nevertheless, I would be happy to provide log extracts or other
> information that may help.
>
> Have a nice week-end, best regards,
>     Laurent Lyaudet
