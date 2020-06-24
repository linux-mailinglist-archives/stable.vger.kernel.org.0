Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16E2072AE
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 13:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388522AbgFXL6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 07:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388491AbgFXL6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 07:58:32 -0400
X-Greylist: delayed 196 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 24 Jun 2020 04:58:31 PDT
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546E2C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 04:58:30 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 3B6802AF; Wed, 24 Jun 2020 13:58:29 +0200 (CEST)
Date:   Wed, 24 Jun 2020 13:58:27 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2] iommu: amd: Fix IO_PAGE_FAULT due to __unmap_single()
 size overflow
Message-ID: <20200624115827.GO3701@8bytes.org>
References: <20200624084121.6588-1-suravee.suthikulpanit@amd.com>
 <20200624090906.GC1731290@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624090906.GC1731290@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Jun 24, 2020 at 11:09:06AM +0200, Greg KH wrote:
> So what exact stable kernel version(s) do you want to see this patch
> applied to?

It is needed in kernels <= v5.4. Linux v5.5 has replaced the code with
the bug.


	Joerg
