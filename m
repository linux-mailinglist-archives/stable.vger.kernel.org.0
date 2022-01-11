Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3347A48A699
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 04:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347339AbiAKDsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 22:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiAKDst (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 22:48:49 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF45C06173F;
        Mon, 10 Jan 2022 19:48:49 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id y11so20590614iod.6;
        Mon, 10 Jan 2022 19:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WNQs6LbWcRmRmi0P34aqDM5w6SlKKEAW2g5xn1iLR7Q=;
        b=hULUmVUCyUN+r0gT5RNapkHj3BeKk6Sb05aMMHFHU91rvBjqf3aSeXMEj8KGA2QeaG
         G6+NT4mLzNrWLajbwwVqPLC3DgbUvEUV9EWW8M4K+mbWqGnSeJin68P4C3NZA5fb0h02
         kW80//M6nKIYIz9w8xt4yYBr97JqGOHbz6F4uhydB5MW2sOJKE/WJB3GeAh3l1D7DMr5
         oupmRzqDFtvkzqg4DF3TX2Ym1iR6cdsacr4aPZN+7ewjhHm/23+APhfJHqiXIp9GeDb7
         Q4ZdFxqNIvzPza4Cg127QgqVemwdZRE6tNcMcBXHCfZS3YIR8ypjSuGfWQIrz29ajbOB
         lzTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WNQs6LbWcRmRmi0P34aqDM5w6SlKKEAW2g5xn1iLR7Q=;
        b=Nvhu5WK02+rSjCv1NuH0OqkxFIz1rbpC3IS2Qnirn3XdiSwtnHz9FPX0pDuonawLSi
         Tc/grTUiiCmF8fQdBM6lBclGgCc9AmjXNtPofEDh0gwqSsGu0z7rMb1d4u2qpUbk2hY9
         aaAtcjo45acvtLvn2yVw2tfBmUAKbmd3unAXxC+ya22u5Ix9h3setQ4MOz7XEI/rsRB+
         ZLpmrmAF/QvHfmO7hQtXzsNI9RiIqlYDji343f/EKOP7DPfVkJCg0GRW1m/m4OB7auaZ
         Ai6hdjp5GsPyV+vdUnYVZYkjxuPpsXbxRRWj3TGyd05a+T8NIpxWUCFGiJEFqSyaGP5j
         d1Vg==
X-Gm-Message-State: AOAM5318+K7g0ouoJ/QStWQ5yEUU3MvaKf9cynExGJ4K90+/PdxhLEET
        JeeOmul0DdQXRn7hQjRfiHyzSvivGTA5SKQhldM=
X-Google-Smtp-Source: ABdhPJwaUwZ+eVUMpv8w9NhE0GA+6kjJcHmOzy2iDhLiplpfrOuu6vmXU3KySSFQD777sbJ/TuSkWUceYlkq/ZIWyLE=
X-Received: by 2002:a5d:888c:: with SMTP id d12mr1225891ioo.175.1641872928536;
 Mon, 10 Jan 2022 19:48:48 -0800 (PST)
MIME-Version: 1.0
References: <20220110071821.500480371@linuxfoundation.org>
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 10 Jan 2022 20:48:37 -0700
Message-ID: <CAFU3qoaBJqnHwVONaJiFP-MvY+h2258h4w2EN2d=SqPN-+2SMA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 8:26 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> thanks,
>
> greg k-h
>

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
