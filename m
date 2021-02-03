Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E9730D3FD
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 08:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhBCHVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 02:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230193AbhBCHVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 02:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5340364F61;
        Wed,  3 Feb 2021 07:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612336858;
        bh=TpgXwgnQr+jX+xbM5MDKMswVgu0xwvcRdjla+jPf3N0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijUJ/rAWbhlk+n8TQoUnPF1kznhHe2vwchiCjXGo/ROV2o87f5ZOb+jDGfyn+XzmB
         1zwl5GI2yz5X7ux1q20U0T2tRMwdT8XAQWwzZU0TR6/0/dnBAEyn+KIF48srnOuHFq
         pOYQzCVoNou+Ucu5cdtzKV+Y9j12XOO4QegD5hHg=
Date:   Wed, 3 Feb 2021 08:20:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Quentin Perret <qperret@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 066/142] KVM: Documentation: Fix spec for
 KVM_CAP_ENABLE_CAP_VM
Message-ID: <YBpO1vKngzl+8WNy@kroah.com>
References: <20210202132957.692094111@linuxfoundation.org>
 <20210202133000.449940320@linuxfoundation.org>
 <20210203010506.GU4035784@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203010506.GU4035784@sasha-vm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 08:05:06PM -0500, Sasha Levin wrote:
> On Tue, Feb 02, 2021 at 02:37:09PM +0100, Greg Kroah-Hartman wrote:
> > From: Quentin Perret <qperret@google.com>
> > 
> > commit a10f373ad3c760dd40b41e2f69a800ee7b8da15e upstream.
> > 
> > The documentation classifies KVM_ENABLE_CAP with KVM_CAP_ENABLE_CAP_VM
> > as a vcpu ioctl, which is incorrect. Fix it by specifying it as a VM
> > ioctl.
> > 
> > Fixes: e5d83c74a580 ("kvm: make KVM_CAP_ENABLE_CAP_VM architecture agnostic")
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > Message-Id: <20210108165349.747359-1-qperret@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> > Documentation/virt/kvm/api.rst |    2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1319,7 +1319,7 @@ documentation when it pops into existenc
> > 
> > :Capability: KVM_CAP_ENABLE_CAP_VM
> > :Architectures: all
> > -:Type: vcpu ioctl
> > +:Type: vm ioctl
> > :Parameters: struct kvm_enable_cap (in)
> > :Returns: 0 on success; -1 on error
> 
> Um, how did this patch made it in?

It came from my scripts, keeping documentation correct seems to be
something it wanted to do :)

thanks,

greg k-h
