Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2160B37FF30
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhEMUeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbhEMUeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:34:04 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E51AC061574;
        Thu, 13 May 2021 13:32:54 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id i67so26815288qkc.4;
        Thu, 13 May 2021 13:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2fy3yU/nGYr2ZfPy8/bHaM4Fp6k4bSPzpYXlr5lnJmI=;
        b=s1crW71W8p6hqAMxPcJAP/yEu7ujOw7hVoOeuB70JIvbXUwCk462xxM/1wapLsUZSh
         1W+/D3omutQ9qrTGsAPmzjPc6b8WKuwlqZ1Ngd5py0WSjED8TfXSO/FD/xQ2jILrDQvg
         xTvfhzF5sVnvNty6niOeC4Vue8695KuwTyHUSGlaOJyCJuZrIp7W1GJCjF+8hxhDQr7/
         0U+/EZ96jz1mgqDteGDDMchF/Z7iEW6MkfYjnVkEzLDY7yGIwd+QUTUv4D7dF7he5Nkc
         fCljSQ9Ccrh+p03/4WQZf/JgyAcISLwWAdygnu9GwCdaSSsW/jQtelaWySMXQ4emXJPH
         wGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2fy3yU/nGYr2ZfPy8/bHaM4Fp6k4bSPzpYXlr5lnJmI=;
        b=WVsEepk0d6AIK70xvlLVx/OHOBwODNENC3ICUT3CeHQchKdlddyJ+bUE5AVXxo9POb
         7thctRQ4MKpu46g8KgcDmmEHKAwjK0M921YdTdrz/HNsocYkL5mZpcFVSrKOAvuGzMKf
         oSJ4Om38it4sh0fapHgANUTxAOVLNC+0U9XKQI/CWtaQf76uPtvPE25fnM+LbM7N5of4
         WK4wuDDebYzWkBXevc0EKvrFxD86HHOO1EwxOy9Oq+ubYS8b5AmUEvatQW1YIVGqwOsD
         QGhSOw4AFgmgtWKaDL+WBtVHBO6tHy8r+av5Ivn+E3NLdMZ1oBCQ4u47dFbac8sqE2Uf
         bm9w==
X-Gm-Message-State: AOAM533DvcxBYaDue7MJOe9KLOiRRCwDGR5LJrnefnByJVOerDnQEYt8
        1T4NuHFw3WxYqp+d92ntSAU=
X-Google-Smtp-Source: ABdhPJzTKq7qz2MvQVN87Tf9Bn2T9jRhMk0QBkZQgv2VT62ZBC0HbzQ1A2X+WAPNrlfFYJodzSIu6Q==
X-Received: by 2002:a05:620a:786:: with SMTP id 6mr40814401qka.196.1620937973811;
        Thu, 13 May 2021 13:32:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 66sm3499121qkh.54.2021.05.13.13.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 13:32:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 13 May 2021 13:32:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/601] 5.11.21-rc1 review
Message-ID: <20210513203252.GC911952@roeck-us.net>
References: <20210512144827.811958675@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 04:41:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.21 release.
> There are 601 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 461 pass: 460 fail: 1
Failed tests:
	mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs

Failure as already reported.

Guenter
