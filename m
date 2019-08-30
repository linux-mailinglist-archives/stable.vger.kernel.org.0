Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC593A37FA
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfH3NsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 09:48:03 -0400
Received: from 8bytes.org ([81.169.241.247]:52456 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbfH3NsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 09:48:03 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 0302720E; Fri, 30 Aug 2019 15:48:01 +0200 (CEST)
Date:   Fri, 30 Aug 2019 15:48:00 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH] iommu/vt-d: Fix wrong analysis whether devices share the
 same bus
Message-ID: <20190830134800.GA11578@8bytes.org>
References: <20190820085317.29458-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820085317.29458-1-namit@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 01:53:17AM -0700, Nadav Amit wrote:
>  drivers/iommu/intel_irq_remapping.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.
