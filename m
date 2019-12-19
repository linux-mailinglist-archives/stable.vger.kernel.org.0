Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F32A125D4A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 10:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLSJIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 04:08:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:27063 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfLSJIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 04:08:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 01:08:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,331,1571727600"; 
   d="scan'208";a="298652928"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by orsmga001.jf.intel.com with ESMTP; 19 Dec 2019 01:08:47 -0800
Subject: Re: Please apply commit 057d476fff778f1 ("xhci: fix USB3 device
 initiated resume race with roothub autosuspend") to v4.4.y and v4.14.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lee, Chiasheng" <chiasheng.lee@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        "Lee, Hou-hsun" <hou-hsun.lee@intel.com>,
        "Pan, Harry" <harry.pan@intel.com>
References: <DBAD849DB12B1B48BA1A6C7335FD47B540A2A63E@PGSMSX108.gar.corp.intel.com>
 <20191219082900.GA1015381@kroah.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <2b70a289-d35f-eecb-c230-e6b85f42c990@linux.intel.com>
Date:   Thu, 19 Dec 2019 11:10:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191219082900.GA1015381@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.12.2019 10.29, Greg Kroah-Hartman wrote:
> On Thu, Dec 19, 2019 at 08:20:12AM +0000, Lee, Chiasheng wrote:
>> Hi,
>>
>> Commit 057d476fff778f1 ("xhci: fix USB3 device initiated resume race with roothub autosuspend")
>> fixes race conditions when we're dealing with a USB3 modem using v4.4 and USB3 hubs using 4.14.
>> Kindly apply the patch to v4.4.y and v4.14.y.
> 
> Why not 4.9.y and 4.19.y?  You can not just skip stable kernel trees,
> otherwise people upgrading will have a regression.
> 
> Anyway, the reason I did not backport the patch to older kernels is that
> it does not apply at all.  If you have already done the backport (and I
> am guessing you have as otherwise how would you have tested this),
> please provide it to us so that we can apply it to all trees.
> 

Let me fix up and submit the backport, give me a few minutes.
I'll check it applies to the other stable trees as well.

-Mathias
