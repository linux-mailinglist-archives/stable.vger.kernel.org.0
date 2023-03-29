Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833996CF6FF
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 01:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjC2XYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 19:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjC2XYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 19:24:44 -0400
X-Greylist: delayed 424 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Mar 2023 16:24:39 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8B6468F
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 16:24:39 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4FB542CB312
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 23:17:45 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C42A1C40067;
        Wed, 29 Mar 2023 23:17:31 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.35.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id E7D5C13C2B0;
        Wed, 29 Mar 2023 16:17:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com E7D5C13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1680131851;
        bh=LS3MKLWJd4mb/vj5so6zIWCqxhs9UCjfJNfmEm+z63A=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=gmoVy/lqIaVvnAC+w93vZ19p89ZJosatdIFXRYbvPBJf/sHEZsbTOQLWkuR3NdSTZ
         25ajfHOwtFpV1RM+8thfcST1Zz5vxX97iUCIKvDhSaL2PVAV0lT3zOJvY1VP4OX65x
         3SX+lnB3H8ZM2x9EwW35bqrzPT6sDInk0HOfxpr8=
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
From:   Ben Greear <greearb@candelatech.com>
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bjorn@helgaas.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220823080115.331990024@linuxfoundation.org>
 <20220823080123.228828362@linuxfoundation.org>
 <CABhMZUVycsyy76j2Z=K+C6S1fwtzKE1Lx2povXKfB80o9g0MtQ@mail.gmail.com>
 <YwXH/l37HaYQD66B@kroah.com>
 <47b775c5-57fa-5edf-b59e-8a9041ffbee7@candelatech.com>
 <20220830205832.g3lyysmgkarijkvj@pali>
 <00735f18-11f9-c6c6-4abf-002d378957df@candelatech.com>
 <20220830215532.6nnl6d4cfg55dmcl@pali>
 <370dee6c-919a-2f98-1404-a3feda14d1ba@candelatech.com>
Organization: Candela Technologies
Message-ID: <9dfa04c4-e0cc-f265-5935-254f43db931b@candelatech.com>
Date:   Wed, 29 Mar 2023 16:17:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <370dee6c-919a-2f98-1404-a3feda14d1ba@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
X-MDID: 1680131853-JyskUiQsUrIm
X-MDID-O: us5;ut7;1680131853;JyskUiQsUrIm;<greearb@candelatech.com>;66c7af989e59a0657cb045da8e674f5e
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/30/22 3:16 PM, Ben Greear wrote:
> On 8/30/22 2:55 PM, Pali Rohár wrote:
>> On Tuesday 30 August 2022 14:28:14 Ben Greear wrote:
>>> On 8/30/22 1:58 PM, Pali Rohár wrote:
>>>> On Tuesday 30 August 2022 13:47:48 Ben Greear wrote:
>>>>> On 8/23/22 11:41 PM, Greg Kroah-Hartman wrote:
>>>>>> On Tue, Aug 23, 2022 at 07:20:14AM -0500, Bjorn Helgaas wrote:
>>>>>>> On Tue, Aug 23, 2022, 6:35 AM Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>>> wrote:
>>>>>>>
>>>>>>>> From: Stefan Roese <sr@denx.de>
>>>>>>>>
>>>>>>>> [ Upstream commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 ]
>>>>>>>>
>>>>>>>
>>>>>>> There's an open regression related to this commit:
>>>>>>>
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=216373
>>>>>>
>>>>>> This is already in the following released stable kernels:
>>>>>>     5.10.137 5.15.61 5.18.18 5.19.2
>>>>>>
>>>>>> I'll go drop it from the 4.19 and 5.4 queues, but when this gets
>>>>>> resolved in Linus's tree, make sure there's a cc: stable on the fix so
>>>>>> that we know to backport it to the above branches as well.  Or at the
>>>>>> least, a "Fixes:" tag.
>>>>>
>>>>> This is still in 5.19.5.  We saw some funny iwlwifi crashes in 5.19.3+
>>>>> that we did not see in 5.19.0+.  I just bisected the scary looking AER errors to this
>>>>> patch, though I do not know for certain if it causes the iwlwifi related crashes yet.
>>>>>
>>>>> In general, from reading the commit msg, this patch doesn't seem to be a great candidate
>>>>> for stable in general.  Does it fix some important problem?
>>>>>
>>>>> In case it helps, here is example of what I see in dmesg.  The kernel crashes in iwlwifi
>>>>> had to do with rx messages from the firmware, and some warnings lead me to believe that
>>>>> pci messages were slow coming back and/or maybe duplicated.  So maybe this AER patch changes
>>>>> timing or otherwise screws up the PCI adapter boards we use...
>>>>
>>>>   From that log I have feeling that issue is in that intel wifi card and
>>>> it was there also before that commit. Card is crashing (or something
>>>> other happens on PCIe bus) and because kernel had disabled Error
>>>> Reporting for this card, nobody spotted any issue. And that commit just
>>>> opened eye to kernel to see those errors.
>>>>
>>>> I think this issue should be reported to intel wifi card developers,
>>>> maybe they comment it, why card is reporting errors.
>>>
>>> My main concern is not that AER messages started showing up, but that there
>>> started being kernel NPE and WARNINGS showing up sometime after 5.19.0.
>>>
>>> Possibly this AER thing is mis-direction and the real bug is elsewhere,
>>> but since the bugzilla also indicated (different) driver crashes, then
>>> I am suspicious this changes things more significantly, at least in a subset
>>> of hardware out there.
>>
>> Yea, of course, this is something needed to investigate.
>>
>> Anyway, do you see driver crashes? Or just these AER errors? And are
>> your PCIe cards working, or after seeing these messages in dmesg they
>> stopped working? It is needed to know if you are just spammed by tons of
>> lines in dmesg and otherwise everything works. Or if after AER errors
>> your PCIe devices stop working and rebooting system is required.
> 
> We did see higher frequency of weird crashes (accessing null-ish pointer) after upgrading to 5.19.3,
> I am building kernel now with 5.19.5 and that AER patch reverted.  We will
> test to see if that solves the crashes.
> 
>>> Also, any idea what this error in my logs is actually indicating?
>>
>> Your PCIe controller received non-fatal, but uncorrected error. There is
>> also indication of Unsupported Request Completion Status. Unsupported
>> Request is generated by PCIe device when controller / host / kernel try
>> to do something which is not supported by device; pretty generic error.
>> PCIe base spec describe lot of scenarios when card should return this
>> error. Maybe some more detailed information are in TLP Header hexdump,
>> but I cannot decode it now.
>>
>> Basically it is PCIe card driver who could know how fatal it is that
>> issue and how to recover from it. But as you can see intel wifi driver
>> does not implement that callback.

