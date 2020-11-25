Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC32C3CD3
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 10:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgKYJuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 04:50:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:62548 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgKYJuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 04:50:19 -0500
IronPort-SDR: AtPG2yK6wBk1mYyj+hXM8JO64BgbbvnZyZWFdMayt/A/VR0ikqNc14hD5alRrqjacvI/ZuyzcX
 1L2tH0qFax/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="172200370"
X-IronPort-AV: E=Sophos;i="5.78,368,1599548400"; 
   d="scan'208";a="172200370"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 01:50:18 -0800
IronPort-SDR: NPpcqPMewZIMLnvDK7uUqQILjUinc1EZ0INqU3cxeQfmU/OZOltazDTXxtFspy7dZhg8GVzxzD
 VMC5iOjQAepw==
X-IronPort-AV: E=Sophos;i="5.78,368,1599548400"; 
   d="scan'208";a="478858066"
Received: from jclobus-mobl1.ger.corp.intel.com (HELO [10.252.55.230]) ([10.252.55.230])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 01:50:17 -0800
Subject: Re: [Intel-gfx] [PATCH] dma-buf/dma-resv: Respect num_fences when
 initializing the shared fence list.
To:     =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>, dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <20201124115707.406917-1-maarten.lankhorst@linux.intel.com>
 <a40b62d6-3285-abe6-17b7-47b89a53d89f@linux.intel.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <95ae2c09-4907-4f99-6669-1858ae5499aa@linux.intel.com>
Date:   Wed, 25 Nov 2020 10:50:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <a40b62d6-3285-abe6-17b7-47b89a53d89f@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 24-11-2020 om 14:10 schreef Thomas Hellström:
>
> On 11/24/20 12:57 PM, Maarten Lankhorst wrote:
>> We hardcode the maximum number of shared fences to 4, instead of
>> respecting num_fences. Use a minimum of 4, but more if num_fences
>> is higher.
>>
>> This seems to have been an oversight when first implementing the
>> api.
>>
>> Fixes: 04a5faa8cbe5 ("reservation: update api and add some helpers")
>> Cc: <stable@vger.kernel.org> # v3.17+
>> Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> ---
>>   drivers/dma-buf/dma-resv.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
> Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>
>
Thanks, pushed!

