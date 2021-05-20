Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547A438B5B7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 20:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhETSFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 14:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231648AbhETSFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 14:05:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E95760FF1;
        Thu, 20 May 2021 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621533825;
        bh=+S8gvzrrVIm9MmYR5IHUp56ZCZSVIkWr11OHTYVVHjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QBltvNlp1cuGHicXMTZJMAwd56LlDbbW14zoq4ivEXNwFrQHR/GlRO+cpnSVEARgn
         /CNpJcY/rFmqoYsYMXgtBsK5LZyfiiDnUTyhkeyI6d9qHgke9NrgTIC2pD+NwCFOlf
         UTRA7rdArULfg3fwozgPV7jcNMqESB1EXgB4XZ9VWLVOP0PEuV1bOUgZ6ODCrQLetE
         39+TYx7RRWm217PQ6ywAQ3Fb3D3idiPAdkw+0Fjb7eP5rCxpiemMwkpx2tYQvHq75v
         97MJtq79ZQf9E4CDymZbyGnkUNLkHNx0MF3+xCitb9JOcXg5ZTt2ojckMc20UomZsd
         dDyDERAsBCaXA==
Date:   Thu, 20 May 2021 12:03:43 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        "Liang, Prike" <Prike.Liang@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210520180343.GA3783@C02WT3WMHTD6>
References: <BYAPR12MB3238055D4B08CC91D9ABFD39FB2A9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <20210520165848.GA324094@bjorn-Precision-5520>
 <MN2PR12MB4488F16CE50BFD4E1F453CFAF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB4488F16CE50BFD4E1F453CFAF72A9@MN2PR12MB4488.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 05:40:54PM +0000, Deucher, Alexander wrote:
> It doesn't really have anything to do with PCI.  The PCI link is just a proxy
> for specific AMD platforms.  It's platform firmware behavior we are catering
> to.  This was originally posted as an nvme quirk, but during the review it
> was recommended to move the quirk into PCI because the quirk is not specific
> a particular NVMe device, but rather a set of AMD platforms.  Lots of other
> platforms seems to do similar things in the nvme driver based on ACPI or DMI
> flags, etc.  On our hardware this nvme flag is required for all cezanne and
> renoir platforms.

The quirk was initially presented as specific to the pci root. Does it make
more sense for nvme to recognize the limitation from querying a different
platform component instead of the pci bus?
