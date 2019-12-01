Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6710E1E5
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 13:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfLAMap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 07:30:45 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43737 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbfLAMap (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 07:30:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CB12D921;
        Sun,  1 Dec 2019 07:30:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 01 Dec 2019 07:30:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=imap.cc; h=to:cc
        :references:from:subject:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=k
        n2pHQXCE0STE2AL8UyaAOLoHfqasuB2x2MErPCU8PQ=; b=FbPyDaMljvOAcD5Ja
        QK7D3joBNSAfLL4wceRb4XK2f9yPC8gm/AnX9OpaBLS8ZHBU0AsQB7YC8OooNNou
        dlSAXBhyOnm3/oP6OtQtcu8PSzsUeK36jAHcA/TeJtSrSYSj90N+UBAiYzCqAh0Q
        fW0vWloLHG/LNP/lQHUFphAylwrZeo51FrZhTF7cVh8EqTDcORSH5PSPSm26puFM
        U1Lamm+nNzcja5khB4WaKOSogauIBTjN+j+WvanMpUKgV8A+8IIWiU9p4ZPFNtqH
        rvhegkisTmx7hcXOwRl9xL8ZlU2cV7l/qIB1bsVaI3DeHjog1kHmxa38hRb0sXa6
        o7avw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=kn2pHQXCE0STE2AL8UyaAOLoHfqasuB2x2MErPCU8
        PQ=; b=hxkieanKGkq1bTJsyWSZm5UTr0Ln0UKZ0EyMkwWU6WhKW3nQVO4DAGZ4h
        hsp3OaMgPqMBuqYstqDPJz8oB5q0VPr5+YDTf/8VXlszENsEIPtoaqSoIXsclwW2
        6CHiw9nNJGUCThi1dlSh0c7j+ewQPQ7nUgtm+tf3m6coA66coXt2sshd10W2j+kH
        Of1pVI8+bxScJfdChE2ClBb3kIRpxPWduCbsaJoM15UokAj/LtZ8i/wAzB0JHLZe
        8FXgW14MM5RbNnRvQ2CSaxLpgigYpzQ8XdFm4xH+jhYBWW2iBehOFA0dDjYMlKg1
        PC3aQb9N9yNGzi1bW/qMRXdn8mpHw==
X-ME-Sender: <xms:crLjXa_LuT8eCm9Td1ThKd4EAsFpklfx6c0JCrZDJ67-w1itonrwcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejfedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfedtmdenucfjughrpefvfhfhuffkffgfgggjtgfgsehtkeertddt
    feejnecuhfhrohhmpefvihhlmhgrnhcuufgthhhmihguthcuoehtihhlmhgrnhesihhmrg
    hprdgttgeqnecukfhppeejledrvdegledrudegiedrudejkeenucfrrghrrghmpehmrghi
    lhhfrhhomhepthhilhhmrghnsehimhgrphdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:crLjXeqyJTIygFDhMFmDrY423LfpFdKf2If4vC8wR2rQ29QNMSHbtw>
    <xmx:crLjXUkgehht-4ShQ8EFliXm6Wb8KT40DI1gZE7dxR1YPfqzqghyOg>
    <xmx:crLjXaZe80v1UQvytcInYpgyn080jr8Ay5IgNZC1-Kd426pd9wJYBw>
    <xmx:c7LjXYo8Ra3YeZCYVMx7vhaXtAChngVAGJdZiqyqkYbOBSBPIL1W1g>
Received: from [192.168.59.117] (p4ff992b2.dip0.t-ipconnect.de [79.249.146.178])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC796306014B;
        Sun,  1 Dec 2019 07:30:41 -0500 (EST)
To:     Johan Hovold <johan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hansjoerg Lipp <hjlipp@web.de>, stable@vger.kernel.org
References: <20191129101753.9721-2-johan@kernel.org>
 <20191201001505.964E72075A@mail.kernel.org>
From:   Tilman Schmidt <tilman@imap.cc>
Autocrypt: addr=tilman@imap.cc;
 keydata= mQENBFOnH60BCADAjDkW8QHkuYEGOCimq/2xhB7Fe0ljGHAoy36bqZJ3mKo6vUVibl7e4QH/
 VxBxYyfM9N2EdxSf8e3g0736oamQTjpvUMcApELTq7RufCxIpjXbV/3ZAzFEf3SbBozfKYA/
 h+sFM+Yy0BF/6NWwC7UgCm2AvV6w6gwHHIQvLED1BeRkD/EH1HmgfgiqJIGlwSqkSTNsUtL6
 WZoBOTNeInj5rl431dz0gJdYs//ZDJ2z35XaljDP8x0Vx4L4Tm1AhZCTt5Qxj9I68WwJv66u
 fz+weZ3MzG7QNVn3YVMzAAD6P8z74NM1EZF6Kg2w319d3lPL9Ba02CcU8o/Jo5/MUEcDABEB
 AAG0H1RpbG1hbiBTY2htaWR0IDx0aWxtYW5AaW1hcC5jYz6JATsEEwECACUCGyMGCwkIBwMC
 BhUIAgkKCwQWAgMBAh4BAheABQJTpyKiAhkBAAoJEFPuqx0v+F+qj8sH/14MtCKDIpUSZ+jz
 2iTbF+szyF+RxgPKch7l4+MaLvthp3y7RvPM1fRsBYkuOvnSf2x2R8bfVAbGo8Agev6RAGce
 KVcmD0VAFDrYbyeM5YveL1TfbIEPYMG4qF0mQok9mhaesDCTk4LfVmmIXqAVOpKUd3Rcw6fc
 xG4nsgclTcj8csg5BJKiLBFyk1qYsEG+2l351qrITDSjzq1Ooq7VugCtYrR4b7kH4UuPUkse
 v4aZOvddsrH57jNBiNZnN71Y7/L3N6DNg8YQir+hRpMS0cc+jhX0GOy3idUCt63t7HZTJadY
 qQy6nh3dIq94kiKFDYpMDVcFmivgLzR3kzHwDFC5AQ0EU6cfrQEIAJ67b2JDD0Y8CwEYOzta
 3NRyL67lj6dzawteFh7/an9fHsdiuEUV0/EHvCQAiD6Gbpc+qNCAkX5l9Q4uNqyvwUouO+Tw
 lqC3lGq3dZxc0ukf1mVbmuoxL8dU76KvjaTexbBphWRY4LJHQGjdf2jZRWPqO9FejSWaD6A5
 Icx5xexf+b66Wj8EibfF+Gw5kzPs9mjZrBpseAVJ+EbNkgx2/yx9oDw25LMycr+MMb61bSfr
 8id8gr+lDXhowgxik30bxLQtpj9UPZgRC4Y2CcyzQqotbOWciY5tpmT5tTv+ddgfQVhinsZP
 KAEK3AIYou27RkkjZ+kFTbnJ4tPKGOW8otMAEQEAAYkBHwQYAQIACQUCU6cfrQIbDAAKCRBT
 7qsdL/hfqlinB/9PBwJIS5+ZGiYblEog2HJFAn7YutnvHxoEoLZRZ/8tfIoCsGI18+OXpull
 YbCaLvXgYCeJjKsB6cY7Ih+xmclmNQmD6hsNvWIxNLEOtWxPCxXwbhvnFKzYiQHADnyyz12k
 uJlb6pT2sdTynl6gVwJz7s9cdipTB/aRaHpiMAUYgxxh8gEpoKmqKFoSwMA0lGozvfr8X9OI
 E8sCWFTs1Gr0Iz4SOJ26vwHSDZO880G+YW9O4l08mTNPBdBoV1auNqfKNF6wW4JQ6Spm6PZm
 26esWpBITo1IxICllLdjNI6DJf2vq8ShqAbb9S7yKClXPDSq+QLpUAKcKizg1UiBP6wS
Subject: Re: [PATCH 1/4] staging: gigaset: fix general protection fault on
 probe
Message-ID: <7cfa2ada-d1ea-aafe-6ac1-f407e3bd558d@imap.cc>
Date:   Sun, 1 Dec 2019 13:30:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191201001505.964E72075A@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

this is probably caused by the move of the driver to staging in
kernel release 5.3 half a year ago. If you want your patches to
apply to pre-5.3 stable releases you'll have to submit a version
with the paths changed from drivers/staging/isdn/gigaset to
drivers/isdn/gigaset.

HTH
Tilman

Am 01.12.2019 um 01:15 schrieb Sasha Levin:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 07dc1f9f2f80 ("[PATCH] isdn4linux: Siemens Gigaset drivers - M105 USB DECT adapter").
> 
> The bot has tested the following trees: v5.4.1, v5.3.14, v4.19.86, v4.14.156, v4.9.205, v4.4.205.
> 
> v5.4.1: Build OK!
> v5.3.14: Build OK!
> v4.19.86: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.14.156: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.9.205: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.4.205: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
