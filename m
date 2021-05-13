Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9337FF29
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhEMUdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhEMUda (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:33:30 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0F9C061574;
        Thu, 13 May 2021 13:32:20 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id k10so7223362qtp.9;
        Thu, 13 May 2021 13:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M1oskAKS27DqzwrOPskd+42e0/nMq1heLZSY/zOEPI0=;
        b=Uio8jzo2+ZIjvBlgwDHQjwPnKMI/JI7INBMxD0uKSH+VzIvJ9nqirbriD/uoAyarHJ
         bUuNhpyAEBfK6abTt4rMxJ9tTRLN31jHAbHbidKlbxjAKxnKomFVINEHACre1UhPPtjo
         oFvlUx2CQIXhoWi2PGn87UWHy6h8RGAVhLce3OvvYytmPWMLKGtaQYR25TiH9+PU41l7
         CNSlya3KsUPGlWlN5Uya3HDOox/391LPm35lmsbmKki5bn9hEf6KmZ9pPZedoAac9Il3
         We/K2NfwdbPWFP2hmfJi5D2WdEaxQi9KXqM6pCombHlK91M6zYrxlWXKtC319aqGTn9s
         nTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=M1oskAKS27DqzwrOPskd+42e0/nMq1heLZSY/zOEPI0=;
        b=sV/rCJ1dzcpDNlnnu6pbTxcCi+zhYm3rXqcIAT5b/ElF2ebTL1i9QHVTZk/eUcB9b0
         eq/zK9JLHlnphxcLg9WXIwMs3VUG+nDBSjiif2jYDSSCPswdeqctUeYDFjzzoN+mqhSQ
         sluBr3L3oeIPVagX5fFYLj2+7CexWKi37eVy7IzuStgR2ew58g03Irp+lhrFK4TENsLe
         VmM+jIvmPuzXE5VBbX7zoY6oIbZ5vBTEiI8tORq1tQeb0675EzcfysemBpxhglDblKnw
         QO9eCVmCglDq7HcC/bSVa+xJlDK9B6OZXtGVz5s0ouW4IY6eCot/70hvzsNKWkmRwqaJ
         4eJw==
X-Gm-Message-State: AOAM533WM2toOGxd3bo7U91ZRVhiZGta1CmvHj6TBLLhJuYE6x9JVpe5
        yLgFh6vhlstvBjWbHuGNxsk=
X-Google-Smtp-Source: ABdhPJwIDRJo5zI5zZa/25FEWhznU7stUpQZawDmoCiTIYVjOln0a3vgdssXBqxbcrOeVqmP/U4hjg==
X-Received: by 2002:ac8:570b:: with SMTP id 11mr8834839qtw.287.1620937939979;
        Thu, 13 May 2021 13:32:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 11sm3258404qky.71.2021.05.13.13.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 13:32:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 13 May 2021 13:32:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
Message-ID: <20210513203218.GB911952@roeck-us.net>
References: <20210512144819.664462530@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 04:41:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 454 fail: 1
Failed tests:
	mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs

Failure as already reported.

Guenter
