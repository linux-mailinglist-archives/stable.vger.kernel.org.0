Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF69A160070
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 21:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOUXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 15:23:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgBOUXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Feb 2020 15:23:20 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E866A207FF;
        Sat, 15 Feb 2020 20:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581798200;
        bh=txuUHI+IT6WcSY5jyP7bxO+zuwppHijiFgpJ4ENkcQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kZWVwZjRx13QuHR3csJgV+++ntoagspa2unxY/Y+23/qu323Em+NXO0731BSDMgVT
         4yvknOq/8FulEz6APNKAxbf/glOsfRxTUri1kL3zA5+rQ2o/G84Bz/I43I0LQlnoLA
         riQc7IIoMUEu+8sqj41AX+nmLrm0I/xMIRsy8nSQ=
Date:   Sat, 15 Feb 2020 15:23:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org,
        Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [stable 4.14 PATCH 1/3] arm64: cpufeature: Set the FP/SIMD
 compat HWCAP bits properly
Message-ID: <20200215202319.GI1734@sasha-vm>
References: <20200214151937.1950083-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200214151937.1950083-1-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 03:19:35PM +0000, Suzuki K Poulose wrote:
>commit 7ef1ab8792c50797c6c5c7c5150a02460 upstream
>
>We set the compat_elf_hwcap bits unconditionally on arm64 to
>include the VFP and NEON support. However, the FP/SIMD unit
>is optional on Arm v8 and thus could be missing. We already
>handle this properly in the kernel, but still advertise to
>the COMPAT applications that the VFP is available. Fix this
>to make sure we only advertise when we really have them.
>
>Cc: stable@vger.kernel.org # v4.14
>Cc: Will Deacon <will@kernel.org>
>Cc: Mark Rutland <mark.rutland@arm.com>
>Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
>Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Queued for 4.14, thank you.

-- 
Thanks,
Sasha
