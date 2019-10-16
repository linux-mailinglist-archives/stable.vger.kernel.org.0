Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F30D862D
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 05:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389187AbfJPDDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 23:03:11 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:35943 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729457AbfJPDDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 23:03:11 -0400
Received: from mxback5j.mail.yandex.net (mxback5j.mail.yandex.net [IPv6:2a02:6b8:0:1619::10e])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 1338D4B01B04;
        Wed, 16 Oct 2019 06:03:05 +0300 (MSK)
Received: from myt5-e8d19f59bd21.qloud-c.yandex.net (myt5-e8d19f59bd21.qloud-c.yandex.net [2a02:6b8:c12:3e24:0:640:e8d1:9f59])
        by mxback5j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id eRJqu7dm48-34aqGRtk;
        Wed, 16 Oct 2019 06:03:05 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571194985;
        bh=8HBD9RyaLSJOSxtvT5S+4AeSlj26222duXzFg8wgclU=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=KMNeJjOw94wZwKvkADVC6dCax/VWr1TnbYwR3eyuW9j1IPhgPo/YEs+u61H1PteUS
         kZbSrchwBRh/Jc67xG/WK3cvlnNubOp2zezvhDn9DJOV9sRXnmXxCbL175qY1+Ev6n
         tc6diJvzC9LFQWrAJ7zYd2k56z3ZP+GzWaZoqgss=
Authentication-Results: mxback5j.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by myt5-e8d19f59bd21.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id SQHfl8AhvD-30Hqfu8X;
        Wed, 16 Oct 2019 06:03:02 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v1] MIPS: elf_hwcap: Export userspace ASEs
To:     "Maciej W. Rozycki" <macro@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>
Cc:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Meng Zhuo <mengzhuo1203@gmail.com>,
        Paul Burton <pburton@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20191010150157.17075-1-jiaxun.yang@flygoat.com>
 <MWHPR2201MB127715CCA6D7B8CCBCCC2683C1940@MWHPR2201MB1277.namprd22.prod.outlook.com>
 <alpine.LFD.2.21.1910160023280.25496@eddie.linux-mips.org>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <d1d4cff7-ac3e-a9ab-ecee-cc941b0895e7@flygoat.com>
Date:   Wed, 16 Oct 2019 11:02:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1910160023280.25496@eddie.linux-mips.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/10/16 上午7:27, Maciej W. Rozycki wrote:
> On Thu, 10 Oct 2019, Paul Burton wrote:
> 
>>> A Golang developer reported MIPS hwcap isn't reflecting instructions
>>> that the processor actually supported so programs can't apply optimized
>>> code at runtime.
>>>
>>> Thus we export the ASEs that can be used in userspace programs.
>>
>> Applied to mips-fixes.
> 
>   This makes a part of the user ABI, so I would advise discussing this with
> libc folks.  Also you probably want to report microMIPS support too.
Hi Maciej,

How can hwcap advance libc? I know that Arm world is using it to probe 
SIMD extensions in high-level programs like ffmpeg.

microMIPS binary can't be applied at runtime, so userspace programs 
shouldn't aware that.

  Should I Cc this discussion to libc-alpha or other lists?

--
Jiaxun
> 
>    Maciej
> 
