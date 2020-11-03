Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8546A2A4A34
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgKCPoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:44:01 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39401 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727901AbgKCPoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:44:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CEE691942B59;
        Tue,  3 Nov 2020 10:43:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:43:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Jy6VyS
        xgdi6GOAVubDrqsCM3BSpekKRSOv6FZUONKSk=; b=gP3nQnoXjZezi2V9iPxOE3
        mHZuqne6u5nhsLh2Mt/US9Sm8rH8Kp2lQLLR6V8fVQEFx6VD8k0KXC/HFAYqeI/7
        DH8yMPFrfTofrvDYCkx4L+x9Q3Fn9Oqit7vREwXdYfrYMTG2hDACP7o4C/PriQBL
        RlP0CNQkASwbZvGpobR+uLCmPrzZNP/kG6qpay9HD2jPGfc0rXxeFKb97GPia9EO
        C9qmhFq8V2gtsgNiYEyxXgVQeYgIr8qp9uvNAO6iPPJTZyxQkxTZUm2EoAuVdl5Q
        inrNa+pGgDKPU915wVhqa/vep2Ppfbg+esniDTHvB6RsNkJ6ZG6zsIyYNHmNxmUw
        ==
X-ME-Sender: <xms:v3qhXzqvAT9RRqPLZpEFmlRWaYGk3j_6riEez5_t0pWg0w1TQ5qmFg>
    <xme:v3qhX9rTk3SfWKJHYq8u4AW3GN64xLpBirJ5YAsQURjDDIbM0ZKVUHOX8CXg31OT1
    c7oSANxqq6Lkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:v3qhXwNon8OET2vWtozChj3MjnTSjykLHrSrbmowVP0tCfrTqJs25Q>
    <xmx:v3qhX25n-UNB4TwpUN2XRS1d4jxpyWcQK9w56UJO0b6aY1Ehp3-pzA>
    <xmx:v3qhXy6iyf2dARxpsTqmW6jbwGKo9dm9Ml9eBbJxCan2OlfnwCjCkA>
    <xmx:v3qhXyGHKbIOTDbGmID3ykU8iD8ra5B894n3Vot4X9-H8zhrzHJH5w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74BD83064685;
        Tue,  3 Nov 2020 10:43:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix DFPstate hang due to view port changed" failed to apply to 5.9-stable tree
To:     paul.hsieh@amd.com, Aric.Cyr@amd.com, Rodrigo.Siqueira@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:44:53 +0100
Message-ID: <1604418293224145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9804ecbba8f73916101ac36929bc647c3cb17155 Mon Sep 17 00:00:00 2001
From: Paul Hsieh <paul.hsieh@amd.com>
Date: Wed, 5 Aug 2020 17:28:37 +0800
Subject: [PATCH] drm/amd/display: Fix DFPstate hang due to view port changed

[Why]
Place the cursor in the center of screen between two pipes then
adjusting the viewport but cursour doesn't update cause DFPstate hang.

[How]
If viewport changed, update cursor as well.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 66180b4332f1..c8cfd3ba1c15 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1457,8 +1457,8 @@ static void dcn20_update_dchubp_dpp(
 
 	/* Any updates are handled in dc interface, just need to apply existing for plane enable */
 	if ((pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed ||
-			pipe_ctx->update_flags.bits.scaler || pipe_ctx->update_flags.bits.viewport)
-			&& pipe_ctx->stream->cursor_attributes.address.quad_part != 0) {
+			pipe_ctx->update_flags.bits.scaler || viewport_changed == true) &&
+			pipe_ctx->stream->cursor_attributes.address.quad_part != 0) {
 		dc->hwss.set_cursor_position(pipe_ctx);
 		dc->hwss.set_cursor_attribute(pipe_ctx);
 

