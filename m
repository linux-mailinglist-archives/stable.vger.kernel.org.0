Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E909F377057
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 09:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhEHHXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 03:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEHHXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 03:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 583F36145E;
        Sat,  8 May 2021 07:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620458555;
        bh=75QzCGmWcilMFGqhtLbNi4lbm90RLc6Y8MR3bsjz8IA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzNgqZ1PGsNQWOtBMSrc7TB2OFZjXh0Ezp1/zJVKj9u+3OmDAA/w+jSbIVRyp8sd5
         1iyX9tOY7ZjW/jlvEhfQKvgcMWTEjouzxmq/liD4gbqjTrGog1gREUhIKwUGEVPii1
         z+sbXfG6rY+Q4wY+5fnzC19xZK+ZGQSqv/9yYGsM=
Date:   Sat, 8 May 2021 09:22:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, maz@kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        cohuck@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
Message-ID: <YJY8OOGMNEp97ej9@kroah.com>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021 at 03:11:52PM +0800, Zhu Lingshan wrote:
> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
> 
> The reverted commit may cause VM freeze on arm64 platform.
> Because on arm64 platform, stop a consumer will suspend the VM,
> the VM will freeze without a start consumer
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  virt/lib/irqbypass.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
