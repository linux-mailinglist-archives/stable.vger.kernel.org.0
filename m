Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D316942C6
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 11:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjBMKZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 05:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjBMKYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 05:24:47 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C90B1BEA;
        Mon, 13 Feb 2023 02:24:46 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AB0423200907;
        Mon, 13 Feb 2023 05:24:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 13 Feb 2023 05:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm3; t=1676283883; x=
        1676370283; bh=mmdn/5U15CkHYElQVUNYUP3/OAbo6/VgMQ5noy+p1YY=; b=n
        gF8Ss4Yx7j/g+jT3RU3b0wX+fLun5/myeAP1lXpi3U3XH64yHySguHKWx2rNz8vd
        8r2mZ4SLxYrzza9uBeS3rG4rfC5v4O51a6RPmdqCDeDZbcxYlWWPjgwD2VQ42xVA
        bA6FEErMHFCDtiwUF4fcBkXdriyA4e4NsxddOBUOfodmMOgx5Pw0O6In42qblxhn
        X5sQw7ZCkaj8Q79LpuN92YlqsKW41Q9S+xyBkgquChwrstQzGyKUu15ENZtQCfEz
        hLQ1ZsEhbPapoQqcLbew7ilFwnvY4/7JiHwm9+czRPH/Y7lB7qLq48gqCuIHzgXa
        baraCFFeoomqVxjYvgrxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1676283883; x=1676370283; bh=mmdn/5U15CkHYElQVUNYUP3/OAbo6/VgMQ5
        noy+p1YY=; b=pI1HMqsoqWTQ3kzcpHXER9OC8xbvKkg0I0zd63tEYNTRNq2sg2l
        wxEh1twhPrhkDwNj7wglVzUD0THcFhPKNAjtzc1NQrXRhBIbJ81qN8zC7nuZsUs0
        l+97XXj8OL+dHMsWqabd7bcc/qTpc+OOywsg351yU13Y8w3g6t3FQmPAKJFxzvXU
        5RGlLCel4gg7HViu1uJFF+7z4tEtgn5AUXIZZ5o4gbRQHxQoQcIcsChOkzw5+Qf1
        vnFZ4MJKOmcD1DT7G/UcojF71ZvxnNa3w2vn6vppv828mvMTnZt3BqSJfF8wZ8AW
        ym8VFPwpepzzeuH+8GMAWHb4QJdrDq66p5w==
X-ME-Sender: <xms:6g_qY4LiHKZ9JlB-LMNld5ZJM9FT0zASlPZIteOnzHBcGFxU6pFJIg>
    <xme:6g_qY4JZm4HGForcooEfYIfjoVd4L32kBZr8NBgOzMKse1suPw_wNabFwcPl0ENhB
    i7E150gjTU5qTw>
X-ME-Received: <xmr:6g_qY4tAyPh9_y-Y18Hi2Awgrch-UUEGSp4ebSWSWHRMRs2XDrrqRzYaHDXBfEC6SuRKpjjmANXRwpBBU2B7HtU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiuddgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepufhimhhonhcu
    ifgrihhsvghruceoshhimhhonhesihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeeiueethfehudfhtdejgeelvdefheduvdejgeekjeet
    fefhgeehiedtgfekleefveenucffohhmrghinhepihhnthgvlhdrtghomhenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsihhmohhnsehinhhv
    ihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:6g_qY1bJRyYXXIqg4Vf36rBtCI5Rdr5HJ9QTuXC3mreK9LhYYByUIg>
    <xmx:6g_qY_bB_zY1eithdShE-qRn3yKBVuc7gfLsykhovB_pSzeRBW4CDw>
    <xmx:6g_qYxA219YTOe8knuLxosGvw4bAKxkLWiBGp5lmhdugmxS1XXtPZA>
    <xmx:6w_qY-nXyH-P3gjJ-5-vRoI2nR2VeTKl1fA8U4JiO7wiXCVneFar1g>
Feedback-ID: idc5945a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Feb 2023 05:24:38 -0500 (EST)
From:   Simon Gaiser <simon@invisiblethingslab.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Gaiser <simon@invisiblethingslab.com>,
        stable@vger.kernel.org
Subject: [PATCH] ata: ahci: Add Tiger Lake UP{3,4} AHCI controller
Date:   Mon, 13 Feb 2023 11:24:49 +0100
Message-Id: <20230213102450.1604-1-simon@invisiblethingslab.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mark the Tiger Lake UP{3,4} AHCI controller as "low_power". This enables
S0ix to work out of the box. Otherwise this isn't working unless the
user manually sets /sys/class/scsi_host/*/link_power_management_policy.

Intel lists a total of 4 SATA controller IDs in [1] for those mobile
PCHs. This commit just adds the "AHCI" variant since I only tested
those.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/631119

Signed-off-by: Simon Gaiser <simon@invisiblethingslab.com>
CC: stable@vger.kernel.org
---

As noted above this doesn't include the other PCI IDs listed by Intel
for those PCHs (RAID modes). Also the same is probably needed for newer
generations. But for both I don't have hardware to test handy right now,
so only included what I have actually tested.

Added stable to CC, since on systems using S0ix this prevents S0ix
residency and therefore leads to such high power consumption that
suspend is effectively broken.

 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 14a1c0d14916..3bb9bb483fe3 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -421,6 +421,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x34d3), board_ahci_low_power }, /* Ice Lake LP AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d3), board_ahci_low_power }, /* Comet Lake PCH-U AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d7), board_ahci_low_power }, /* Comet Lake PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0xa0d3), board_ahci_low_power }, /* Tiger Lake UP{3,4} AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-- 
2.39.1

