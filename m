Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11DB1CC46C
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 22:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgEIUMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 16:12:17 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:58015 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728445AbgEIUMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 16:12:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 687935A2;
        Sat,  9 May 2020 16:05:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 09 May 2020 16:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=Ew42L4+sGtXg1rthBvoivnjXlL
        0sKSK0vrB5L8HvPIw=; b=irwi4PiEEnm3yS5ojpXizK80wCkAe9CqI4cpobElyE
        TMstGge/F2IG24p9/WnXexsl1FXvy9Xeyuq2JWClBtd9e36yR8NQGuX8Z1cNKamf
        ks3++I88EDJyOqSof+lojfivo7aqbBNuq4NwZJhERmCD6HOEi/Tpq3oC+ain7J1B
        Ut1iSkoT7TdY/9teezX6f/OAEg9UX00RHIQO4TQ3aXU6Rmqml/3xWCW3IsCyU2tV
        Ln1h/f4YPBX5hN4yGy+PIe07oFUVIt7SX37xM1ZgXTPUsBf7XqlxytSKqciVuvoK
        T1qoLIPjs+sjpg5wnrDAA6Tjos6mTaXIoTm+VhUfFJoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ew42L4+sGtXg1rthB
        voivnjXlL0sKSK0vrB5L8HvPIw=; b=wWniHsJMia5XslNF4Fk+sJqHm5PB/aMPb
        gfg9SpVgMf9ZcKRUxNXuf5AUfC9BrRlLMbg7rl+ZdFoQRNLDZIDxuDlC+jrQFEAg
        FDBveEJCxarX0xxF/FJbFH//UOj14cAi08YrtwaJtbXP5XfRjhzV+zq6ZV1Knc8k
        IKi2YWtZgxB2MJzHReUW9DzZVAT90glgc+6kWz2ocza6w++le3p7pgagXGbOXloH
        cN10WK51o3S9S7xUTFg2vemlP/YNYLE/JfPBpMuVYyoigoWSERnyrsuYRCpP8+uZ
        35+KIGKEGZaQYRhyNNmlf7DHF/QraaM+Sxh0nkGJfxmtGEIuEu0pQ==
X-ME-Sender: <xms:Fw23XmtOCK3AFqkx9u8SK_NmO06cgXyWfJY3QwX0nGq5LZuuP81S1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeeiteekhfehuddugfeltddufeejjeefgeevheekueffhffhjeekheeiffdt
    vedtveenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdr
    ohhrgh
X-ME-Proxy: <xmx:Fw23Xp9wBgF6l1tux0T5LNtaq17_ACd09z7ePsLbCRceQqfTrFgBug>
    <xmx:Fw23XoFS9-EkLd1c1PhvNt-NDga-LRqTdc1dsm4Wz1E0Z-YxV2oUbw>
    <xmx:Fw23XnxC25xuzT2AWRDxXxE4MVhUl72sb7HcK6BJnF6V3vugeEjNRw>
    <xmx:Gg23Xu1pwmeq2-Kij57xRjyI5jCSc_krsWXtEQkQMlErMMkxxhh4qjfHdh0>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21E8D3066240;
        Sat,  9 May 2020 16:05:43 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sunxi@googlegroups.com,
        Samuel Holland <samuel@sholland.org>, stable@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 1/2] media: cedrus: Program output format during each run
Date:   Sat,  9 May 2020 15:06:42 -0500
Message-Id: <20200509200643.30597-1-samuel@sholland.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously, the output format was programmed as part of the ioctl()
handler. However, this has two problems:

  1) If there are multiple active streams with different output
     formats, the hardware will use whichever format was set last
     for both streams. Similarly, an ioctl() done in an inactive
     context will wrongly affect other active contexts.
  2) The registers are written while the device is not actively
     streaming. To enable runtime PM tied to the streaming state,
     all hardware access needs to be moved inside cedrus_device_run().

The call to cedrus_dst_format_set() is now placed just before the
codec-specific callback that programs the hardware.

Cc: <stable@vger.kernel.org>
Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Suggested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Suggested-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Tested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
---

v2: added patch
v3: collected tags

---
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 2 ++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index 4a2fc33a1d79..58c48e4fdfe9 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -74,6 +74,8 @@ void cedrus_device_run(void *priv)
 
 	v4l2_m2m_buf_copy_metadata(run.src, run.dst, true);
 
+	cedrus_dst_format_set(dev, &ctx->dst_fmt);
+
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
 	/* Complete request(s) controls if needed. */
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 15cf1f10221b..ed3f511f066f 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -273,7 +273,6 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
-	struct cedrus_dev *dev = ctx->dev;
 	struct vb2_queue *vq;
 	int ret;
 
@@ -287,8 +286,6 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
 
 	ctx->dst_fmt = f->fmt.pix;
 
-	cedrus_dst_format_set(dev, &ctx->dst_fmt);
-
 	return 0;
 }
 
-- 
2.24.1

