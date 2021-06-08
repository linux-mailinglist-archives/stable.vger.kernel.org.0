Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB539F695
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhFHM2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:28:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:53421 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232588AbhFHM2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:28:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 1DF671CFD;
        Tue,  8 Jun 2021 08:26:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 08:26:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RB7VUu
        Aeez7iMT4adpvC6/owvBO6YIhhWu/q4WLItSE=; b=LGgBN3bWpvreG1kf4uemP4
        hqbL1Io7cGNTvpvp5fK+v+jPPhEU1u9nDJ1Pl4mfafmuWLQZ6EsVj76nV6ETu3cD
        0/vH2EEb8hOqSDlMmRcfDdJzFa9Ef+dBrMD4VnO4X6xF8SdKDp5yF0dMDuKIoUTr
        rfUKuWBrBWswWb2T4mY1toacR+6IQD8hlZNOggT6g7/5/T3rGbuSVEMx8Luct5Up
        hsXl01JdbxoUGBCbFamwE9625bFzMmsnaBPcPGz8MF7VabvBYL3Knj6mjP4cx1nd
        5uPEw3W86VQST8VtzPFzwZnNZ/6sz7dhBgLxm/6YEDyokKPNdpDE5bMuyCL4EW1w
        ==
X-ME-Sender: <xms:CGK_YD29ID7iE29PwMa4tWr2TDQwG8yxI1aviK0_Hio2aoTae-sweQ>
    <xme:CGK_YCF9J4CkMyjtvv1Mhm5oqTG_zR5xYfEd2O6cWu9CKOMwDeX93CUMIqFXEBBnW
    e76vHqHIBLaSg>
X-ME-Received: <xmr:CGK_YD5FCPslGCueyYJuUoMefuW1wVyVAdKR39Qc-jUYbLfDInV7gpmohIkoCRNcx9nrwH1ZRpGjjX53o_RIuAN7NTD8cKq5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:CGK_YI2bxi7ZmpPkrX6LqknbvKW_OvX3pPAdyDu5bkfUEzHXVUyKlg>
    <xmx:CGK_YGGtkEJA7426Pd0AjT4VAZMu5v106P6CU4LmgkeSUIHK0wA91g>
    <xmx:CGK_YJ-Usccp5sdUTlR1mwMTzUn0MAKmsfxgGMhMwMqwJYroz_gBAA>
    <xmx:CGK_YIOr7ovfafrgU15WzQRFCNMIW3qH5mUF1-pDI_qWU1i-Ea0-15yvjb0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:26:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix memory leak in ext4_mb_init_backend on error path." failed to apply to 4.19-stable tree
To:     phil@philpotter.co.uk, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:26:32 +0200
Message-ID: <1623155192137127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8867f4e3809050571c98de7a2d465aff5e4daf5 Mon Sep 17 00:00:00 2001
From: Phillip Potter <phil@philpotter.co.uk>
Date: Mon, 12 Apr 2021 08:38:37 +0100
Subject: [PATCH] ext4: fix memory leak in ext4_mb_init_backend on error path.

Fix a memory leak discovered by syzbot when a file system is corrupted
with an illegally large s_log_groups_per_flex.

Reported-by: syzbot+aa12d6106ea4ca1b6aae@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20210412073837.1686-1-phil@philpotter.co.uk
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3239e6669e84..c2c22c2baac0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3217,7 +3217,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		 */
 		if (sbi->s_es->s_log_groups_per_flex >= 32) {
 			ext4_msg(sb, KERN_ERR, "too many log groups per flexible block group");
-			goto err_freesgi;
+			goto err_freebuddy;
 		}
 		sbi->s_mb_prefetch = min_t(uint, 1 << sbi->s_es->s_log_groups_per_flex,
 			BLK_MAX_SEGMENT_SIZE >> (sb->s_blocksize_bits - 9));

