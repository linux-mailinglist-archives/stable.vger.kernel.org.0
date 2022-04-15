Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3A1501FDD
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 02:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244109AbiDOA7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 20:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiDOA7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 20:59:11 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6A7B91B5
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 17:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649984206; x=1681520206;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PIIeXs/XKpoxh4Ro8M+e5fsOaqPWnqNURWijGAB3loc=;
  b=nEIZbYjUg1SSCYpZ0884GvmdHJk5nsj+/+ZvUug9L8cR0PFVAzNH6PXM
   vU1d88nVyP+DBUjrSaeuhReTeSfoE7buDomaFILtVuQb+/HIbuTiIOuuZ
   042udPO2zzQfbFgaIrS1Y4qjilBRajnzqdEDr7E+cI+h9xJ3v1pu9o7ft
   68pHEZIe9rdOpVOGKDWQgH/aR42gKmqN6nXZAQOW2H2vTpQrS7TtxeYvn
   l0kO0aVciTkMI+WpZ+aQrDkoZWEyK8/bFGFt573wvMeY9JTm5VHCDU81x
   2UPE/fgsB6FeRgpAP/JK2QV8dLUsZcBLAG5qiRd2oi5cyXjsKKpZrgKjZ
   w==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="198854683"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 08:56:45 +0800
IronPort-SDR: yrJl588LSL1s38dCLEwGah2Qnc8CHc2gTINhmXl1cRA+vIpGVEi3dNg0jaGo9ZA+gOZ7HJyUG5
 ff5xh+EQFDfX6fLBcw2FHTCP9Ji6O1mNpFv/DscmZFbLJ7mzBoBg1ImIu3olxNA5s6txqN/XaI
 iAUMC9PbglXo/LeqdjLkVf9UHF8egamdaH5bLJHsRPqqOSWbEGd4NmoK49lGzvrytFpRz6zwBz
 lRXkbjBu09wClZs8VcWdE3/tVlq6N3U+HiUrJWjmolgEmLyxGpqlFHXDsNEJm6Uxr/7wdchgOW
 18iJtTTdQ7j0CmcZVGfwL3Bu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 17:27:56 -0700
IronPort-SDR: J51FL3etGep7UzrIRHWya/0ca2nqv5G6HQvLJoV4n1zedZrtTwdsLlBrRtTJsKTr5aMnHo2Mgl
 WD5lRCDIwoqpDAXarCmYHVoD6yDujwp9pOxaAeuIRNdRO5TxK7GNp3I310GwSsY90ZAUqi/8k7
 U1yOgw581PtTcqk5WoMQ75EgphWKewCEyF2VkB7N30BAg7LOzNfYqqaSVLDpgP5Y1tZLoII0Py
 2I3PBrAkiJTt1eGyCs4vxBjssd8PQE7bIWzepszhI0GKOiJwOA7AYmQwvJoNRJ0pMBG1rhSpdy
 /Lc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 17:56:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KfdFR2szjz1SVp3
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 17:56:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649984202; x=1652576203; bh=PIIeXs/XKpoxh4Ro8M+e5fsOaqPWnqNURWi
        jGAB3loc=; b=XsjOMN5cgk+Kag0RPwLITFO6mtYll1ywbvEhTEODj6B8KE8+QHB
        o/EsbPvhp4pzGPjsGk7lsKF75i+2DyXnmOimROm+EMZ58U7iaZSbo3XnUFFH3J+8
        h6BOGtc9P8l1OUuht0bbSxMXiEYoqRLMuoVfhSA+8u/Ik4A9zm3wmrg7aCqlKel3
        RYrNwv8AVsAS0YhJz0yyRCvlFT8miCTracpnS7T3xrstVEq0nJKLCq0c7dsruYZc
        yfoUdW0hM1MUnspPBPc/3KOUqP1AEtfKnaifOtCPf56rVbqTfvmtAmle9LXVBFCP
        7uNRRC/d2OnpsPpR7Ts5TJxu/6MlLIsAIQQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id o3E95sl8Etc3 for <stable@vger.kernel.org>;
        Thu, 14 Apr 2022 17:56:42 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KfdFN0s2vz1Rvlx;
        Thu, 14 Apr 2022 17:56:39 -0700 (PDT)
Message-ID: <6ee62ced-7a49-be56-442d-ba012782b8e2@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 09:56:38 +0900
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
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Yli8voX7hw3EZ7E/@x1-carbon>
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

On 4/15/22 09:30, Niklas Cassel wrote:
> On Fri, Apr 15, 2022 at 08:51:27AM +0900, Damien Le Moal wrote:
>> On 4/14/22 18:10, Niklas Cassel wrote:
> 
> (snip)
> 
>> This looks good to me. But thinking more about it, do we really need to
>> check what the content of the header is ? Why not simply replace this
>> entire hunk with:
>>
>> 		return rp + sizeof(unsigned long) * 2;
>>
>> to ignore the 16B (or 8B for 32-bits arch) header regardless of what the
>> header word values are ? Are there any case where the header is *not*
>> present ?
> 
> Considering that I haven't been able to find any real specification that
> describes the bFLT format. (No, the elf2flt source is no specification.)
> This whole format seems kind of fragile.
> 
> I realize that checking the first one or two entries after data start is
> not the most robust thing, but I still prefer it over skipping blindly.
> 
> Especially considering that only m68k seems to support shared libraries
> with bFLT. So even while this header is reserved for ld.so, it will most
> likely only be used on m68k bFLT binaries.. so perhaps elf2flt some day
> decides to strip away this header on all bFLT binaries except for m68k?
> 
> bFLT seems to currently be at version 4, perhaps such a change would
> require a version bump.. Or not? (Now, if there only was a spec.. :P)

The header skip is only for riscv since you have that
"if (IS_ENABLED(CONFIG_RISCV)) {". So whatever you do under that if will
not affect other architectures. The patch will be a nop for them.

So if we are sure that we can just skip the first 16B/8B for riscv, I
would not bother checking the header content. But as mentioned, the
current code is fine too.

Both approaches are fine with me but I prefer the simpler one :)

> 
> 
> Kind regards,
> Niklas
> 
>>
>>> +	}
>>> +	return rp;
>>> +}
>>> +
>>>  static int load_flat_file(struct linux_binprm *bprm,
>>>  		struct lib_info *libinfo, int id, unsigned long *extra_stack)
>>>  {
>>> @@ -789,7 +813,8 @@ static int load_flat_file(struct linux_binprm *bprm,
>>>  	 * image.
>>>  	 */
>>>  	if (flags & FLAT_FLAG_GOTPIC) {
>>> -		for (rp = (u32 __user *)datapos; ; rp++) {
>>> +		rp = skip_got_header((u32 * __user) datapos);
>>> +		for (; ; rp++) {
>>>  			u32 addr, rp_val;
>>>  			if (get_user(rp_val, rp))
>>>  				return -EFAULT;
>>
>> Regardless of the above nit, feel free to add:
>>
>> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>>
>> -- 
>> Damien Le Moal
>> Western Digital Research


-- 
Damien Le Moal
Western Digital Research
