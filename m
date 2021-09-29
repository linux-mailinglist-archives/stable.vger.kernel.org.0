Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF5141C9A7
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343809AbhI2QIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 12:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346064AbhI2QHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 12:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62F1161216;
        Wed, 29 Sep 2021 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632931552;
        bh=fNNNxYHWQEEd+3svnB573Ub1aoDLkCmetUDrutXYuG4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=a3lb0s0JUVDnmqe/xWSvr5ySGESDD2phU80Pk4SP+kUHOgi5kOarzDq3hQh+oElF2
         yp8h1wAaM8+5SVAwPsB+w5HYfiw/X21NtJIehwNTcQkQwyBEAD7zTUl3Sb6q5PEomj
         h4yflU/w+5tdYrBH5SSKVFdVTd2qK79WQ+IHW4OG3JObV2FD4yhUZ2YjBoZjaOmo7y
         JJ4i+qoRtVT305vk3mE5YGSkepVmImZXlkO4EvaUeN8EWlo4ML19/iFW3D28Vgsryf
         sGy54O9aX8iSfFpPdo5Wpm56kOcfJGvQdpIZGlwSU0bw/t5r0wGL0lJup2OtPzxSR4
         jvajW2ZPk8nHw==
Date:   Wed, 29 Sep 2021 11:05:50 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, paulmck@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210929160550.GA773748@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929061107.243699c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 06:11:07AM -0700, Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 19:46:48 -0700 Jakub Kicinski wrote:
> > My Lenovo T490s with i7-8665U had been marking TSC as unstable
> > since v5.13, resulting in very sluggish desktop experience...
> 
> Where do we stand? Waiting for tglx to refactor PC10 detection and use
> that, or just review delay?

From my point of view, this is an x86 issue, not a PCI one, so I'll
defer to the x86 folks.

> > +++ b/arch/x86/kernel/early-quirks.c
> > @@ -716,6 +716,8 @@ static struct chipset early_qrk[] __initdata = {
> >  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> >  	{ PCI_VENDOR_ID_INTEL, 0x3e20,
> >  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> > +	{ PCI_VENDOR_ID_INTEL, 0x3e34,
> > +		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> >  	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
> >  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> >  	{ PCI_VENDOR_ID_INTEL, 0x8a12,
> 
