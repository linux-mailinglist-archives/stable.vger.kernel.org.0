Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4087065AAFC
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 19:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjAASdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 13:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjAASdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 13:33:23 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5E726E4;
        Sun,  1 Jan 2023 10:33:21 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AD1FB320039A;
        Sun,  1 Jan 2023 13:33:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 01 Jan 2023 13:33:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1672598000; x=1672684400; bh=Bc
        rNw+w4SNGHCE4lx9Q7z+Zcv9oKolCWuuHkfZmCA7w=; b=vIIeS466ptQuOHMydg
        7+zt+zhwPQTGDtQHXGc9usTB8nIXqFaguDCPX543aOJlLFFcEBO2CM9wx6o07mVF
        FuIrsiVecs9RegpKtHGCz6zEaCVQGDr7PbI6OuMVpq78iJ+5VoByKApOnVIANXbV
        arNpT1xxF1+WOOMwGKTAXWiCmBJSiImbLUPa3egcH+fW5TedFxWsw7n8qQ2Wrzto
        lLtnu88TlQDPIfts5Kn2tWc+HTt9DBC2oX6FTMZdMx/n4Df5m9C0XqQaD/dQtBXv
        obGCzIppON567mN20UZkaNnQDcS0bQuxB9yFcsYVwObdP4ISN49Ezinpa7mbM+4R
        Z/2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1672598000; x=1672684400; bh=BcrNw+w4SNGHC
        E4lx9Q7z+Zcv9oKolCWuuHkfZmCA7w=; b=JTk2uFeou2tfXoKp6XM7d+lV8OikV
        4wirUf5qLap69gsp49CJuYnJ8VLcWcCMV+f2k6AtibiKr9nI/Xw8S9N1KII/xqOZ
        nn/txguuYokG4nKsRofw1cepDfNMna16DEJ6ToNQFqg8BppvoPs4JxahPJXAF16O
        vIa/TNbAtXMjxg7XkFJeYpvksJfplDLJzvJvLA3hyo6DIcdAUHpXWmGKOy0RgnPH
        1dDjn6b8AMe0iXSHvBdfZz2E0LIuDWgE+8k51A5rLXriFSW3bEo10MDV5bXBGZ/9
        NKllMIB0rRrxzsSBJM8yrfEEveOHZMXuI0Lxn8fzyN6sp33Y8rbG12kaA==
X-ME-Sender: <xms:8NGxYxek_BwzywUKk4-Br8yaGHM4kc8y3lyUAMCccSChAAwFKuiCSA>
    <xme:8NGxY_OjKNLCldJnnmyrsFH4fH4kkbBsVwTI6VOmxnK8YcO3KUBInuDjU0R4OfHgO
    WEcViT8YOmShYdLhQ>
X-ME-Received: <xmr:8NGxY6h4_tPbN8wZpUwVGCgS_Y7cZdLi919XXGMh3DzxbruGuqOJ10Dv9CLMlfyccr9s34PbX6XoqlLNA3zm4th3yhg2ZL01b_KheYCYAuiRXkswzgF1vbv7T7B7f1XAjPod2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrjedtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhu
    vghlucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecugg
    ftrfgrthhtvghrnhepudekteeuudehtdelteevgfduvddvjefhfedulefgudevgeeghefg
    udefiedtveetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:8NGxY6-7gxOMvUEq5XV9WwSSnyLB3UUqtypnJAJDxXB2P4s9Q2JfZA>
    <xmx:8NGxY9vnTa0aYsTb1l8kbidLP20j8xkdhdSCATuy-94IsC7p7cbVpA>
    <xmx:8NGxY5EWRfE4Kt7bCRlUZfm6cD_DO0-hWpfSRmWI4uILSSnM74y8ng>
    <xmx:8NGxYzDbXLQt6bL2Z4XcxObCgKoolHJz4WwXDhrS9K8nDKYg_6ROoA>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 1 Jan 2023 13:33:19 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     Samuel Holland <samuel@sholland.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, stable@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH v2 1/2] nvmem: sunxi_sid: Always use 32-bit MMIO reads
Date:   Sun,  1 Jan 2023 12:33:15 -0600
Message-Id: <20230101183316.43642-2-samuel@sholland.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20230101183316.43642-1-samuel@sholland.org>
References: <20230101183316.43642-1-samuel@sholland.org>
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

The SID SRAM on at least some SoCs (A64 and D1) returns different values
when read with bus cycles narrower than 32 bits. This is not immediately
obvious, because memcpy_fromio() uses word-size accesses as long as
enough data is being copied.

The vendor driver always uses 32-bit MMIO reads, so do the same here.
This is faster than the register-based method, which is currently used
as a workaround on A64. And it fixes the values returned on D1, where
the SRAM method was being used.

The special case for the last word is needed to maintain .word_size == 1
for sysfs ABI compatibility, as noted previously in commit de2a3eaea552
("nvmem: sunxi_sid: Optimize register read-out method").

Cc: stable@vger.kernel.org
Fixes: 07ae4fde9efa ("nvmem: sunxi_sid: Add support for D1 variant")
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---

(no changes since v1)

 drivers/nvmem/sunxi_sid.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/sunxi_sid.c b/drivers/nvmem/sunxi_sid.c
index 5750e1f4bcdb..92dfe4cb10e3 100644
--- a/drivers/nvmem/sunxi_sid.c
+++ b/drivers/nvmem/sunxi_sid.c
@@ -41,8 +41,21 @@ static int sunxi_sid_read(void *context, unsigned int offset,
 			  void *val, size_t bytes)
 {
 	struct sunxi_sid *sid = context;
+	u32 word;
+
+	/* .stride = 4 so offset is guaranteed to be aligned */
+	__ioread32_copy(val, sid->base + sid->value_offset + offset, bytes / 4);
 
-	memcpy_fromio(val, sid->base + sid->value_offset + offset, bytes);
+	val += round_down(bytes, 4);
+	offset += round_down(bytes, 4);
+	bytes = bytes % 4;
+
+	if (!bytes)
+		return 0;
+
+	/* Handle any trailing bytes */
+	word = readl_relaxed(sid->base + sid->value_offset + offset);
+	memcpy(val, &word, bytes);
 
 	return 0;
 }
-- 
2.37.4

