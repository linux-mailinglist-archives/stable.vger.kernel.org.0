Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBE04742CE
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 13:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhLNMlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 07:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhLNMln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 07:41:43 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5DCC061574;
        Tue, 14 Dec 2021 04:41:42 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v11so32130083wrw.10;
        Tue, 14 Dec 2021 04:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zotKu+rcN1MpdvP96QQbJ3+IlJIZ6mnGt8Zdk2yua7M=;
        b=dOPpFHl2zBf/taW2RzPxzMei7Zx2X13o2vDs+zTcQ2prGpn2ybAK1Njc/i3v9m6S6N
         iFGQslueUjkxpnyjBZx44Am/05Knu6iMNIcIQ2iAsR3i7tMbn3hHuBNm3bqbFwZe5Dfn
         BYJEOgiMjTR+x+lB7dU07laVtVcSuhcxwvrYyBEBaQskhd4nmW+rsFKPzVGZnEJ1KoOV
         WL+R4VilFLXCYD1wHnTQpuaryT3eDWigRKnQMET77NgH79D16TrPSD4folM2lFrPInMu
         +F9jc2U658OW9R/4TLYdl2EzbzovwkZP0GS5KOnnd+tX7bgATZDL0tC/CutB3icZVNU8
         VYcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zotKu+rcN1MpdvP96QQbJ3+IlJIZ6mnGt8Zdk2yua7M=;
        b=cgCw3qammLAMsupL6lmVeS+gEY8oJJSBV/YCI8vAK2CdXkMHeS7g9HXd7xhrrV2nV9
         RIhBI4p1QaZEljmMMllKrI9fc5getNsypB8P7XVokiJbCgWv38ABpHoJuMaJpFdBtKFg
         gGlGe57lVnizanBchwpqsIA225MLgQVqOE0efrxNrPr8syGTuGXAp6HI/FykAG+HzDVk
         WvSQLvW54JaHMVyBv73Hi1nBneW02CBBB+X4lCnJ3J3JRBP2+ulAR7ghG0940y4CZON+
         box8djrMt+9xhhSbyBhjFQO5u9788XGSQCoJJ1L8LT/g+dM204ya7NCxAbTvB4BQnhKQ
         d0XA==
X-Gm-Message-State: AOAM533QytfuTixYSk+hIn6yJ5zgbwrLm44oqvTuV3nbyplXkaXFwTmy
        /Q6Njktl+4OkLbhcKDf6Hj8=
X-Google-Smtp-Source: ABdhPJxu9bVoK/gD2rZC97Hi3Tma8GPcynFh+aeL4DV8kWYCDaqnSEbQb8y6uxB7QRQSrzVGG+KEpQ==
X-Received: by 2002:a5d:5986:: with SMTP id n6mr5602968wri.297.1639485701345;
        Tue, 14 Dec 2021 04:41:41 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id n14sm16253307wrf.69.2021.12.14.04.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 04:41:41 -0800 (PST)
Date:   Tue, 14 Dec 2021 12:41:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/88] 5.4.165-rc1 review
Message-ID: <YbiRA891TtczV5o8@debian>
References: <20211213092933.250314515@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 13, 2021 at 10:29:30AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.165 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 65 configs -> no new failure
arm (gcc version 11.2.1 20211112): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/504


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
