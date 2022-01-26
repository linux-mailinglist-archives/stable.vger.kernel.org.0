Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2897D49C871
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 12:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240568AbiAZLRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 06:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240567AbiAZLRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 06:17:40 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66080C06161C;
        Wed, 26 Jan 2022 03:17:40 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id r7so2355843wmq.5;
        Wed, 26 Jan 2022 03:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t47oAXxusbQX268+jco67eiS/8CQ1VFbXiv59jxtU3c=;
        b=hvR9Sai7emFri6uqLYucqxnjJ0o4n0f9Gki8GXzqyR+lz0/iHxMctd0Z+Ozdsd93iQ
         lfBg6ihc1FDM0/4JzN+K83SjXdzmsLYHxmLCCPeO4TbFnO78SEPAxhu7TvIxcszPylTJ
         Jt7SiQLUGfjsuaBjBnbt1pU0/tkv721H9qkI/JArFa4LAh6AXBFZv67IaisadSYbYd89
         NlpvJS/E1ZlsNeMXukS96Dthulz1EyyYAJHRa6W8t30TM53T0Oxcn3jlUKaQU3KCJHfl
         ijENNjuoKQNVCzrB7XK6+yPQ5hDiGSGc1PrCnFMIFP5SRU4x2UDdGX3BQtpazZw55H8j
         I3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t47oAXxusbQX268+jco67eiS/8CQ1VFbXiv59jxtU3c=;
        b=ZCtWO9R6YHoh5F1NVupqwEjM4tosgx4lEpVx2XspD1qHv1ncOKnXesehYEJcnAh1ze
         ZXQ0sYfQ+GnZFoXiIyL11K2vRREn3X7DsT1fjBGS+2Gc3KTexPFKl9KxFXFJxoujuN+B
         tSQGbVmucsDwaYgftMPA2gXZ8AzhwJPVwRfQwUOpHEbupQNdCepBiFjCDCc0CecuVda2
         Ozt4HXBM1FLj2jd7QOWSImgY9Uhh8U13UGmDuHvIYJ3bvDL0+ne/1RYBOmKRuNrTTEvu
         gOdE9UdAvQDIpBuWvedYTO1/UASMMVF1sjubrmDJz63ODXoS/QbXbZzSUYWHI38x2e9n
         UVMw==
X-Gm-Message-State: AOAM530jw3W/o9OB91iriRCO/poFffiQumh7Efc/i6Hwlj8ctWDD7en2
        Dy5jmQmjCJj3r+fpktE8c98=
X-Google-Smtp-Source: ABdhPJwNaVgBlxy+T7qq2LDiVY9pADohFo112yD5ywo7B9/erVjLE1yiLuoW+uwJdVclvWJ6R3yhpg==
X-Received: by 2002:a05:600c:4112:: with SMTP id j18mr7074144wmi.72.1643195858909;
        Wed, 26 Jan 2022 03:17:38 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p15sm19110387wrq.66.2022.01.26.03.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 03:17:38 -0800 (PST)
Date:   Wed, 26 Jan 2022 11:17:36 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/560] 5.10.94-rc2 review
Message-ID: <YfEt0KfqZ0cKD9m7@debian>
References: <20220125155348.141138434@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155348.141138434@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 25, 2022 at 05:32:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.94 release.
> There are 560 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no new failure
arm (gcc version 11.2.1 20220121): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/657
[2]. https://openqa.qa.codethink.co.uk/tests/659


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

