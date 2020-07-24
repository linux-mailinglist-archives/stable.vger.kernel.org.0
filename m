Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5904822C131
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGXItD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 04:49:03 -0400
Received: from 8bytes.org ([81.169.241.247]:59022 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbgGXItD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 04:49:03 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 63D2F46A; Fri, 24 Jul 2020 10:49:02 +0200 (CEST)
Date:   Fri, 24 Jul 2020 10:48:59 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Ashok Raj <ashok.raj@intel.com>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Lu Baolu <baolu.lu@intel.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v3 1/1] PCI/ATS: Check PRI supported on the PF device
 when SRIOV is enabled
Message-ID: <20200724084859.GQ27672@8bytes.org>
References: <1595543849-19692-1-git-send-email-ashok.raj@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595543849-19692-1-git-send-email-ashok.raj@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 23, 2020 at 03:37:29PM -0700, Ashok Raj wrote:
> PASID and PRI capabilities are only enumerated in PF devices. VF devices
> do not enumerate these capabilites. IOMMU drivers also need to enumerate
> them before enabling features in the IOMMU. Extending the same support as
> PASID feature discovery (pci_pasid_features) for PRI.
> 
> Fixes: b16d0cb9e2fc ("iommu/vt-d: Always enable PASID/PRI PCI capabilities before ATS")
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>

Acked-by: Joerg Roedel <jroedel@suse.de>

