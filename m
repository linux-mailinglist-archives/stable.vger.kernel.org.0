Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C5731BB59
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 15:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBOOp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 09:45:26 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:33627 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhBOOpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 09:45:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9BE45F4A;
        Mon, 15 Feb 2021 09:44:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Feb 2021 09:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xrSpRv
        ZESBxOyXgV5AWDTrCTB+CIp2/gqkJECLxb5k0=; b=NrmMtwXDYGeQJ+p1TPrKtm
        2wV0AaCM4/YcPfVzK21y6g0Or7UmIFtkLZGRv8gcAwRrMWm2HsX3K5VjnNC2FNMY
        ZWrzjHhF0D5AqMnXQvAHVpl/cXPpnLMWdf5kJMrGJ3QKn901LqytNW7TkWvZrYKm
        tHN4oySKhJk21sB66Qt5mkpbObYV3lpl9koIgcqqr7uERFa1Z5oJCliRTgm8iEUc
        pKQnLmbMrEQ8tH0BohT04+xq4V9eZA3p8J8y511IBtoWcIuJ1v0SclKSZ8uAux83
        1o+5hTICcT6JTst9qEH3+SjEjYHcq12kzEnZWe1LC2CasShnT81XThAMXx1P4ZVQ
        ==
X-ME-Sender: <xms:1IgqYBIQ65XXWv_wP7a-wvxSyPFXP2wrA_PAQvLgdjH1KY1_Ie5CbA>
    <xme:1IgqYNIfFLrxu6JID4D6iWz5wtBCjGrNytVQWtTMPR8LIu9Q6w0JOy7mSv2aG27QM
    pD-DRLaG9G9vQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieekgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:1IgqYJuQILhXJeNhCwx-9IqzpHc1QmroqOH5_55XLrnrUIEJAgOXzA>
    <xmx:1IgqYCZAkKUZXjdXg5AfG5p3pZV_xrtDiWgtYU0l-ZpRbarcFgBDLg>
    <xmx:1IgqYIY4WWvSsUCmcB90z2rvRsvQMEbTcaaQUgbSyxXjwiJtVgHOJA>
    <xmx:1YgqYGm2bZjFZNMFoZvyVXQ0TIr4lHRBTuboE_DKSj6cl27tQuCizrpO9ZQabLou>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1988F240057;
        Mon, 15 Feb 2021 09:44:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/mremap: fix BUILD_BUG_ON() error in get_extent" failed to apply to 5.10-stable tree
To:     arnd@arndb.de, 0x7f454c46@gmail.com, akpm@linux-foundation.org,
        bgeffon@google.com, kirill.shutemov@linux.intel.com,
        natechancellor@gmail.com, ndesaulniers@google.com,
        richard.weiyang@linux.alibaba.com, sedat.dilek@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Feb 2021 15:44:34 +0100
Message-ID: <1613400274103207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a30a29091b5a6d4c64b5fc77040720a65e2dd4e6 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 9 Feb 2021 13:42:10 -0800
Subject: [PATCH] mm/mremap: fix BUILD_BUG_ON() error in get_extent

clang can't evaluate this function argument at compile time when the
function is not inlined, which leads to a link time failure:

  ld.lld: error: undefined symbol: __compiletime_assert_414
  >>> referenced by mremap.c
  >>>               mremap.o:(get_extent) in archive mm/built-in.a

Mark the function as __always_inline to avoid it.

Link: https://lkml.kernel.org/r/20201230154104.522605-1-arnd@kernel.org
Fixes: 9ad9718bfa41 ("mm/mremap: calculate extent in one place")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/mremap.c b/mm/mremap.c
index f554320281cc..aa63bfd3cad2 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -336,8 +336,9 @@ enum pgt_entry {
  * valid. Else returns a smaller extent bounded by the end of the source and
  * destination pgt_entry.
  */
-static unsigned long get_extent(enum pgt_entry entry, unsigned long old_addr,
-			unsigned long old_end, unsigned long new_addr)
+static __always_inline unsigned long get_extent(enum pgt_entry entry,
+			unsigned long old_addr, unsigned long old_end,
+			unsigned long new_addr)
 {
 	unsigned long next, extent, mask, size;
 

