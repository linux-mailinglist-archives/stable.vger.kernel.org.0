Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046654839C7
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiADB1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiADB1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:27:11 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700D7C061761;
        Mon,  3 Jan 2022 17:27:11 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id w15-20020a4a9d0f000000b002c5cfa80e84so11165888ooj.5;
        Mon, 03 Jan 2022 17:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jyjz+aEItqww1J7LbqlundvdgcAOxsjWms724puSu8o=;
        b=qp1yxAzGD4UYm7RYg+oKjZIx9BpejHN7TweYO+6ZBsdVmomo5SIusgydC/S1Gil2YD
         SbrDn6zSvlhNsOg4k3iCgHtwh/6SXI+O1ExlWiUiTXCtjQp9BdJ7G72RYAQB8segwNTY
         bOG4GAtgqZZMZAMhs5Fzs5FeYnfen2cXWC197PNZ5Aiw90DnFUG7+qpC4K9dMgqC7CD2
         gAJIbsUCtjdc/ng916Wr/jpjoUXSR4LiOMJSe6SKwuGOZnaPcQ4Kn5M7L4sZcDwR4ouP
         QLOEywX5+qJOG/0Vh0SuR32fD1/Rzq/48tRacd8u3RrtAdyxKBvqn7pWWOPWGG58ZABX
         AODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jyjz+aEItqww1J7LbqlundvdgcAOxsjWms724puSu8o=;
        b=SavyxTtgD6JCMRBneRnbNy9xGvuQSjm+/Pp7Lday6uXW/ocCY2JvbmeoMaW4D1uTHh
         2LlNnGzEW6N60Yxba6vM/BuFXvFyLyYRLlpjsD6yg3slF9dDRI/HScWafDyHZs10dGqb
         81Qo/qS7R3jQRY2pMMk6MWey2Lmbng382PmzV+GzPyX5dy8PqdssKTzwHcVFndAwVn52
         atXtrwqTtFLq7C1Jo0HCtPJX7mLLY8BSayt+8WLj8pHn+dps0p7d22wsmGSm9556LnPW
         jARRjZVVCswttaYdV9YvO39c6a2Ih8f4jrfIUr5poiSfcpqTA5OSLpXhREES4DJkKDRZ
         w1og==
X-Gm-Message-State: AOAM5322tS3csZ9If5kwWgtcuyDtI4FPXsHr4tYAwNm8dMq0IsXMtMBp
        7agj+rxRyPheTSHJWy2QlRU=
X-Google-Smtp-Source: ABdhPJwgbrY3nipctbb7V1iTEEojtw+eu02mCA9OWwlw1o366KuPipXd+crpPl7tWmhhSwIOEisdFg==
X-Received: by 2002:a4a:d40c:: with SMTP id n12mr30075748oos.30.1641259630797;
        Mon, 03 Jan 2022 17:27:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r17sm7998390otc.65.2022.01.03.17.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:27:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Jan 2022 17:27:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.170-rc1 review
Message-ID: <20220104012709.GD1572562@roeck-us.net>
References: <20220103142051.883166998@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:23:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 442 fail: 2
Failed tests:
	arm64:xlnx-versal-virt:defconfig:smp:net,default:mem512:initrd
	arm64:xlnx-versal-virt:defconfig:smp2:net,default:mem512:virtio-blk:rootfs

The Ethernet interface is not detected in the failed tests.
This is repeatable. Unfortunately I am out of town and won't be able
to bisect the problem until Wednesday.

Guenter
