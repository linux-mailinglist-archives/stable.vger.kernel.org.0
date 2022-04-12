Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98E4FE42F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbiDLOy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 10:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiDLOy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 10:54:58 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BE54EA08;
        Tue, 12 Apr 2022 07:52:40 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:42280)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1neHsk-007MRw-6s; Tue, 12 Apr 2022 08:52:38 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:43398 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1neHsi-0098PU-V8; Tue, 12 Apr 2022 08:52:37 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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
References: <20220412100338.437308-1-niklas.cassel@wdc.com>
        <9437ce7f-0553-3688-5695-69add6b2971c@opensource.wdc.com>
        <YlVv2Z5y9qhzu7X9@x1-carbon>
Date:   Tue, 12 Apr 2022 09:52:13 -0500
In-Reply-To: <YlVv2Z5y9qhzu7X9@x1-carbon> (Niklas Cassel's message of "Tue, 12
        Apr 2022 12:26:03 +0000")
Message-ID: <878rsatkv6.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1neHsi-0098PU-V8;;;mid=<878rsatkv6.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Bet/PxatGaqnfgOKcuhb9h08XezFlLak=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Niklas Cassel <Niklas.Cassel@wdc.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 656 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 3.8 (0.6%), b_tie_ro: 2.6 (0.4%), parse: 0.74
        (0.1%), extract_message_metadata: 13 (2.0%), get_uri_detail_list: 3.3
        (0.5%), tests_pri_-1000: 10 (1.6%), tests_pri_-950: 1.00 (0.2%),
        tests_pri_-900: 0.80 (0.1%), tests_pri_-90: 157 (23.9%), check_bayes:
        152 (23.1%), b_tokenize: 11 (1.6%), b_tok_get_all: 14 (2.1%),
        b_comp_prob: 2.4 (0.4%), b_tok_touch_all: 122 (18.6%), b_finish: 0.62
        (0.1%), tests_pri_0: 459 (70.0%), check_dkim_signature: 0.58 (0.1%),
        check_dkim_adsp: 6 (0.8%), poll_dns_idle: 0.03 (0.0%), tests_pri_10:
        1.71 (0.3%), tests_pri_500: 6 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] binfmt_flat: do not stop relocating GOT entries
 prematurely
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Niklas Cassel <Niklas.Cassel@wdc.com> writes:

