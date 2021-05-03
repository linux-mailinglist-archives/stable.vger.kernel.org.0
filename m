Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0333B37186F
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhECPvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 11:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhECPvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 11:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DAF2610C8;
        Mon,  3 May 2021 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620057020;
        bh=BMJrILOMBNPtSPtdylpuDTW4a8a4Um/NZx8UjOidZsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=fGpmG54cqQxDYjdTM4gMFA2C8/nqtmc6LNjSnoTyLcMsf8s9WJAzMAulU0xqVoLmV
         wPsS6P+ac0Yhy2hJ6zQe3zO8xRWRqTOpdUJelTM5bXTKZbMzM2hgUBFfJSFIGLT8vq
         KBQushaeP/LcdkOal0PB0z3GHhEJziTewTYZwBwWdiA2Wmj/gOZjhWf1uMKRRXMqWy
         l0H6BoBt8bqOgXfqiXPd6IlE7q7kqrZ2hMMmQvAxLeY17JQf2MaEdtmAbMSgnda9cs
         85h0P10mh3Bx3TM3wfLChaCl39q+K+62/UH4R5R7VPr9HcnCDFg2AOwHleJlB58vIu
         x+aiUzyIVWy1w==
Date:   Mon, 3 May 2021 10:50:18 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Prike Liang <Prike.Liang@amd.com>,
        linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Alexander.Deucher@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210503155018.GA910672@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503145702.GC910137@dhcp-10-100-145-180.wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 07:57:02AM -0700, Keith Busch wrote:
> On Mon, May 03, 2021 at 08:14:07AM +0100, Christoph Hellwig wrote:
> > On Fri, Apr 30, 2021 at 12:50:49PM -0500, Bjorn Helgaas wrote:
> > > Patch 2/2 only uses PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND in the nvme
> > > driver, so AFAICT there is no reason for the PCI core to keep track of
> > > the flag for you.
> > > 
> > > I see below that Christoph suggests it needs to be in the PCI core,
> > > but the reason needs to be explained in the commit log.
> > 
> > As far as I can tell this has nothing to do with NVMe except for the
> > fact that right now it mostly hits NVMe as the nvme drivers is one of
> > the few drivers not always doing a full device shutdown when the
> > system goes into the S3 power state.  But various x86 platforms now
> > randomly power done the link in that case.
> 
> Right, and the v5 of this series uses a generic name for the PCI quirk
> without mentioning "NVME".

It'd be nice if somebody would figure out how to cc: linux-pci on
these patches.
