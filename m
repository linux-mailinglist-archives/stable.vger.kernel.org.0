Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B6C22B4FC
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 19:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgGWRiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 13:38:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:47251 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgGWRiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 13:38:20 -0400
IronPort-SDR: Swnt+x6Avvevd67Xah2bgxQEC3FGmqxGXZBxCQ95CovRjpc99PtBodv0EL+hIB3F7ElbD9tF3r
 62M5hqOSorzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="150572895"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="150572895"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 10:38:19 -0700
IronPort-SDR: RAlpV8HD4DHIIAZb8EmCMWGPilcgqD0Gm+gGatQLHiZhoYs228KT/Kn2JKaqWZpDGUSfH0aBLg
 jPu0+Fu/mxNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="462939769"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by orsmga005.jf.intel.com with ESMTP; 23 Jul 2020 10:38:19 -0700
Date:   Thu, 23 Jul 2020 10:38:19 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH] PCI/ATS: PASID and PRI are only enumerated in PF devices.
Message-ID: <20200723173819.GA345408@otc-nc-03>
References: <1595263380-209956-1-git-send-email-ashok.raj@intel.com>
 <20200721145401.GA1117318@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721145401.GA1117318@bjorn-Precision-5520>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn

On Tue, Jul 21, 2020 at 09:54:01AM -0500, Bjorn Helgaas wrote:
> On Mon, Jul 20, 2020 at 09:43:00AM -0700, Ashok Raj wrote:
> > PASID and PRI capabilities are only enumerated in PF devices. VF devices
> > do not enumerate these capabilites. IOMMU drivers also need to enumerate
> > them before enabling features in the IOMMU. Extending the same support as
> > PASID feature discovery (pci_pasid_features) for PRI.
> > 
> > Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> 
> Hi Ashok,
> 
> When you update this for the 0-day implicit declaration thing, can you
> update the subject to say what the patch *does*, as opposed to what it
> is solving?  Also, no need for a period at the end.

Yes, will update and resend. Goofed up a couple things, i'll update those
as well.


> 
> Does this fix a regression?  Is it associated with a commit that we
> could add as a "Fixes:" tag so we know how far back to try to apply
> to stable kernels?

Yes, but the iommu files moved location and git fixes tags only generates
for a few handful of commits and doesn't show the old ones. 

Cheers,
Ashok
