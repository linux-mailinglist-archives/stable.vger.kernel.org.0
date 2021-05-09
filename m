Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433533776D2
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 15:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEINsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 09:48:08 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:54959 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhEINsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 09:48:07 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 102671940CAF;
        Sun,  9 May 2021 09:47:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 09 May 2021 09:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jNlpfU
        1B+U3uwN0Q58qFnsHeILxTqFqsiPiF0lzRKao=; b=StTzMb6x+4TPE9ELD1NIif
        hjd7LoJ9WiO2uGh/AZ8/409S3iXGy3kfOEEag5TxkVIEPIbI7xwsJFi1fJDeSB8c
        ClLTW/UAcgEoFe1DxGJnhIOvW8wScu2YcNimsplo5+vQgkszMEz17u4Q3GZVHbKW
        w7hlumn4mwbqGSjBnZOImJxGj2p4SNXvmbsi9zz//q6i6/vnlm5Ciaio2/8PbSRV
        LllQo0TmI5ESq6A23MP9HLoTlN4gjbjLk69JHGHvlisS/Wt2+Z7OAnrB8e+sLbBn
        Zms/S9hpVusVspdjPQ4jF72g28dhL9mbFzruGO+fDxiL9ujYk/ynQzyDaQIlepzg
        ==
X-ME-Sender: <xms:1-eXYJ7k3kVF2IetvBXFH7_i6P488nv3Y6xQxOqkO2o4aJN3qqQhsQ>
    <xme:1-eXYG5n6w7_4ovof5nhpE3sVb84MDtA_kamnuaBAHJgOQOj0y9nOPrnR7iYRTavS
    msa5NHENadXLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:1-eXYAc28I1J8eBFyAUsK5iXnTH4uBJXrfbDN1bcOGQQDGJBGAL46A>
    <xmx:1-eXYCK3KGWqpSl1CT9WbHykZlvuHtP1SOLagsZY3ZAbBYlRwJDI5w>
    <xmx:1-eXYNJJejLp68UYrLpwGGxUhIKu1MEHNu8gu_qvl5rhPqAM92SaWg>
    <xmx:2OeXYPxs1c2byleNcHbGuUjJ1uuaMsFaxhM3FohLcvRFof-nzOX-Rg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 09:47:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm: vtpm_proxy: Avoid reading host log when using a virtual" failed to apply to 4.9-stable tree
To:     stefanb@linux.ibm.com, jarkko@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 15:47:01 +0200
Message-ID: <162056802186171@kroah.com>
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

From 9716ac65efc8f780549b03bddf41e60c445d4709 Mon Sep 17 00:00:00 2001
From: Stefan Berger <stefanb@linux.ibm.com>
Date: Wed, 10 Mar 2021 17:19:16 -0500
Subject: [PATCH] tpm: vtpm_proxy: Avoid reading host log when using a virtual
 device

Avoid allocating memory and reading the host log when a virtual device
is used since this log is of no use to that driver. A virtual
device can be identified through the flag TPM_CHIP_FLAG_VIRTUAL, which
is only set for the tpm_vtpm_proxy driver.

Cc: stable@vger.kernel.org
Fixes: 6f99612e2500 ("tpm: Proxy driver for supporting multiple emulated TPMs")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

diff --git a/drivers/char/tpm/eventlog/common.c b/drivers/char/tpm/eventlog/common.c
index 7460f230bae4..8512ec76d526 100644
--- a/drivers/char/tpm/eventlog/common.c
+++ b/drivers/char/tpm/eventlog/common.c
@@ -107,6 +107,9 @@ void tpm_bios_log_setup(struct tpm_chip *chip)
 	int log_version;
 	int rc = 0;
 
+	if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
+		return;
+
 	rc = tpm_read_log(chip);
 	if (rc < 0)
 		return;

