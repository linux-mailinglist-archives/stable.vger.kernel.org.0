Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22000485030
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 10:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbiAEJjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 04:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiAEJif (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 04:38:35 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0237C061784;
        Wed,  5 Jan 2022 01:38:34 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id o3so23507567wrh.10;
        Wed, 05 Jan 2022 01:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dUITgGtpL31IeX6cwiB/AlKUldEsi1k26xqsJqiQSOM=;
        b=nRh5YcuZ8DiWWz0Z+4oo3DgEHCGhLb+JBPcwXTWQXoEk1KBCwHueJXc5guFL52Nan6
         RXheLpr0c3FfYlYWrzuJli+nnKJHC8Qangb7uBRIh1UD338gzSt4BJzJZDeXV1CRFuYx
         GSdrgKne0zTN72Oz5fcsTIPt218nGGIoq0Gi1eTkmsymKRAwQ4RXGT2EnnpyFjSQPdLD
         aFC1bWxXF3jslf5nECnJdFxdde9pzncV5UEMeykZaDTJEbnc8f3t4zp+70gcpbV4vkGU
         AnpoI/Qx5P9acoQzIyX6QygaJLFGHVU4NDxWsxGpjoYVlAU+Hfky9Rg6EwDR2HEZEynp
         T3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dUITgGtpL31IeX6cwiB/AlKUldEsi1k26xqsJqiQSOM=;
        b=ufZWZmkM+PHVGJDva3t3LjCAAKNe7cdOaMDm71/UMpjFI2/WJOON5ZJx80ukbKvcPh
         zQmXHnaoRVLkXgbLllnl+MW4TQi1iTWYqMvMfm4HmjVGbJxqex+2CJcFInAxdZLQOdDk
         SsO2/l6cbAnMTJ9gvrC56YRiBJXDv0lx6b0JKqW92CsaH6k0AEN25PoKpG8/484chibo
         ET7lcy0FWGl1DuMAMpmmHc7nSFWSR9g75Y54LUqG7vcIuVRokuswzb7hlRCgu0zxZ/hm
         JjbxMAzcW0Klg0NdExlgAZlJpb2ePLdePo90UhxDG+WOBrIpgsE5EoFBYPUtUjBHcFa+
         INbA==
X-Gm-Message-State: AOAM5335O3mOYchEtqmMZUTy4onhMcTHsYgQjg4+TGkZXfNLM/9t9VBv
        9my1R8sMkfiPbsLYDZBgm60=
X-Google-Smtp-Source: ABdhPJwGu5yvfwfmJ5cd7qmD4alqvCMEMhR+piYMP7nabQY4YPI5lMNDF6EkNCj+xZQXTnnrFAJ0CA==
X-Received: by 2002:a05:6000:168e:: with SMTP id y14mr47066460wrd.492.1641375513425;
        Wed, 05 Jan 2022 01:38:33 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id g5sm45240720wrd.100.2022.01.05.01.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 01:38:33 -0800 (PST)
Date:   Wed, 5 Jan 2022 09:38:31 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/47] 5.10.90-rc2 review
Message-ID: <YdVnFwpz0zFpv00Z@debian>
References: <20220104073841.681360658@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104073841.681360658@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 04, 2022 at 08:41:05AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211214): 63 configs -> no new failure
arm (gcc version 11.2.1 20211214): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211214): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211214): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/588
[2]. https://openqa.qa.codethink.co.uk/tests/589


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