> On Tue, Apr 12, 2022 at 08:40:27PM +0900, Damien Le Moal wrote:
>> On 4/12/22 19:03, Niklas Cassel wrote:
>> > bFLT binaries are usually created using elf2flt.
>> > 
>> > The linker script used by elf2flt has defined the .data section like the
>> > following for the last 19 years:
>> > 
>> > .data : {
>> > 	_sdata = . ;
>> > 	__data_start = . ;
>> > 	data_start = . ;
>> > 	*(.got.plt)
>> > 	*(.got)
>> > 	FILL(0) ;
>> > 	. = ALIGN(0x20) ;
>> > 	LONG(-1)
>> > 	. = ALIGN(0x20) ;
>> > 	...
>> > }
>> > 
>> > It places the .got.plt input section before the .got input section.
>> > The same is true for the default linker script (ld --verbose) on most
>> > architectures except x86/x86-64.
>> > 
>> > The binfmt_flat loader should relocate all GOT entries until it encounters
>> > a -1 (the LONG(-1) in the linker script).
>> > 
>> > The problem is that the .got.plt input section starts with a GOTPLT header
>> > that has the first word (two u32 entries for 64-bit archs) set to -1.
>> > See e.g. the binutils implementation for architectures [1] [2] [3] [4].
>> > 
>> > This causes the binfmt_flat loader to stop relocating GOT entries
>> > prematurely and thus causes the application to crash when running.
>> > 
>> > Fix this by ignoring -1 in the first two u32 entries in the .data section.
>> > 
>> > A -1 will only be ignored for the first two entries for bFLT binaries with
>> > FLAT_FLAG_GOTPIC set, which is unconditionally set by elf2flt if the
>> > supplied ELF binary had the symbol _GLOBAL_OFFSET_TABLE_ defined, therefore
>> > ELF binaries without a .got input section should remain unaffected.
>> > 
>> > Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defconfig.
>> > 
>> > [1] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-riscv.c;hb=binutils-2_38#l3275
>> > [2] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfxx-tilegx.c;hb=binutils-2_38#l4023
>> > [3] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elf32-tilepro.c;hb=binutils-2_38#l3633
>> > [4] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-loongarch.c;hb=binutils-2_38#l2978
>> > 
>> > Cc: <stable@vger.kernel.org>
>> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>> > ---
>> > RISC-V elf2flt patches are still not merged, they can be found here:
>> > https://github.com/floatious/elf2flt/tree/riscv
>> > 
>> > buildroot branch for k210 nommu (including this patch and elf2flt patches):
>> > https://github.com/floatious/buildroot/tree/k210-v14
>> > 
>> >  fs/binfmt_flat.c | 11 ++++++++++-
>> >  1 file changed, 10 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
>> > index 626898150011..b80009e6392e 100644
>> > --- a/fs/binfmt_flat.c
>> > +++ b/fs/binfmt_flat.c
>> > @@ -793,8 +793,17 @@ static int load_flat_file(struct linux_binprm *bprm,
>> >  			u32 addr, rp_val;
>> >  			if (get_user(rp_val, rp))
>> >  				return -EFAULT;
>> > -			if (rp_val == 0xffffffff)
>> > +			/*
>> > +			 * The first word in the GOTPLT header is -1 on certain
>> > +			 * architechtures. (On 64-bit, that is two u32 entries.)
>> > +			 * Ignore these entries, so that we stop relocating GOT
>> > +			 * entries first when we encounter the -1 after the GOT.
>> > +			 */
>> 
>> 		/*
>> 		 * The first word in the GOTPLT header is -1 on certain
>> 		 * architectures (on 64-bit, that is two u32 entries).
>> 		 * Ignore these entries so that we stop relocating GOT
>> 		 * entries when we encounter the first -1 entry after
>> 		 * the GOTPLT header.
>> 		 */
>
> Sure, I can update the comment when I send a v2.
>
>> 
>> > +			if (rp_val == 0xffffffff) {
>> > +				if (rp - (u32 __user *)datapos < 2)
>> > +					continue;
>> 
>> Would it be safer to check that the following rp_val is also -1 ? Also,
>> does this work with 32-bits arch ? Shouldn't the "< 2" be "< 1" for
>> 32-bits arch ?
>
> I think that checking that the previous entry is also -1 will not work,
> as it will just be a single entry for 32-bit.
> And I don't see the need to complicate this logic by having a 64-bit
> and a 32-bit version of the check.

Handling 64bit in this binfmt_flat appears wrong.  The code is
aggressively 32bit, and in at least some places does not have fields
large enough to handle a 64bit address.  I expect it would take
a significant rewrite to support 64bit.


I think it would be better all-around if instead of applying the
adjustment in the loop, there was a test before the loop.

Something like:

static inline u32 __user *skip_got_header(u32 __user *rp)
{
	if (IS_ENABLED(CONFIG_RISCV)) {
	        /* RISCV has a 2 word GOT PLT header */
		u32 rp_val;
		if (get_user(rp_val, rp) == 0) {
        		if (rp_val == 0xffffffff)
                		rp += 2;
		}
        }
	return rp;
}

....

	if (flags & FLAT_FLAG_GOTPIC) {
		rp = skip_got_header((u32 * __user) datapos);
		for (; ; rp++) {
			u32 addr, rp_val;
			if (get_user(rp_val, rp))
				return -EFAULT;
			if (rp_val == 0xffffffff)
				break;
			if (rp_val) {


Alternately if nothing in the binary uses the header it would probably
be a good idea for elf2flt to simply remove the header.

> The whole GOT (.got.plt + .got) will be more than two words anyway, if
> there is a GOT (i.e. if flag FLAT_FLAG_GOTPIC is set in the bFLT binary),
> so the "end of GOT"/LONG(-1) will always come way after these first two
> entries anyway.
>
> Another reason why I don't fancy a 64-bit and 32-bit version is because
> some architectures might be 64-bit, but I assume that they can be running
> a 32-bit userland. (And in comparison with the ELF header that tells if
> the binary is 32-bit or 64-bit, I don't see something similar in the bFLT
> header.)

Looking at the references you have given the only active architecture
supporting this header is riscv.  So I think it would be good
documentation to have the functionality conditional upon RISCV.

There is the very strange thing I see happening in the code.
Looking at the ordinary relocation code it appears that if
FLAT_FLAG_GOTPIC is set that first the address to relocate
is computed, then the address to relocate is read converted
from big endian to native endian (little endian on riscv?)
adjusted and written back.

Does elf2flt really change all of these values to big-endian on
little-endian platforms?


Eric
