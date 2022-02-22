Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0427E4BFAF5
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 15:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiBVOfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 09:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiBVOfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 09:35:05 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFED715B999
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 06:34:39 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d21so19216452yba.11
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 06:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/DlyKF0fsFHIL3ZRxGR6B6FKoiaBHXQcIhAur8eZR4=;
        b=rSLHZ7/Ts90ykKxRj/eXkC5LBFNr7lcKuo8pQCgZveGofwpb88i2ERtFMQv1XL2T1v
         J9NYP1DkBV9OREviXN7NsGWdw5r7RyVsX/cvZ9OuLxILwkYSfA+os+LgtIRbzDIhcy6+
         WHAQSAh5lEdnXOZby0b8IDXPLdiVQyzd8pyjgdAHcrha0HykBtkhSnjScvFB0QAPAJGQ
         49d8xXvGxntnlEjS7atc/FJJqk9HMly+Hxl2GlqYEAYwOlncxFOgn0YQ5CJi0Z8WbULk
         wc5ik6o0Yh6FK+mkLvn/Z/v/G24w/3fBtqg/CrNeM9IVpGM1edFR2HRvpfjaFx7nTBcb
         F2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/DlyKF0fsFHIL3ZRxGR6B6FKoiaBHXQcIhAur8eZR4=;
        b=RTooR2YvEh0CosSK0EnGaOhKy7+MOJkbJUQ9kfg/wG+BNVgn6SKK5Lsad0BW7kXuxz
         4EHnVfob4pd7qY5zj+GfFkV+TjATAiDNR5g4AejvGPInFfENfonViWwphORTblciPy/i
         MhkOoNmckXtit65LYOssFBLs1AJDaajfVD3el87DOsAaFtSf5BeewEYrilD4RHGvW/nP
         anocQNSTvn9GXeSdByUlD4XZtRJaJGSJn1AUygcdGjz4ftNeNNJJeEoN4hClDXlnmW+R
         /QWjbPpz39zssLhEHxgIjH6ANGYJnGqc+9+sL54K/sqGWXk2xrYP9v3Ys2IUcWtUooUC
         l8ew==
X-Gm-Message-State: AOAM530VkkSzo+oOH2EdZdaiWkn4bdyAUSSJb196SuM+T/UUXOGQHCWA
        IZrvubcBOOfN881GAKlkLkbDYQlF1aZbh9akbhnmJQ==
X-Google-Smtp-Source: ABdhPJyp/O8lflw1Oob6Fy3aWNuT05mzy+IoS+1fqGMl7Y3cl08+++5pWQAoGTY31dUasccAppWN/r2Rr2m7tUdCcLE=
X-Received: by 2002:a25:b3c8:0:b0:614:d179:79dc with SMTP id
 x8-20020a25b3c8000000b00614d17979dcmr23493027ybf.265.1645540478807; Tue, 22
 Feb 2022 06:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20220221084911.895146879@linuxfoundation.org>
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Tue, 22 Feb 2022 09:34:02 -0500
Message-ID: <CAG=yYwkXEimS9xdZK7eqtNdrThtqt3x2E59ys-814SYwq2fWPQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 4:41 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.231-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
hello,

Compiled and booted  4.19.231-rc1+ on ...

Processor Information
        Socket Designation: FM2
        Type: Central Processor
        Family: A-Series
        Manufacturer: AuthenticAMD
        ID: 31 0F 61 00 FF FB 8B 17
        Signature: Family 21, Model 19, Stepping 1

NO new regression or regressions  from dmesg.

Tested-by: Jeffrin Jose T  <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology  -  autonomous
