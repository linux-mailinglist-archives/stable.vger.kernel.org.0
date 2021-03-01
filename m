Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407E7327BA0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhCAKKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:10:46 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52551 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231591AbhCAKKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:10:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E73281940B48;
        Mon,  1 Mar 2021 05:09:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:09:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IVlAAG
        WV46iROpGeIojZ0h/d30NMYPzU4Dq63ZaVaRU=; b=OZ1aYxJp4D6s8qxzGGm0no
        9wAp2xyiSFc3C5VeWYt2x0NSHst11zWTwrZOYmFVV/TTJmJJDgiGRAwdTHsz/H5P
        5iX+BJiSHh0qeVHemhM5l/3YNW03z4D7swfl9Mf4NJJdUi5rGpfvS0bJwxeFIuJx
        NL6Sr29Q3CoViXMaxTd+Gx+JyiDDKCWPvECn2Q+vGR2JGAxoBckQJvaMSUChTZHL
        8Lywbcf5uVBSdISsfLxi9xnhtytR6TpUJGnVAuT9eZNPFVE/CNURrx1DVj/DWIs0
        NGZVgFhw8AAHklC24c4+pvaDyT9xBTQ2MouRp7RL3DUGR/tfwGYgDZB6SouqzkDw
        ==
X-ME-Sender: <xms:db08YOg_HTenAQ7wCiA47MMhZq8ezIem2Ce_4hQepcAAek2Ygr_wNg>
    <xme:db08YPDBtCC-z86Pm71grvsnXZJ25vfR9C1phkgAhtjC9q4_g0VsGCsXIUhUgur9U
    KXRJTw6fwrdEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:db08YGGL1DOu3_SAusJxoCi0_46rhTB5XRKF0xrXizTICVDFonCOwA>
    <xmx:db08YHTqB-dX_0ITojfppDlSTxMClhlLN7PumxjkEI-tYKq510a7tA>
    <xmx:db08YLzPNnIJSq2il45IDY-afIrdF7zbC6S3dGMR1haLHCT79SGQgQ>
    <xmx:db08YEpQvrydetYt1xQ9oNjtruTMNmrwWj1LVBC3NultC_t1mp9JTw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60D841080063;
        Mon,  1 Mar 2021 05:09:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] tpm_tis: Fix check_locality for correct locality acquisition" failed to apply to 4.9-stable tree
To:     James.Bottomley@HansenPartnership.com, jarkko@kernel.org,
        jsnitsel@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:09:47 +0100
Message-ID: <1614593387241210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3d9ae54af1d02a7c0edc55c77d7df2b921e58a87 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 1 Oct 2020 11:09:21 -0700
Subject: [PATCH] tpm_tis: Fix check_locality for correct locality acquisition

The TPM TIS specification says the TPM signals the acquisition of locality
when the TMP_ACCESS_REQUEST_USE bit goes to one *and* the
TPM_ACCESS_REQUEST_USE bit goes to zero.  Currently we only check the
former not the latter, so check both.  Adding the check on
TPM_ACCESS_REQUEST_USE should fix the case where the locality is
re-requested before the TPM has released it.  In this case the locality may
get released briefly before it is reacquired, which causes all sorts of
problems. However, with the added check, TPM_ACCESS_REQUEST_USE should
remain 1 until the second request for the locality is granted.

Cc: stable@ger.kernel.org
Fixes: 27084efee0c3 ("[PATCH] tpm: driver for next generation TPM chips")
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 92c51c6cfd1b..f3ecde8df47d 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -125,7 +125,8 @@ static bool check_locality(struct tpm_chip *chip, int l)
 	if (rc < 0)
 		return false;
 
-	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
+	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID
+		       | TPM_ACCESS_REQUEST_USE)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
 		priv->locality = l;
 		return true;

