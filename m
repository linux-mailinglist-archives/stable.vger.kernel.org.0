Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C41447BECC
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 12:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhLULWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 06:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhLULWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 06:22:08 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBF2C061574;
        Tue, 21 Dec 2021 03:22:08 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q16so26226463wrg.7;
        Tue, 21 Dec 2021 03:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KZzpcrrAcpWTY2y1jEpj0XhjvIMEP88+mp+z4tPe288=;
        b=FjExgWJIfAfCZarRS7XKa0+qY6BTrl57GIAVXGbWsoROqkRoR/Jpn7qwqyaGEIG8N5
         xgX1klyBgcCN6NnUMFt1VvclEJvLLNWSC+5sWJpCkFeydIP0Y7gsvYXgjuJvlNQ0WwzE
         sxGIsC+64a9e0HRXMlfUliol7Kk779IEkXCrZMGwypnxyMkYoIaZrSc0qSVoOCRSY7ys
         oE8VmPsGtRYxmHRxiuF005d4+lpMdzF2Pw/xUdXOaA1nE9qCfYsx+3mPktu/x0ShNZDO
         g2MNi8IzAdrHHqBssigxik0p8R8x2i+axPEzqaz0BKpfBE6nK5lpADN4CB/gTL+ZM2V4
         AQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KZzpcrrAcpWTY2y1jEpj0XhjvIMEP88+mp+z4tPe288=;
        b=St/XJWZeWsGBAOprjWSuXIjCRaI56sHIQXfvYIFKWxLTfRPyDUyrwaA2RRjsi5Xm6H
         7PK0K6QKoeuYwY9+LJSxCeOYcyDtjIJTWeRt6VnnmOeghSQ+C58aHBSI7C9qQcnJcFDV
         EECBrcDfxsKGAfKEwPFpxWvCcPSI+VNBCMtWQ0kigLw0f1zdifIIWz4BjbugmgWW9kk8
         1YCpMjNcIBlbXcBdeL9C8acQo9gxxtjF++0O1XlYWAqfNYqfcbfauNuVvhVdlARzn/tP
         6zC+R0CTfgGfi6Yg61qOz+eCOYOrfzzPdrY5A7pxArZxlI35KighlfLDCx73S5EoDs0f
         OQpg==
X-Gm-Message-State: AOAM533ivNMPr7fIicULprFBD7Vj+S/hayU77KtJBbzbg05EHYSwlzAN
        /LanJ6aC6/R8qVZIZuXCNM4=
X-Google-Smtp-Source: ABdhPJwPFrK2DJhoeT3Ttb6IBWq8VhZP+V41BUBf2uzRsNuBauD2hvjcaTzrU0YFftYJBNEuKTOjwg==
X-Received: by 2002:a05:6000:1aca:: with SMTP id i10mr2207573wry.453.1640085727016;
        Tue, 21 Dec 2021 03:22:07 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id d10sm1844131wri.57.2021.12.21.03.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 03:22:06 -0800 (PST)
Date:   Tue, 21 Dec 2021 11:22:04 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/56] 4.19.222-rc1 review
Message-ID: <YcG43LSU6HDqK0nX@debian>
References: <20211220143023.451982183@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 20, 2021 at 03:33:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.222 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 63 configs -> no failure
arm (gcc version 11.2.1 20211214): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/533


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

