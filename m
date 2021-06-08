Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9131839FB27
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFHPtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231192AbhFHPtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 11:49:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73FEC60FE8;
        Tue,  8 Jun 2021 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623167230;
        bh=GbRp5BPUJ2Df0pG6TbZEFatA5ZEf7IyXImXQ60dD5uU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ddzfwYIUjOWwJi/BFn/MF65Xqi7Qz2m7oqfSMoNy8zBX52P5DDv49uYoiiM8HKtu1
         MujxFhIn5HT/eWGp3WuV2KvzrrLQIgzgK2zloVtHCznblnAUZ/uVtV+I3uLcVjZb3h
         KNKIs6xTiN5RnWGzehjEIdAIArFdMcLmEMi8RJ6U=
Date:   Tue, 8 Jun 2021 17:47:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, maz@kernel.org, alexandru.elisei@arm.com,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH v2 stable-5.12.y backport 0/2] KVM: arm64: Commit
 exception state on exit to userspace
Message-ID: <YL+Q+6wsn67Z1JEy@kroah.com>
References: <20210601140738.2026-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601140738.2026-1-yuzenghui@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 10:07:36PM +0800, Zenghui Yu wrote:
> As promised on the list [0], this series aims to backport 3 upstream
> commits [1,2,3] into 5.12-stable tree.
> 
> Patch #1 is already in the queue and therefore not included. Patch #2 can
> be applied now by manually adding the __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc
> macro (please review). Patch #3 can be applied cleanly then (after #2).
> 
> I've slightly tested it on my 920 (boot test and the whole kvm-unit-tests),
> on top of the latest linux-stable-rc/linux-5.12.y. Please consider taking
> them for 5.12-stable.
> 
> * From v1:
>   - Allocate a new number for __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc
>   - Collect Marc's R-b tags
> 
> [0] https://lore.kernel.org/r/0d9f123c-e9f7-7481-143d-efd488873082@huawei.com
> [1] https://git.kernel.org/torvalds/c/f5e30680616a
> [2] https://git.kernel.org/torvalds/c/26778aaa134a
> [3] https://git.kernel.org/torvalds/c/e3e880bb1518
> 
> Marc Zyngier (1):
>   KVM: arm64: Commit pending PC adjustemnts before returning to
>     userspace
> 
> Zenghui Yu (1):
>   KVM: arm64: Resolve all pending PC updates before immediate exit
> 
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/kvm/arm.c               | 20 +++++++++++++++++---
>  arch/arm64/kvm/hyp/exception.c     |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
>  4 files changed, 28 insertions(+), 5 deletions(-)
> 
> -- 
> 2.19.1
> 

All now queued up, thanks.,

greg k-h
