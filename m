Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5893E382531
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 09:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhEQHUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 03:20:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:50831 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235178AbhEQHUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 03:20:02 -0400
IronPort-SDR: TfrCAxax4OuHRuI74clguvAmeLD3/tGpmptBxGicFJy9M16YW89Zf9ANnLhIRIGd665mKgKMGv
 97YuAa0QZAEg==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="180678240"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="180678240"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 00:18:46 -0700
IronPort-SDR: P1IaDKMnrkElhmaGC1lfnf7Wbk3itKu8xis06TaibqfCjXT97sqC0X8dIpgxADWhqTP2Np6b2t
 brufPlRp5H/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="460205322"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 17 May 2021 00:18:44 -0700
Cc:     baolu.lu@linux.intel.com, sashal@kernel.org, ashok.raj@intel.com,
        jroedel@suse.de, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [REWORKED PATCH 1/1] iommu/vt-d: Preset Access/Dirty bits for
 IOVA over FL
To:     Greg KH <gregkh@linuxfoundation.org>
References: <20210517034913.3432-1-baolu.lu@linux.intel.com>
 <YKIWS0lFKTcZ9094@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <726aede1-3d9f-6666-b31d-9db8e4301a0c@linux.intel.com>
Date:   Mon, 17 May 2021 15:17:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKIWS0lFKTcZ9094@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 5/17/21 3:07 PM, Greg KH wrote:
> On Mon, May 17, 2021 at 11:49:13AM +0800, Lu Baolu wrote:
>> [ Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 ]
>>
>> The Access/Dirty bits in the first level page table entry will be set
>> whenever a page table entry was used for address translation or write
>> permission was successfully translated. This is always true when using
>> the first-level page table for kernel IOVA. Instead of wasting hardware
>> cycles to update the certain bits, it's better to set them up at the
>> beginning.
>>
>> Suggested-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Link: https://lore.kernel.org/r/20210115004202.953965-1-baolu.lu@linux.intel.com
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/iommu/intel/iommu.c | 14 ++++++++++++--
>>   include/linux/intel-iommu.h |  2 ++
>>   2 files changed, 14 insertions(+), 2 deletions(-)
>>
>> [Note:
>> - This is a reworked patch of
>>    https://lore.kernel.org/stable/20210512144819.664462530@linuxfoundation.org/T/#m65267f0a0091c2fcbde097cea91089775908faad.
>> - It aims to fix a reported issue of
>>    https://bugzilla.kernel.org/show_bug.cgi?id=213077.
>> - Please help to review and test.]
> 
> What stable tree(s) is this supposed to be for?

It's for 5.10.37.

> 
> thanks,
> 
> greg k-h
> 

Best regards,
baolu
