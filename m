Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982CF33F134
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhCQNdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 09:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhCQNcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 09:32:42 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DA7C06174A;
        Wed, 17 Mar 2021 06:32:41 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5B8992DA; Wed, 17 Mar 2021 14:32:38 +0100 (CET)
Date:   Wed, 17 Mar 2021 14:32:35 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] iommu/amd: Don't call early_amd_iommu_init() when
 AMD IOMMU is disabled
Message-ID: <YFIE8xnr/HWqxm4p@8bytes.org>
References: <20210317091037.31374-1-joro@8bytes.org>
 <20210317091037.31374-3-joro@8bytes.org>
 <449d4a2d192d23eb504e43b13c35c326f2d0309a.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <449d4a2d192d23eb504e43b13c35c326f2d0309a.camel@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 11:47:11AM +0000, David Woodhouse wrote:
> If you've already moved the Stoney Ridge check out of the way, there's
> no real reason why you can't just set init_state=IOMMU_CMDLINE_DISABLED
> directly from parse_amd_iommu_options(), is there? Then you don't need
> the condition here at all?

True, there is even more room for optimization. The amd_iommu_disabled
variable can go away entirely, including its checks in
early_amd_iommu_init(). I will do a patch-set on-top of this for v5.13
which does more cleanups.

Thanks,

	Joerg
