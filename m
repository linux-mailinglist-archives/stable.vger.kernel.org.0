Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5162156C8F
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 22:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgBIVUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 16:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbgBIVUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 16:20:23 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7856220708;
        Sun,  9 Feb 2020 21:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581283222;
        bh=KNXh0UnmUOnTwOu0hXfhm7rqZrsYrzEWIKS8Cyzi0AY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=miMxbWa3vfVAHT9sBXvwNErHL3KowWi+rhPEb6QSKLFSFAcWprFqqgq/kUinOwwRH
         emj61UoqkDKyQE8L6+0B/woiE3jbfnsxBLoF6YN7rRSIOT7CZTsJDIjt56IZslll/s
         BPpYfc15uqQnqKIN31wkThXJ+vHXlwDv+xa7TXb8=
Date:   Sun, 9 Feb 2020 16:20:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: Use vcpu-specific gva->hva
 translation when querying" failed to apply to 5.5-stable tree
Message-ID: <20200209212021.GD3584@sasha-vm>
References: <15812517989452@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15812517989452@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:36:38PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From f9b84e19221efc5f493156ee0329df3142085f28 Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Wed, 8 Jan 2020 12:24:37 -0800
>Subject: [PATCH] KVM: Use vcpu-specific gva->hva translation when querying
> host page size
>
>Use kvm_vcpu_gfn_to_hva() when retrieving the host page size so that the
>correct set of memslots is used when handling x86 page faults in SMM.
>
>Fixes: 54bf36aac520 ("KVM: x86: use vcpu-specific functions to read/write/translate GFNs")
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

5.5-4.14 were fixed by working around not having 2f57b7051fe8 ("KVM:
x86/mmu: Persist gfn_lpage_is_disallowed() to max_level") on those
kernels.

4.9 and 4.4 still need a backport.

-- 
Thanks,
Sasha
