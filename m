Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E774FDDDB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 13:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243515AbiDLLTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 07:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352854AbiDLLSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 07:18:37 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D1D986C4;
        Tue, 12 Apr 2022 03:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649757826; x=1681293826;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3TQDdDKv+/2Nw49GG6zX+ckjKkTqdRxGeiL8NxypWVM=;
  b=MStD1NG59JQ/G5Mrbi1CE72dVJN7GfPecXvOeX2+SQXdxLQozLigK/J4
   Qm1BBfoNnAkKwW8/HENNKfoQvi/ksbAzdotkAgUxxJOZfHD4FNgYKBxnX
   u+rcC/AJI7QPLRwGVnp60m6zuB0BLJQkX+0znhnEisah3/+2ta1NKnekm
   CcETlGqlZq4L6xBq1Fej2dDNzOeT8CfR3daQk0DRXAEdHvjdIHgXS3Rh4
   OKEeTB0ZmnNrQ6HVJj8bj/FncbddMhLWsm/1M9CF5nCT51es9UZBrTKPY
   76bnYF8BcYMklz23an3o/C4a9yIVTBsilko2e0DtXI97q0GeliOSu9Ugq
   w==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643644800"; 
   d="scan'208";a="301896809"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2022 18:03:45 +0800
IronPort-SDR: 9w99oQV5wuUFdBLFZNhBomzZsPL3ey60hFa0eRqcReZx6xjT/jjky2b+ac79sfw+bIjAVUcxrg
 wsOdzu572Ucp10jzz7ygsfEQrNy+OoYg+jByxxiRa0TJm8+ha6ysOEuP5Twv90o//lczimPmLQ
 ik6UMtuL0mxH9tQcwVN1SP+qo0RYTMLq19XHPJrS5ZZVlmHKsSTn1rUWqr0Od9eB2P+fP6qKIm
 8Eikq7YCXIGsG53CK0b9s2tn0Er9MFku/ZVN6cM52lmvBBTsDzvq7urFoOIn6Wm7meQDIO/jtR
 rRXh0vPZhwLXMOMmJBjKW57M
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Apr 2022 02:35:00 -0700
IronPort-SDR: Uo3VSS959+vgVAzuuoPugaw2AGcOb5AzVwNMZ6muqhLfY+2hmyMI0q/omZMZn72OHgau0Abq42
 QGIeU8/fIlPRG2lvaElIUsM2eZLcztSzJc1YsAxPIgjTxRuXXPwFQvY/Du7B3QqTSAk7g2hP2P
 LK5yMeoMrjP6oRySFuvh5X2b3C2WMKjhIZ6syvOTjxoTKXi5Kq7QoUwIbe7HP4cHnHegneiKXe
 Te2G2/RzHFUJoWgoIloujG4dYTCNolMO3oOb4cb5fkgNS5plzVPV6nWoCgIKl6rWHX1AqnMyYx
 Zvg=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.cphwdc) ([10.225.164.111])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Apr 2022 03:03:42 -0700
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
Subject: [PATCH] binfmt_flat: do not stop relocating GOT entries prematurely
Date:   Tue, 12 Apr 2022 12:03:38 +0200
Message-Id: <20220412100338.437308-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
that has the first word (two u32 entries for 64-bit archs) set to -1.
See e.g. the binutils implementation for architectures [1] [2] [3] [4].

This causes the binfmt_flat loader to stop relocating GOT entries
prematurely and thus causes the application to crash when running.

Fix this by ignoring -1 in the first two u32 entries in the .data section.

A -1 will only be ignored for the first two entries for bFLT binaries with
FLAT_FLAG_GOTPIC set, which is unconditionally set by elf2flt if the
supplied ELF binary had the symbol _GLOBAL_OFFSET_TABLE_ defined, therefore
ELF binaries without a .got input section should remain unaffected.

Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defconfig.

[1] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-riscv.c;hb=binutils-2_38#l3275
[2] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfxx-tilegx.c;hb=binutils-2_38#l4023
[3] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elf32-tilepro.c;hb=binutils-2_38#l3633
[4] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-loongarch.c;hb=binutils-2_38#l2978

Cc: <stable@vger.kernel.org>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
RISC-V elf2flt patches are still not merged, they can be found here:
https://github.com/floatious/elf2flt/tree/riscv

buildroot branch for k210 nommu (including this patch and elf2flt patches):
https://github.com/floatious/buildroot/tree/k210-v14

 fs/binfmt_flat.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 626898150011..b80009e6392e 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -793,8 +793,17 @@ static int load_flat_file(struct linux_binprm *bprm,
 			u32 addr, rp_val;
 			if (get_user(rp_val, rp))
 				return -EFAULT;
-			if (rp_val == 0xffffffff)
+			/*
+			 * The first word in the GOTPLT header is -1 on certain
+			 * architechtures. (On 64-bit, that is two u32 entries.)
+			 * Ignore these entries, so that we stop relocating GOT
+			 * entries first when we encounter the -1 after the GOT.
+			 */
+			if (rp_val == 0xffffffff) {
+				if (rp - (u32 __user *)datapos < 2)
+					continue;
 				break;
+			}
 			if (rp_val) {
 				addr = calc_reloc(rp_val, libinfo, id, 0);
 				if (addr == RELOC_FAILED) {
-- 
2.35.1