Hello,

I notice this patch appears to be in 6.2.6 kernel, and my kernel logs are
full of spam and system is unstable.  Possibly the unstable part is related
to something else, but the log spam is definitely extreme.

These systems are fairly stable on 5.19-ish kernels without the patch in
question.

Any suggested cures for this other than reverting the patch?

Here is sample of the spam:

[ 1675.547023] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1675.556851] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1675.563904] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1675.569398] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1675.576296] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1675.576302] pcieport 0000:03:02.0: AER: device recovery failed
[ 1675.576303] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:02.0
[ 1675.576317] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1675.586144] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1675.593196] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1675.598691] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1675.605584] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1675.605588] pcieport 0000:03:02.0: AER: device recovery failed
[ 1676.497155] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:02.0
[ 1676.497174] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.507015] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.514091] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1676.519599] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1676.526491] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1676.526516] pcieport 0000:03:02.0: AER: device recovery failed
[ 1676.526517] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:02.0
[ 1676.526531] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.536367] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.543440] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1676.548936] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1676.555830] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1676.555850] pcieport 0000:03:02.0: AER: device recovery failed
[ 1676.555851] pcieport 0000:00:1c.0: AER: Multiple Uncorrected (Non-Fatal) error received: 0000:03:02.0
[ 1676.555955] pcieport 0000:03:01.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.565792] pcieport 0000:03:01.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.572846] pcieport 0000:03:01.0:    [20] UnsupReq               (First)
[ 1676.578344] pcieport 0000:03:01.0: AER:   TLP Header: 34000000 04001f10 00000000 88c888c8
[ 1676.585268] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.595105] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.602162] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1676.607655] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1676.614538] pcieport 0000:03:02.0: AER:   Error of this Agent is reported first
[ 1676.620566] pcieport 0000:03:03.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.630398] pcieport 0000:03:03.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.637454] pcieport 0000:03:03.0:    [20] UnsupReq               (First)
[ 1676.642945] pcieport 0000:03:03.0: AER:   TLP Header: 34000000 06001f10 00000000 88c888c8
[ 1676.649840] pcieport 0000:03:05.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.659681] pcieport 0000:03:05.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.666738] pcieport 0000:03:05.0:    [20] UnsupReq               (First)
[ 1676.672253] pcieport 0000:03:05.0: AER:   TLP Header: 34000000 07001f10 00000000 88c888c8
[ 1676.679172] pcieport 0000:03:07.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.689002] pcieport 0000:03:07.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.696055] pcieport 0000:03:07.0:    [20] UnsupReq               (First)
[ 1676.701550] pcieport 0000:03:07.0: AER:   TLP Header: 34000000 08001f10 00000000 88c888c8
[ 1676.708461] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
[ 1676.708467] pcieport 0000:03:01.0: AER: device recovery failed
[ 1676.708480] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1676.708483] pcieport 0000:03:02.0: AER: device recovery failed
[ 1676.708496] iwlwifi 0000:06:00.0: AER: can't recover (no error_detected callback)
[ 1676.708499] pcieport 0000:03:03.0: AER: device recovery failed
[ 1676.708511] iwlwifi 0000:07:00.0: AER: can't recover (no error_detected callback)
[ 1676.708515] pcieport 0000:03:05.0: AER: device recovery failed
[ 1676.708541] iwlwifi 0000:08:00.0: AER: can't recover (no error_detected callback)
[ 1676.708544] pcieport 0000:03:07.0: AER: device recovery failed
[ 1676.893674] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:02.0
[ 1676.893692] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.903527] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.910584] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1676.916098] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1676.923010] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1676.923018] pcieport 0000:03:02.0: AER: device recovery failed
[ 1676.923018] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:02.0
[ 1676.923046] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.932876] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.939929] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1676.945425] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1676.952319] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1676.952325] pcieport 0000:03:02.0: AER: device recovery failed
[ 1676.952325] pcieport 0000:00:1c.0: AER: Multiple Uncorrected (Non-Fatal) error received: 0000:03:02.0
[ 1676.952462] pcieport 0000:03:01.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.962292] pcieport 0000:03:01.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.969347] pcieport 0000:03:01.0:    [20] UnsupReq               (First)
[ 1676.974839] pcieport 0000:03:01.0: AER:   TLP Header: 34000000 04001f10 00000000 88c888c8
[ 1676.981734] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1676.991560] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1676.998614] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[ 1677.004107] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[ 1677.010991] pcieport 0000:03:02.0: AER:   Error of this Agent is reported first
[ 1677.017014] pcieport 0000:03:03.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1677.026841] pcieport 0000:03:03.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1677.033894] pcieport 0000:03:03.0:    [20] UnsupReq               (First)
[ 1677.039390] pcieport 0000:03:03.0: AER:   TLP Header: 34000000 06001f10 00000000 88c888c8
[ 1677.046292] pcieport 0000:03:05.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1677.056118] pcieport 0000:03:05.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1677.063174] pcieport 0000:03:05.0:    [20] UnsupReq               (First)
[ 1677.068667] pcieport 0000:03:05.0: AER:   TLP Header: 34000000 07001f10 00000000 88c888c8
[ 1677.075575] pcieport 0000:03:07.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[ 1677.085402] pcieport 0000:03:07.0:   device [10b5:8619] error status/mask=00100000/00000000
[ 1677.092457] pcieport 0000:03:07.0:    [20] UnsupReq               (First)
[ 1677.097951] pcieport 0000:03:07.0: AER:   TLP Header: 34000000 08001f10 00000000 88c888c8
[ 1677.104844] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
[ 1677.104849] pcieport 0000:03:01.0: AER: device recovery failed
[ 1677.104881] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[ 1677.104884] pcieport 0000:03:02.0: AER: device recovery failed
[ 1677.104908] iwlwifi 0000:06:00.0: AER: can't recover (no error_detected callback)
[ 1677.104911] pcieport 0000:03:03.0: AER: device recovery failed
[ 1677.104938] iwlwifi 0000:07:00.0: AER: can't recover (no error_detected callback)
[ 1677.104943] pcieport 0000:03:05.0: AER: device recovery failed
[ 1677.104968] iwlwifi 0000:08:00.0: AER: can't recover (no error_detected callback)
[ 1677.104971] pcieport 0000:03:07.0: AER: device recovery failed


Thanks,
Ben


