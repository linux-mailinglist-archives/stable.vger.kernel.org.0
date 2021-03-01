Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098B6327BA1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhCAKLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:11:00 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46069 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231591AbhCAKK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:10:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EC00D1940D5E;
        Mon,  1 Mar 2021 05:09:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5u+to1
        hNsy3ttDNb/1ng3VIyq+VQTUQygWgZ4oKsHL8=; b=QoucD3C5HyyLF0twPPqGB2
        EJvYcJFa6hRLNolpnBJCsZ97qQEe3dVjhjBx/V3FNVqBdKXxozs7qSLxaSuZCJVz
        lNSqk3ac661WbPpVMmZ+Fd3e4sy85Y7oiU2sL6rqSjtTv6UrQsSTo827tYXvFHJi
        7FMCSGtduhF3HlyBsD1AjliOg9y6gU3MLzizjnqG0jobP+mOqVoJRNA/GlRgeM8u
        QNju438V1UPu/HJMbnDmv7XMz0j53+e0MZz99I3jqy6JD9MT28K4Pn+YD8Tn237O
        bl7tRRqRQmhyjES35UbtzlxXblRJPVCvCuHHtk1vQXmjPhKpz6njj0QYDn+bDoqA
        ==
X-ME-Sender: <xms:bb08YOB9F7yVB5hCEFAaO-yvBVuTtRPGLHCBEdYwhH6zNlmSV1JpBQ>
    <xme:bb08YIj0jcPv2hxCdCQkopdWNmFN8QWCE1PJQtiG9Y6897LMh7u8gqH8GqZOCt3u5
    xfERewzecI4dQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:bb08YBmm4yGDGj5sUHDSqrCzJKbmMUWTS74XApRwTnMbbY8W61v8zQ>
    <xmx:bb08YMyaFwcToqr3FRN--1XxzPb4zOSp61eIag0tc8_05spXOf1xXw>
    <xmx:bb08YDT1cxKYQk3y8i5QMB7xsG5M7e33t6csz-f3mnFNXeINuw50Xw>
    <xmx:bb08YKKzAsIx5mu6O1SVicMjsTl2iRjhuoJYbsuEJOmDFtXt1cwaAQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 262F81080063;
        Mon,  1 Mar 2021 05:09:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] tpm_tis: Fix check_locality for correct locality acquisition" failed to apply to 4.4-stable tree
To:     James.Bottomley@HansenPartnership.com, jarkko@kernel.org,
        jsnitsel@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:09:47 +0100
Message-ID: <161459338711344@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

