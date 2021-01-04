Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D772E93B3
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhADKuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:50:54 -0500
Received: from first.geanix.com ([116.203.34.67]:36860 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbhADKux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:50:53 -0500
Received: from [IPv6:2a06:4004:10df:1:da27:a6d2:5305:fd0a] (_gateway [172.21.0.1])
        by first.geanix.com (Postfix) with ESMTPSA id 824154E083C;
        Mon,  4 Jan 2021 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1609757410; bh=vzQBIiX2ZNmabReTeKi3DQ9XqK9ef5/p5TwmnrtLyjY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Oy0LrhR/kRG2/ccgCAqdunZl1RBGvyaB5W6RIiKu5yoZ+ayk+nVJDh5Olh4MC1meN
         9MoX3u+2Vggt4S1GCIwtsKkF2H0X7ZEkITxKGi4V+BPWDWS2BDING6/4uzQCIxReSm
         D6sIPWKtwZSbSuGvXlZn9DVmM62DYStkD95OPU0sXxM3GYfv1qa2y7DwnLxEiF9SMt
         XYbRx1Jtd4XL357/DmHGUUr/N/vLK0elnhcTYjPIHW482MP585FyPJqWPEhjcxUl0N
         +xbGFSsI/DZ6CqZE+Q5RA79Y7sUk4KnRSE3HzsFKBOdT7hS85I+eKTTDMCo6Picz5+
         0L0p6vys4OMMQ==
Subject: Re: [PATCH] mtd: rawnand: gpmi: fix dst bit offset when extracting
 raw payload
To:     Miquel Raynal <miquel.raynal@bootlin.com>, Han Xu <han.xu@nxp.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210104103558.9035-1-miquel.raynal@bootlin.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <7db4b36e-23a6-6075-132c-214d043e78bd@geanix.com>
Date:   Mon, 4 Jan 2021 11:50:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104103558.9035-1-miquel.raynal@bootlin.com>
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



On 04/01/2021 11.35, Miquel Raynal wrote:
> On Mon, 2020-12-21 at 10:00:13 UTC, Sean Nyekjaer wrote:
>> Re-add the multiply by 8 to "step * eccsize" to correct the destination bit offset
>> when extracting the data payload in gpmi_ecc_read_page_raw().
>>
>> Fixes: e5e5631cc889 ("mtd: rawnand: gpmi: Use nand_extract_bits()")
>> Cc: stable@vger.kernel.org
>> Reported-by: Martin Hundebøll <martin@geanix.com>
>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.
>
> Miquel
Hi Miquel

Will you please queue this for fixes? It's quite relevant for 5.10 LTS :)

Best regards
Sean Nyekjaer
