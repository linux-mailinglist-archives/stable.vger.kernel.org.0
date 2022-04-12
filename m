Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8884FE001
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352957AbiDLMad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354306AbiDLM22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:28:28 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992A83CFC1
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 04:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649763635; x=1681299635;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CEPm7umbMupxMebiwkuP+fJcBJ3QXrLrjof4l//fGl0=;
  b=FMdQycSxtdsHMrVM5Cu5rq/lQmYXdzumeZleO3GEjYF4gWTvYndBGsXv
   LsL/xsdz0hDpHIMqnuXiqIMqgVOrqihM3Ca/cUp/TSEJbpdZeK4v4UK1C
   78Dka2J3p5rUldC8OFvbrbAWSgRgP4YoRszmUGNroy0OXqw5zudmU8lN2
   SdNGND8fGNOdJSQ3jxUUt3lS+1F0W6jN3lEKAQqnPh0LIKrf3K15PE5N1
   hZlpcGorGYsRxk6uhNciirYkwXKAqNMj4Vh2OuhX1pGMU8sU2OkWHVJzv
   Zg4oGp64yPELna5uH6n2eLjdGjoIpxBRrfXsgPbr6uTUxqxFA/R4kRUeQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643644800"; 
   d="scan'208";a="196589482"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2022 19:40:33 +0800
IronPort-SDR: BhsyOYhEyPfvjpMO4tLTIdEXvWxUTcqYoeL9QOuvMehMO07Ac+/Fj1T+fk8Yg9aH/Dm1Z0mLoL
 wK2ZgeDJiLVT7mqsuiC0QmLSeJxhETrRhozjq2q79bn/upwdQYY2lJUmWjjiqLpY+vUKL9zPBu
 7cnB+6dTZCI0+GauXpFJT8r0xJibf4gK0j7ULsd7uLWFqw1faIs+CEWc8vp0ssDsqHt8t1g2QU
 QLkF33VyX6mSYrdSaUkX+Jch16AKGjYrBGC4pIyyqKtO4qRo26hbWAW52LD7YCHfuuEN7FGM5G
 uqxZZsaFq7NpeEtxXcj6qGPV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Apr 2022 04:11:02 -0700
IronPort-SDR: Nt+3OYD7lwuLSq1zPj56pZz5qdHk900mwOr5o6717qj9c8Hlv2MXXWs4ffHg5vWCix5eg9MZkL
 9WaHN06G/Jw1mWWbwak0Zp67E51hgb4uVDPqNY6r3qZMf7yDZQ3MAQVWjVCuPuWZTnxyvMjbuT
 HhNS/TFrhuL2mIq+DfAXFPTUjLra7wWLDUiYP/JPax7XHFIFBh2VlJfQeh94llpdtawO4Zo/fz
 aNIRN/SDLC5bRGa6gQU5DKeoYYpAsHl6r5/Ty//h8RnNGtm7zBGRdJe5hhVVAC2PRUqQsCfefj
 vYg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Apr 2022 04:40:33 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kd3gj1g7Qz1SHwl
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 04:40:33 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649763632; x=1652355633; bh=CEPm7umbMupxMebiwkuP+fJcBJ3QXrLrjof
        4l//fGl0=; b=fbTJuKJ2G6ifUiTVRB0Gqz01yuz/MaUDxVzmOeh081w3SYPXoCw
        4p6fCoi10IHVoQWk+tK6s7h3A/KKrQAVewEMxbbMQmjllSZMhJQMhOZgF8ioacUz
        hDugNqCVwqLFeppGyNL5w4Mv9DJmkkES/iZULgu6noSnuccDNQr1f1YWHVzg8GaX
        VbPILCPUaH8fO5Nze8eHanRDgjpxr4zwN8piLgdjr3vQ/E2cmHOyoJj6FcXBkTYz
        XOt2Gx+DZKkEWFgpkOQixoIyiZM6IyD4mH243seXfD7ROL13IMTenV2V/0wuHzbw
        f04CG5NxXqGRs4ckFqgasa5kGKgFRNQNshQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ssbpdxrNMxHL for <stable@vger.kernel.org>;
        Tue, 12 Apr 2022 04:40:32 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kd3gd37GCz1Rvlx;
        Tue, 12 Apr 2022 04:40:29 -0700 (PDT)
