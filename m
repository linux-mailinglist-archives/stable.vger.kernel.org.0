Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC318180051
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 15:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgCJOhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 10:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgCJOhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 10:37:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 321E420848;
        Tue, 10 Mar 2020 14:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583851041;
        bh=7+Rolt4JAaG2NPONONFU5lXnQMOHuojK9VaWjCMa3LY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1Ltik8vOL3+KxzllK7dXzoeVaqUxu1z/idbUmXkIPXqHU5VySXHHtQYtDrIR9zEbE
         9Kdwe/T7W+IcXSseVKVL0z/TNLK7A3WN757QSv2mVgLcZ10sWbg7T+y9X4Y1/dMR6Y
         FzG6SCiRGRDfzUD6Cs3m/ti9bhB/XA6RZc/hNi70=
Date:   Tue, 10 Mar 2020 15:37:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     rhkernel-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Paul Lai <plai@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org,
        Oliver Upton <oupton@google.com>
Subject: Re: [RHEL 8.2 virt PATCH 1/3] KVM: nVMX: Don't emulate instructions
 in guest mode
Message-ID: <20200310143719.GC3376131@kroah.com>
References: <20200310141152.29029-1-jmaloy@redhat.com>
 <20200310141152.29029-2-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310141152.29029-2-jmaloy@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 10:11:50AM -0400, Jon Maloy wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> vmx_check_intercept is not yet fully implemented. To avoid emulating
> instructions disallowed by the L1 hypervisor, refuse to emulate
> instructions by default.
> 
> Cc: stable@vger.kernel.org
> [Made commit, added commit msg - Oliver]
> Signed-off-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> (cherry picked from commit 07721feee46b4b248402133228235318199b05ec)
> Signed-off-by: Jon Maloy <jmaloy@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please fix your email system to not mail public people internal Red
Hat-specific things :(
