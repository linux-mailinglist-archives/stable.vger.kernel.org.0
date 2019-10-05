Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4615CCD35
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 01:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfJEXB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 19:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfJEXBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 19:01:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F123520862;
        Sat,  5 Oct 2019 23:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570316485;
        bh=OSMf8B0AB6AIqckNzRwk3oaI7AdreTyoAu9Y39HJWY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wdh7qOQEB4QaKJ9SsdQIroEMCFUpYSThpjFkzk3JTX+LmSsoc8UgEcT/7Dh+9cp4M
         hCXIakPFvhJkjm/MKMrN6YCu5z66OVEtIbxUxKmCC7vGerW1A44245MN1f7bqzjCOM
         h0u2+hCUSBGr8akNAPcZtdglTavpSlWip+KIgu1I=
Date:   Sat, 5 Oct 2019 19:01:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, john@phrozen.org, kishon@ti.com,
        ralf@linux-mips.org, robh+dt@kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>, mark.rutland@arm.com,
        ms@dev.tdt.de
Subject: Re: [PATCH AUTOSEL 4.19 12/33] MIPS: lantiq: update the clock alias'
 for the mainline PCIe PHY driver
Message-ID: <20191005230124.GC25255@sasha-vm>
References: <20190929173424.9361-1-sashal@kernel.org>
 <20190929173424.9361-12-sashal@kernel.org>
 <CAFBinCCD7xTnektDhDa+wRsAWmyzMwgfou59Y3=Qf8b2utaciw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFBinCCD7xTnektDhDa+wRsAWmyzMwgfou59Y3=Qf8b2utaciw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 07:40:28PM +0200, Martin Blumenstingl wrote:
>Hi Sasha,
>
>On Sun, Sep 29, 2019 at 7:34 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>>
>> [ Upstream commit ed90302be64a53d9031c8ce05428c358b16a5d96 ]
>>
>> The mainline PCIe PHY driver has it's own devicetree node. Update the
>> clock alias so the mainline driver finds the clocks.
>the mainline PCIe PHY driver only made it into Linux 5.4
>I am pointing this out because OpenWrt uses an out-of-tree PCIe driver
>with Linux 4.19 and this patch will break that if we don't do
>additional work there
>
>thus I would like to understand why this got queued as backport for
>various -stable kernels

It went through the automatic selection process, where we attempt to
identify fixes that were not tagged for stable.

I've dropped this patch from all stable trees, thank you.

-- 
Thanks,
Sasha
