Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B92E3EB914
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242021AbhHMPVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242528AbhHMPSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:18:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 320F1604D7;
        Fri, 13 Aug 2021 15:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867866;
        bh=7IvGPmbqt6MeOuUj/O12dGFXesS8HBm8zaWzZDYSZSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=szT/Ohsjn9/mPLA0w8HRUPcr13w/4QxpFOK0SLkKliYX/HXKfUpfV25WshO9bsjWq
         bug2cJTKZjzXohR20iZfvKgzJWMKGyDTRp55ivfUuhBYxChjrWMztb/NyKzNXvTXRf
         86CbOG9kIEGGAx50fTdBgXAW+etmkNHnZJWUvb98=
Date:   Fri, 13 Aug 2021 17:09:37 +0200
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
Message-ID: <YRaLMWh3zsVQqNr1@kroah.com>
References: <YRYrDQ3yuvtLtoKr@kroah.com>
 <20210813142901.GA2574831@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813142901.GA2574831@bjorn-Precision-5520>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 09:29:01AM -0500, Bjorn Helgaas wrote:
> On Fri, Aug 13, 2021 at 10:19:25AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Aug 12, 2021 at 12:14:50PM -0500, Bjorn Helgaas wrote:
> > > On Thu, Aug 12, 2021 at 11:17:12AM -0500, Bjorn Helgaas wrote:
> > > > [+to Greg, please update sysfs_defferred_iomem_get_mapping-5.15]
> > > 
> > > Actually, Greg, totally up to you, but if nobody else is depending on
> > > the sysfs_defferred_iomem_get_mapping-5.15 branch, another possibility
> > > would be for you to drop that branch and for me to merge the two
> > > patches on it + Krzysztof's fix below + (hopefully) Krzysztof's PCI
> > > static attribute work.
> > 
> > I can not "drop" the branch as it is already merged into my
> > driver-core-next branch that I can not rebase.  I could revert it, but
> > is that really needed?
> 
> Nope, I don't think a revert is warranted.  I'll take care of getting
> Krzysztof's fix into v5.15.

Thanks, I'll handle the merge issues after that happens in my tree.

greg k-h
