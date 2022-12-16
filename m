Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E007864E929
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 11:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLPKJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 05:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiLPKJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 05:09:37 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54FD186DD;
        Fri, 16 Dec 2022 02:09:36 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 21so1455239pfw.4;
        Fri, 16 Dec 2022 02:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tMaMBgsq8eORmfV8+PIZjBPcmOMr4lsOOptzTq8e43g=;
        b=HNeS5nga8gqWPiRg5c33ua5opBuG1voX7d2wARSpZlPpoCxXjvcQTgIfgSO33sw97h
         7pSj3NvlJCgGkUriue23ShhsBZjkRUxT54GxUvecaT30u6u6XWLs6JgFNcLRaETrPD2p
         JGcSGNBBaHCB1KyvzRofUJPpKHbCXPCsHRDGm7Tgym1iypjZFpB+3JV63eAh8pb7H/HL
         8zDfyzKTx6z8cxo2yrVEPPgugTbTNBRDgqbVvS/rAFgSGSq3A7BgYHt9HY2W6nX6/cX6
         LDfT/KHhC7XmLmDyFZf5Wkk5AdKPRznp+hk/pegPHUS6JRYs0h+8XVdpK0YtzWWhhlmY
         tCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMaMBgsq8eORmfV8+PIZjBPcmOMr4lsOOptzTq8e43g=;
        b=M+xR9n0zYsl5HryhItssn7HuifwP/e9wqgXP0twJAJ2dyMyzOmYZ/QLglAL4jQWqKX
         FTOgQvZKeQkAdcAU4kNZyw+oEgxjIG4sdH1NgO3u97pw/ld/yi/zuUi3tRWDqVLsFdsr
         oZydxZKkWcpr/xJYselwlx//OUV+MEMgi+epSd5ZI+tVN0FkfHdU/xCUxEc2hlDnHafs
         u7+tXpnQDyptQXxrWk1kRlxAL1gBM85pXSNh3qHJS2x2IdYquaxRP/6v3hBTfgpvlELK
         4B+78lstqzWwAzGrycwbbOsAAGqqc7q8v4ZJQ4NChjApAcNtpGzG5e0n+zTo8xIw2vCB
         ekiA==
X-Gm-Message-State: ANoB5pmny95VEQC4G3lTM3ZW4CRXMCkE0il/3o5qBU9jYWNNV4j2+7dH
        oKXcdmlzNRdb7PyFOEZ5rUYBeP9PhYkQA8ncAVM=
X-Google-Smtp-Source: AA0mqf4B3jGP7Pqepv0U9EHWK/kucZRuZDgnIaca7zxhv27TtAd0Ky/vXd5PzVkM3rXw1h5g/QNQ2KYoJw5GQeZN7mE=
X-Received: by 2002:a63:ff62:0:b0:476:898c:ded8 with SMTP id
 s34-20020a63ff62000000b00476898cded8mr78680687pgk.251.1671185376169; Fri, 16
 Dec 2022 02:09:36 -0800 (PST)
MIME-Version: 1.0
References: <20221215172906.338769943@linuxfoundation.org>
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 16 Dec 2022 02:09:25 -0800
Message-ID: <CAJq+SaCYJDGyQW-EFj3H3mD0uumCHGz5HfL=c0SS=NB+yWkt5A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
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

> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.84-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
