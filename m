Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F017157A94
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgBJMhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgBJMhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:10 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3786F2467C;
        Mon, 10 Feb 2020 12:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338230;
        bh=NtsZhrgDJIlTF5zSo7Bs2rx2dneDPsrJqbQN4iPbGGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5PrMtsyp4+U59ro8f2W8MNfpboQ/UgFnewfhGT9E4Ifcr67/+am2Vp46JgWoTNke
         YcuQCWQq+AQyCjx3cXs6J3/n4a0bUxq1iO1rcOmEpNrQCJMEwTis9rA1ystP1Gr3Va
         6QkwgZDqQPFNs8a753XcP59N+YeWX8wwBhspHY7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.4 072/309] MIPS: boot: fix typo in vmlinux.lzma.its target
Date:   Mon, 10 Feb 2020 04:30:28 -0800
Message-Id: <20200210122412.806640101@linuxfoundation.org>
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

commit 16202c09577f3d0c533274c0410b7de05fb0d458 upstream.

Commit 92b34a976348 ("MIPS: boot: add missing targets for vmlinux.*.its")
fixed constant rebuild of *.its files on every make invocation, but due
to typo ("lzmo") it made no sense for vmlinux.lzma.its.

Fixes: 92b34a976348 ("MIPS: boot: add missing targets for vmlinux.*.its")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
[paulburton@kernel.org: s/invokation/invocation/]
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rob Herring <robh@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/boot/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/boot/Makefile
+++ b/arch/mips/boot/Makefile
@@ -123,7 +123,7 @@ $(obj)/vmlinux.its.S: $(addprefix $(srct
 targets += vmlinux.its
 targets += vmlinux.gz.its
 targets += vmlinux.bz2.its
-targets += vmlinux.lzmo.its
+targets += vmlinux.lzma.its
 targets += vmlinux.lzo.its
 
 quiet_cmd_cpp_its_S = ITS     $@


