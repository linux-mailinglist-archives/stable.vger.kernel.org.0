Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E0530E432
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 21:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhBCUmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 15:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhBCUma (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 15:42:30 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B2CC061573;
        Wed,  3 Feb 2021 12:41:49 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id n7so1271499oic.11;
        Wed, 03 Feb 2021 12:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k35Bzcsy09PBwkrYF/euBFKLU8xDsYYauEsoWXQn0Ds=;
        b=pdaR28aadxadFKf5wq5l+vwzKZXuh5P/lQ+1SZYLVVlrOBSra3UyGxbLhVeN8y/6zU
         zfAC5Ih0xunZUT2WcG/k+qA+U5w4VuPcUyzpcKu8n28FVN4ZD5asLEfKHv57/mq2+IKt
         KMpPEhi8u0oSLgDTZpcwGDABY1mWlSqOPsky87xcFEvWjnh7LfdOJYo5jmF3kFc1f2BP
         gLaPasvKjM8euteOS1PgwIuKY4ypaY21ZAPeAM+WfD64sPWXxvmVgPox7WPZmzbVfvZQ
         Ts9y5Paxi24JdOKvIdI0IsoTczifw++jQCWsNl6cUMe4LBhlo0jH1F6aVdwMRkSJq6AX
         Ps9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=k35Bzcsy09PBwkrYF/euBFKLU8xDsYYauEsoWXQn0Ds=;
        b=hQuuayVnNU0jyvIPII6rd2t7GB/vgy1TPocGi7WXoCRgRKnkE9Ks/yjwW272Xeu3sb
         XdlPYRNr6vzPW5+h92gk2fEzK+rYPfckyRPJUlQrdjoFRj6GcVHE2IgCPsDqtniDMkOO
         fvDi22qrLi5SqDXVw/7ukYtN/ooxTaTif8qidjPE5zD3wKBJGqmQM2vKG/5a9c/9iCpT
         +JioPGPBQWVe14E6m2LqoXYPvcVw978EhKMrdgVjiQGyeamiePPOY6H/ShHz1KfPwdSx
         Udaq4xn31EwdzuyZ2h0Cdhzb5wPpN2w9Bpfx/VRfKirzhNhST7RzyegrDWM5e6AcgUqD
         5Jhw==
X-Gm-Message-State: AOAM531zh/M8zagNCwUWXBTYJ7lKRABOPUWbi8YhErG3aaIq92rnJkJk
        TDFNDDcoDqUJBfRjYCVf+4Y=
X-Google-Smtp-Source: ABdhPJyjSJWfHY63Va2vROfiqwokJeYkH3hubGh3bhdJ1yl9hJzfZXOQHKjp5G5QctD3FUf3D54e/Q==
X-Received: by 2002:aca:c4ca:: with SMTP id u193mr2971437oif.178.1612384908783;
        Wed, 03 Feb 2021 12:41:48 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e17sm645341otf.32.2021.02.03.12.41.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 12:41:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Feb 2021 12:41:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/30] 4.14.219-rc1 review
Message-ID: <20210203204146.GC106766@roeck-us.net>
References: <20210202132942.138623851@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:38:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.219 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
