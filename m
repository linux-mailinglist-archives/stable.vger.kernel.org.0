Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3618A12291E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLQKps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:45:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:60204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfLQKps (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 05:45:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8CDE3B33E;
        Tue, 17 Dec 2019 10:45:37 +0000 (UTC)
Date:   Tue, 17 Dec 2019 11:45:35 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu: set group default domain before creating direct
 mappings
Message-ID: <20191217104535.GB28651@suse.de>
References: <20191210185606.11329-1-jsnitsel@redhat.com>
 <49bca506-1f6a-ab2d-fac0-302073737af7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49bca506-1f6a-ab2d-fac0-302073737af7@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 08:54:21AM +0800, Lu Baolu wrote:
> On 12/11/19 2:56 AM, Jerry Snitselaar wrote:
> > iommu_group_create_direct_mappings uses group->default_domain, but
> > right after it is called, request_default_domain_for_dev calls
> > iommu_domain_free for the default domain, and sets the group default
> > domain to a different domain. Move the
> > iommu_group_create_direct_mappings call to after the group default
> > domain is set, so the direct mappings get associated with that domain.
> > 
> > Cc: Joerg Roedel <jroedel@suse.de>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> 
> This fix looks good to me.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Applied, thanks.

