Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB72A453CA9
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 00:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhKPXZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 18:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhKPXZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 18:25:26 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80398C061570;
        Tue, 16 Nov 2021 15:22:28 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so3117804pjb.1;
        Tue, 16 Nov 2021 15:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ha8h9ShoVLH6cu4RBG8moEn5fvLLdJhe6zE/PMWNzTU=;
        b=RUn+jRIr6aXIKK6zsnFCR4fCUZqkj8xXtZ1kXpHD1rLynsZxgK6H7ywG8XahTBXhPp
         ggiLUoQ0kDDU5/DsMa+aNulFjxhNoWybha3hi4fJ5S5WOreaOkcedP7fyAv58Pk00jpE
         a1aohhi0y91rgJLY7jMOue3c/ZyEMftrEs0p/JnvMiRrOJjVEOmp/slunR/AiiQuAuO1
         uWrdmXBlxXfBPRuleMBWJUtZb2hTv95AqDHtpu2U47k8mazdQHryREGZkTpOxbbuVmw9
         BCNq3ioQNzKVFCQh0JVc3rlBcDDvN3FK0odfnDL3wF58QjRvvcE7XqmmtwHOYML8unrT
         G/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ha8h9ShoVLH6cu4RBG8moEn5fvLLdJhe6zE/PMWNzTU=;
        b=0asvFB/X9ELHK10AwiUDrSJmAwBbYwhdor7MjBh/mYfccEnWHYhitzpaNrt8hP/DFl
         qP/QPbFv4ywuJlEMPsGzqQSRvT8CJTBy/O/jck63fosf5mMiWWNIfJsdT6lxoqB84rqJ
         Ij+e/Wl5Uzy7WwJM6uzjqfLwxkwriSHoFY3q54OK/h6kFuD4Igc5mpmOtz8fRW4/6CU4
         wyDu3Cp5jqEMflOdnjBhr9jrSN1SWkldykiTKhtPVlq7RziEdo40nmCt3HXeEl8e1/D3
         53i9ZuItT7PggQIJqKeQvSbHK3Wfd7EdIMsa5Ki6fWVbxTUf7aBX/OZHHetumF9X/HXY
         vLhw==
X-Gm-Message-State: AOAM530XVV7P+/qv/ugR+cYdLQTrdYw7llPyEwDEKTk/zo44toYhBiTN
        qrmj+gCY3YaK+3JVSV31dMDbbA5/ReZmGSoS4ww=
X-Google-Smtp-Source: ABdhPJxKMpT2M/c8seTRkmhVsqFcDdznbr70qwAtiQD9EaziwSZKiW3uYpxfzMMyUaH4AXIiW0WaZg==
X-Received: by 2002:a17:902:8d8a:b0:143:bb4a:d1a with SMTP id v10-20020a1709028d8a00b00143bb4a0d1amr34031965plo.1.1637104947612;
        Tue, 16 Nov 2021 15:22:27 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h18sm21197164pfh.172.2021.11.16.15.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 15:22:26 -0800 (PST)
Message-ID: <61943d32.1c69fb81.4956e.d5d2@mx.google.com>
Date:   Tue, 16 Nov 2021 15:22:26 -0800 (PST)
X-Google-Original-Date: Tue, 16 Nov 2021 23:22:25 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211116142622.081299270@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/857] 5.14.19-rc2 review
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

On Tue, 16 Nov 2021 16:01:03 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.19-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

