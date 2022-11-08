Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB3B621FFB
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiKHXFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKHXFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:05:20 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F83163140;
        Tue,  8 Nov 2022 15:05:20 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h14so15127048pjv.4;
        Tue, 08 Nov 2022 15:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gcur06YXVkpMCUTbS1b/OnVOrutrgJBtjqG3uOLRXak=;
        b=Kq4NEanaCGU52P7s3v3jGRzbSfwCAVDjno72X8vKFdqCzVRZrgtjrUA870eQKayPeh
         M4zl2U8Rn0ov/0D01FgYWSkWBXu5b1SvtNxG5wZ1BzKIOB/W/c9p7LeRcyYfdMM+i8ZF
         7gdDUY5kMhf7HA+BPFwsuQJaNsaEb9q7IDB7GJfY7wh5TEhBtLrfs9VG5KpEn41+lWl6
         HGcyXKv27IGU2/TZyQOrV83e0fAxVtgvSFv8/s8rn0hUypZHyHdH0TM9rOAyzHegSEWF
         2KktVwcvAFzF7MXDvAcVLplnS4jawB/BCrd97ticupTb0U1lypXrCfh3lSbpXXPm+rNz
         y1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gcur06YXVkpMCUTbS1b/OnVOrutrgJBtjqG3uOLRXak=;
        b=AZyzsk9dh0+X98m/CbZ0Noc/fEcElPWI5xKPuFERDEdacRhuAbFLi7WchNXShQXWp2
         4zn0wPM1rhQefl3X5DUpl/+KBEBm6eil+uAdf9T3+zd9VylkSj/Y2HBjCG57X5fg80WD
         xu9AnI4tSVn/cMe/iq/nUYVOHhlOhLe0MDuYdnOzpjZEbDqoev4KXkN8vDuUbYqZvLjC
         Np/EAwX9rNP9Q4ybRT4GSKzuGOeCb0q1vkADCnfWO6c8e6WRqK10DALgh8vECVxYinwu
         Lk2MTru30Fyrjb9Vf8FYXD52W+djAy5bzPjKuwReMvM8Ypt41uD8r9rzMVRhuCmh6vm/
         HyAg==
X-Gm-Message-State: ACrzQf3NuowA9nZ29kO7oJbnIv35utMgoQdXVKf6nfLNoN1XevOVyUK5
        9eekk03ezjiC4UFJmph+B2npJyXg2YRvryNpnxQ+Qk6XFZk=
X-Google-Smtp-Source: AMsMyM7SqemD9JPp8GWfXJpXFIGp1dsxWi8Tw+x49gjJjHiIH4LM61lJcXMaFVFEWLwJYXtbpuclxFRPJUxYWxskNEw=
X-Received: by 2002:a17:903:1211:b0:178:a692:b1e3 with SMTP id
 l17-20020a170903121100b00178a692b1e3mr60279037plh.48.1667948719734; Tue, 08
 Nov 2022 15:05:19 -0800 (PST)
MIME-Version: 1.0
References: <20221108133354.787209461@linuxfoundation.org>
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 8 Nov 2022 15:05:08 -0800
Message-ID: <CAJq+SaCAUWM=ErYEesXQ5PNSsy6AxJWUpHhKcN0MH5X92azxEw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
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

> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
