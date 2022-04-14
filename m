Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C299501F4F
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 01:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiDNXyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 19:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240890AbiDNXyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 19:54:00 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A337D01C
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649980293; x=1681516293;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WbVM9cfScKKYc/EursZygzoF86dsBLIRg6xwYxy7W0E=;
  b=MQYqIwZwEqUAeX6wd+9VwoTnLk5NuryceTTEfBICQWnVcC90GtXkVzRg
   UGFsTa5J1WXnzZ0zdcj+gzLyoiHRwPFucDArZHQgPkTDbSOcg0VARb1h7
   MZcjwyltmlprKqQArEDhlursKEBmC4MWffSpZT89tZMRrsQBk1seMCxwI
   kC+D7viVTtHcnoMHpF3l95cd7YSy+vBZ2dZUI2otKUJdqXZdEb569eiKc
   iBHq1AoEdslCAW/92v/fJJ1HbDj+KsmtEJIGkh9v0p48XK0QgZZTBq6YE
   vi12bAYyRdGXWF4/nes5+oRW59kPeBttKSzJbiGdUODcTn7RjY0BF61Jv
   g==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="197954185"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 07:51:33 +0800
IronPort-SDR: bFPNb7EuxzAounVaDT+YeR0ilhotgusekzI6ttlhoOSeR+p21kQ5jEkpc0V3rBytQSvcqFNlW3
 4207APDbmY7r8aasBW/lnoXFuvAG+YjVsLhoZqxpeOMfQJC1dBLrmxFVdOevGvjqA0h7jVtlpw
 Ju4g8Jl4cvRAZcC4YtrW/zQSrcn5eOEbCzSZ2FKLWz+sCNMDYo7jFstpzICWg5aXokDE12gvNX
 YhOnlzPtkpLXvN/vXt1KYCgGLUUqBt1eVbWAEvrwnFcletaBK4kYt+rsUHo+dnuiZ4MaP6ggFN
 Z6yelReiAigq3Z9E7xCe0lvN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 16:22:45 -0700
IronPort-SDR: sYkLJN8t6H6GhmWg4QGlFHEZF2Ww17sZBCxoP520+VfCUtvFRfFqqXUvLBleussfsGEU2ae+BE
 EcSGeTCla4ehxM/RMH/tu9G7BrPeUMd+RfWbZVIIj8xZrhFlilvPGo5ijXHXxG8q9HWv0sxIBp
 qntkaByRFRJjIHZiNQCWAgtwlnt+B/txKgLwehLmO4jye/QtVAuaBhR+nlmvQnlxlw6KVzK0wW
 aUKz0LrLxF+4S6n6/+VldOpNhHBrsM3ewdmJhQqS4riiGiCK6WW7QdcmjQQHxJqAnSHq06GmH5
 sto=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 16:51:34 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KfbpD6ktcz1SVp4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:51:32 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649980291; x=1652572292; bh=WbVM9cfScKKYc/EursZygzoF86dsBLIRg6x
        wYxy7W0E=; b=cKEhB42giErCT2IlFVEQa2gh6lHnR8sHxTTUPuQWALBSpaAGvGT
        mGL4PdrltRTNgGcZVQhmNWj+iOhhaj7raUOIsMozPAD3jvXBE4Y7rhE6kYmMW+GU
        SqbqYrYbDcdJwswoJ2O7p/OylgnhOC4xbRfuY15N5vs8YrmxwMdkVq4zffFXHgY0
        I/FAgjKzXKzRjN6jSnwKZA0MrTdAW2KKLPtvrD9a0EBVi3Vt/yPxqUCF4cBm7Xaa
        UPjYAq3mJb+Z7jFuHA0DJkxAcDC3tz3bWT8y1s99lGuVm4JPrILm0NvTCS6AUgRb
        9frurXIYEBUxcziyVQUXnkBzincyCOiaBLQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Fv4KAhj_JWKm for <stable@vger.kernel.org>;
        Thu, 14 Apr 2022 16:51:31 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kfbp91f4qz1Rvlx;
        Thu, 14 Apr 2022 16:51:29 -0700 (PDT)
Message-ID: <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 08:51:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
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
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220414091018.896737-1-niklas.cassel@wdc.com>
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

On 4/14/22 18:10, Niklas Cassel wrote:
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
> (which has size 16 bytes on elf64-riscv and 8 bytes on elf32-riscv), where
> the first word is set to -1. See the binutils implementation for riscv [1].
> 
> This causes the binfmt_flat loader to stop relocating GOT entries
> prematurely and thus causes the application to crash when running.
> 
> Fix this by skipping the whole GOTPLT header, since the whole GOTPLT header
> is reserved for the dynamic linker.
> 
> The GOTPLT header will only be skipped for bFLT binaries with flag
> FLAT_FLAG_GOTPIC set. This flag is unconditionally set by elf2flt if the
> supplied ELF binary has the symbol _GLOBAL_OFFSET_TABLE_ defined.
> ELF binaries without a .got input section should thus remain unaffected.
> 
> Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defconfig.
> 
> [1] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-riscv.c;hb=binutils-2_38#l3275
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
> Changes since v1:
> -Incorporated review comments from Eric Biederman.
> 
> RISC-V elf2flt patches are still not merged, they can be found here:
> https://github.com/floatious/elf2flt/tree/riscv
> 
> buildroot branch for k210 nommu (including this patch and elf2flt patches):
> https://github.com/floatious/buildroot/tree/k210-v14
> 
>  fs/binfmt_flat.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 626898150011..e5e2a03b39c1 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -440,6 +440,30 @@ static void old_reloc(unsigned long rl)
>  
>  /****************************************************************************/
>  
> +static inline u32 __user *skip_got_header(u32 __user *rp)
> +{
> +	if (IS_ENABLED(CONFIG_RISCV)) {
> +		/*
> +		 * RISC-V has a 16 byte GOT PLT header for elf64-riscv
> +		 * and 8 byte GOT PLT header for elf32-riscv.
> +		 * Skip the whole GOT PLT header, since it is reserved
> +		 * for the dynamic linker (ld.so).
> +		 */
> +		u32 rp_val0, rp_val1;
> +
> +		if (get_user(rp_val0, rp))
> +			return rp;
> +		if (get_user(rp_val1, rp + 1))
> +			return rp;
> +
> +		if (rp_val0 == 0xffffffff && rp_val1 == 0xffffffff)
> +			rp += 4;
> +		else if (rp_val0 == 0xffffffff)
> +			rp += 2;

This looks good to me. But thinking more about it, do we really need to
check what the content of the header is ? Why not simply replace this
entire hunk with:

		return rp + sizeof(unsigned long) * 2;

to ignore the 16B (or 8B for 32-bits arch) header regardless of what the
header word values are ? Are there any case where the header is *not*
present ?

> +	}
> +	return rp;
> +}
> +
>  static int load_flat_file(struct linux_binprm *bprm,
>  		struct lib_info *libinfo, int id, unsigned long *extra_stack)
>  {
> @@ -789,7 +813,8 @@ static int load_flat_file(struct linux_binprm *bprm,
>  	 * image.
>  	 */
>  	if (flags & FLAT_FLAG_GOTPIC) {
> -		for (rp = (u32 __user *)datapos; ; rp++) {
> +		rp = skip_got_header((u32 * __user) datapos);
> +		for (; ; rp++) {
>  			u32 addr, rp_val;
>  			if (get_user(rp_val, rp))
>  				return -EFAULT;

Regardless of the above nit, feel free to add:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
