Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937F847E602
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 16:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbhLWPts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 10:49:48 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43471 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349069AbhLWPtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 10:49:39 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 53A635C016A;
        Thu, 23 Dec 2021 10:49:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 23 Dec 2021 10:49:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwcx.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=w+OCQKaR9fThO/RPri2JnBRIRY
        P7/F4zfxZs/8kP+LM=; b=aA4Gn+Ev8JXdGjM2OO8zbFp+cOvg5zyTcCPH0jVvmv
        sxEQRW5polfhKBcvgYgCxTP0tUTOFzt1yw+LPyJClMJncVlA/4t4CHauVwWoLttE
        5florhDViJyT85VBqodg+rGToLM0BWAqqX22yTdofOh92XR1+jDh2CWRBd6gjcWr
        ldKb9Sl/vGFafPZyt8xmuUvRoy7S1ACy8NeJqCFXMiYNGyym+G1ODZrH5LrNsDdx
        uf3w1XU7ff37p1flZaLrldjF1z1s9uUwyBxgV5Nw1JBeZ67aXhZ1g8KY2e2iQOHE
        Kp/OSIoDKBwE3paXfvclG9QmlWByKqS3i8ygO170FjHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=w+OCQKaR9fThO/RPr
        i2JnBRIRYP7/F4zfxZs/8kP+LM=; b=Oznwu/pETiss8/LDfZzxOhLG1Vqv7OBW8
        d8QMTK1npQhGvnD+QaooE8vtG0r2AVBk2WPPo0f559oBIJG0ctpD7cvue1bargsM
        5G4xZqk0fnJR0/+vlqBg3vOcpImJlQqkZsuKcypVYz1vFVkOx9e7jItM87+1XZVB
        A4Jv8fZp3pO14wfzkIMKlgmzwuB5vBUEfHzVEVAS1RkkQOgt+LPiyci3yJNKQG8g
        x5uYRAF1xiOlfFH4Pi+bujjqJQo/IcEHLOBGaIbwx6klivDhn/kkqiJVE+PA/tXJ
        rsamKzJczdGrB+WtZbQMHMYenEMV8+fDZcYYcZGUaFAoGwxLNxz+w==
X-ME-Sender: <xms:kZrEYVrvYOXZav5rc6N506smd8U6KVQG1DNkI3YwMMLKroC86jP7wg>
    <xme:kZrEYXrhPrzvcDGCOl_x-bAqy63qpm3YYpSBhbM3H4ix3XvhpiHMxJeejCsOyR91l
    IKNnWSgPTVdzOgJg6E>
X-ME-Received: <xmr:kZrEYSP1MUUy-tN4A6LjraNpwNStAxEN_4M1iZ3zOsb5qUehSQXLbMSx3e2ScTVjazHuAhRdUe3K-Wq7qYeOLhIR8Vq8Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtkedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpefhvffufffkofgggfestdekredtredttden
    ucfhrhhomheprfgrthhrihgtkhcuhghilhhlihgrmhhsuceophgrthhrihgtkhesshhtfi
    gtgidrgiihiieqnecuggftrfgrthhtvghrnheptdeludegheejteelheduudegkeehleet
    feekiedtfefgleeifeelhefgveejhfffnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepphgrthhrihgtkhesshhtfigtgidrgiihii
X-ME-Proxy: <xmx:kZrEYQ4-qvONOt4j4zKBBtLzgfabc4kNfPaHTxfiBLYFglPBKnasqA>
    <xmx:kZrEYU7EaEgggE1hQR4rjpvrTZV3AMuNs4nT2a9CcFAiWve6p3Gdyw>
    <xmx:kZrEYYhFyBGIJIHFZGLnA7ED7KUAna44LGe6NUF9jMZtslfqQR4B9w>
    <xmx:kprEYRvfsN-O62pZ5ptj-Mj8baYI5hfo2zmWaQXQukh3uZZXQil1FQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Dec 2021 10:49:37 -0500 (EST)
From:   Patrick Williams <patrick@stwcx.xyz>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Hao Wu <hao.wu@rubrik.com>
Cc:     Patrick Williams <patrick@stwcx.xyz>, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tpm: fix NPE on probe for missing device
Date:   Thu, 23 Dec 2021 09:49:31 -0600
Message-Id: <20211223154932.678424-1-patrick@stwcx.xyz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When using the tpm_tis-spi driver on a system missing the physical TPM,
a null pointer exception was observed.

    [    0.938677] Unable to handle kernel NULL pointer dereference at virtual address 00000004
    [    0.939020] pgd = 10c753cb
    [    0.939237] [00000004] *pgd=00000000
    [    0.939808] Internal error: Oops: 5 [#1] SMP ARM
    [    0.940157] CPU: 0 PID: 48 Comm: kworker/u4:1 Not tainted 5.15.10-dd1e40c #1
    [    0.940364] Hardware name: Generic DT based system
    [    0.940601] Workqueue: events_unbound async_run_entry_fn
    [    0.941048] PC is at tpm_tis_remove+0x28/0xb4
    [    0.941196] LR is at tpm_tis_core_init+0x170/0x6ac

This is due to an attempt in 'tpm_tis_remove' to use the drvdata, which
was not initialized in 'tpm_tis_core_init' prior to the first error.

Move the initialization of drvdata earlier so 'tpm_tis_remove' has
access to it.

Signed-off-by: Patrick Williams <patrick@stwcx.xyz>
Fixes: 79ca6f74dae0 ("tpm: fix Atmel TPM crash caused by too frequent queries")
Cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm_tis_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index b2659a4c4016..9813b934e6e4 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -950,6 +950,8 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	priv->timeout_max = TPM_TIMEOUT_USECS_MAX;
 	priv->phy_ops = phy_ops;
 
+	dev_set_drvdata(&chip->dev, priv);
+
 	rc = tpm_tis_read32(priv, TPM_DID_VID(0), &vendor);
 	if (rc < 0)
 		goto out_err;
@@ -962,8 +964,6 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		priv->timeout_max = TIS_TIMEOUT_MAX_ATML;
 	}
 
-	dev_set_drvdata(&chip->dev, priv);
-
 	if (is_bsw()) {
 		priv->ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
 					ILB_REMAP_SIZE);
-- 
2.32.0

