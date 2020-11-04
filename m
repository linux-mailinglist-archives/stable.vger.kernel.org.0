Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2897C2A667A
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgKDOgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgKDOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 09:36:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C622920709;
        Wed,  4 Nov 2020 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604500579;
        bh=rAWaU2Y008uAEMUI6gGHxq/S/dBhzoRPmOELlx34STg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sf+wSO1pqU94V8Lzx/YfZEX012IIwppE54eJUQm7y+hqrgtPR+p2BzHGVmi6s/ugJ
         N+GXv5OzMrci4lFL749pHOKRlVTP0qx9VESXFupjLFdyx7PdkoxmGSM7Kndyaps9Im
         SaGSijKVk3yRDuTVzhW2rfdfKKrTr/ISxI6xFnLo=
Date:   Wed, 4 Nov 2020 15:37:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: build failures in v4.4.y stable queue
Message-ID: <20201104143709.GC2202359@kroah.com>
References: <20201104141230.GC4312@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104141230.GC4312@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 06:12:30AM -0800, Guenter Roeck wrote:
> Building ia64:defconfig ... failed
> --------------
> Error log:
> drivers/acpi/numa.c: In function 'pxm_to_node':
> drivers/acpi/numa.c:49:43: error: 'numa_off' undeclared

Caused by 8a3decac087a ("ACPI: Add out of bounds and numa_off
protections to pxm_to_node()"), I'll go drop it.

Sasha, you didn't queue this up to 4.9, but you did to 4.4?

> 
> Building powerpc:defconfig ... failed
> --------------
> Error log:
> arch/powerpc/kvm/book3s_hv.c: In function ‘kvm_arch_vm_ioctl_hv’:
> arch/powerpc/kvm/book3s_hv.c:3161:7: error: implicit declaration of function ‘kvmhv_on_pseries’

Caused by 05e6295dc7de ("KVM: PPC: Book3S HV: Do not allocate HPT for a
nested guest"), I'll go drop this.

Sasha, why did you only queue this up to 4.4 and 5.4 and 5.9 and not the
middle queues as well?

thanks,

greg k-h
