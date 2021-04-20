Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFE636560D
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 12:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhDTKWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 06:22:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:34809 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhDTKWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 06:22:36 -0400
IronPort-SDR: KzGZND0pyRSqeUuaOiFQ5W5SSJlo9Cueve3IvLAd6AxoEYJEBYMwh6O91MczocXPm/HYkxD2bN
 0F4P0smBo4zA==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="195508885"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="195508885"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:22:04 -0700
IronPort-SDR: yirMUWERDYce0xR6aBQqunuWlhSFnIXRlQU5SjyFCuQxBxKWw0hY0vuU+H7C/KWlycCWW6xAKN
 GJqlhKnS51Ow==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="463066320"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:22:01 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lYnW2-005iGd-0V; Tue, 20 Apr 2021 13:21:58 +0300
Date:   Tue, 20 Apr 2021 13:21:57 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bingbu Cao <bingbu.cao@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
        will@kernel.org, bhelgaas@google.com, rajatja@google.com,
        grundler@chromium.org, tfiga@chromium.org,
        senozhatsky@chromium.org, sakari.ailus@linux.intel.com,
        bingbu.cao@linux.intel.com
Subject: Re: [RESEND v2] iommu/vt-d: Use passthrough mode for the Intel IPUs
Message-ID: <YH6rRUXyNdC6DDzQ@smile.fi.intel.com>
References: <1618886913-6594-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618886913-6594-1-git-send-email-bingbu.cao@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 10:48:33AM +0800, Bingbu Cao wrote:
> Intel IPU(Image Processing Unit) has its own (IO)MMU hardware,
> The IPU driver allocates its own page table that is not mapped
> via the DMA, and thus the Intel IOMMU driver blocks access giving
> this error:
> 
> DMAR: DRHD: handling fault status reg 3
> DMAR: [DMA Read] Request device [00:05.0] PASID ffffffff
>       fault addr 76406000 [fault reason 06] PTE Read access is not set
> 
> As IPU is not an external facing device which is not risky, so use
> IOMMU passthrough mode for Intel IPUs.

I'm wondering if IPU MMU should be described properly in the DMAR table.

-- 
With Best Regards,
Andy Shevchenko


