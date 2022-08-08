Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0E358C32E
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 08:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiHHGPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 02:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiHHGPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 02:15:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B717426D2
        for <stable@vger.kernel.org>; Sun,  7 Aug 2022 23:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659939319; x=1691475319;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=myj3gVPJm7KgJFeb/MDO+zYSOE6m0is7hb9SC6rQMD8=;
  b=Vak3lS0P4MVqeKjqYKuiRWfqivmSKd/C8+y7fWdNZJExPhRkw1QFHCoA
   sa4f7/UTS91I/dMK2lGT2Me+FeJPgvrubMFeC9IHbKsE/HWYGaRjzzpUH
   11a9pjyNsWXXVGNKwaLH3fFQgxBgwIycuVw6SILHF57MwMFfo1K2H/+ce
   AXQUil/BHduvVi4IFUL93FPy9G9fMYgKeNm0+GHVq/QD//PEI1j8NAaoO
   e7/h8CboHEF+tlC18SHNjdYGIMS41c4YxQVGfi0906HaHSd5JqS2ApjUX
   dvz2LlWe49KLf0l1QX3zttQ3HeiGWLIGWjJ7jrqOff/3DdWAXUJM88cVk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270287130"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270287130"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 23:15:19 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="663794199"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.254.215.109]) ([10.254.215.109])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 23:15:17 -0700
Subject: Re: Fwd: warning: stable kernel rule is not satisfied
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        lkp <lkp@intel.com>
References: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
 <baf4e189-2302-ea9c-e905-4ebc33c1e937@intel.com> <YvCnCgvNiKVVR+ux@kroah.com>
From:   "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <f65ce603-36b4-7d89-fc4e-b62193c7c1ed@intel.com>
Date:   Mon, 8 Aug 2022 14:15:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YvCnCgvNiKVVR+ux@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/8/2022 2:02 PM, Greg KH wrote:
> On Mon, Aug 08, 2022 at 10:51:08AM +0800, kernel test robot wrote:
>> Hi Greg, Sasha,
>>
>> Sorry to bother you, this is kernel test robot, we have sent some
>> reports related to the stable kernel rule, do you want to receive such
>> report? or any suggestion for us to improve it, or disable it?
> 
> Yes, can you respond with the same subject line as the original email,
> to make it obvious what this is referring to?  Much like your other
> emails for when a submission breaks the build.
> 
> thanks,
> 
> greg k-h
> 

Hi Greg,

Thanks for your reply, we'll update the report subject to point to the
original mail.

Best Regards,
Rong Chen
