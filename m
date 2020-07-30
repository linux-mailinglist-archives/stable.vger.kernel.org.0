Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76A7232C88
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 09:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgG3H2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 03:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG3H2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 03:28:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CB7206E6;
        Thu, 30 Jul 2020 07:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596094128;
        bh=0vavgTMDfVfwJjBVHBedsRYmusoi+PhLN5q4bb6SHOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b7tAP4FWtQkiZLoSwjJG62hN21GEeii/kdwCI0X9X+ZE8Afmu4bmmgbRB2yHY8xX4
         x0AxjqMYqtL1LtiJBV1vstzxiSfi9U1nSknRZkrKYNVNIVAFcgXvixL77abIMuLEbz
         R4GCQERO0n7rhsXI297WaDYODKd8Ovh7tv8mg9CA=
Date:   Thu, 30 Jul 2020 09:28:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2] iommu: amd: Fix IO_PAGE_FAULT due to __unmap_single()
 size overflow
Message-ID: <20200730072837.GB4045776@kroah.com>
References: <20200624084121.6588-1-suravee.suthikulpanit@amd.com>
 <20200624090906.GC1731290@kroah.com>
 <20200624115827.GO3701@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624115827.GO3701@8bytes.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 01:58:27PM +0200, Joerg Roedel wrote:
> Hi Greg,
> 
> On Wed, Jun 24, 2020 at 11:09:06AM +0200, Greg KH wrote:
> > So what exact stable kernel version(s) do you want to see this patch
> > applied to?
> 
> It is needed in kernels <= v5.4. Linux v5.5 has replaced the code with
> the bug.

This doesn't apply to any older kernels that I can see :(
