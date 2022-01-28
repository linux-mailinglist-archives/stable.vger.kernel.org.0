Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5474A040D
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 00:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbiA1XFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 18:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiA1XFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 18:05:09 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4391DC061714;
        Fri, 28 Jan 2022 15:05:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k17so7599276plk.0;
        Fri, 28 Jan 2022 15:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=8VyEfnd6HQ7MDHn6H1B87XHphvepdAaMu26R8e0Hh7E=;
        b=nBJX6yjQ5JuNiEy2mbbvxrREFLuhj7sNnshb+rhGHnqjie/Qo9rc5KkOQnZHM6yLVa
         DN2+1sQAhIpu4Qv4xGUYvwp8xDowPvInIksmzYSQp5dlywqMIXlHbkQQTDnPZoaA3Bfd
         RaXCJ8LXxN6IDVi8M257OGzVHl33dW8bN8o+k4B0+coGo/3Ib5XL7S5eNM2lOfFc0IKz
         HHhcYCxZx4qXWTRTI8FZbkAMRbLI4YSN+9uRV0kRnXDa/4k3tfQXfWNmDB622NwbhOX8
         3C17LyDwvi6KbGhPeigpzg2lVPsxFZ1ZPR9GQPmigyf+e/k05SBiTC26E96ly3gITG9X
         P0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=8VyEfnd6HQ7MDHn6H1B87XHphvepdAaMu26R8e0Hh7E=;
        b=3LXcrHQyYVfKKJpMequ32iui/vAVC9vpAZMNEfDkMCl3e13w1T1E2Zr2wcUYJK+oVT
         YAzC2kEZ5hmpHCwGt+4RlVJvB3oPyLG7yys1HDQuGQCiL5CvTyQSNZiwT8IcG8tIltA+
         qZoqLkrjTTAcXzlTgWA650lDmEF0mSiarT19+AGFqDLt8XJBL0rqSDztslB1KqCNgn78
         wtMVrCrtwXl4vAqyOWgWd7YztsDhqtD2hyH2SIQ/qp88YGz2jGZsauaJgJJHALdGVAGk
         Z3dvU/abZNwRLzTrJrQwR810h691oih4Wy0PzTG+LjhtGsKOs1JsCVpSb7yW42yc7U5/
         Om1w==
X-Gm-Message-State: AOAM530t8KMMNl608irrxucpK2zNaahiIcXR2lPvEzGW908pSV3sJX+0
        we/TIgBAAMbe8I3NljpwYswgNrHAA0Vnzc7WM4E=
X-Google-Smtp-Source: ABdhPJwCLsU2/saRmQURtENCLXOvDX2bh/TYR7srM7B6X5/uXMqrgjEyrlb0svDC8FEbnE5kbm5kNg==
X-Received: by 2002:a17:903:11c3:: with SMTP id q3mr10649189plh.97.1643411108133;
        Fri, 28 Jan 2022 15:05:08 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id y191sm10008648pfb.114.2022.01.28.15.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 15:05:07 -0800 (PST)
Message-ID: <61f476a3.1c69fb81.9ac1a.be60@mx.google.com>
Date:   Fri, 28 Jan 2022 15:05:07 -0800 (PST)
X-Google-Original-Date: Fri, 28 Jan 2022 23:05:01 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
Subject: RE: [PATCH 5.16 0/9] 5.16.4-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:35 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.4 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.4-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

