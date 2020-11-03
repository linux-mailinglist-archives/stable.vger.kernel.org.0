Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2149B2A4A3A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCPo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:44:56 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:55591 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727470AbgKCPo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:44:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 144531942BEB;
        Tue,  3 Nov 2020 10:44:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=51pNoe
        ZiQOUSc8pnBCy0YZBtisyOGzLQGQ6Mw60c7Ik=; b=G2nnCTMrJZGyeJaF5Mj6SW
        jzg3VowblIEpYPnuj9SV1NfWi460UO/azBCYgoXt7Rd4CQhFLk1a1leG0CictC59
        Eln00Mw/+6h/szfpFNyCDNYRyXUtz94lC3Tf2nmz907MxArp5FUk8aLqzzg6vyxf
        Z3wtVN/MhA+jGFTWlcx/ezSJbt4Mys5qLGno5sgZMhn8yKKnHwTafvLQype15Zd/
        4aeoNUj4UdDhjKT2p8V7Vlx3gDW8MLF3LvXvXcwZaUfNuooFl3ddRq2TUF1GXHA4
        F6HiAcUyajzEviZX9feWdLzOpJK0Yr5VgHQ1MAZHZxDgdOf/DjHdwUCe5D0ohCrg
        ==
X-ME-Sender: <xms:9nqhXzB9i3juwxW4WapRRkzPT3dNVIYlQBG9K1YrraWJ3aBbkKvZZQ>
    <xme:9nqhX5iJE_Y3tu7qWelgXJOUdsTmGbDtf1mAcU1sxThkU3jrm0EmgnLW6EIiLDnko
    DF6MPtDzDOlRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:9nqhX-l9cPMCEe64V1ISdD0qAz49gzQDCtQ-rXpz0IOdEm6NBCoe6Q>
    <xmx:9nqhX1xetB1Iam2IRWgASTAg9C00wub_IBWzpdr7zV1JjKFpFGAIfg>
    <xmx:9nqhX4SZprMy0ylQZW5_9RuIahXquOtus1SZk0MbdpX80AY8erSTzA>
    <xmx:93qhXzfTsYopTGQIoHGO1BbUhMXB_EnjeaN5v3kmQjJN-nT8qiLLFg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 762223064684;
        Tue,  3 Nov 2020 10:44:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Blank stream before destroying HDCP session" failed to apply to 5.9-stable tree
To:     jaehyun.chung@amd.com, Alvin.Lee2@amd.com,
        alexander.deucher@amd.com, qingqing.zhuo@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:45:45 +0100
Message-ID: <160441834515249@kroah.com>
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

From 8db2d634ed29eeaed56fdbeaf63da7ae9e65280b Mon Sep 17 00:00:00 2001
From: Jaehyun Chung <jaehyun.chung@amd.com>
Date: Thu, 30 Jul 2020 16:31:29 -0400
Subject: [PATCH] drm/amd/display: Blank stream before destroying HDCP session

[Why]
Stream disable sequence incorretly destroys HDCP session while stream is
not blanked and while audio is not muted. This sequence causes a flash
of corruption during mode change and an audio click.

[How]
Change sequence to blank stream before destroying HDCP session. Audio will
also be muted by blanking the stream.

Cc: stable@vger.kernel.org
Signed-off-by: Jaehyun Chung <jaehyun.chung@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 4bd6e03a7ef3..117d8aaf2a9b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3286,12 +3286,11 @@ void core_link_disable_stream(struct pipe_ctx *pipe_ctx)
 		core_link_set_avmute(pipe_ctx, true);
 	}
 
+	dc->hwss.blank_stream(pipe_ctx);
 #if defined(CONFIG_DRM_AMD_DC_HDCP)
 	update_psp_stream_config(pipe_ctx, true);
 #endif
 
-	dc->hwss.blank_stream(pipe_ctx);
-
 	if (pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
 		deallocate_mst_payload(pipe_ctx);
 

