Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCAB1CECA0
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 07:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgELF5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 01:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgELF5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 01:57:02 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 027E620733;
        Tue, 12 May 2020 05:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589263021;
        bh=OlLN7L6aFdchYQt9EQtvpEZTj2xnd4xu4wLKyEKCqEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BhgrCuDKcllH3uuYxNLm5B7Tx9zHjBrZkSDP8CasEe2ozvXofmDiPnmTiUvMg+EvN
         SwW4CXZ4ndBnEF4JiKTPzfcUu65+cBJJ5iqJJLVkpcllze/+OcQbAWKshSlFBo9Uxu
         NDXQh7XVgCnN0cRPn5EAm/ONCk8lr8MTplYj1P60=
Date:   Tue, 12 May 2020 08:56:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc or next 2/3] IB/hfi1: Do not destroy link_wq when
 the device is shut down
Message-ID: <20200512055657.GB4814@unreal>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031322.189865.4129.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512031322.189865.4129.stgit@awfm-01.aw.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 11:13:22PM -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
>
> The workqueue link_wq should only be destroyed when the hfi1 driver
> is unloaded, not when the device is shut down.

It really doesn't make sense to keep workqueue if no devices exist.

Thanks
