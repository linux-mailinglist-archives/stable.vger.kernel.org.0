Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4D82E09ED
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 13:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgLVMHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 07:07:44 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60719 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725950AbgLVMHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 07:07:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 85F455C00E2;
        Tue, 22 Dec 2020 07:06:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 22 Dec 2020 07:06:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memlen.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=J55pJLKpTSrZdJxP72RW8Sf3mb
        BFXKgJ49xTyIFg/RI=; b=NOn7Y5oWpmHq5QtJeLFTCHN51zcqBbA0QIIsJ8e/uE
        6vWA/qeXJtPA6hqSrjBCG0pb1GKN77dbBjYJyYSLr2imqzJ+oySmOSzWEq59jBzG
        FfLqR/8sHqrDF1qEqvDsoAcjNbivP66N0i/ZofEuu3oVFfNdUKb/M7Kc9OwXhdQR
        8YekpmCmzsEk+2oXKALANwTocDuFAc3W/jNp4ewGs08n8uVIczQaH75EjolpptYR
        EXM+Nt+F3B65G5k02uWzTE91kCSfgjPslAw1pQjC5VP0UWdmKlhCuTvZ3UjrHj0u
        H0qDWtoBBLrO497vpId2jah29Q6F4lNHlcLWT9p4AqLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=J55pJLKpTSrZdJxP7
        2RW8Sf3mbBFXKgJ49xTyIFg/RI=; b=g4QDW+Pv2lcQ05kAvQpYozCsF+tYTJLA2
        o19ki8T/9cRzmi2c3pL2jhWOe3Y/yMiPJ6NKRras1v5KPhj4BUfVI1rTLhWathEH
        f1xXMFN0qWTEORV/6EH2i1esEFFlo96jaLWveLo3XMDpLLTL/ZTJbAjzHPHzJKxX
        n20xmH/S8A5KXLgIF96YkSbf80N4upBqgHk0XTXS3eQCWFpx+TzLkqLx3Wb6Prby
        0Q8w9YnCSAUOC+7GRfYbWzeglssozclGMVJ+77sLnk5BBOeEVSYr7JJzH8belJyx
        TIh7Pgcnh4j81chP9po4Ol7c2W5RqVcSyQ5iBdetp3CVzBELyMaXA==
X-ME-Sender: <xms:TOHhX7Z1nrkAcPf_gRQuLIsfTUOWtdk7fLzKD2Yw1buqySkMjWjGGw>
    <xme:TOHhX6a-9wVa61KCVmQCvMvAri8yI1qM-nHIbRBlrwYD7dzPCCD87botcn9LDEW-m
    XhBnCQ8R61MvZsud0s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtgedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomheplfgrmhgvshcutfgvhihnohhlughsuceojhhrsehmvghmlhgvnhdr
    tghomheqnecuggftrfgrthhtvghrnheptefhgedutefhuedutdffuedufeettdeujefhud
    fhhedufefhheetfeeuudegveehnecukfhppeekfedrudehuddrvddtiedrvdduvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjrhesmhgvmh
    hlvghnrdgtohhm
X-ME-Proxy: <xmx:TOHhX9-oLcztoEQYtJghycgtsFNJ7GpPKrJtXxjNq3APKQKOKCE6gQ>
    <xmx:TOHhXxqtoEm5tdHcMvRMo3q53YY0yfMMQkNfiKE-GaRkjLl6VNYx-A>
    <xmx:TOHhX2rUKhEcG1XL0uyX1UCh-BWO_Eox8IegvMEgmvLlNbUuBoynng>
    <xmx:TeHhX7CBUo_GZj6pDsMQQpJOa7KfwHZCNBSncDiSZEPpMrXYlfi1lw>
Received: from razorback.. (unknown [83.151.206.212])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4FE67108005C;
        Tue, 22 Dec 2020 07:06:36 -0500 (EST)
From:   James Reynolds <jr@memlen.com>
To:     sean@mess.org
Cc:     linux-media@vger.kernel.org, stable@vger.kernel.org,
        syzbot+ec3b3128c576e109171d@syzkaller.appspotmail.com
Subject: [PATCH] media: mceusb: Fix potential out-of-bounds shift
Date:   Tue, 22 Dec 2020 12:07:04 +0000
Message-Id: <20201222120704.10534-1-jr@memlen.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When processing a MCE_RSP_GETPORTSTATUS command, the bit index to set in
ir->txports_cabled comes from response data, and isn't validated.

As ir->txports_cabled is a u8, nothing should be done if the bit index
is greater than 7.

Cc: stable@vger.kernel.org
Reported-by: syzbot+ec3b3128c576e109171d@syzkaller.appspotmail.com
Signed-off-by: James Reynolds <jr@memlen.com>
---
 drivers/media/rc/mceusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index f1dbd059ed08..c8d63673e131 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1169,7 +1169,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, u8 *buf_in)
 		switch (subcmd) {
 		/* the one and only 5-byte return value command */
 		case MCE_RSP_GETPORTSTATUS:
-			if (buf_in[5] == 0)
+			if (buf_in[5] == 0 && *hi < 8)
 				ir->txports_cabled |= 1 << *hi;
 			break;
 
-- 
2.29.2

