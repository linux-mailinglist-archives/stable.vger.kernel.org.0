Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50002D983
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 11:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfE2JwX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 05:52:23 -0400
Received: from prv1-mh.provo.novell.com ([137.65.248.33]:33324 "EHLO
        prv1-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2JwX (ORCPT
        <rfc822;groupwise-stable@vger.kernel.org:6:2>);
        Wed, 29 May 2019 05:52:23 -0400
Received: from INET-PRV1-MTA by prv1-mh.provo.novell.com
        with Novell_GroupWise; Wed, 29 May 2019 03:52:22 -0600
Message-Id: <5CEE56510200007800233550@prv1-mh.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 18.1.1 
Date:   Wed, 29 May 2019 03:52:17 -0600
From:   "Jan Beulich" <JBeulich@suse.com>
To:     "Juergen Gross" <jgross@suse.com>
Cc:     "Stefano Stabellini" <sstabellini@kernel.org>,
        <iommu@lists.linux-foundation.org>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2 1/3] xen/swiotlb: fix condition for
 calling xen_destroy_contiguous_region()
References: <20190529090407.1225-1-jgross@suse.com>
 <20190529090407.1225-2-jgross@suse.com>
In-Reply-To: <20190529090407.1225-2-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>> On 29.05.19 at 11:04, <jgross@suse.com> wrote:
> The condition in xen_swiotlb_free_coherent() for deciding whether to
> call xen_destroy_contiguous_region() is wrong: in case the region to
> be freed is not contiguous calling xen_destroy_contiguous_region() is
> the wrong thing to do: it would result in inconsistent mappings of
> multiple PFNs to the same MFN. This will lead to various strange
> crashes or data corruption.
> 
> Instead of calling xen_destroy_contiguous_region() in that case a
> warning should be issued as that situation should never occur.
> 
> Cc: stable@vger.kernel.org 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>


