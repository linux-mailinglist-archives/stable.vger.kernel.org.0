Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E0BCCD34
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 01:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfJEXAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 19:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfJEXAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 19:00:39 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6574222C5;
        Sat,  5 Oct 2019 23:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570316438;
        bh=jNhO1yhzGmSxpfUauYxPl/dwBJJO9Ob403LUDD3Bg+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YNaXatoOwa/0IdJBMX+mRjlIeFMz4GkAT5W8RUCWhl3BkW1NLTl/9B0lgMloyKZLd
         LoQ5dTmMajZ3BTzoFiGWTTNA9+iqYUJf8fZSMkAVg8X0pVbnHZY3lWUWj/Qv4WzOB/
         oHvVrKf1hQYoUv8A/SUj9T234TIgtseI9C3HCQEg=
Date:   Sat, 5 Oct 2019 19:00:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, john@phrozen.org, kishon@ti.com,
        ralf@linux-mips.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ms@dev.tdt.de
Subject: Re: [PATCH AUTOSEL 5.2 17/42] MIPS: lantiq: update the clock alias'
 for the mainline PCIe PHY driver
Message-ID: <20191005230036.GB25255@sasha-vm>
References: <20190929173244.8918-1-sashal@kernel.org>
 <20190929173244.8918-17-sashal@kernel.org>
 <fe9161b3-2402-e5a8-959b-63c807be3e08@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fe9161b3-2402-e5a8-959b-63c807be3e08@hauke-m.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 07:39:49PM +0200, Hauke Mehrtens wrote:
>On 9/29/19 7:32 PM, Sasha Levin wrote:
>> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>>
>> [ Upstream commit ed90302be64a53d9031c8ce05428c358b16a5d96 ]
>>
>> The mainline PCIe PHY driver has it's own devicetree node. Update the
>> clock alias so the mainline driver finds the clocks.
>>
>> The first PCIe PHY is located at 0x1f106800 and exists on VRX200, ARX300
>> and GRX390.
>> The second PCIe PHY is located at 0x1f700400 and exists on ARX300 and
>> GRX390.
>> The third PCIe PHY is located at 0x1f106a00 and exists onl on GRX390.
>> Lantiq's board support package (called "UGW") names these registers
>> "PDI".
>>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> Signed-off-by: Paul Burton <paul.burton@mips.com>
>> Cc: linux-mips@vger.kernel.org
>> Cc: devicetree@vger.kernel.org
>> Cc: john@phrozen.org
>> Cc: kishon@ti.com
>> Cc: ralf@linux-mips.org
>> Cc: robh+dt@kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: hauke@hauke-m.de
>> Cc: mark.rutland@arm.com
>> Cc: ms@dev.tdt.de
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/mips/lantiq/xway/sysctrl.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>
>Hi Sasha,
>
>This change only makes sense with the new upstream PCIe phy driver which
>was added to kernel 5.4 [0], older kernel versions do not have this PCIe
>PHY driver. I would not backport these changes to older kernel versions.

I'll drop it, thank you!

-- 
Thanks,
Sasha
