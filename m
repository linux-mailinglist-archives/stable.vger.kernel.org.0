Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D164222B6C0
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 21:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGWTao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 15:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgGWTao (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 15:30:44 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33B2B2067D;
        Thu, 23 Jul 2020 19:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595532643;
        bh=7InW/I38muM+u0qDvAzcUWvmPajbXN7K+EHKB8+aI98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VoGkpg7/H/Gv5IFWFsnv3YGd9Frr08vHEFmbXvHV17HbCRv5l1QxuOEeN+84FkX9M
         TiN0omh+WS5rh/FCKxAypSKymdubnrxE3f/EiI+4VGLZxy0A4lBLQBqFTt2r8ylvVJ
         RVPy/b29uNx5A8yMwdwYNa6gxhM5VF+H99Mm6Bmg=
Date:   Thu, 23 Jul 2020 14:30:41 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] PCI/ATS: PASID and PRI are only enumerated in PF devices.
Message-ID: <20200723193041.GA1446817@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723173819.GA345408@otc-nc-03>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 23, 2020 at 10:38:19AM -0700, Raj, Ashok wrote:
> Hi Bjorn
> 
> On Tue, Jul 21, 2020 at 09:54:01AM -0500, Bjorn Helgaas wrote:
> > On Mon, Jul 20, 2020 at 09:43:00AM -0700, Ashok Raj wrote:
> > > PASID and PRI capabilities are only enumerated in PF devices. VF devices
> > > do not enumerate these capabilites. IOMMU drivers also need to enumerate
> > > them before enabling features in the IOMMU. Extending the same support as
> > > PASID feature discovery (pci_pasid_features) for PRI.
> > > 
> > > Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> > 
> > Hi Ashok,
> > 
> > When you update this for the 0-day implicit declaration thing, can you
> > update the subject to say what the patch *does*, as opposed to what it
> > is solving?  Also, no need for a period at the end.
> 
> Yes, will update and resend. Goofed up a couple things, i'll update those
> as well.
> 
> > Does this fix a regression?  Is it associated with a commit that we
> > could add as a "Fixes:" tag so we know how far back to try to apply
> > to stable kernels?
> 
> Yes, 

Does that mean "yes, this fixes a regression"?

> but the iommu files moved location and git fixes tags only generates
> for a few handful of commits and doesn't show the old ones. 

Not sure how to interpret the rest of this.  I'm happy to include the
SHA1 of the original commit that added the regression, even if the
file has moved since then.

Bjorn
