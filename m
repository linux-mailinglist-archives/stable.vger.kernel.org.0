Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8722F502006
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 03:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiDOBQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 21:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiDOBQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 21:16:03 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC0F6B0B9
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649985217; x=1681521217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2o3hbZhROctTrf9/YEdToCbep6cUQhIveDuZAWOBAjM=;
  b=lTkN6pAHkAYRgwRi9e1oDcGb6b8957pT4Fz1NO/bFW3Pf7Hxv7FXBOS0
   CU61fEj579chu/LRwr1eg5PO/oa3w7O/qeO7yf/vhD4vuBJZiKot00nEY
   Q+j+NVNa1xR9HO6XjyJWbWBJOwFCQOhIO5jqh/Ju07HVRjTWrt3lkhPnC
   OIUxvaK6oO9z2KJbp3HH+Uj9RJWtS5fAmtCDFIME4TTSTGvmbqmAWyfMU
   iMcuDHg4xHliuamtJvaDAG9ZItbzC0l75IWtmM0211n7aH7zeTJasXWp9
   LlISJGXE71HlgYQnji97kvOP9M26JFsfeEwX+pWYPrxcDVQ71I7iojo3W
   g==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="198855965"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 09:13:37 +0800
IronPort-SDR: a7jA7UcAm0Ykou7qg9+0r3JrzgFEH3xavQS/srvj73ettlIblaKcdnUEnzmKy5nF4jcwQj1W+C
 4Q0hAOphkiIM13WmTjQjI13swTrtsEAKh/wiIDinO85GJDXonMxVUX91AwvyUn4XPkj4SyaWB7
 3Wztu8Nhp2ZnTLckDbUffLoLaOjbWvish+apjowCzwmAIB4iX9MdWjv3NcjHlRN81vgPYCIhMZ
 ssF4KSUWByk7w926i+pJpqAVAQfYLSm+NOdgeH/tGtMiYxExFA0ioGiXqVERHTpw7PXOXgjbgb
 HRVy8pxNgAlyACV2Mpmxi/Zw
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 17:44:47 -0700
IronPort-SDR: 5iI7XWBhTAReLLihGQo5gsZeXblA3lTxsPw53RwW7smpuhWIcRgZQXzMeYHr2V/hsmEp8pahBo
 sS1TkxFs5EFAwHwEzsZfHg5veIPBnUBdeiqsns0KgXH4OXCbcn62N36BrI8O10EbPwYDAzwNEN
 M5xphlQjQ2PkJLdmWG/yUHYjolfba1P3HEqPMR0OPQDkeAWcCxR/AEHZOTwyg7fzpg87iDJcRR
 y6SX7HxMyJSUCSUSgta3ZWfoqBhBgvP09/c281eHQN5J17V5cUzbQR3MkgxWG2s7scnfJlgImL
 zOA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 18:13:36 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kfdcv4Ly7z1SVp6
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:13:35 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649985214; x=1652577215; bh=2o3hbZhROctTrf9/YEdToCbep6cUQhIveDu
        ZAWOBAjM=; b=mWJ7/209jF5f6cH7UXv/Nyw7kMvCcMKmosSacEyi84ORPLbeYJQ
        MtUB3jAAFeHPNpA8o+sWbphgyyUNQYB8OZ5diOrgk9B7KoXA2yecdJ4CPlqgi0zL
        X7gNmQToLzBFQR8a23dn9UnxA7nz1U3gm4qx6SZyK+2/dHZc0je0n5KbV/l9B2xH
        gK4Kfaqn7Nwu1VunDYoDJD7KwWLLKzn9IQqxk0vKWAbRtNdVl1uDlsiv/0jNo8cv
        xCYXVwG3tp64CBUPTC1Qyl37g2PHLfG3O0Xz5HzP+cChYa98sC49qe95xjj26W74
        5xSEMLfkgGl/VvMtJsCUkoM/fpFgWzarxOA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IJ-lUag0b5yv for <stable@vger.kernel.org>;
        Thu, 14 Apr 2022 18:13:34 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kfdcr4SBfz1Rvlx;
        Thu, 14 Apr 2022 18:13:32 -0700 (PDT)
Message-ID: <9a9a4dcf-0ea1-01ac-d599-16c10b547beb@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 10:13:31 +0900
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
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YljFiLqPHemB/u77@x1-carbon>
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

On 4/15/22 10:08, Niklas Cassel wrote:
> On Fri, Apr 15, 2022 at 09:56:38AM +0900, Damien Le Moal wrote:
>> On 4/15/22 09:30, Niklas Cassel wrote:
>>> On Fri, Apr 15, 2022 at 08:51:27AM +0900, Damien Le Moal wrote:
>>>> On 4/14/22 18:10, Niklas Cassel wrote:
> 
> (snip)
> 
>> So if we are sure that we can just skip the first 16B/8B for riscv, I
>> would not bother checking the header content. But as mentioned, the
>> current code is fine too.
> 
> That was my point, I'm not sure that we can be sure that we can always
> skip it in the future. E.g. if the elf2flt linker script decides to swap
> the order of .got and .got.plt for some random reason in the future,
> we would skip data that really should have been relocated.

Good point. Your current patch is indeed better then. BUT that would also
mean that the skip header function needs to be called inside the loop
then, no ? If the section orders are reversed, we would still need to skip
that header in the middle of the relocation loop...

> 
> So I think that it is better to keep it, even if it is a bit verbose.
> 
> 
> Kind regards,
> Niklas


-- 
Damien Le Moal
Western Digital Research
