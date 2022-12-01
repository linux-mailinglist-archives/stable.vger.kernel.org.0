Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C0A63EDA9
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 11:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiLAK0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 05:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiLAK0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 05:26:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15FF9B7B3
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 02:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669890369; x=1701426369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oNGPIWaFLYej+DI4gylbEes0YeP7Sm6o9NjKOHmOJto=;
  b=XXeuZOztKX2p6FBi8M59GylrnkntzVBgXFEKsUvBLfHjY3aQl8UTy4H0
   B0P7y+WPJi8QszWPyZ9g85hkBf51oAxDw++qKOGPHoPSIowdlpk/uvEu5
   giaxMUAR78IClQeymaBM4HLDNDtdmB13XbUd1TOLU273sV5HUy73oz4wH
   nGULOGku0LK7CwWFBfrKwxQb0zlXQB02K7w7GeYkcs8T8uxXhlJpgdkpk
   XXjuF+JCntdEUFhpFZXl6cKnyxJ9epCgJH2AVYLTmR9837T/lDOpBmMYr
   /1hNthnZ07IRomR11Gxmf2RETymVkc9a/wt76EojJjDRSz+WRPLx1KisG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="379931542"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="379931542"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:26:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="708017793"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708017793"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.21.183]) ([10.213.21.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:26:07 -0800
Message-ID: <958bb07e-1cc5-d97b-5480-6d8ce09c27d8@intel.com>
Date:   Thu, 1 Dec 2022 11:26:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: FAILED: patch "[PATCH] drm/i915: fix TLB invalidation for Gen12
 video and compute" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>, chris.p.wilson@intel.com,
        daniel.vetter@ffwll.ch, torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org
References: <1669831197124193@kroah.com> <Y4ebgwSCQPeCPtFY@kroah.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <Y4ebgwSCQPeCPtFY@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 30.11.2022 19:05, Greg KH wrote:
> On Wed, Nov 30, 2022 at 06:59:57PM +0100, gregkh@linuxfoundation.org wrote:
>> The patch below does not apply to the 5.15-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> Possible dependencies:
>>
>> 04aa64375f48 ("drm/i915: fix TLB invalidation for Gen12 video and compute engines")
>> 33da97894758 ("drm/i915/gt: Serialize TLB invalidates with GT resets")
>> 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
>> 1176d15f0f6e ("Merge tag 'drm-intel-gt-next-2021-10-08' of git://anongit.freedesktop.org/drm/drm-intel into drm-next")
>>
> Ah, wait, I found the tarball you sent for these, and have taken them
> for 5.4, 5.10, and 5.15 now (the original broke the build.)  We still
> need them for older kernels though, that's still an issue.

Thanks for applying patches.
Older kernels ( < 5.4) do not have the patch to fix ("drm/i915: Flush 
TLBs before releasing backing store"), and they do not support Gen12 AFAIK,
so it should be fine.

Regards
Andrzej

>
> thanks,
>
> greg k-h

