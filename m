Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A053EB27D
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbhHMITz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239581AbhHMITy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2496109E;
        Fri, 13 Aug 2021 08:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628842768;
        bh=TvHtyw8XEy9+YFEwQhnp3Gp3MU8ta3O84sqfiw6+pVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r9tsJHgwosbiQUXlLm6uruskIhT2IR34LMjt9Y5how8AAw0cl/bAMfnaqObd9Cwwc
         VG/Gl9XnUy0VhybKDjAO9nTetD+Jlk5lzfxODahAKC6eyi2noG0hPJnX6UIpSwsrJ/
         uaM+WQS1n7pNzSxKvc1WDkLVeAw1wXTGBDntqryE=
Date:   Fri, 13 Aug 2021 10:19:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI/sysfs: Use correct variable for the legacy_mem sysfs
 object
Message-ID: <YRYrDQ3yuvtLtoKr@kroah.com>
References: <20210812161710.GA2479934@bjorn-Precision-5520>
 <20210812171450.GA2485383@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812171450.GA2485383@bjorn-Precision-5520>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 12, 2021 at 12:14:50PM -0500, Bjorn Helgaas wrote:
> On Thu, Aug 12, 2021 at 11:17:12AM -0500, Bjorn Helgaas wrote:
> > [+to Greg, please update sysfs_defferred_iomem_get_mapping-5.15]
> 
> Actually, Greg, totally up to you, but if nobody else is depending on
> the sysfs_defferred_iomem_get_mapping-5.15 branch, another possibility
> would be for you to drop that branch and for me to merge the two
> patches on it + Krzysztof's fix below + (hopefully) Krzysztof's PCI
> static attribute work.

I can not "drop" the branch as it is already merged into my
driver-core-next branch that I can not rebase.  I could revert it, but
is that really needed?

> That would make my v5.15 pull request easier because I simple-mindedly
> base all my branches on -rc1 while your branch is based on -rc3.  But
> again, up to you.  I put those two patches on a local branch:
> 
>   94b34bc04c25 ("sysfs: Rename struct bin_attribute member to f_mapping")
>   97e9dada53f1 ("sysfs: Invoke iomem_get_mapping() from the sysfs open callback")
> 
> in case that seems better to you.

I do not see what I can do with that here as it's already in my tree :(

confused,

greg k-h
