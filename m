Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA27488868
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 09:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiAIIxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 03:53:44 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:59075 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiAIIxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 03:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1641718423; x=1673254423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GSiH/twDmxaano1xqPfNIZ4td3CwYd/sSEPnGPMt4A4=;
  b=LHLJCojTqAqpRxYqc/tW5dAnNO1MYlYCgVsWideKQD675j1Mm9CaM6JF
   ItxUv91A1TzJPuGKyp1oBhiJ5JzVknBrqtEsr9qWza2OnvrFKBLh3CqHJ
   d9c+09HOJuw3z1n/KiZHdHnO62FWGYOuJB+NWWH3A3yKMsu6BHWspkDLb
   yEfxI+OkyGGLWrSlZZWD6Gp/aIGkbIsj84ejj8Se+I91ftC2OqlQaggOO
   HhS4GTsewcmJW0pNb4J3GLNnMdoRM4uHnfT1j16lJ+5VV/gnFyfdXXmfy
   8m3hAvC7v9BF9rj5Lqv98SDb0iiAU0Q/aMf+8+h0FNOfqNNTK7siTCeUq
   A==;
X-IronPort-AV: E=Sophos;i="5.88,274,1635177600"; 
   d="scan'208";a="190030268"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2022 16:53:42 +0800
IronPort-SDR: WCGDjUjB1h1AEC8N1LHkjh4ZBEvkVk/0EUOLdEJoIWaebHREYXU2frM6D1/jFWVmoV8G71dgBy
 9rJPW3nuysXxqlHLSTd7iXF0qLA/OkCfxNTSRYqfsVLP4W32ghSA5foyYevESXBNLrLAT+VcAD
 ySRgvwinieqCfJl3ik++4gMrWXLiUpgi9SM75h/zrUrm1mVD2ksQsCMU8+qKQqdG2lvkbgtkcY
 5bl7ql6z3qYdWKqOtVE7oVhPjuXXIpGABtHctRQzUcNr5ANuqNOndnwcPMBwWztbUjF8gZU9Xz
 DcWozjmQ7Z6ZzpUC5G5U4q72
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 00:26:08 -0800
IronPort-SDR: GKXlSLRwtvr0xYyQjdLgP5mLSNn+1na4spw8LThOr9c8++caSUiM2R+6VbcZvQ9VYq2Gdj0gAV
 JLHYGfY1ReEZvkPaYZE7B5hQsMwyEPUh3oiub4vAtw4HxcNsbU40i3b3uBM+vpn7odFosJ6lUj
 isnaF7vEdyS7SP0cIa0QpcNkpJ8W3JRckKLmNRdUK0tPI6AmquzgkycuvMyl+VcWQ3Sks/nU48
 Y4WP+B5Xd321V4m86whc34kx27xweXGqDt+s28tJAZAsPESf0kWWHaYmFCNfci2R2LS1NfJezm
 uoo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 00:53:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JWrN71kNCz1VSkj
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 00:53:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1641718422; x=1644310423; bh=GSiH/twDmxaano1xqPfNIZ4td3CwYd/sSEP
        nGPMt4A4=; b=q7FS87BLwWn4Sz5+cdMOazcLw6xn+l6YYe58Ojv4MKsu+g8PgYD
        oWL43OBZMeJT6TnmS9kYbJppVJxWr0weeRJP9lp9i5y/8de3TBJJsSHgJBilM25H
        tOfB6e/JQ4B0NDWkR419pux6puaasZPcXhvxdewhTkJcCnykATcqXgYXY6MI5Dbm
        iomjSOn2zFZg7f3UVGgSzS5WqPjuUMNnMJpablazHtLWSRaV9b10pubKKfOWFXqe
        BuWMEiWDXNIpzqEjiWZLHtYQKqoxm3zzVi0gDrneJFQQfX6FTp9zBj8wGaVUnyEe
        z2ISTyk2l69GNoy98zqZZLd5GWi/msSPq4g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hdvvmPW3Skzz for <stable@vger.kernel.org>;
        Sun,  9 Jan 2022 00:53:42 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JWrN53zGpz1VSkW;
        Sun,  9 Jan 2022 00:53:41 -0800 (PST)
Message-ID: <11d2e187-03eb-9a66-56ad-337fb5996b7b@opensource.wdc.com>
Date:   Sun, 9 Jan 2022 17:53:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v3] ide: Check for null pointer after calling devm_ioremap
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, David.Laight@ACULAB.COM,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220108035552.4081511-1-jiasheng@iscas.ac.cn>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20220108035552.4081511-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/01/08 12:55, Jiasheng Jiang wrote:
> On Sat, Jan 08, 2022 at 10:53:42PM +0800, Damien Le Moal wrote:
>>> Cc: stable@vger.kernel.org#5.10
>>
>> Please keep the space before the #
>>
>> Cc: stable@vger.kernel.org #5.10
> 
> Actually, I added the space before, but the when I use the tool
> 'scripts/checkpatch.pl' to check my format, it told me a warning
> that it should not have space.
> 
> The warning is as follow:
> WARNING: email address 'stable@vger.kernel.org #5.10' might be
> better as 'stable@vger.kernel.org#5.10'
> 
> So I have no idea what is correct.
> Is the tool outdated?
> If so, I will correct my cc and please update the tool.
> 
>> As commented before, what exactly was corrected ? That is what needs to be
>> mentioned here. In any case, I fail to see what code change you added between v2
>> and v3. The code changes are identical in the 2 versions.
> 
> Thanks, I will make the changelog more clear.
> In fact, in the v2 I was careless to write '!!alt_base'.
> So I removed the redundant '!' in v3.
> 
> Please tell me the right cc format, and then I will submit a new v3,
> without the problems above.

Cc: stable@vger.kernel.org # 5.10

Should work.

> 
> Sincerely thanks,
> Jiang
> 


-- 
Damien Le Moal
Western Digital Research
