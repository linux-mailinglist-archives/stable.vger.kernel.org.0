Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29F3157A9B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgBJNX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgBJMhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:09 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C1942467A;
        Mon, 10 Feb 2020 12:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338229;
        bh=vvmGs6nVmzOQFlgd10Nl4XppRHWf2yjrDu/yBIVkwIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO3ETb0FTNatyw1j6z9xUp65aGjTOakubq6+IaIU5sKM0dNSmfIOm0J4NR/BEuH7f
         QOOb+PXNqQ/LViEmXD64A/jhTeDtpex3mLqYn9bEntxVtnxnLx9SommVOAqieqCZwH
         nSnDuAHYwptDJMHA64tO4vLqFXqp3IBqpPfNUsGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.4 070/309] MIPS: syscalls: fix indentation of the SYSNR message
Date:   Mon, 10 Feb 2020 04:30:26 -0800
Message-Id: <20200210122412.629619982@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

commit 4f29ad200f7b40fbcf73cd65f95087535ba78380 upstream.

It also lacks a whitespace (copy'n'paste error?) and also messes up the
output:

  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n32.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n64.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_o32.h
  SYSNR  arch/mips/include/generated/uapi/asm/unistd_nr_n32.h
  SYSNR  arch/mips/include/generated/uapi/asm/unistd_nr_n64.h
  SYSNR  arch/mips/include/generated/uapi/asm/unistd_nr_o32.h
  WRAP    arch/mips/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/mips/include/generated/uapi/asm/ipcbuf.h

After:

  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n32.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n64.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_o32.h
  SYSNR   arch/mips/include/generated/uapi/asm/unistd_nr_n32.h
  SYSNR   arch/mips/include/generated/uapi/asm/unistd_nr_n64.h
  SYSNR   arch/mips/include/generated/uapi/asm/unistd_nr_o32.h
  WRAP    arch/mips/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/mips/include/generated/uapi/asm/ipcbuf.h

Present since day 0 of syscall table generation introduction for MIPS.

Fixes: 9bcbf97c6293 ("mips: add system call table generation support")
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rob Herring <robh@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/syscalls/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/syscalls/Makefile
+++ b/arch/mips/kernel/syscalls/Makefile
@@ -18,7 +18,7 @@ quiet_cmd_syshdr = SYSHDR  $@
 		   '$(syshdr_pfx_$(basetarget))'		\
 		   '$(syshdr_offset_$(basetarget))'
 
-quiet_cmd_sysnr = SYSNR  $@
+quiet_cmd_sysnr = SYSNR   $@
       cmd_sysnr = $(CONFIG_SHELL) '$(sysnr)' '$<' '$@'		\
 		  '$(sysnr_abis_$(basetarget))'			\
 		  '$(sysnr_pfx_$(basetarget))'			\


