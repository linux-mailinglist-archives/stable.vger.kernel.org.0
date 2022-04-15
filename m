Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE750205A
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 04:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbiDOCRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 22:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345726AbiDOCRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 22:17:20 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04D64D615
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 19:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649988893; x=1681524893;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WhFCPjpcY73NOr+2vy/xILbKOpm8U3lMJb79Q6mDq7Q=;
  b=EnfQJ+WflKmFcds4PCUFaqmxVY/wc2h7iT8mDIbjWHClaL2CumJJr0MJ
   oshn1CiDvU9qzGfLbMX6JlWNeWsfnot9ysZHeFwF7XIpn1GLT4yTUadRu
   gzb4ZXvBy3Q2mR2sHWxDvYfaSulVQPm+47qRFpsxQBgK0rxFN9/RdDNSI
   hOliaucZSc7Riucc1kgnB+F6GRiQUHLhcoIZSYaYAZXVg9D0bTBBCYHKI
   xgXc7D9WkkM0C88meQkWT8HLDhrovZ6Md5BE2i51snOk8y8vbFlQDgfHJ
   lW6OwuT0qa8gA8959Tbbw6GA5tya9VA2ZclXErbJVWSs3xLfZDFoqXKVu
   w==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="196824083"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 10:14:52 +0800
IronPort-SDR: 2fA+cbdnIkZNgMU7yXesi9nn7Pxh8I2s4tjhXpd9y1roWej0tSvUSAjpC2QwwLaBPBzQRd1MPd
 eu8Ixsa/0IENqh3PENpdh7AHa+u3P2OUnjXWB1wp6WB6n8nxgUQ6hytW5+oaK32NrOVmrwhQan
 Q6yKPyr0f7czfSlC47CcNmSKar2iHULt2+47iLzAuz4e2p2zGwy4ZPZc+idx9FZ9zG+8eRL0qC
 SsNDPTv+gcyX1Y6Au/IKt5srcalC7m0ggW+mE4Ub4+6/k+HPHfM2gccKB5xI7S/4PrCIwMCpmL
 EOOYaIAHZU67G/3QX3tbxHwr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 18:46:03 -0700
IronPort-SDR: 1IZepmypspmJkEuf0Yk5d2DvARDri/7lA6krm6B12OSyKT0lsTEHUn1UPVYHuLk+PMO9DtJKr4
 grFB6Sl5KqNY5vvprmjqUBxU/gy2kGxlKoFmzXnC1sXMVBlVgMjyyb7Fig72StlkeD30GDSRje
 Cyi9Xi3tMY0xevzYkBw4l3KEjgZoea7gQZfVuiN5rXWaRRrvPOP+t92+sZ3KVJ6OJlWKqGB63U
 P8oulP/vw+inoFmEdnzFz9Lcj8Y1M4EyFEva1FdqILtL7NJa/2euvVTcNgyJgAcBJbIO50WKsZ
 3k4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 19:14:53 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kffzb45DVz1SVp2
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 19:14:51 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649988890; x=1652580891; bh=WhFCPjpcY73NOr+2vy/xILbKOpm8U3lMJb7
        9Q6mDq7Q=; b=Je/KTCSORMEIBsQ9wzBGLn5Wo3UMd7sE2lFIN5Rq985Iji1IXPo
        iCJAyaGCoha060/PbFVDMlRHJdhkSml8b/ir9aQH0DW7YizZa4FJ8QHNCOYppqNh
        jQlNFP3Xr0a0A/TeSI4Ho9yv9ik71juA9gPCZuqPfgjxiQk1HuRcSJHExbup/3rQ
        vUvoOoSHzb37h6QKTl1KAxr5rWJR97jWSIwd3cllkfiVUVboU+58h0RwM9e4gH2Y
        PZ5Ft3VsQheRqzXZAu0A8Ri+FeNfH1qm5fjisfcTFrSmit2G6RwzCUgXvyBEzhoB
        HCjDVfmcMu9bKJ8hWcwmN7thSnoedePTA9g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DC06Gp-zvy4p for <stable@vger.kernel.org>;
        Thu, 14 Apr 2022 19:14:50 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KffzX2zWTz1Rvlx;
        Thu, 14 Apr 2022 19:14:48 -0700 (PDT)
Message-ID: <1ad275e2-8c7b-4b13-06f2-e2be13155185@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 11:14:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
 <Yli8voX7hw3EZ7E/@x1-carbon>
 <6ee62ced-7a49-be56-442d-ba012782b8e2@opensource.wdc.com>
 <YljFiLqPHemB/u77@x1-carbon>
 <9a9a4dcf-0ea1-01ac-d599-16c10b547beb@opensource.wdc.com>
 <YljUWpq42t1gQFRf@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YljUWpq42t1gQFRf@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/22 11:11, Niklas Cassel wrote:
> On Fri, Apr 15, 2022 at 10:13:31AM +0900, Damien Le Moal wrote:
>> On 4/15/22 10:08, Niklas Cassel wrote:
>>> On Fri, Apr 15, 2022 at 09:56:38AM +0900, Damien Le Moal wrote:
>>>> On 4/15/22 09:30, Niklas Cassel wrote:
>>>>> On Fri, Apr 15, 2022 at 08:51:27AM +0900, Damien Le Moal wrote:
>>>>>> On 4/14/22 18:10, Niklas Cassel wrote:
>>>
>>> (snip)
>>>
>>>> So if we are sure that we can just skip the first 16B/8B for riscv, I
>>>> would not bother checking the header content. But as mentioned, the
>>>> current code is fine too.
>>>
>>> That was my point, I'm not sure that we can be sure that we can always
>>> skip it in the future. E.g. if the elf2flt linker script decides to swap
>>> the order of .got and .got.plt for some random reason in the future,
>>> we would skip data that really should have been relocated.
>>
>> Good point. Your current patch is indeed better then. BUT that would also
>> mean that the skip header function needs to be called inside the loop
>> then, no ? If the section orders are reversed, we would still need to skip
>> that header in the middle of the relocation loop...
> 
> So this is theoretical, but if the sections were swapped in the linker
> script, and we have the patch in $subject applied, we will not skip data
> that needs to be relocated. But after relocating all the entries in the
> .got section we will still break too early, if we actually had any
> .got.plt entries after the .got.plt header. The .got.plt entries would
> not get relocated.
> 
> However, the elf2flt maintainer explicitly asked ut to fix the kernel or
> binutils, so that they can continue using the exact same linker script
> that it has been using forever. (And we shouldn't need to change binutils
> just for the bFLT format.)
> 
> So the chance that the linker script changes in practice is really small.
> (This .got.plt vs .got hasn't changed in 19 years.)
> 
> But if it does, we will just have one problem instead of two :)
> However, I think that applying this patch is sufficient for now,
> since it makes the code work with the existing elf2flt linker script.
> 
> Adapting the code to also handle this theoretical layout of the linker
> script would just complicate things even more. I'm not even sure if we
> would be able to handle this case, since the information about the .got
> and .got.plt section sizes is lost once the ELF has been converted to
> bFLT.

OK. All good then.
I maintain my reviewed-by tag :)



-- 
Damien Le Moal
Western Digital Research
