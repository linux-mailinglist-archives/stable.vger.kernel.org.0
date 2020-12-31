Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6763B2E7FA6
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 12:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgLaLWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 06:22:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:40598 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLaLWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 06:22:46 -0500
IronPort-SDR: 76/JmFrba5xU76InK8l36sulX9HHZYbNLJxRp3FgRSBZzhE+lMGSjJEvHffXM9n+WTSmjVpPvA
 aSSwq/rCvNUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9850"; a="164409035"
X-IronPort-AV: E=Sophos;i="5.78,464,1599548400"; 
   d="scan'208";a="164409035"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2020 03:21:00 -0800
IronPort-SDR: MCSb26NCT3haZgnwKx3W+3G0gg8BUw5jh/DgXusdplSmczPYUHtfkrsPhvTyOIycslnx9xZ4Jx
 d7oZ0tZpkm9g==
X-IronPort-AV: E=Sophos;i="5.78,464,1599548400"; 
   d="scan'208";a="419856018"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.249.135.34]) ([10.249.135.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2020 03:20:57 -0800
Subject: Re: Haswell audio no longer working with new Catpt driver
To:     Christian Labisch <clnetbox@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Akemi Yagi <toracat@elrepo.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Greg Kroah-Hartman <stable@vger.kernel.org>,
        Greg Kroah-Hartman <linux-kernel@vger.kernel.org>,
        Justin Forbes <jforbes@redhat.com>
References: <2f0acfa1330ca6b40bff564fd317c8029eb23453.camel@gmail.com>
 <efc6d5e8abc1da3cac754cb760fff08a1887013b.camel@gmail.com>
 <X+2MzJ7bKCQTRCd/@kroah.com>
 <a194639e-f444-da95-095d-38e07e34f72f@metafoo.de>
 <267863e8ca1464e4e433d83c5506ed871e3899b2.camel@gmail.com>
From:   =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
Message-ID: <4c5b8a03-6508-541f-2a72-39cb3052b4f1@linux.intel.com>
Date:   Thu, 31 Dec 2020 12:20:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <267863e8ca1464e4e433d83c5506ed871e3899b2.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/31/2020 11:50 AM, Christian Labisch wrote:
> Hi Lars-Peter,
> 
> Thank you, please find attached the requested information from both kernels.
> I freshly installed the fedora kernel 5.10.4 to give you the latest results.
> 
> Regards,
> Christian
> 
> Christian Labisch
> Red Hat Accelerator
> clnetbox.blogspot.com
> access.redhat.com/community
> access.redhat.com/accelerators
> 
> 
> On Thu, 2020-12-31 at 11:04 +0100, Lars-Peter Clausen wrote:
>> On 12/31/20 9:33 AM, Greg Kroah-Hartman wrote:
>>> On Wed, Dec 30, 2020 at 07:10:16PM +0100, Christian Labisch wrote:
>>>> Update :
>>>>
>>>> I've just tested the kernel 5.10.4 from ELRepo.
>>>> Unfortunately nothing changed - still no sound.
>>> Ah, sad.  Can you run 'git bisect' between 5.9 and 5.10 to determine the
>>> commit that caused the problem?
>>
>> The problem is that one driver was replaced with another driver. git
>> bisect wont really help to narrow down why the new driver does not work.
>>
>> Christian can you run the alsa-info.sh[1] script on your system and send
>> back the result?
>>
>> You say sound is not working, can you clarify that a bit? Is no sound
>> card registered? Is it registered but output stays silent?
>>
>> - Lars
>>
>> [1] https://www.alsa-project.org/wiki/AlsaInfo
>> <https://www.alsa-project.org/wiki/AlsaInfo>
>>
>>

Hi,

from reading provided files it seems that you use snd_intel_hda driver, 
it should be possible to git bisect it between 5.9 and 5.10 as it wasn't 
replaced.

Catpt driver is used on machines using DSP.

Amadeusz
