Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117BA66A180
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 19:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjAMSG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 13:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjAMSGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 13:06:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36DA88DC2;
        Fri, 13 Jan 2023 10:00:28 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so25126326pjj.4;
        Fri, 13 Jan 2023 10:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ke+ienpbuFMxWDqjTnzXxB3ry8pENDQ07EXrRNlGZRU=;
        b=G4mb5qnn4HfOwTQSLovmIewgur6Z96/xjlZ65HdfRB6f2xMA/vWIG2wfw1hr/nChzS
         32mtz828+E3K1bvLflqWdRmy0wfFDWozd/JVNxGYwmb67dRwQcvMoXeHIkApxPC1ciV4
         xnOFtj3ivERLFS6jWb8onr2C88Y/xWlloQ0YyY/W9rOqQ2RLjG7PhlWgW8BGFQrjB/ys
         dCdAk48N7hYKuys2+fHRPDcoJVETA1aV7P2h+8xuIhTmZyKz8LQL8WSTzhEBtfhSulFT
         JGYr2k/kqidqhdCcz2tjlO2S+602+Lw17Xn5BkX8okNNCMqzGwL+8GXZ8dTPp6mlUxIT
         7fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ke+ienpbuFMxWDqjTnzXxB3ry8pENDQ07EXrRNlGZRU=;
        b=B2hwOOjeWEIYVAzrPFY17w+tMLZR8L+kKQ2SvgxkEaR48AWV8P+55A8oYxzEZxA09m
         Xmykm1Mg2O7Xqca8/Vr/3KLqgWiYYiR+pCsgEJziiqgZUXZHqLho2HFYBVhqRtiTPysa
         s/ei8qi7Ibl6PYNvFpuObkil0Vovel3rPYjlH+XyDIws1Bov6XuP435A9Iiy2z3zz6TJ
         QZyKWSMzpomMc6JQf0n0Ec/7pFTbbnLybFjc7QtFwVc+/hPHB6aomIPjvqjbaJtORUHJ
         0iTI8B6BpvTYSRP//p7JD4+HWVX1xkABuPmN35+2wTImhNCTAZuBvQm2eMD8J3o6kCj6
         9KPA==
X-Gm-Message-State: AFqh2kqlqOcokfs4eS57efLKAQnySwtuAx3maYYODxOsEHBCqZ5/cUhg
        oGDVijHMUEK3MckaI+q4HaaBGLi8AU2Y1X3VN1Q=
X-Google-Smtp-Source: AMrXdXtuNPALzE7NjD8Ef7TcmxoiFQT7MKvPY5Hl4JnizFCF7SPgtbZ9kns/CvMJX0BoxyRA3C9dvaWBsCeg4s6vep8=
X-Received: by 2002:a17:902:e786:b0:189:8f97:5f14 with SMTP id
 cp6-20020a170902e78600b001898f975f14mr34180plb.49.1673632828199; Fri, 13 Jan
 2023 10:00:28 -0800 (PST)
MIME-Version: 1.0
References: <20230112135326.689857506@linuxfoundation.org>
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 13 Jan 2023 10:00:17 -0800
Message-ID: <CAJq+SaDOEUqfp-dK_TibbXwT9zfuFf8bgeR3BeWsCpTEOJz9aA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
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

> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
