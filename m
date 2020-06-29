Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA320E509
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgF2Vbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:31:46 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:43835 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728736AbgF2SlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4750C19417DF;
        Mon, 29 Jun 2020 07:33:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MoEmOR
        d/85CX547TmhhSVhPofeBJuVRFW2vY2DzNIuY=; b=fE3xge7BFl18/urp3fzKAg
        28vwgit5FADhnmzkcGshiqC32UhDQOaUqzyWb5a7C4ogVMQG0Yl/xv85Y39nfmIE
        /oAKm5PacDFj98bxM6VVc6d0aNWBcxnHSYOjK3hquXhpBCSSazY8wetv8v4yv/zk
        bAXOBlpt6FILDbiGmiW6mOjG/CTPuRoS5tp3qrnVYXPsR03i+fmEiojkycm/unCb
        0/6SwI1XvL9D5tQYUYEFF3MEA9yuDGdfUpKIacn8v5xZKfG50BCPJAik34C8279n
        PrvVDwoMAvuZvkxciAPmLRCFQJlytBKjFkaafbxqXxzYv/ibaEkSD3L9ApmFnolQ
        ==
X-ME-Sender: <xms:n9H5Xgskfre_q2KcgZ_wwlS73kQQYmaZpE6TG3GdDNGaOBOAPDFT0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:n9H5XtdWMYEX3OWQuJfkt2FQzVLQYL7ysIeZOV6f7tzGkMLff63Kmw>
    <xmx:n9H5Xrx7m83CAwSRbA95f0K53qQjBim9hXwmC_rr649fP1CcZFvqhA>
    <xmx:n9H5XjMDkpr2vbCvLgdkQ1CdKii4fG85yk-86eh8u5yzdP69AFFdLg>
    <xmx:oNH5XukhhdtJ3z3HnUM7-1KLtsEis1YaCSDoZSijNFcmYgABYXOUDg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D8583280067;
        Mon, 29 Jun 2020 07:33:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix ineffective setting of max bpc property" failed to apply to 5.7-stable tree
To:     stylon.wang@amd.com, Nicholas.Kazlauskas@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:33:43 +0200
Message-ID: <159343042310143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fa7041d9d2fc7401cece43f305eb5b87b7017fc4 Mon Sep 17 00:00:00 2001
From: Stylon Wang <stylon.wang@amd.com>
Date: Fri, 12 Jun 2020 19:04:18 +0800
Subject: [PATCH] drm/amd/display: Fix ineffective setting of max bpc property

[Why]
Regression was introduced where setting max bpc property has no effect
on the atomic check and final commit. It has the same effect as max bpc
being stuck at 8.

[How]
Correctly propagate max bpc with the new connector state.

Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7ced9f87be97..10ac8076d4f2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5024,7 +5024,8 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	struct drm_connector *connector = &aconnector->base;
 	struct amdgpu_device *adev = connector->dev->dev_private;
 	struct dc_stream_state *stream;
-	int requested_bpc = connector->state ? connector->state->max_requested_bpc : 8;
+	const struct drm_connector_state *drm_state = dm_state ? &dm_state->base : NULL;
+	int requested_bpc = drm_state ? drm_state->max_requested_bpc : 8;
 	enum dc_status dc_result = DC_OK;
 
 	do {

