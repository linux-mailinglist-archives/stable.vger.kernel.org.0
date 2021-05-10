Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFBE3783A7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhEJKq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:63092 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232874AbhEJKop (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:45 -0400
IronPort-SDR: joUYuo3pLlnHOtcwwjwWdupPLKGHraOjTorHbjAkB7r4QOLXnw2td0i+P91TwIV3Z+SLjCbeUg
 nUr4EZxfz4JA==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="199212809"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="199212809"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 03:38:12 -0700
IronPort-SDR: JU9em1rwG53c9I2GxwySruTaXdECp0gSZmcOso56Md1N0uhUomogH00vC9OTP7tlBwt4Y3xl/N
 uFOmBnvwbipg==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="470754705"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136]) ([10.254.212.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 03:38:05 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     Marc Zyngier <maz@kernel.org>
Cc:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        cohuck@redhat.com, stable@vger.kernel.org
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
 <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
 <e5d63867-7a4a-963f-9fbd-741ccd3ec360@redhat.com>
 <b822cde1-7970-dac0-26cc-da1daa0b622f@intel.com>
 <feee2889-6e91-46f3-123f-826a9c4ef43c@intel.com>
 <87wns6oqn1.wl-maz@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <dc75cd9b-cbab-41f1-bf92-71047f628389@intel.com>
Date:   Mon, 10 May 2021 18:37:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <87wns6oqn1.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/2021 6:00 PM, Marc Zyngier wrote:
> On Mon, 10 May 2021 09:32:54 +0100,
> "Zhu, Lingshan" <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 5/10/2021 3:09 PM, Zhu, Lingshan wrote:
>>>
>>> On 5/10/2021 12:34 PM, Jason Wang wrote:
>>>> 在 2021/5/10 上午11:00, Zhu, Lingshan 写道:
>>>>>
>>>>> On 5/10/2021 10:43 AM, Jason Wang wrote:
>>>>>> 在 2021/5/8 下午3:11, Zhu Lingshan 写道:
>>>>>>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>>>>>>
>>>>>>> The reverted commit may cause VM freeze on arm64 platform.
>>>>>>> Because on arm64 platform, stop a consumer will suspend the VM,
>>>>>>> the VM will freeze without a start consumer
>>>>>>>
>>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>>
>>>>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>>>>>
>>>>>> Please resubmit with the formal process of stable
>>>>>> (stable-kernel-rules.rst).
>>>>> sure, I will re-submit it to stable kernel once it is merged into
>>>>> Linus tree.
>>>>>
>>>>> Thanks
>>>>
>>>> I think it's better to resubmit (option 1), see how
>>>> stable-kernel-rules.rst said:
>>>>
>>>> ""
>>>>
>>>> :ref:`option_1` is **strongly** preferred, is the easiest and most
>>>> common.
>>>> :ref:`option_2` and :ref:`option_3` are more useful if the patch
>>>> isn't deemed
>>>> worthy at the time it is applied to a public git tree (for
>>>> instance, because
>>>> it deserves more regression testing first).
>>>>
>>>> """
>>>>
>>>> Thanks
>>> OK, works for me, I will add cc stable, and resubmit it soon
>>>
>>> Thanks!
>> I just seeMarc has already added "Cc: stable@vger.kernel.org", and
>> he would take the patch in his tree, so I think no need to resend.
> That's fine, I can fix things up myself and queue the fix for -rc2.
Thanks Marc!
>
> Thanks,
>
> 	M.
>

