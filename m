Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4295156C64
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 21:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgBIUcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 15:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbgBIUcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 15:32:42 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B29A207FF;
        Sun,  9 Feb 2020 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581280361;
        bh=P/v7SK5fSzdNNM7h+0uqrnw/0mggqkG3IsZ47tZyNPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JjMqnWSocfuY09K62EXup8CrKqH9m8SE6y/hUrXeWWVMU9wkgYax654HMGLCvX0xQ
         /AtbumIuJil/Y8GHaStCgerBKDtuwfDZalAl9BrkuB7lkjSm43mWB3oewTZjFijJE6
         JWeL88c8JLLXHQPwuLFwB8NmSLTDSmJtkSTureag=
Date:   Sun, 9 Feb 2020 15:32:40 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linmiaohe@huawei.com, liran.alon@oracle.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: nVMX: vmread should not set rflags
 to specify success in" failed to apply to 5.4-stable tree
Message-ID: <20200209203240.GC3584@sasha-vm>
References: <158125178414544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158125178414544@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:36:24PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From a4d956b9390418623ae5d07933e2679c68b6f83c Mon Sep 17 00:00:00 2001
>From: Miaohe Lin <linmiaohe@huawei.com>
>Date: Sat, 28 Dec 2019 14:25:24 +0800
>Subject: [PATCH] KVM: nVMX: vmread should not set rflags to specify success in
> case of #PF
>
>In case writing to vmread destination operand result in a #PF, vmread
>should not call nested_vmx_succeed() to set rflags to specify success.
>Similar to as done in VMPTRST (See handle_vmptrst()).
>
>Reviewed-by: Liran Alon <liran.alon@oracle.com>
>Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>Cc: stable@vger.kernel.org
>Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Conflict because of missing c90f4d03cce1 ("kvm: nVMX: Aesthetic cleanup
of handle_vmread and handle_vmwrite") on older kernels. Cleaned up and
queued for 5.4-4.4.

-- 
Thanks,
Sasha
