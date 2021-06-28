Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C43B5E08
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhF1MfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:35:20 -0400
Received: from phobos.denx.de ([85.214.62.61]:59736 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhF1MfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 08:35:19 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id CFBF082DA5;
        Mon, 28 Jun 2021 14:32:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624883571;
        bh=Drbif/ovk/vG5fMOjIhZo7mrgJSOiHqSsEO/sqRhiOk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nlIPBRlsh/+64cY6lbvIjxKNMawescR4W/MEBfH9aGAwQz3u4XbtfICbsTSebJCck
         Uo1D36YdGsza0U615nahaQqEPrAfLZNS/oC6h3WkUXd3F6873lpOBz973K5gDF0B03
         8551ymQ5t9z870mH9w0xHnF9P+7E2OVLXggYTLARQdCwocI7EFC06K6WERFDO28UQg
         8HAgjdYF9p7c2FtFDHwbqOJEy6ZqziEBD6+fDwGCVU63ngiRg25WgMOhfM6Q7pwWLM
         kEPkQvWQCafdMajGHRYX8iXiVoBRILmMF8CHxH39vQPaj/lEDeff1bni4lpwEpAPYN
         VHWvd1OXajCBg==
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
From:   Marek Vasut <marex@denx.de>
Message-ID: <7fc37c79-4e04-2cb0-efc4-4f642316c612@denx.de>
Date:   Mon, 28 Jun 2021 14:32:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNnAxiDMCQ8Y05ll@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/21 2:29 PM, Greg KH wrote:
> On Mon, Jun 28, 2021 at 12:44:37PM +0200, Marek Vasut wrote:
>> On 4/9/21 1:00 AM, Marek Vasut wrote:
>>> The Microchip LAN8710Ai PHY requires XTAL1/CLKIN external clock to be
>>> enabled when the nRST is toggled according to datasheet Microchip
>>> LAN8710A/LAN8710Ai DS00002164B page 35 section 3.8.5.1 Hardware Reset:
>>
>> [...]
>>
>>> Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
>>
>> Adding stable to CC.
>>
>> Patch is now part of Linux 5.13 as commit
>>
>> 1cebcf9932ab ("ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM")
> 
> $ git show 1cebcf9932ab
> fatal: ambiguous argument '1cebcf9932ab': unknown revision or path not in the working tree.
> Use '--' to separate paths from revisions, like this:
> 'git <command> [<revision>...] -- [<file>...]'
> 
> Are you sure?

This would seem to indicate so:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1cebcf9932ab76102e8cfc555879574693ba8956

linux-2.6$ git describe 1cebcf9932ab76102e8cfc555879574693ba8956
v5.13-rc1-1-g1cebcf9932ab

Did the commit get abbreviated too much ?
