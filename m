Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABAF3ED6FF
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhHPNZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:25:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:21784 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240039AbhHPNXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:23:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="301441757"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="301441757"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 06:15:23 -0700
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="530522645"
Received: from gaoboxix-mobl1.ccr.corp.intel.com (HELO [10.254.215.86]) ([10.254.215.86])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 06:15:21 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Camille Lu <camille.lu@hpe.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210816113932.1210581-1-baolu.lu@linux.intel.com>
 <YRpQcOQzOVnGn0Lg@kroah.com>
 <76945715-9a4c-2f94-b458-b6ab53d40a1c@linux.intel.com>
 <YRpcIKvXY3LzXaqt@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix agaw for a supported 48 bit guest
 address width
Message-ID: <4f7ecd17-0b24-51b9-ea0e-5da90a5e2510@linux.intel.com>
Date:   Mon, 16 Aug 2021 21:15:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YRpcIKvXY3LzXaqt@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/8/16 20:37, Greg Kroah-Hartman wrote:
> On Mon, Aug 16, 2021 at 08:20:31PM +0800, Lu Baolu wrote:
>> Hi Greg,
>>
>> On 2021/8/16 19:48, Greg Kroah-Hartman wrote:
>>> On Mon, Aug 16, 2021 at 07:39:32PM +0800, Lu Baolu wrote:
>>>> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>>>>
>>>> [ Upstream commit 327d5b2fee91c404a3956c324193892cf2cc9528 ]
>>>
>>> Also, this really does not look like this commit at all :(
>>>
>>
>> This is not a back port. It's a fix for some stable kernels. Sorry for
>> the confusion.
>>
>> The error happens in a helper function that has been deprecated in the
>> upstream kernel by above commit. I added below explanation in the commit
>> message:
>>
>> "
>> This issue happens on the code path of getting a private domain for a
>> device. A private domain was needed when the domain of an iommu group
>> couldn't meet the requirement of a device. The IOMMU core has been
>> evolved to eliminate the need for private domain, hence this code path
>> has already been removed from the upstream since commit 327d5b2fee91c
>> ("iommu/vt-d: Allow 32bit devices to uses DMA domain"). Instead of back
>> porting all patches that are required for removing the private domain,
>> this simply fixes it in the affected stable kernel between v4.16 and v5.7.
>> "
>>
>> I'm sorry if this is not the right way to do this.
> 
> Ah, sorry, I totally missed that.  This is fine, now queued up for
> 4.19.y and 5.4.y.

Thank you! Greg.

Best regards,
baolu

> 
> thanks,
> 
> greg k-h
> 
