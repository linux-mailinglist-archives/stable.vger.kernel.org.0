Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E654D3872
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiCISJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 13:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiCISJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 13:09:55 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F00286D6;
        Wed,  9 Mar 2022 10:08:56 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2dbfe58670cso32545707b3.3;
        Wed, 09 Mar 2022 10:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ifl8zjXJKRKZGSm5jJ/M8kCTgxdJ2vnFQmZ9XC5e+1E=;
        b=nGEAqFEOQ02rbg9Z0sUxiyqsbjFNXBNhT0O57fibX5o1/8VMMEwS/9xVqGObua0btC
         jF1K4BmvEuUPGfjnm7q7/umADV/bFv6cJFCAUiJ6oU9mvI3+9/OzLSkcajxA0UVr5DtA
         +9UxNMmaTPvOuqvojIII3kmzSduGyfuCP5WTf9UODwvQNvaNgSsBbTuuylnaE80CWvMB
         4jAGMURdNFl7/yYJ0KMHgM+P5LFbXBQK9kIKkZe+7Avqdtls/GduQZFHGVdv9yHr01NS
         +jB99T+5sn8qYEIsqH3olUWOhjHKQdM6r1YUnfvX7eDelCeg4ILFnQjRZnCk12cGezmd
         Yq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ifl8zjXJKRKZGSm5jJ/M8kCTgxdJ2vnFQmZ9XC5e+1E=;
        b=EK1dOGqVtoRyK5iodjB8+3czqoJl6UlA6v+4FBKvgQSwKN0Bdt9NphHxM6lWsbei53
         WKob6QMInPT9BIS/QPko0tJQ0QZkJKxeY1Euo0gIYAXvVDDE8Y9etCqcWdzy6khc6c45
         rJh7Xr2WvCQniEyTVgWLkv3/b0CNgpqOxKNHC/Uqi37938Rx1dcuJJ6IJmeZIHJByGBq
         NPnLdwzs8rB7BmToBMRJ8/t62edNeMl3JtabbGMq5lQKMCNiRAIWCMGXE+PysXxFRL5p
         199ezdIBBgT5BnaT4LZsbUY+X3MMYs8Sa9HmCsxGAZgqAagIIrXWsSBvIVNCNl7KKGQt
         5l6w==
X-Gm-Message-State: AOAM5310C5zwtIJfrd/WRzWePt6OnAm0ntul3KRsQNPZIP2t/wWK54hY
        ol6yD3BAF3Yh53lJ9uyjI7Xc3Gv82OMDwPo3ML4=
X-Google-Smtp-Source: ABdhPJwHHDubL3hFO19tcAoXUSIUQXp0LSo/WnHjBgqxogG9oYYGf/VDvba++pud6bfgaCxPccT3OhYK2VFlnKS3BSI=
X-Received: by 2002:a81:1493:0:b0:2dc:1a9d:8150 with SMTP id
 141-20020a811493000000b002dc1a9d8150mr878076ywu.361.1646849335285; Wed, 09
 Mar 2022 10:08:55 -0800 (PST)
MIME-Version: 1.0
References: <20220309155856.155540075@linuxfoundation.org>
In-Reply-To: <20220309155856.155540075@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 9 Mar 2022 18:08:19 +0000
Message-ID: <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.

My tests are still running, but just an initial result for you,

x86_64 defconfig fails with:
arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
function 'unprivileged_ebpf_enabled'
[-Werror=implicit-function-declaration]
  973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())


-- 
Regards
Sudip