Message-ID: <9437ce7f-0553-3688-5695-69add6b2971c@opensource.wdc.com>
Date:   Tue, 12 Apr 2022 20:40:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] binfmt_flat: do not stop relocating GOT entries
 prematurely
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org
References: <20220412100338.437308-1-niklas.cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220412100338.437308-1-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/22 19:03, Niklas Cassel wrote:
> bFLT binaries are usually created using elf2flt.
> 
> The linker script used by elf2flt has defined the .data section like the
> following for the last 19 years:
> 
> .data : {
> 	_sdata = . ;
> 	__data_start = . ;
> 	data_start = . ;
> 	*(.got.plt)
> 	*(.got)
> 	FILL(0) ;
> 	. = ALIGN(0x20) ;
> 	LONG(-1)
> 	. = ALIGN(0x20) ;
> 	...
> }
> 
> It places the .got.plt input section before the .got input section.
> The same is true for the default linker script (ld --verbose) on most
> architectures except x86/x86-64.
> 
> The binfmt_flat loader should relocate all GOT entries until it encounters
> a -1 (the LONG(-1) in the linker script).
> 
> The problem is that the .got.plt input section starts with a GOTPLT header
> that has the first word (two u32 entries for 64-bit archs) set to -1.
> See e.g. the binutils implementation for architectures [1] [2] [3] [4].
> 
> This causes the binfmt_flat loader to stop relocating GOT entries
> prematurely and thus causes the application to crash when running.
> 
> Fix this by ignoring -1 in the first two u32 entries in the .data section.
> 
> A -1 will only be ignored for the first two entries for bFLT binaries with
> FLAT_FLAG_GOTPIC set, which is unconditionally set by elf2flt if the
> supplied ELF binary had the symbol _GLOBAL_OFFSET_TABLE_ defined, therefore
> ELF binaries without a .got input section should remain unaffected.
> 
> Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defconfig.
> 
> [1] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-riscv.c;hb=binutils-2_38#l3275
> [2] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfxx-tilegx.c;hb=binutils-2_38#l4023
> [3] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elf32-tilepro.c;hb=binutils-2_38#l3633
> [4] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-loongarch.c;hb=binutils-2_38#l2978
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
> RISC-V elf2flt patches are still not merged, they can be found here:
> https://github.com/floatious/elf2flt/tree/riscv
> 
> buildroot branch for k210 nommu (including this patch and elf2flt patches):
> https://github.com/floatious/buildroot/tree/k210-v14
> 
>  fs/binfmt_flat.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 626898150011..b80009e6392e 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -793,8 +793,17 @@ static int load_flat_file(struct linux_binprm *bprm,
>  			u32 addr, rp_val;
>  			if (get_user(rp_val, rp))
>  				return -EFAULT;
> -			if (rp_val == 0xffffffff)
> +			/*
> +			 * The first word in the GOTPLT header is -1 on certain
> +			 * architechtures. (On 64-bit, that is two u32 entries.)
> +			 * Ignore these entries, so that we stop relocating GOT
> +			 * entries first when we encounter the -1 after the GOT.
> +			 */

		/*
		 * The first word in the GOTPLT header is -1 on certain
		 * architectures (on 64-bit, that is two u32 entries).
		 * Ignore these entries so that we stop relocating GOT
		 * entries when we encounter the first -1 entry after
		 * the GOTPLT header.
		 */

> +			if (rp_val == 0xffffffff) {
> +				if (rp - (u32 __user *)datapos < 2)
> +					continue;

Would it be safer to check that the following rp_val is also -1 ? Also,
does this work with 32-bits arch ? Shouldn't the "< 2" be "< 1" for
32-bits arch ?

>  				break;
> +			}
>  			if (rp_val) {
>  				addr = calc_reloc(rp_val, libinfo, id, 0);
>  				if (addr == RELOC_FAILED) {


-- 
Damien Le Moal
Western Digital Research
