Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB13959E3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhEaLuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhEaLuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 07:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F3D2611CA;
        Mon, 31 May 2021 11:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622461722;
        bh=891VrBkNRRtoIW8BFWYIMMMjBurDAf5XshY6TW0F4cI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ybe7aQLjs9BX1cG3pqg73l5Pc4ZOJduzd92tGEhqiOMUlmhve12XTC4BYgsT/BBQE
         w55uPuEArvQ2ET9TuapXJ3/XfXQA5i4nyvZl4n0x/OV6cXrab8UxLpvgDCC45TVcF0
         1gTe0l3k8YM9eWePQwNIs0Vcnsf8zsn7fkv7Kb6A=
Date:   Mon, 31 May 2021 13:48:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     maz@kernel.org, alexandru.elisei@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: arm64: Commit pending PC adjustemnts
 before returning to" failed to apply to 5.12-stable tree
Message-ID: <YLTNF8rJTT3X/VgH@kroah.com>
References: <162237159654109@kroah.com>
 <0d9f123c-e9f7-7481-143d-efd488873082@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d9f123c-e9f7-7481-143d-efd488873082@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 06:52:49PM +0800, Zenghui Yu wrote:
> Hi Greg,
> 
> On 2021/5/30 18:46, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.12-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Indeed this patch should be applied to the 5.12-stable tree, together
> with other 2 patches, in order.
> 
> [1/3] f5e30680616a ("KVM: arm64: Move __adjust_pc out of line")
> [2/3] 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before
> returning to userspace")
> [3/3] e3e880bb1518 ("KVM: arm64: Resolve all pending PC updates before
> immediate exit")
> 
> Patch #1 has been applied cleanly onto linux-stable-rc/linux-5.12.y.
> It's just fine. It's expected that there's no functional change with
> patch #1.

That's already in the queue.

> Patch #2 (this patch) can be applied by manually resolving the conflict.
> I can send a patch for it if Marc doesn't get enough bandwidth.

I need a resolution, I couldn't figure out where to put the change in
arch/arm64/include/asm/kvm_asm.h at.

> Patch #3 has been applied in a wrong way [*]. I'll reply to it so that
> you can drop it from the current stable queue.

Ok, will go drop that one right now, thanks!

greg k-h
