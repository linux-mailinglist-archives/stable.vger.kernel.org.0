Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1262A2F5D
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgKBQJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:09:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:50576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbgKBQJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 11:09:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604333373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYGERTIizeDbHwknUlguoKRRE0qjz7GEkpuaQze0zWg=;
        b=ex0U//acz80ozqclDNVaYT4vrW0RIW4bBeKwcVy4uD1hvyuNP9c1OL0xq8UlvO/ikxC4Vg
        7XVLrCZggWHMrji25s7vUpNsEpnunwfZFu8mPC6PXKxVrVv01CCZJ2ZS2Xegvofbn3Ivig
        N4RuwnMmnm0G4X6ZCxzFvK4PX2YWc0A=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 299E3B1BA;
        Mon,  2 Nov 2020 16:09:33 +0000 (UTC)
Subject: Re: Stable backport request for "xen/events: don't use chip_data for
 legacy IRQs"
To:     Greg KH <gregkh@linuxfoundation.org>,
        Ross Lagerwall <ross.lagerwall@citrix.com>
Cc:     stable@vger.kernel.org
References: <0e4837c4-b750-4889-bb8c-8a36c73c7110@citrix.com>
 <1a63ad59-c0d3-893b-8098-97146920214b@suse.com>
 <20201031100314.GA3847955@kroah.com>
 <fd6482d4-d28e-d1bd-9e08-daf7a36f9b79@citrix.com>
 <20201102160747.GA1845823@kroah.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <683a8376-8154-006d-f6e3-8eaa8fad0034@suse.com>
Date:   Mon, 2 Nov 2020 17:09:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102160747.GA1845823@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.11.20 17:07, Greg KH wrote:
> On Mon, Nov 02, 2020 at 01:40:07PM +0000, Ross Lagerwall wrote:
>> On 2020-10-31 10:03, Greg KH wrote:
>>> [CAUTION - EXTERNAL EMAIL] DO NOT reply, click links, or open attachments unless you have verified the sender and know the content is safe.
>>>
>>> On Fri, Oct 30, 2020 at 03:17:09PM +0100, Jürgen Groß wrote:
>>>> On 30.10.20 14:29, Ross Lagerwall wrote:
>>>>> Hi,
>>>>>
>>>>> Please backport [1] to 4.4, 4.9, 4.14, 4.19.
>>>>>
>>>>> It fixes a commit that has been backported to all the current stable releases but for some reason the fixup was only backported to 5.4 & 5.8.
>>>>
>>>> Greg has told me he queued my backport already.
>>>
>>> I did?  I don't see that commit backported anywhere, did you get
>>> confused with some other patch?
>>>
>>> I need a backported version of this patch if we are able to accept it,
>>> as it does not apply cleanly to those kernel releases.  Can someone
>>> please provide it and send it?
>>>
>>
>> The clean backport to older releases was sent by Jürgen on Oct 5th (subject [PATCH] xen/events: don't use chip_data for legacy IRQs).
>>
>> https://lists.linaro.org/pipermail/linux-stable-mirror/2020-October/221081.html
>>
>> It was queued for 5.4 but not older releases even though it applies cleanly to 4.4..4.19.
> 
> Can you please resend it, that's long out of my mboxes...

I have included it in the series I've already sent to you for 4.19 and
4.14, and will do so for 4.9 and 4.4, too.


Juergen
