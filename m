Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FF037F843
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhEMM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:58:13 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51367 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230447AbhEMM6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 08:58:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B2B305C0131;
        Thu, 13 May 2021 08:57:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 13 May 2021 08:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=1bWNkO+xtTgO+
        nBeqiO1bNG/Jcme/8RK9i++sOTt6cs=; b=VUzEvmq3TtL8Ys91DYbAWrSJdDayl
        unGtLnDmZSFviMcI490XEL+lGUzpBZLiP3gjJZsf6j1xjXFPwObErv7dRkkPe0Q9
        y4YvJT/AoAcytQq8fkyRgySlYRZQSez3/GCoX6XUZGSUJ8fbhru/ULpR5NKi//m8
        jJwSf5Kxe5dspO6XzhKHUCO4CDUiP2m08q82wMUIzTGUdfhl41y+aV0l1e1HmrXn
        JTSZKAFA65nmoqzk6WmUHq+sawf2KFXkGPGebqYf3pBtz1c5jdSuH5ZmY4hZDYqL
        BWktOzcIusHcpUJ+SOBWu1NV1ShpLbhzk//SVtKaMXb7XW0BLwffv/3cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=1bWNkO+xtTgO+nBeqiO1bNG/Jcme/8RK9i++sOTt6cs=; b=j+kyhSXt
        SpgjyhFJSJ0FDXhqAOd/1Aw++6hJeouzqeNFzmqTIK7HxqXjN3btx2BmJb84WzgC
        cUlwgj6JQ6z/cIK07csOaX9++TOk+SOv2AI1r2wrcDTaOhqSj1lDtd1vrVpja3Yn
        3IDgm8EwSW7h6jey5sJc1nKBSxbzrNguJJOMpHV6PA6by40WR24WiNZf2UWMGmhy
        FTuppwGaYYSinX/trTg+5tPJDhlqDJYBXea7y8u3Stn7JJBDg+iTDpc17uf6fbXL
        b6G1dzD/CDifsFanroMsmVlsoEhrohY8ktsipKLZsSK04j0Cap7gfbSnyfeXu1w0
        nHZKTxwbqchXog==
X-ME-Sender: <xms:HiKdYDpgi0WkbMlf8-TMYUgQ65VWeH-kzO_4nAGUxl6Fd9_tn0SEjw>
    <xme:HiKdYNowOh6UFNhIoxM0og75Dkki_eAyaEr_fRsq0t08ME64iK0Uyrs9RhizTziD0
    LSeyEgyCVBeIa0e_Vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgr
    shhhihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepveefffefke
    etgfevgeefleehfffhueejtdejveethfekveektdejjedvtdejhfejnecukfhppedugedr
    fedrieehrddujeehnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:HiKdYAMBAzNQujBEN1Q0IW13IyWW_eUg8Q56v7cIqBsPJPvUIc_W6w>
    <xmx:HiKdYG6M1zidkUxj8syyiGcufpzSrIg8ZxLjTJ-eHxFfNLyNX_e0KA>
    <xmx:HiKdYC5jnfGOb0hOyUBXRJ49BcsQwdgC22QbLmJcp313QE5RaFArlQ>
    <xmx:HiKdYIR3Pu2r7kR47Z9F7VPR3ltJp-BvY4i8FJVo3JgpzQ5cWnVEpg>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 13 May 2021 08:57:01 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 3/5] ALSA: firewire-lib: fix check for the size of isochronous packet payload
Date:   Thu, 13 May 2021 21:56:50 +0900
Message-Id: <20210513125652.110249-4-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
References: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The check for size of isochronous packet payload just cares of the size of
IR context payload without the size of CIP header.

Cc: <stable@vger.kernel.org>
Fixes: f11453c7cc01 ("ALSA: firewire-lib: use 16 bytes IR context header to separate CIP header")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-stream.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index 4e2f2bb7879f..b53971bf4b90 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -633,18 +633,24 @@ static int parse_ir_ctx_header(struct amdtp_stream *s, unsigned int cycle,
 			       unsigned int *syt, unsigned int index)
 {
 	const __be32 *cip_header;
+	unsigned int cip_header_size;
 	int err;
 
 	*payload_length = be32_to_cpu(ctx_header[0]) >> ISO_DATA_LENGTH_SHIFT;
-	if (*payload_length > s->ctx_data.tx.ctx_header_size +
-					s->ctx_data.tx.max_ctx_payload_length) {
+
+	if (!(s->flags & CIP_NO_HEADER))
+		cip_header_size = 8;
+	else
+		cip_header_size = 0;
+
+	if (*payload_length > cip_header_size + s->ctx_data.tx.max_ctx_payload_length) {
 		dev_err(&s->unit->device,
 			"Detect jumbo payload: %04x %04x\n",
-			*payload_length, s->ctx_data.tx.max_ctx_payload_length);
+			*payload_length, cip_header_size + s->ctx_data.tx.max_ctx_payload_length);
 		return -EIO;
 	}
 
-	if (!(s->flags & CIP_NO_HEADER)) {
+	if (cip_header_size > 0) {
 		cip_header = ctx_header + 2;
 		err = check_cip_header(s, cip_header, *payload_length,
 				       data_blocks, data_block_counter, syt);
-- 
2.27.0

