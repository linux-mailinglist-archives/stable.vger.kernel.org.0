Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D656B7DD
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 10:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfGQIIf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 17 Jul 2019 04:08:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:47808 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfGQIIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 04:08:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 01:08:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,273,1559545200"; 
   d="scan'208";a="167894267"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jul 2019 01:08:33 -0700
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 17 Jul 2019 01:08:33 -0700
Received: from shsmsx104.ccr.corp.intel.com (10.239.4.70) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 17 Jul 2019 01:08:33 -0700
Received: from shsmsx107.ccr.corp.intel.com ([169.254.9.162]) by
 SHSMSX104.ccr.corp.intel.com ([169.254.5.110]) with mapi id 14.03.0439.000;
 Wed, 17 Jul 2019 16:08:31 +0800
From:   "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/gvt: fix incorrect cache entry for guest page
 mapping
Thread-Topic: [PATCH] drm/i915/gvt: fix incorrect cache entry for guest page
 mapping
Thread-Index: AQHVPHA72TBsFrNvyUOTc0TP27TZJQ==
Date:   Wed, 17 Jul 2019 08:08:31 +0000
Message-ID: <073732E20AE4C540AE91DBC3F07D4460876B39CE@SHSMSX107.ccr.corp.intel.com>
References: <1563378987-21880-1-git-send-email-xiaolin.zhang@intel.com>
 <20190717075507.GA14238@kroah.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.4.160]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/17/2019 03:55 PM, Greg KH wrote:
> On Wed, Jul 17, 2019 at 11:56:27PM +0800, Xiaolin Zhang wrote:
>> GPU hang observed during the guest OCL conformance test which is caused
>> by THP GTT feature used durning the test.
>>
>> It was observed the same GFN with different size (4K and 2M) requested
>> from the guest in GVT. So during the guest page dma map stage, it is
>> required to unmap first with orginal size and then remap again with
>> requested size.
>>
>> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
>> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
>> ---
>>  drivers/gpu/drm/i915/gvt/kvmgt.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>
>
Greg, Thanks great information to point out this I am not fully aware.
will resend to correct this.

-Xiaolin

