Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DD96255E9
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 09:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbiKKI5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 03:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKKI52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 03:57:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792C07723E
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 00:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59FDC61F02
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 08:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE94BC433C1;
        Fri, 11 Nov 2022 08:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668157046;
        bh=L8nIzM2ad2mazPp6aqwTIdNodqcThvldp8rplkDPm4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gljcx5JsKdcrVjO1JB8sIfEiZpxzcvF0O2ExEAlfHFY5NHTLi1o31weXuk/3UKuuH
         5rKN1bQPou6gZwCw38N6UnkawTfJVD2B87+knQwgIutKGDu9qdumMhwgnxgj35LBag
         Dvyx1zzs7FoyNybayYFeDhMonaZlCge1tGrSdT+Y=
Date:   Fri, 11 Nov 2022 09:57:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     stable@vger.kernel.org, jgg@nvidia.com, kevin.tian@intel.com,
        hch@lst.de, sashal@kernel.org
Subject: Re: [PATCH 6.0] drm/i915/gvt: Add missing
 vfio_unregister_group_dev() call
Message-ID: <Y24Oc6J1VGd+JsDC@kroah.com>
References: <166803668167.3399708.615075636176057580.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166803668167.3399708.615075636176057580.stgit@omen>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 04:31:45PM -0700, Alex Williamson wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> [ Upstream commit  f423fa1bc9fe1978e6b9f54927411b62cb43eb04 ]
> 
> When converting to directly create the vfio_device the mdev driver has to
> put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
> vfio_unregister_group_dev() in the remove.
> 
> This was missed for gvt, add it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com> # v6.0 backport
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com> # v6.0 backport
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c |    3 +++
>  1 file changed, 3 insertions(+)
> 

Now queued up, thanks.

greg k-h
