Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACF5E5834
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 05:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfJZDGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 23:06:35 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53729 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbfJZDGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 23:06:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 67154220C3;
        Fri, 25 Oct 2019 23:06:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 25 Oct 2019 23:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=SK9/MZvBzdwfqRazEGxrhgw470
        rhFjm/4Hzyje9ROUQ=; b=XJaP0p6X3hIRL+HOXhjUDpue9GeZmJzxaxR7bRknIx
        7y/dU70kvIIMFB10wyXC6Lsukly8EQwYNaIfIUd0iwEkz3kBCmnAmp6iR8m4Bu3L
        gbhBk3WWEo42gJUnXG0/AFbBokzL9DxpfDiD46/fUlfKa3bhttcFEMCX2HN0HsXE
        jBTqQ8fbPSMu+HAoN9RgtMxqWbXaz/pGm3dzY7jK3gCnC537NaQcnocIYnz4+z8O
        uoWOZUOlnGCq0EzKCZYssGm7+VmfsmX4+0q2lJx5PRFRwULTy1rn6rNGO3+EsBzI
        BfzNjuCdu7W3BgVpEHouCDAY82uMGPHAOAIi9HXJnBtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SK9/MZvBzdwfqRazE
        Gxrhgw470rhFjm/4Hzyje9ROUQ=; b=DdciPCal1Vfp1vYMLbNnz1XeTHeOOUpy7
        N/PwFiHLKCj4KWfqnzUPNk3AVSnAsploP+TyEx5+jYq4DkJXKrvhoMsQZRuB0tgf
        /sTokulr8EfJ75cRUjeYwpeX0BdlyutrS2cCuEEBOgFPB+9MIr5Kn+lUWcJcV8yt
        nS47CXrgBRtJlqLwLZ80ApS0AshZmXQA+MMLpn8bg5BaIHYeuh1BMHtTpNZF/fxr
        PSY2OzP9lq8cao4JUF7fXH2U6mh7EGaCi6fNRS4ESM7EExyw7wDd/+NtnjBvlodZ
        w94Rlfq662SXxgVrGmTVN2vbw1aD15+/JSZCNk9kmSxl2nfOck+0g==
X-ME-Sender: <xms:MbizXfNQq_L2L9XnN-2TeEIdBXiPappPT_OtWuWXGL65crX45CAXUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleeggdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekudenucfrrg
    hrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhj
    phenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:MbizXc5fPXWquIdNjyd7WyraHeALgM7ikV9WxvAFqta5enqytKHYJw>
    <xmx:MbizXSeqHh3aQmgpZ7tyA1mPIE7-j1vCi-ZII3iAl1A76YgDhsd17Q>
    <xmx:MbizXQ4AksAC3qoJfIJtZ3wN8BH6o9fqGG4xqf5qnpkDWV0sOXdBBA>
    <xmx:MrizXcJH2RbE0NoreUyUM7jkk7muvsKfYwhkgXm_UNZ7jbzh6JDdKA>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0C3818005C;
        Fri, 25 Oct 2019 23:06:23 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: bebob: Fix prototype of helper function to return negative value
Date:   Sat, 26 Oct 2019 12:06:20 +0900
Message-Id: <20191026030620.12077-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A helper function of ALSA bebob driver returns negative value in a
function which has a prototype to return unsigned value.

This commit fixes it by changing the prototype.

Fixes: eb7b3a056cd8 ("ALSA: bebob: Add commands and connections/streams management"
Cc: <stable@vger.kernel.org> # v3.16+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/bebob/bebob_stream.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/firewire/bebob/bebob_stream.c b/sound/firewire/bebob/bebob_stream.c
index 7ac0d9f495c4..f7f0db5aa811 100644
--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -252,8 +252,7 @@ int snd_bebob_stream_get_clock_src(struct snd_bebob *bebob,
 	return err;
 }
 
-static unsigned int
-map_data_channels(struct snd_bebob *bebob, struct amdtp_stream *s)
+static int map_data_channels(struct snd_bebob *bebob, struct amdtp_stream *s)
 {
 	unsigned int sec, sections, ch, channels;
 	unsigned int pcm, midi, location;
-- 
2.20.1

