Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A03500962
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240225AbiDNJNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241659AbiDNJM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:12:56 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF503EF21;
        Thu, 14 Apr 2022 02:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649927432; x=1681463432;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n/RjFhCoHmyvQPqkferP8/GTynI8Zg21tVioUs2fo6s=;
  b=RWRVtxV2m/YOPMWqA/MR6Ch2kxP7Hn5fzO+pAxMNiYsiEeQPuFOOVuW2
   ez++bOCGhnYS7cJd6dToJEDMgnvdaMxANS3tnqJ8QOxkRHbYQ1pKqdcZr
   +pqHl7jXwvgnI7gQgTOipgF2pYxG85Tvbvltag/XrN6xuUI738rJ4I79T
   ldiPhZ+Xz/7jrrXyCJHRZTn18SgP3o+lX9nwYOd5cdXYYT22FLwJpcGwB
   o+7rcngYB7rPdQk2zpRP3fwAcrXMazWeZqYdwPJ1xqYJTGOdW9iTOReHj
   5IyXe1xSlg3E4UK6jNEr3WOdsnNtvdCRpRnCb9R/a+gc5vjk/na0r09qQ
   w==;
X-IronPort-AV: E=Sophos;i="5.90,259,1643644800"; 
   d="scan'208";a="198796636"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2022 17:10:31 +0800
IronPort-SDR: ZzRhVVeRL85+OC0WgV77LMb44ISirh0/Zojd2vST8u369i+UDGTh8SJS0cEyee3X4Go3YOOWNB
 xvMiCtY2lnlTlP9K3DmizMllkhDFMGBG8AuoJBPPih6UePUY9NKOyUYL0c/0gbFO+R/LNrYYTP
 T47hCEE4xilttjTgDdJZQ+ejmwwHdc0tevGT4BgRjiykjhbtMSRFsO4SLsqBnz7jJ3o2dSHKI8
 DuraMRR5ia9A7PcHkM6Ao+c2AgGe7GR7Z03p+ZoDqRYx62mjlZyYVAGmfukNFSBV7rQ5ynOFrw
 +nwBmhbNIRQ2h3JnugECy09k
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 01:40:52 -0700
IronPort-SDR: eECsn3y6XfvMEdB/CiQdQvSLz7JwPK0CMSCKeVLXCutpO/SyK1L6/AerYOS6fivGy+KWqq95WU
 KZbFYZgCW5kS7TYj5djeu2HI6ksPym8IbS8jLa9NQgjmPv9e38kpV1p2hXGKfrhpYHwUnZUmOb
 zRkNgzVAZDugj7lxxDR5RYZ3rJiuiBHVwnn0aS23M5CZbrJUeexv3kOpuX8Ucy+4FH3oLGZ0Ow
 Ctrb/JSBPZKJQNaQvbmnWzhGa2K0Zbfwm+K3S1Az/YVRNg3tciL2jDOMDG9mwyZrA+1qRhhUTO
 5/E=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.18])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Apr 2022 02:10:23 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH v2] binfmt_flat: do not stop relocating GOT entries prematurely on riscv
Date:   Thu, 14 Apr 2022 11:10:18 +0200
Message-Id: <20220414091018.896737-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bFLT binaries are usually created using elf2flt.

The linker script used by elf2flt has defined the .data section like the
following for the last 19 years:

.data : {
	_sdata = . ;
	__data_start = . ;
	data_start = . ;
	*(.got.plt)
	*(.got)
	FILL(0) ;
	. = ALIGN(0x20) ;
	LONG(-1)
	. = ALIGN(0x20) ;
	...
}

It places the .got.plt input section before the .got input section.
The same is true for the default linker script (ld --verbose) on most
architectures except x86/x86-64.

The binfmt_flat loader should relocate all GOT entries until it encounters
a -1 (the LONG(-1) in the linker script).

The problem is that the .got.plt input section starts with a GOTPLT header
(which has size 16 bytes on elf64-riscv and 8 bytes on elf32-riscv), where
the first word is set to -1. See the binutils implementation for riscv [1].

This causes the binfmt_flat loader to stop relocating GOT entries
prematurely and thus causes the application to crash when running.

Fix this by skipping the whole GOTPLT header, since the whole GOTPLT header
is reserved for the dynamic linker.

The GOTPLT header will only be skipped for bFLT binaries with flag
FLAT_FLAG_GOTPIC set. This flag is unconditionally set by elf2flt if the
supplied ELF binary has the symbol _GLOBAL_OFFSET_TABLE_ defined.
ELF binaries without a .got input section should thus remain unaffected.

Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defconfig.

[1] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-riscv.c;hb=binutils-2_38#l3275

Cc: <stable@vger.kernel.org>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
Changes since v1:
-Incorporated review comments from Eric Biederman.

RISC-V elf2flt patches are still not merged, they can be found here:
https://github.com/floatious/elf2flt/tree/riscv

buildroot branch for k210 nommu (including this patch and elf2flt patches):
https://github.com/floatious/buildroot/tree/k210-v14

 fs/binfmt_flat.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 626898150011..e5e2a03b39c1 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -440,6 +440,30 @@ static void old_reloc(unsigned long rl)
 
 /****************************************************************************/
 
+static inline u32 __user *skip_got_header(u32 __user *rp)
+{
+	if (IS_ENABLED(CONFIG_RISCV)) {
+		/*
+		 * RISC-V has a 16 byte GOT PLT header for elf64-riscv
+		 * and 8 byte GOT PLT header for elf32-riscv.
+		 * Skip the whole GOT PLT header, since it is reserved
+		 * for the dynamic linker (ld.so).
+		 */
+		u32 rp_val0, rp_val1;
+
+		if (get_user(rp_val0, rp))
+			return rp;
+		if (get_user(rp_val1, rp + 1))
+			return rp;
+
+		if (rp_val0 == 0xffffffff && rp_val1 == 0xffffffff)
+			rp += 4;
+		else if (rp_val0 == 0xffffffff)
+			rp += 2;
+	}
+	return rp;
+}
+
 static int load_flat_file(struct linux_binprm *bprm,
 		struct lib_info *libinfo, int id, unsigned long *extra_stack)
 {
@@ -789,7 +813,8 @@ static int load_flat_file(struct linux_binprm *bprm,
 	 * image.
 	 */
 	if (flags & FLAT_FLAG_GOTPIC) {
-		for (rp = (u32 __user *)datapos; ; rp++) {
+		rp = skip_got_header((u32 * __user) datapos);
+		for (; ; rp++) {
 			u32 addr, rp_val;
 			if (get_user(rp_val, rp))
 				return -EFAULT;
-- 
2.35.1

