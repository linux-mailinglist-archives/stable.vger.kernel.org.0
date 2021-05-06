Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770993751E4
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 12:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhEFKDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 06:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhEFKDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 06:03:08 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014E0C061574;
        Thu,  6 May 2021 03:02:10 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso4486162wmh.0;
        Thu, 06 May 2021 03:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m96F4W99KwswKkbWpnScN2uKHXVCbK/zvCc7vn2tHx8=;
        b=E4hl0x6DCnp6qiQWQRQaTywQ81Du5YLVJZDKzaOaKEzmV2pksj/vB68Ks1afj1V8fO
         GWa5/M5HttNbx+jT90J2ik+SBsjtJDIso0jTjARp1tPhJmZzCCySr/9YM74+wd6/qJbj
         6wtguvJIEZBwKPYwSmdjUhL0/6F4ZCOORtlloAD848ZVekmk/x6o1b72A6zcK+imgPx0
         KWWC+hbqdwOhNuNcmrDIkZPS3ZHSXB8HSi7hXewRRunXjWsJn5PETKbm+H+QXj66g9xT
         KNzfsGZllbz6BnyAjh0yEMZwHHVj7NvzQMzdwquXSZoxwigwgaXqMDntt+rjtVR21Pzj
         DmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m96F4W99KwswKkbWpnScN2uKHXVCbK/zvCc7vn2tHx8=;
        b=N2IaXglLULVoz9QXf5yTOuU+1qr5vgkvM969kUAoRpucStptZPeMfsAS5BTd3VINcZ
         4pXk2rsyiP1hZfkH7Y04xv8ri4XgpvbsygqNJFcfZbCSXo0NNLZCv0cQUvlehy5iVULV
         8fwGWGvhOKjsyFjVtchHf7GqsE+DEHehZLZHV3ADDdb+lEvSs8mNmiXNfc+ZFaeEFYvc
         nJCLVkixxMoepVmS4rqfsmPw8gbe9PLfH0qUYS+98m9ZmNmzkSu0GFzYWRRrHAL5Dq+I
         x5PBcMMAvnJZXtZKofQNK0OWOU0zPTQasch6MOPhkNPIZ0GP2EJkIejDFxTXNTrv7y7C
         heeA==
X-Gm-Message-State: AOAM533JrNx2CBn03JPCdMNPNqIosoECbiL+RqrBK6gadMueRSV+1MB0
        J6PtYHgGLJoSCmzXssCF370=
X-Google-Smtp-Source: ABdhPJydCAZy4tHE8WanLEGRFMH2I/6RNQ2KWClwVC8nvgVyZYUGKCOSw64T2ySyu3OupLwr/Mc+yA==
X-Received: by 2002:a1c:7c15:: with SMTP id x21mr3153672wmc.186.1620295328691;
        Thu, 06 May 2021 03:02:08 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id a15sm3299137wrr.53.2021.05.06.03.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 03:02:08 -0700 (PDT)
Date:   Thu, 6 May 2021 11:02:06 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/15] 4.19.190-rc1 review
Message-ID: <YJO+nq11d/jGDGPl@debian>
References: <20210505120503.781531508@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, May 05, 2021 at 02:05:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.190 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> no failure
arm (gcc version 11.1.1 20210430): 116 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

