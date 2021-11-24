Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF85245CD37
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 20:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351107AbhKXTdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 14:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350997AbhKXTdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 14:33:25 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F462C061574;
        Wed, 24 Nov 2021 11:30:15 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 71so3052691pgb.4;
        Wed, 24 Nov 2021 11:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Hj/CYlS4wIZEek50wtFCXdzKhGX9mckuZ/RzHkla244=;
        b=A5woH15LwhnGbDK6LeMHBLQ9NDUIVZjIJHDbnawZZb4cSCEAVkaT36G+44ng/LJawY
         SHzHPPoOrbYdziMv6yQXi+qAhH8AanaQBQyXupvPt7tagLTIMDXA9TPRHnGz1gnxOZ3v
         HFarvQyfAltLFWOABUyrm2XmRcfCRJpAtO0ZK18JAxHxetBlJ9kKnWbEOESzxjj+W3iZ
         jlKslzwECJ6LXu4AanfNR6rRkZszdqYLkdLE7oJ7xck+mzBTI6OnkUN2dOAsfI+EmyzZ
         iCUabpUxFIbTjdQ4XOjaczIBqt7MuH+Es8JzLCGtVCLIicCuTohupJdYqt3nyBkujqZs
         XVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Hj/CYlS4wIZEek50wtFCXdzKhGX9mckuZ/RzHkla244=;
        b=1h2gWhjFAq99kGtSGzfgTASAHt6/tysaANLrpqvtqPSuQGroAXkumML2L+KYxMHaYT
         /L10R0F6Rf8xszZsisDltzyvQzdNHil799kFDRIlPTvTEIxga7yQ3FEiqjNJegeFhk3D
         Q7kheXH5kgBvpwf4TF7QBJ/IYZ7sjA5TgDosbpnh0Zq7rtNAtk6o51hrr91OBWRdbQ7f
         A7QSW2uJgcPw/IuFjKcsTlUdpKo+409GrNASjriXf9t9V7m2ag6pDf4AHkuuWxN/n5g0
         4nei+1Czp9ZOK3OCb12klqJH6YHLfVQ1SIjnE8tZm7EMq5Tev9Fhkg8KJ9vT2afF9vzf
         1iKA==
X-Gm-Message-State: AOAM5319LAAt+KSVSOv/zU34u6+0uUy/Hz28DAcN+MtLIOo1tZfQEQtC
        6AH33ttJW+fiFx7sq/clZu3DrCK86Sij4gftOI8=
X-Google-Smtp-Source: ABdhPJy5YE8zS5cc5S386xfxQXBMTXEY+DrlICyj/w8rsTrT7Bkbh8Z0g9mp5DmWbkCxo0iRLUpTCA==
X-Received: by 2002:aa7:9561:0:b0:49f:c8cd:ce6d with SMTP id x1-20020aa79561000000b0049fc8cdce6dmr8444004pfq.67.1637782214770;
        Wed, 24 Nov 2021 11:30:14 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id a18sm452426pfn.185.2021.11.24.11.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 11:30:13 -0800 (PST)
Message-ID: <619e92c5.1c69fb81.2d0bf.1bc1@mx.google.com>
Date:   Wed, 24 Nov 2021 11:30:13 -0800 (PST)
X-Google-Original-Date: Wed, 24 Nov 2021 19:30:07 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/279] 5.15.5-rc1 review
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

On Wed, 24 Nov 2021 12:54:47 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.5 release.
> There are 279 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.5-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

