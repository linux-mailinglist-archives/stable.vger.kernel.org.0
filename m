Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C92197D44
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgC3NqN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Mar 2020 09:46:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:43753 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgC3NqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:46:13 -0400
IronPort-SDR: NSlZJLyDft1JvgpDj5EfvA4sTcRyFL7dUMjd00CgTPNrKxIJB7QW4bHAJX+pwME93GyNiLPKli
 tAVV/EKY43eQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 06:46:11 -0700
IronPort-SDR: c1V9JLhuvFlsnYYTIOb0W1i6yN2yoUTXzsVk+OcUNlMJBYhWG4stV7fnTWJ3U4CvNyCLXacXW7
 a/E6qORb0d6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,324,1580803200"; 
   d="scan'208";a="241619267"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga008.fm.intel.com with ESMTP; 30 Mar 2020 06:46:11 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 06:46:11 -0700
Received: from fmsmsx107.amr.corp.intel.com ([169.254.6.38]) by
 fmsmsx115.amr.corp.intel.com ([169.254.4.81]) with mapi id 14.03.0439.000;
 Mon, 30 Mar 2020 06:46:11 -0700
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        David Airlie <airlied@linux.ie>,
        Shane Francis <bigbeeshane@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: RE: [PATCH v2] drm/prime: fix extracting of the DMA addresses from
 a scatterlist
Thread-Topic: [PATCH v2] drm/prime: fix extracting of the DMA addresses from
 a scatterlist
Thread-Index: AQHWBFQRvRx+hOOiski5ycfWmHv7TahcuvpggAMSJICAAVxq4A==
Date:   Mon, 30 Mar 2020 13:46:10 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663FFFC0C0E@fmsmsx107.amr.corp.intel.com>
References: <CGME20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd@eucas1p1.samsung.com>
 <20200327162126.29705-1-m.szyprowski@samsung.com>
 <14063C7AD467DE4B82DEDB5C278E8663FFFBFCE1@fmsmsx107.amr.corp.intel.com>
 <8a09916d-5413-f9a8-bafa-2d8f0b8f892f@samsung.com>
In-Reply-To: <8a09916d-5413-f9a8-bafa-2d8f0b8f892f@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>-----Original Message-----
>From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of
>Marek Szyprowski
>Sent: Sunday, March 29, 2020 5:56 AM
>To: Ruhl, Michael J <michael.j.ruhl@intel.com>; dri-
>devel@lists.freedesktop.org; linux-samsung-soc@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>; David Airlie
><airlied@linux.ie>; Shane Francis <bigbeeshane@gmail.com>;
>stable@vger.kernel.org; Thomas Zimmermann <tzimmermann@suse.de>;
>Alex Deucher <alexander.deucher@amd.com>
>Subject: Re: [PATCH v2] drm/prime: fix extracting of the DMA addresses from
>a scatterlist
>
>Hi Michael,
>

<snip>

>> Is there an example of what the scatterlist would look like in this case?
>
>DMA framework or IOMMU is allowed to join consecutive chunks while
>mapping if such operation is supported by the hw. Here is the example:
>
>Lets assume that we have a scatterlist with 4 4KiB pages of the physical
>addresses: 0x12000000, 0x13011000, 0x13012000, 0x11011000. The total
>size of the buffer is 16KiB. After mapping this scatterlist to a device
>behind an IOMMU it may end up as a contiguous buffer in the DMA (IOVA)
>address space. at 0xf0010000. The scatterlist will look like this:
>
>sg[0].page = 0x12000000
>sg[0].len = 4096
>sg[0].dma_addr = 0xf0010000
>sg[0].dma_len = 16384
>sg[1].page = 0x13011000
>sg[1].len = 4096
>sg[1].dma_addr = 0
>sg[1].dma_len = 0
>sg[2].page = 0x13012000
>sg[2].len = 4096
>sg[2].dma_addr = 0
>sg[2].dma_len = 0
>sg[3].page = 0x11011000
>sg[3].len = 4096
>sg[3].dma_addr = 0
>sg[3].dma_len = 0
>
>(I've intentionally wrote page as physical address to make it easier to
>understand, in real SGs it is stored a struct page pointer).
>
>> Does each SG entry always have the page and dma info? or could you have
>> entries that have page information only, and entries that have dma info
>only?
>When SG is not mapped yet it contains only the ->pages and ->len
>entries. I'm not aware of the SGs with the DMA information only, but in
>theory it might be possible to have such.
>> If the same entry has different size info (page_len = PAGE_SIZE,
>> dma_len = 4 * PAGE_SIZE?), are we guaranteed that the arrays (page and
>addrs) have
>> been sized correctly?
>
>There are always no more DMA related entries than the phys pages. If
>there is 1:1 mapping between physical memory and DMA (IOVA) space, then
>each SG entry will have len == dma_len, and dma_addr will be describing
>the same as page entry. DMA mapping framework is allowed only to join
>entries while mapping to DMA (IOVA).
>
>> Just trying to get my head wrapped around this.
>
>Sure, I hope my explanation helps a bit.

That is a great example!  Thank you very much for the explanation.

I was somehow seeing it as the dma side getting split and extended (rather
than consolidated) into more possible entries.  This clarifies the issue for me.

Thanks!

Mike

>Best regards
>--
>Marek Szyprowski, PhD
>Samsung R&D Institute Poland
>
>_______________________________________________
>dri-devel mailing list
>dri-devel@lists.freedesktop.org
>https://lists.freedesktop.org/mailman/listinfo/dri-devel
