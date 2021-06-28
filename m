Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9E3B5EBD
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 15:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhF1NNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 09:13:04 -0400
Received: from phobos.denx.de ([85.214.62.61]:39748 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhF1NNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 09:13:04 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 48C7A82DA6;
        Mon, 28 Jun 2021 15:10:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624885837;
        bh=yVRkI9eVNVwlcMjIh+oRvDEepzvufte8nlYV2R/bq2Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=zDSvOspHpnlzCJe2LL+7CQzQ75lYFa2dQOMkN/Yh9WwtuhFS8Dbr81Bqc7ktoRLWa
         HR9HYxvR0QObc8YfZdwu8iCZUKzckucfOEtVnal0FIdnTuMWphdHg095tkPfgS2pBd
         kvhY6TrzGGKvH+H5NfrpVKgWQhJkNUr23AkN1SOsPGAgpsraKDTkg/9Lf5ydXVpxHT
         Lzq7i2BxtTppTOrbqzKKNMsFUupAyOm7mdX74bT51u+bL5FyYITLlbFIV2wzw/wGFr
         DduAS1hGqsBo4Kp5N6JpUaL4MTv5Oo/QiM91kv6elS0CQ8LIZtVoRjwN/8wtDYk+NX
         wOxoQSf8x0Y9A==
Subject: Re: [PATCH] ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-stable <stable@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
References: <20210408230001.310215-1-marex@denx.de>
 <47597d13-e6ec-ccd2-c34b-eb65896cdd70@denx.de> <YNnAxiDMCQ8Y05ll@kroah.com>
 <7fc37c79-4e04-2cb0-efc4-4f642316c612@denx.de> <YNnIXjGyvaQgf2wP@kroah.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <7137f147-f127-2884-39e7-7cfabe9e2bfc@denx.de>
Date:   Mon, 28 Jun 2021 15:10:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNnIXjGyvaQgf2wP@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/21 3:02 PM, Greg KH wrote:
> On Mon, Jun 28, 2021 at 02:32:50PM +0200, Marek Vasut wrote:
>> On 6/28/21 2:29 PM, Greg KH wrote:
>>> On Mon, Jun 28, 2021 at 12:44:37PM +0200, Marek Vasut wrote:
>>>> On 4/9/21 1:00 AM, Marek Vasut wrote:
>>>>> The Microchip LAN8710Ai PHY requires XTAL1/CLKIN external clock to be
>>>>> enabled when the nRST is toggled according to datasheet Microchip
>>>>> LAN8710A/LAN8710Ai DS00002164B page 35 section 3.8.5.1 Hardware Reset:
>>>>
>>>> [...]
>>>>
>>>>> Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
>>>>
>>>> Adding stable to CC.
>>>>
>>>> Patch is now part of Linux 5.13 as commit
>>>>
>>>> 1cebcf9932ab ("ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM")
>>>
>>> $ git show 1cebcf9932ab
>>> fatal: ambiguous argument '1cebcf9932ab': unknown revision or path not in the working tree.
>>> Use '--' to separate paths from revisions, like this:
>>> 'git <command> [<revision>...] -- [<file>...]'
>>>
>>> Are you sure?
>>
>> This would seem to indicate so:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1cebcf9932ab76102e8cfc555879574693ba8956
>>
>> linux-2.6$ git describe 1cebcf9932ab76102e8cfc555879574693ba8956
>> v5.13-rc1-1-g1cebcf9932ab
>>
>> Did the commit get abbreviated too much ?
> 
> Something is really odd, as that commit _is_ in linux-next, but it is
> not in my local copy of Linus's tree.
> 
> So how it is showing up in that link above is beyond me.  Can you see it
> locally on your machine?

Yes, that's where the git describe came from. And I used a different 
repo than the one from which I submitted the patch originally, so the 
commit must've come from fetching origin (i.e. linus tree).

Could it be this "ambiguous argument '1cebcf9932ab'" , which would 
indicate the commit hash got abbreviated too much ?
