Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864A43CF769
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 12:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhGTJ0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 05:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbhGTJZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 05:25:10 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E45C061574;
        Tue, 20 Jul 2021 03:05:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m11-20020a05600c3b0bb0290228f19cb433so1173643wms.0;
        Tue, 20 Jul 2021 03:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4JIAXXGHmdW0LSTjaZLIfI2lrRtYIgeTZPlKP4kjulY=;
        b=OHN6JucIBrLpNHulH+/ESMZQm1svXNWFa9sswkCj9cK9ay777+4HY4xG+7TE/V8UlJ
         b79V1JjjQ3dIy8OZjSCnfOxpSNDYUKSdt5MnqwRNYNnIFOZaQrSdjv3dzeWB+G3dUafC
         ed0nEwU+Ab4SrTQML1pBMU7k3iWUnN/nJFPnOaPBxRajxuBJa3Esxyo/mPRByQT7Lrci
         xC2FSgC2jhJAI1xCrFgTuahOao293pvbVXU6n3+AtVp5SvX+IxA9zw34LoyPUN3JYeIQ
         RaBdcNbJWMKx/2CVV3DoilzzPMIdRtiqh61co0/9PFU0sclWRZlyqTujSXzc1ZxESxoM
         DIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4JIAXXGHmdW0LSTjaZLIfI2lrRtYIgeTZPlKP4kjulY=;
        b=F/PfNNsWMuJlUYGboApmdonBaYQxTar9ERZPble9XvzlcOEtLXvETGcQjslS73EcEJ
         P4jwOV19TTIcwtACtc5QRTfkT5gAStbjolAOntEsrJEPUr1R7VrRW6eyn2BzpKPGof98
         PJ20wSZMfMT28pwgeYu91x0UbZaOl3ub6mP2fomjW+cV8JOQYDCUJicif82GdtWM5F+f
         L41++kDfZGoiIWqLq/2+i+ub2llzC0UIs/iWCH+UCVAbKxLozVJle3yPeQ5AjT+taCVi
         sFiNxICXxZXhWoDLvxnvJPy1TZsmCI7yOAfuc5cPMdrAXd/lrA7/kelrnuJIPgcYzHB/
         MQeg==
X-Gm-Message-State: AOAM531j0eFUQkHAbDsOjlEZcjw5sF7V/iy23wuh59TOqi6x23NUorR5
        foZLcnI7oQp11WkATvjo4JE=
X-Google-Smtp-Source: ABdhPJzufhjdXN01Nw4iVfdH7LMUKsNf/ck7bY0bX9PNPpMEimm0sAYFghMGR5cTQ7jRKB45YUHzTQ==
X-Received: by 2002:a1c:1b87:: with SMTP id b129mr31269394wmb.189.1626775544304;
        Tue, 20 Jul 2021 03:05:44 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id v30sm25045709wrv.85.2021.07.20.03.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 03:05:43 -0700 (PDT)
Date:   Tue, 20 Jul 2021 11:05:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/420] 4.19.198-rc2 review
Message-ID: <YPaf9qz/4XSFuiIK@debian>
References: <20210719184335.198051502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184335.198051502@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jul 19, 2021 at 08:45:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.198 release.
> There are 420 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:43 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 63 configs -> no failure
arm (gcc version 11.1.1 20210702): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

