Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8265A24B122
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgHTIdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:33:50 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60305 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726825AbgHTIdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:33:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 63F0219400E9;
        Thu, 20 Aug 2020 04:33:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4QLgBG
        kqoIbcyCHMe8xLCI75DBpfdv6QQifNuAC0lRw=; b=bQaPUlEITz89iUhAUa+Jpi
        nX7mcQexyr5BQkZLrtFwg/vdQ+4qogRs7qoZJqfrWsa5ARhq+jwDpUqkJ4oGdIFK
        /vQ2qw1gI17fid68qXjLnNRP1IIKiKQUjrwVm38VUEEcKxX7yHGdxgFxm04WzN10
        9alGhCX3ne6DyAorzdVR5zriCUeK+R3+NRcSgyhoq0LuSchYzQ/vpislVboq3kIL
        tTO0/evmAWuuY5ISQebuIzaXTzZsb/GL7c05AjdPytoATvcVP82TXYcVR0+5ILBC
        YXEr9T3AamFmsyFpYbAdToO9Wcq310r4MLtLiYU6S/G++1ZqF7AAptVTa1ym/Tmg
        ==
X-ME-Sender: <xms:bDU-X6FOmzey9iant4dOU5JeAEhJDCjNUPYngnj8_HLFIHYtFbP8Wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:bDU-X7U8J5hB_1Wl6Kp-DktKjUOIkSMuiIqgb9ISUkbrk9Bvdp7eTg>
    <xmx:bDU-X0LPe-2is4Zo-1gtHeWf8S3duUVuGsue6Xxns193PPk40Q5hvg>
    <xmx:bDU-X0H3p-vzIPiTSsSwEn2FP7Au4lbJqxpNpgAKgYlx-BrRqrPYAw>
    <xmx:bDU-X7dJ9OkTeK-zObLeWTzYck-uOx_73bSDW1w9ZuMuoZbwZkvQ0w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0744630600B2;
        Thu, 20 Aug 2020 04:33:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: handle failed allocation during stream" failed to apply to 5.8-stable tree
To:     Josip.Pavic@amd.com, Aric.Cyr@amd.com, Rodrigo.Siqueira@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:34:10 +0200
Message-ID: <159791245016066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4462282a7253e3663790f8ab092a4107d905bd76 Mon Sep 17 00:00:00 2001
From: Josip Pavic <Josip.Pavic@amd.com>
Date: Mon, 6 Jul 2020 15:43:39 -0400
Subject: [PATCH] drm/amd/display: handle failed allocation during stream
 construction

[Why]
Failing to allocate a transfer function during stream construction leads
to a null pointer dereference

[How]
Handle the failed allocation by failing the stream construction

Cc: stable@vger.kernel.org
Signed-off-by: Josip Pavic <Josip.Pavic@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index 3b897372ed27..d6989d115c5c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -56,7 +56,7 @@ void update_stream_signal(struct dc_stream_state *stream, struct dc_sink *sink)
 	}
 }
 
-static void dc_stream_construct(struct dc_stream_state *stream,
+static bool dc_stream_construct(struct dc_stream_state *stream,
 	struct dc_sink *dc_sink_data)
 {
 	uint32_t i = 0;
@@ -118,11 +118,17 @@ static void dc_stream_construct(struct dc_stream_state *stream,
 	update_stream_signal(stream, dc_sink_data);
 
 	stream->out_transfer_func = dc_create_transfer_func();
+	if (stream->out_transfer_func == NULL) {
+		dc_sink_release(dc_sink_data);
+		return false;
+	}
 	stream->out_transfer_func->type = TF_TYPE_BYPASS;
 	stream->out_transfer_func->ctx = stream->ctx;
 
 	stream->stream_id = stream->ctx->dc_stream_id_count;
 	stream->ctx->dc_stream_id_count++;
+
+	return true;
 }
 
 static void dc_stream_destruct(struct dc_stream_state *stream)
@@ -164,13 +170,20 @@ struct dc_stream_state *dc_create_stream_for_sink(
 
 	stream = kzalloc(sizeof(struct dc_stream_state), GFP_KERNEL);
 	if (stream == NULL)
-		return NULL;
+		goto alloc_fail;
 
-	dc_stream_construct(stream, sink);
+	if (dc_stream_construct(stream, sink) == false)
+		goto construct_fail;
 
 	kref_init(&stream->refcount);
 
 	return stream;
+
+construct_fail:
+	kfree(stream);
+
+alloc_fail:
+	return NULL;
 }
 
 struct dc_stream_state *dc_copy_stream(const struct dc_stream_state *stream)

