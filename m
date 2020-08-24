Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B3D2500C2
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgHXPTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 11:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgHXPTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 11:19:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBEBE206B5;
        Mon, 24 Aug 2020 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598282357;
        bh=dTNJ6f4sFfr0WRo993QckaVjaB2TOj8/mYY4GuOEL2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=avluCVyerL/x7VoZPTTQeSselXZiLn+S3dHGpKj+Y1MaZQaucpsKbgtoTrAggRGBz
         SflAewOZ+p95msqK6r6lax6ZmNeiTFSnsANxr1fi2g3VcQC34S767R9B1YhE4QhE6s
         sF1enDSjACba8vQ5LGsPxxWQQ4qRqHApz49tCCHI=
Date:   Mon, 24 Aug 2020 17:19:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, james.morse@arm.com, pbonzini@redhat.com,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH stable-5.8.y backport 1/2] KVM: Pass MMU notifier range
 flags to kvm_unmap_hva_range()
Message-ID: <20200824151933.GB435319@kroah.com>
References: <20200824113048.24960-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824113048.24960-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 12:30:47PM +0100, Will Deacon wrote:
> commit fdfe7cbd58806522e799e2a50a15aee7f2cbb7b6 upstream.
> 
> The 'flags' field of 'struct mmu_notifier_range' is used to indicate
> whether invalidate_range_{start,end}() are permitted to block. In the
> case of kvm_mmu_notifier_invalidate_range_start(), this field is not
> forwarded on to the architecture-specific implementation of
> kvm_unmap_hva_range() and therefore the backend cannot sensibly decide
> whether or not to block.
> 
> Add an extra 'flags' parameter to kvm_unmap_hva_range() so that
> architectures are aware as to whether or not they are permitted to block.
> 
> Cc: <stable@vger.kernel.org> # v5.8 only

This matched the 5.8 patch I had already, but I took it just to be safe,
thanks :)

greg k-h
