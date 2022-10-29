Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A166A612544
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 22:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJ2Uf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 16:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ2Uf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 16:35:57 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C537A326D5;
        Sat, 29 Oct 2022 13:35:56 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id E87A03200406;
        Sat, 29 Oct 2022 16:35:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 29 Oct 2022 16:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1667075753; x=1667162153; bh=bX5Gx15qqiX077Af+ndRf/Ggw
        c6zZu6GTKM8qZRCjzQ=; b=ZtxPIVMDQvMOwWuhpYTtzgQfAUSRBD/2oE+FvGpNQ
        Jxo7BP4Lph8nT9q119tV4GKq3XuOh8e43PjTtw+58oov5NnN4t75xmi9JNRFtsoM
        snAG5EBdPAfg5h5wPaziYCs2a2VUhaypJ/i1HjylX1oJCONf1zvyadGMjD1iCn36
        k03NE17mnXfaBJ5Rlmm24og33g36yYQbEO0s9lk+L4EPIKzP3edwDMQnPOwuTQOD
        nRSwr+8CtwMrxoZVtQ6L0t3NHHfjIdAo7Nxdzvcqlc44k9AymwmvhJT/9PlFZdgf
        trn4mgApIEOh6+Zlw1LXR/pzUS4rYBTgShB3YQDJuhGdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1667075753; x=1667162153; bh=bX5Gx15qqiX077Af+ndRf/Ggwc6zZu6GTKM
        8qZRCjzQ=; b=UmzD5dMBS6tuFFipZte6h+miioNDFbgsLCZl+Wstr1uLN/SCkgN
        HNkYV/Bka0LXbxZq6e0gJNHHOqnhDVROiCh/5eLOkzLbKDjkvVSQrKQBOBwMPfE6
        DVGvRxRdUo5nt10oKM1g62FE8xGBTVyPm8xbKNXAZ4gn9Y3qRC3+83/BCH5UaI8P
        m8sPpUdEJL9uYmomZrCDE4+lXrqwkOXGAgsFQG5as2kT1ijDYzwak6KbOhTLaSA4
        gSV0dlOq4re7g3XtkXKo74SDCGQtWW1WAQXDS34xj3PKqnMHSUum5LL+KHk1k4Hz
        LYKBH19XVb6Kl1Pi5Gw4T1iib3DxoICHKpA==
X-ME-Sender: <xms:qY5dY79VEzQSBVbl37Jwg5bQqzlu27xzSji6qOlbL8fOqEYdufMUjQ>
    <xme:qY5dY3s4T4FshkSn6haF8ByrATWOKdLqz1kA828cpjNonRJN4oLbrpbEM3vSfnKB6
    LO1_ZMleL1dkS5ibh8>
X-ME-Received: <xmr:qY5dY5DmPe5n6GKDEBKYjXSCKZMjasHvnOHqo5x4YWGwljmmfA-RvZnwow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdekgdduhedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghes
    fhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhephfetuddtudevieeljeejte
    ffheeujeduhefgffejudfhueelleduffefgfffveeknecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgoh
    grthdrtghomh
X-ME-Proxy: <xmx:qY5dY3f3I79vD7X-kH7Oa9QzYI6QHYrHo8XacULpZgdQc9qYNYToCA>
    <xmx:qY5dYwMMnUJCgNWPzvKLf6IDt86eQtYQqUUP6vZjMera8WD9TAzPzQ>
    <xmx:qY5dY5lrU6Nqx86fJDLB80lDgAo0yb9dXeuGeQPEg9CALKwpgVK6KQ>
    <xmx:qY5dY_1-kvJZuXKA_HANyGmjwZL3T4ubeIHUouHB48KqNonph1bFuQ>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 29 Oct 2022 16:35:51 -0400 (EDT)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, tsbogend@alpha.franken.de,
        ardb@kernel.org, rostedt@goodmis.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: [PATCH] MIPS: jump_label: Fix compat branch range check
Date:   Sat, 29 Oct 2022 21:35:35 +0100
Message-Id: <20221029203535.940231-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cast upper bound of branch range to long to do signed compare,
avoid negtive offset trigger this warning.

Fixes: 9b6584e35f40 ("MIPS: jump_label: Use compact branches for >= r6")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org
---
 arch/mips/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 71a882c8c6eb..f7978d50a2ba 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -56,7 +56,7 @@ void arch_jump_label_transform(struct jump_entry *e,
 			 * The branch offset must fit in the instruction's 26
 			 * bit field.
 			 */
-			WARN_ON((offset >= BIT(25)) ||
+			WARN_ON((offset >= (long)BIT(25)) ||
 				(offset < -(long)BIT(25)));
 
 			insn.j_format.opcode = bc6_op;
-- 
2.34.1

