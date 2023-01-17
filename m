Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2DB66E032
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 15:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjAQOT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 09:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjAQOTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 09:19:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9767F3C2A6;
        Tue, 17 Jan 2023 06:19:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id dw9so31085515pjb.5;
        Tue, 17 Jan 2023 06:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l+gG5SAYt1RkPg1LOSIKLTdG82d5Mlvgl0CxibdSrVA=;
        b=M0DAL0eP+0MMc+Sj5+9iTxoAgGR6bc1hH4UJe9FbO7Bmk+MXfm+Ktp5JkAar2IfJ+E
         +zlTV5Nij1/bJg6nQptfUKvRurMn1QExlfXinu7oYcG+8XQZwpcJWJMjgwqErAVJ2Xif
         Fgg6q0JRqPUAkU5TsVucjEQBcR6jmkUz2CPsRJmNWioufTRr+bscrXidShQ9tmwd/bDc
         tPS7I/etd9so6t8DGBoT0x4Z60F4qplyNVXZ1klZgjCiX+cVEx73JQbIdxq/7ZSPE7D6
         x1udVIAfxDLur6x2DgZ+yP1NjpzZcTEp/AnNIaLq12mJlGUAEUSi0ReiS/cssVEBlV0L
         4HDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+gG5SAYt1RkPg1LOSIKLTdG82d5Mlvgl0CxibdSrVA=;
        b=VN0JEc/TSmNNk8F1++SslJog8TZ0yx01IGSz3bPDtE7p2A7WitFfwDCuzfVth8OKmI
         hB8T+f93TlHcI5qOEh88DxuFrju9RruNOqM4raqAgSsi1l9RbupU7kpxhivk5pQifTac
         Z1hTLeBgfpmBIhqEDYK4Src2qnYSM25BqOtKVi3ucD/052duCpyogL6pF8Q3oedIG0TP
         r7fhcsqHGMZ/6LBrFA73MROedQLKCtcq+PH4wsrPUeU1e7H6JfUwKnm5qFuCVCeeFPCm
         5ltVjtgzOhpVNqS5noB3nkX7iWRDIhvQbZhy0Te830aQZ+NS78FE4ziKvwFfgCzsA9kS
         bO4g==
X-Gm-Message-State: AFqh2kpCcadT/vnTTc57iDMXue3TOIs3KDLN/luGCFURGfx61yVLDjKf
        0Yg7d7BPdHpgUtagBd423kNVqrbNLeDJ2bd2FyY=
X-Google-Smtp-Source: AMrXdXs2NfXMWu0i7Gi5AloLWuLxgQ0AAJX8RPUvH+prS4pPWCHYgwdrlKbKN341M7bGjGiEOhZFmImG4rlv4cz39uw=
X-Received: by 2002:a17:902:d4cb:b0:194:87f2:3b5a with SMTP id
 o11-20020a170902d4cb00b0019487f23b5amr243227plg.52.1673965188113; Tue, 17 Jan
 2023 06:19:48 -0800 (PST)
MIME-Version: 1.0
References: <20230117124546.116438951@linuxfoundation.org>
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 17 Jan 2023 06:19:37 -0800
Message-ID: <CAJq+SaBzukOtzmstnfSED1MOk8QyH_9wrmTZqvsL_1St-Vds2Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
