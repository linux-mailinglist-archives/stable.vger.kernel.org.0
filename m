Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEC0365658
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 12:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhDTKmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 06:42:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:37280 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhDTKmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:00 -0400
IronPort-SDR: 6kAnX2Oqq601rIVnshvdyJGrPfbF+Tx9vQTQ+WkiwYTcfppmjRiKbLMjch4aKx2v5kMCCTGrXL
 ae6BaBxz1thw==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="259439880"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="259439880"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:28 -0700
IronPort-SDR: zBEE34l19qdqr83AHGBhxQffq+4JvC3ZbYqCOiE4ip4c669xO6weWyCL0VUIfhoj5vmAZi7aFB
 akOfFPKkyhLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="523757927"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.202]) ([10.238.232.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Apr 2021 03:41:24 -0700
Subject: Re: [RESEND v2] iommu/vt-d: Use passthrough mode for the Intel IPUs
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
        will@kernel.org, bhelgaas@google.com, rajatja@google.com,
        grundler@chromium.org, tfiga@chromium.org,
        senozhatsky@chromium.org, sakari.ailus@linux.intel.com
References: <1618886913-6594-1-git-send-email-bingbu.cao@intel.com>
 <YH6q+FCTQheO6FHi@smile.fi.intel.com>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <c9a0fc75-8b7b-e0ae-572e-8ca030a04537@linux.intel.com>
Date:   Tue, 20 Apr 2021 18:34:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YH6q+FCTQheO6FHi@smile.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andy,

On 4/20/21 6:20 PM, Andy Shevchenko wrote:
> On Tue, Apr 20, 2021 at 10:48:33AM +0800, Bingbu Cao wrote:
>> Intel IPU(Image Processing Unit) has its own (IO)MMU hardware,
>> The IPU driver allocates its own page table that is not mapped
>> via the DMA, and thus the Intel IOMMU driver blocks access giving
>> this error:
>>
>> DMAR: DRHD: handling fault status reg 3
>> DMAR: [DMA Read] Request device [00:05.0] PASID ffffffff
>>       fault addr 76406000 [fault reason 06] PTE Read access is not set
>>
>> As IPU is not an external facing device which is not risky, so use
>> IOMMU passthrough mode for Intel IPUs.
>>
>> Fixes: 26f5689592e2 ("media: staging/intel-ipu3: mmu: Implement driver")
>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
>> ---
>>  drivers/iommu/intel/iommu.c | 29 +++++++++++++++++++++++++++++
> 
> This misses the changelog from v1 followed by the explanation why resent.
> 
I noticed there was a typo in the recipient list:
stable.vger.kernel.org -> stable@vger.kernel.org

no code change for resent.

-- 
Best regards,
Bingbu Cao
