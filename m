Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589E338F362
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 21:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhEXTB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 15:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhEXTB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 15:01:26 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD841C061574;
        Mon, 24 May 2021 11:59:57 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e22so5050909pgv.10;
        Mon, 24 May 2021 11:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=dNmbbm7vV2wdR8BIrLsykmJDRlXUTn+Fo63moxvECms=;
        b=ofsq6Etij2PRpy7t3jNqI9WiGS0tTNgPHODRcyAfMNp6022PSnuZXcuW5HDpFJxM7v
         iBDnWp8LNor4wBPX4N9eP5srsMdfOD40ZmAuDYx10+S+xmjjAX6FprafcXXVp9nNlyVi
         nXzB4MpnJ/JQqUqd8L8o23Ysm8y/JA4gxoMePKdIYuKH8al/9+guoCVryiRV479c7LBQ
         Fnuez/UoPZZo0thFfseZSkr1Z4LvDkBesnwMKRrBTKoK1WTVasTANjhxAx3q6S8FHuUt
         0ahBtuGEtBObAfDP81LnjCEJVTBTkZe0Bv1JLeoHZOBzgkBYUQ5DgQIbho2DX6ouu6so
         iQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=dNmbbm7vV2wdR8BIrLsykmJDRlXUTn+Fo63moxvECms=;
        b=ifg9ugiBXXLf1npRj2tCBZX0zj2YuTcSt3W8QDCMoe8LGGCmeGaVmxsD9AeLXkp7iK
         rCV1hkuBOUMjlKR5V0VGdQPgkonKxtfyQqfsISeT8qGE+j+GlMlskKJa3zhulIsFk2AR
         JGCZHkrBGk7N1mAU90wS/BBEWHubjiKCOyyouDfh0U/7f4ivDH70+S3IZwP5jrwZZlLL
         nKV3s/mhf4ghovgQH7PSmLzlPPYZV35bytPKPu0CQS92MD/mVHU1lRHCHFJzPbvtkjI1
         o24aM7ne+OJVG1G724ARVWsUTopfR7qafUoYHRLP+Lfty/uv+9CVPiCXDsosyL2J2gls
         UPIA==
X-Gm-Message-State: AOAM531xwU0VXFZ3wR2LeyUuzWet0MNnCW1whpw7Luha1eRN5zljyeZr
        ijTCnoAImqr0tOKNhuYs6ljTwPDZUG3vn4+1Vrw/3A==
X-Google-Smtp-Source: ABdhPJzD00sn2trc3wkjjloNvGsiMKB8uLcl70wNn3Cup6baOm64drcasP3Mn/VqHDncJYHxOJ2btQ==
X-Received: by 2002:aa7:982e:0:b029:2e4:eef5:e0c9 with SMTP id q14-20020aa7982e0000b02902e4eef5e0c9mr17633500pfl.3.1621882796905;
        Mon, 24 May 2021 11:59:56 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 25sm11493311pfh.39.2021.05.24.11.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 11:59:56 -0700 (PDT)
Message-ID: <60abf7ac.1c69fb81.fd61c.6a38@mx.google.com>
Date:   Mon, 24 May 2021 11:59:56 -0700 (PDT)
X-Google-Original-Date: Mon, 24 May 2021 18:59:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/127] 5.12.7-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:25:17 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.7-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

