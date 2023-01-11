Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E706661CD
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 18:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjAKR3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 12:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjAKR2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 12:28:05 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4757534771;
        Wed, 11 Jan 2023 09:23:59 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 78so11010283pgb.8;
        Wed, 11 Jan 2023 09:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nws/lrJ/9lnH+CI6+ZqOmrPtXwa6Sor7KBXY1a2tRLo=;
        b=pcQG+G+sXb3AoCMPVQjPSIEMREoOMdNjdA1OEvKV1T6DbXlqBGXgzC21zLlfSFHPT/
         JOSSck60cqBx8sRMqSdKUfcWk6131zEXMN2Y+wQmIlovf5p8eLMKEfKh5twIfBOReo8K
         x7Sd5WTWFhrsYC1JAf6l8gV5zndyb+2Z/XrzCaVLZWaMY08IMqQs3WRh5iMJU59ApG3G
         cyiMxhP05Lt87ueXGo/1w0z8GxMcbHN3jkKL0YA28r8DCC9xYB0ywp5WqoEuJ+gUdPVa
         de58vEZp0sWMsibLLEMQgrQ4jSLBLzN1gSAqkDD4BKKjYzVpSsPSLy0pBOP3m5z+Zs2A
         mPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nws/lrJ/9lnH+CI6+ZqOmrPtXwa6Sor7KBXY1a2tRLo=;
        b=7vDFqiRhQ1DThoF3m8DLn55nKcplsLdPC+xef9t0z/mrZlKRtbyEBIC3zRD2OF7GH3
         wrx9+bIzYW9msKPxzFnSOZbdk/+ZCl9K+JVtsYM3JV6uRbkyQZMCAunYHBzzFk+mrdpA
         k4pYR1RBInYyHKBKQx/b9BiwaQiyyL6r3dzYQwVZfQ8AnE9l8fKgp7M1WDKZRtISPyGz
         y2hzMPflqYqqi86FS0xoB+cz0hS3MiZMQd3f7rl5xR1uy2bO1XugSxgWrnYLciHLJQZb
         hYtX77K3lV/ElsgQJ+KL1o3Y3Eb8m7uLc7yMQiP0wcpH0CWWnJwdsa+FerA3F0Yli4Ve
         4tZg==
X-Gm-Message-State: AFqh2kopwW5MG5vlUzwsvLgDD/tVGXz4oOGowceVc8p/JCBfO+21lyNb
        UCEwpt6/x6O1qAifhgvMuxi7fIcljLPzVtnBDgQ=
X-Google-Smtp-Source: AMrXdXuSnK+mHilhunGrKaWO+sLX2d/nIateiEydXV1J2v2T8QSOxLb3Kq3eaBJFAwl+o/JJC9d4rdl0SHe4Sl8PyuQ=
X-Received: by 2002:a63:2143:0:b0:49f:1721:c6d8 with SMTP id
 s3-20020a632143000000b0049f1721c6d8mr3243719pgm.342.1673457838609; Wed, 11
 Jan 2023 09:23:58 -0800 (PST)
MIME-Version: 1.0
References: <20230110180031.620810905@linuxfoundation.org>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 11 Jan 2023 09:23:47 -0800
Message-ID: <CAJq+SaBDTgSPd+YQ3BCRgkvY_+a=3y4L9_2qcCD5huyJAHK89A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
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

>
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
