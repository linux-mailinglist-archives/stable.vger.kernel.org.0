Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F1444D6A4
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 13:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhKKMbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 07:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhKKMbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 07:31:10 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99043C061766;
        Thu, 11 Nov 2021 04:28:21 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u18so9525607wrg.5;
        Thu, 11 Nov 2021 04:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yZljgxv/NvPvs9YR5qRbC+FbUXMRudGCFPe742WPTo8=;
        b=IIVSkeseL4J/afM5V2kWZUzq8UhbXXgwqnbIt1SIgT5hk2S/TQsMN6unBDTDQOllJT
         c1RYTFity9Jw9yhLWpWy4deKdsQOr6wrpe0KlvkFGVutjchT7klsN/FEWcBpPU8t5fqX
         cYWydWbS7/zg6Gs5d43zetVc+rx3IiZtNDyvEZ895dCixyn6NhnXy2tmL5Yybzmg+4DK
         s9s1+x2KRpdXo40+nlBgxsJtmyPaMWDFH4G4xVXE0dIoqsvfl2dpVNJnAKeeyavAudSP
         lfd/XaFaVTMOWqdekyCMpLwIsyyHzEuAodswAiKkrJAbO6BTK11sOvvT42fvXYOi3Ene
         FpaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yZljgxv/NvPvs9YR5qRbC+FbUXMRudGCFPe742WPTo8=;
        b=7O4uKE+PyCe4b/k/sByGl5wwpBM3g5BOPRbST5PxTjEW4o9SjR6TwZ8BYYK4Y367gC
         z7Hz6GvqkyoLOBrSoNkJZTuWTIEzo51+Hhiv3SEhXeH/tAl/syCEI9uAZS+SNlC12GRo
         4o4VuDZuDqxsjDUxeQXxo1zqln85f6iY1kZ49nb7UuaT4CZtbsw8J3CmCVGefwM7BvD1
         iCvkcE8S/BTGtoCAdX9mkWN/wQWXvqwoJ+omm3H9/SkmxHT9Xs1rHiBEhtE20wEKRC1T
         m77fXzBma6uWS1pBkR0S9MYzlkzBp0+S4RKQV3h6R8gMGIz9qrZXRiJj3ya0NSnNhWnd
         Rpmw==
X-Gm-Message-State: AOAM531Fe5VtSbQUFN0DcOaQ8E0KdFKAJW25tysN09Y6U1XviTuN04U0
        j7kmDgiBxfaX8leoIElbXVOM0JqrwRw=
X-Google-Smtp-Source: ABdhPJwUd2eEkGvsNHoffx8KTRWjOjwhCU1xgdCT4N69ikUwDvtCQGuHmBP/g6VPvUpNnZsDT9i9aw==
X-Received: by 2002:adf:8919:: with SMTP id s25mr8643676wrs.185.1636633700152;
        Thu, 11 Nov 2021 04:28:20 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id o12sm3056782wmq.12.2021.11.11.04.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 04:28:19 -0800 (PST)
Date:   Thu, 11 Nov 2021 12:28:17 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/16] 4.19.217-rc1 review
Message-ID: <YY0MYcFrviPRNcb5@debian>
References: <20211110182001.994215976@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182001.994215976@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 10, 2021 at 07:43:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.217 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211104): 63 configs -> no failure
arm (gcc version 11.2.1 20211104): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211104): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211104): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/363


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

