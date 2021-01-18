Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AE42F9DB3
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbhARLLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:11:21 -0500
Received: from first.geanix.com ([116.203.34.67]:40332 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389349AbhARLHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:07:47 -0500
Received: from [IPv6:2a06:4004:10df:1:da27:a6d2:5305:fd0a] (_gateway [172.21.0.1])
        by first.geanix.com (Postfix) with ESMTPSA id 3A4374E4AB0;
        Mon, 18 Jan 2021 11:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1610968022; bh=UTAJNPJuZKiKbfUBeRRbDLiD/CF2iT9OqIJEUKLZjSg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Tiv7/dTBeoLW2y/Q0CJ2i9yYTSgsUTs05XiBVVAbT0G2YNfJbyQacgZ1tQPHtsopZ
         B9xgQENVDqVlFdlCIv4+BABOgUMvNJvHgrochkOLOUlOZ1z/9prZ/QM2CIjfkKVKZ4
         REgrSogzi3jXycvyU8bumgD+/7+26mt+aB7mFn/0mGkvP74CnHRxcRKrpaxm+yPMVf
         ek1jqNu/9QwTNARD0xUVQoOkMbQrdDSk0O8vVBf05n6aC42aTXo7PlQ72h119/5SvI
         cyOlxC0dKiFQU8+K3obUGjib1ePXAK/m8QxJZqtu6VRBIopV1xUfRTD8UYhq7hMj91
         WTWiCfu1s3fNw==
Subject: Re: [PATCH] mtd: rawnand: gpmi: fix dst bit offset when extracting
 raw payload
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Han Xu <han.xu@nxp.com>, Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210104103558.9035-1-miquel.raynal@bootlin.com>
 <7db4b36e-23a6-6075-132c-214d043e78bd@geanix.com>
 <20210104121516.3d50fb58@xps13>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <d3ebfc3c-4842-a506-512a-28c6c02f6c42@geanix.com>
Date:   Mon, 18 Jan 2021 12:07:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210104121516.3d50fb58@xps13>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        URIBL_BLOCKED autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on ff3d05386fc5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 04/01/2021 12.15, Miquel Raynal wrote:
> Hi Sean,
>
> Sean Nyekjaer <sean@geanix.com> wrote on Mon, 4 Jan 2021 11:50:10 +0100:
>
>> On 04/01/2021 11.35, Miquel Raynal wrote:
>>> On Mon, 2020-12-21 at 10:00:13 UTC, Sean Nyekjaer wrote:
>>>> Re-add the multiply by 8 to "step * eccsize" to correct the destination bit offset
>>>> when extracting the data payload in gpmi_ecc_read_page_raw().
>>>>
>>>> Fixes: e5e5631cc889 ("mtd: rawnand: gpmi: Use nand_extract_bits()")
>>>> Cc: stable@vger.kernel.org
>>>> Reported-by: Martin Hundebøll <martin@geanix.com>
>>>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
>>> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.
>>>
>>> Miquel
>> Hi Miquel
>>
>> Will you please queue this for fixes? It's quite relevant for 5.10 LTS :)
> Right, that will be quicker to have it in Linus' tree. I moved
> the patch to the mtd/next branch.
>
Hi Miquel,

Any guess to when the mtd/fixes branch will be pulled into Linus' tree?

/Sean
