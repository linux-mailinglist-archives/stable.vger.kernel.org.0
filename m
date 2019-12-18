Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF115124BD0
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLRPgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 10:36:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:22535 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfLRPgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 10:36:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 07:36:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="298413148"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by orsmga001.jf.intel.com with ESMTP; 18 Dec 2019 07:36:13 -0800
Subject: Re: [PATCH] usb: xhci: Fix build warning seen with CONFIG_PM=n
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henry Lin <henryl@nvidia.com>, stable@vger.kernel.org
References: <20191218011911.6907-1-linux@roeck-us.net>
 <20191218142932.GA237894@kroah.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <04cef5f6-2bc2-b056-d2c4-e79ba5498225@linux.intel.com>
Date:   Wed, 18 Dec 2019 17:38:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191218142932.GA237894@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.12.2019 16.29, Greg Kroah-Hartman wrote:
> On Tue, Dec 17, 2019 at 05:19:11PM -0800, Guenter Roeck wrote:
>> The following build warning is seen if CONFIG_PM is disabled.
>>
>> drivers/usb/host/xhci-pci.c:498:13: warning:
>> 	unused function 'xhci_pci_shutdown'
>>
>> Fixes: f2c710f7dca8 ("usb: xhci: only set D3hot for pci device")
>> Cc: Henry Lin <henryl@nvidia.com>
>> Cc: stable@vger.kernel.org	# all stable releases with 2f23dc86c3f8
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/usb/host/xhci-pci.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Nice catch.
> 
> Mathias, I can queue this up now if you give me an ack.

Yes, please

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>

