Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5970A7512
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 22:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfICUjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 16:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfICUjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 16:39:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26CB207E0;
        Tue,  3 Sep 2019 20:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567543143;
        bh=bZtzty9af7kRsvHmUoTn6KzfKB0cciJND8F5+HiK4Zc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PrtUwQjMiHLGjgMX/dsORTYl3yGmxEO55pAzSs6Dk4pTEEKdYZhkr5vr/ruUyZekC
         /Apnrca0IyBeetgtptiXvPIdjV2FnfR/RTJSwzZOfDXTcbd3Qnmmt7dflEAswx+PXX
         OtwpIs+mTduwJVAcoO0f+0YvNMjoqSz1gCayy4fU=
Date:   Tue, 3 Sep 2019 16:39:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     maz@kernel.org, andre.przywara@arm.com, will@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: arm/arm64: vgic-v2: Handle SGI bits
 in GICD_I{S,C}PENDR0" failed to apply to 4.19-stable tree
Message-ID: <20190903203902.GM5281@sasha-vm>
References: <156753605576100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156753605576100@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:40:55PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up and queued it for 4.19, 4.14, and 4.9. Just context
changes due to missing 8fa3adb8c6bee (KVM: arm/arm64: vgic: Make
vgic_irq->irq_lock a raw_spinlock).

--
Thanks,
Sasha
