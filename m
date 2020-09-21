Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8AD273090
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgIURFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:05:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:26655 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbgIUQdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:33:22 -0400
IronPort-SDR: +cx7KqMnipMgsruBr3NS7gLVuECKsOJGEgnAtxpeUUxAwv0eqNUd6lloBVvPIoJ8GAwaziVTmE
 ehr96rb49ngQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="222022681"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="222022681"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:33:20 -0700
IronPort-SDR: nbNAJM23sFv3u5RRBh7OR9/yfHg0OwKMw1asdddER3mGszAmnOVtUw+BUO1zLuE50gSg5J9FGL
 shY8XjQH1wvg==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="321826103"
Received: from apatwary-mobl.amr.corp.intel.com (HELO [10.212.120.65]) ([10.212.120.65])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:33:19 -0700
Subject: Re: [PATCH] ASoC: SOF: intel: hda: support also devices with 1 and 3
 dmics
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
References: <20200918161533.166533-1-pierre-louis.bossart@linux.intel.com>
 <20200921161024.GB1096614@kroah.com>
 <399fe98f-5577-6616-8539-885cbc89be1b@linux.intel.com>
 <20200921162159.GA1260133@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <b4b7a9dc-42d3-1663-0501-89ed64085129@linux.intel.com>
Date:   Mon, 21 Sep 2020 11:33:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200921162159.GA1260133@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/21/20 11:21 AM, Greg KH wrote:
> On Mon, Sep 21, 2020 at 11:18:47AM -0500, Pierre-Louis Bossart wrote:
>>
>>
>> On 9/21/20 11:10 AM, Greg KH wrote:
>>> On Fri, Sep 18, 2020 at 11:15:33AM -0500, Pierre-Louis Bossart wrote:
>>>> From: Jaska Uimonen <jaska.uimonen@linux.intel.com>
>>>>
>>>> [ Backported from Upstream commit 3dca35e35b42b3405ddad7ee95c02a2d8cf28592]
>>>
>>> There is no such commit in Linus's tree :(
>>
>> no such commit yet, it's in Mark Brown's tree and should be in 5.10
>>
>> https://lore.kernel.org/alsa-devel/20200825235040.1586478-4-ranjani.sridharan@linux.intel.com/
>>
>> I must admit I didn't know how to tweak the information between brackets.
>>
>> do you want me to remove the 'Upstream' comment and resend?
> 
> I can't take anything that is not already in Linus's tree, so we need to
> wait until it hits there, right?

no worries. Will resend this after 5.10-rc1, thanks!
