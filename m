Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638BB37FF33
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhEMUew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhEMUev (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:34:51 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC688C061574;
        Thu, 13 May 2021 13:33:41 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id f18so4963907qko.7;
        Thu, 13 May 2021 13:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BFrw4VPhlC+J41k/oEpkbIyGKduHOIvRYxg0bnJZ2Xc=;
        b=L7KWpxuHXR7+6y6meBepH+/8H1IkzreG9snTxcdGCnuso9gsRyiBJWIK0M+9oUukIB
         PJawsztAvMRemyhn9a4MVzXkOkQsvt6MetcQ3JKRqVeuB+jcLPU4/JmP9N9SXxcULtIJ
         YI+xQ4Gw2zc1rSVqhUrjInGGB3thF86Jl3XpZODEpXTBq9+SiONPRspeQf90Xf3+pM2X
         14a1qbwm+3d64KCCHwCmOoY+LSsICT6kf7epV0O0gDUVIAbdOi8iB/xV5RFKyYV76BYk
         RF9NmCyFAIlUcCUMbelWPXHxLedMTBMTRkAvDJDsAapzLVCz287RT/ijeCQt8LLBVo3w
         Q82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BFrw4VPhlC+J41k/oEpkbIyGKduHOIvRYxg0bnJZ2Xc=;
        b=UF8T64lvcWaMxjodhGJKtF8hMiZa83ziR/qF7qv58IJTAMnrCi3adwsoVe53uS67KA
         az4N7q6xkKxBFNExwnzYLuy1h4L7jrR7OMsaqP7HLtwW5XrRm59DyEgsOvqWUq/6xwUV
         NyUmEkVcuLOLeZZyQSLUJ1mcc2I8lIFfMmgFQCgdOuPpdwHpfTe8tsJxKxbF0O2bvGxF
         mgQJxgL11Q8umF7xKAXvHT9b43i1VFh3E2GLwbTQd956ZlhvEjuGqixJHCgCoE8o+8Bb
         2u64ZnmsleI4kJXDTvKylt5q56kdsI1aYTpoL/QTegPuemSQW69Ol2DH3NqrtS64icKW
         0o7w==
X-Gm-Message-State: AOAM532D4g4PoW6bKevc6w20607AC0F2IF9VGqU2j/0h80Uv5IlOcGOV
        pgizUlIKTxSvsx8BPBXpPes=
X-Google-Smtp-Source: ABdhPJw/8rwE6MvI4qSIocpYB/IxCodL/8zBsvIV4TnM9CONQuMrC5BdvcDSwyac9fIb7Umew9CR+w==
X-Received: by 2002:a37:ef17:: with SMTP id j23mr36293222qkk.392.1620938021059;
        Thu, 13 May 2021 13:33:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f66sm3180923qke.42.2021.05.13.13.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 13:33:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 13 May 2021 13:33:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
Message-ID: <20210513203339.GD911952@roeck-us.net>
References: <20210512144837.204217980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 04:40:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.4 release.
> There are 677 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 461 fail: 1
Failed tests:
	mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs

Failure as already reported.

Guenter
