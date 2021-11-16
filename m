Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4374453A7C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhKPUBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:01:16 -0500
Received: from phobos.denx.de ([85.214.62.61]:59888 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239956AbhKPUBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 15:01:15 -0500
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 76A1182C88;
        Tue, 16 Nov 2021 20:58:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1637092696;
        bh=Ufochh4U7Of4ts3b6uAVj71FbT1mTO3mTz5yS4g4Jy4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZG5P4TKzrA1RJd3Y1vDINBiO0qILf4A+FTjlmRvfTNEn4cxA+cfxrIuOUf9sq7IZb
         6pt7GutB8wbEC1PwO0g9lh3xWBRw7WqDaIhANiyIBGPDxSmxa8NRTdu0/PKYWod47u
         +MJg1zcdidOg7LkKNvk/vBldRlhNL1bwU8q8Xboc85vUYa7p6RZs54hz4bpza7MolM
         F7Spj63/5gvY0lxLiP0dPUvl1Q4tLJrEDlDMQflXq2zDqZrAZG+Whp43E3VOGc9nVF
         nJ5fwbhlmoPZoky8VaLDkU1r+mxAvNEy0seu1nkuqUGpo8KL7fmEfMLuSwlfzhtsn0
         +Rti2Sp7jSy9Q==
Subject: Re: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Szabolcs Sipos <labuwx@balfug.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
References: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
 <YWPrSHGbno3dODKr@kroah.com>
 <62685363-e1b3-bc97-431e-a7c8faccb78d@balfug.com>
 <YZP6CL+CDMyzQ6aA@kroah.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <5931c469-c0bf-4e93-e7e3-443b5ca60fb3@denx.de>
Date:   Tue, 16 Nov 2021 20:58:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZP6CL+CDMyzQ6aA@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 7:35 PM, Greg Kroah-Hartman wrote:
> On Tue, Nov 16, 2021 at 06:41:08PM +0100, Szabolcs Sipos wrote:
>> On 10/11/21 09:44, Greg Kroah-Hartman wrote:
>>> On Sun, Oct 10, 2021 at 10:59:06PM +0200, Marek Vasut wrote:
>>>> Hello everyone,
>>>>
>>>> The following new device USB ID has landed in linux-next recently:
>>>>
>>>> 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
>>>>
>>>> It would be nice if it could be backported to stable. I verified it works on
>>>> 5.14.y as a simple cherry-pick .
>>>
>>> A patch needs to be in Linus's tree before we can add it to the stable
>>> releases.  Please let us know when it gets there and we will be glad to
>>> pick it up.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hello Greg,
>>
>> The patch has reached Linus's tree:
>> 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
>>
>> Could you please add it to stable (5.15.y)?
> 
> I will queue it up for the next set of kernels after the current ones are
> released.

btw while you're bringing it up, is there some sure-fire method I can 
use to verify the patch is in Linus tree, besides having a separate 
checkout of that tree ?

I usually have both Linus tree as origin and next in one git tree, so I 
was wondering if there is a recommended way to avoid mistakes like the 
one I made above (and checking at git.kernel.org apparently also has its 
downsides).
