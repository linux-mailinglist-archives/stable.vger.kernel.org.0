Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7820B3ED518
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhHPNH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237580AbhHPNGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F78610A0;
        Mon, 16 Aug 2021 13:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119168;
        bh=tFioTXH4kIzub7fSKadaM2XRQp+lMnt2ycFBJLIxd4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbpZIHVD6T7q9XtDbV0J031AjHM8ciudv4trOZYGxbTvIwlRw0752NWaBJF7JH3Eh
         ckWh9kPym2D0s1+L+ToY6tev9mPN7MyZmmG4rnXs9yGe7ftabGOZa1xweRa6MldcGX
         E0E1kDycVc6oTijnEJY77PJXhmpdcKrvIW9Y6FcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Eric Bernstein <eric.bernstein@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 19/96] drm/amd/display: Remove invalid assert for ODM + MPC case
Date:   Mon, 16 Aug 2021 15:01:29 +0200
Message-Id: <20210816125435.563212724@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Bernstein <eric.bernstein@amd.com>

commit c90f6263f58a28c3d97b83679d6fd693b33dfd4e upstream.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Eric Bernstein <eric.bernstein@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -1875,7 +1875,6 @@ static bool dcn30_split_stream_for_mpc_o
 		}
 		pri_pipe->next_odm_pipe = sec_pipe;
 		sec_pipe->prev_odm_pipe = pri_pipe;
-		ASSERT(sec_pipe->top_pipe == NULL);
 
 		sec_pipe->stream_res.opp = pool->opps[pipe_idx];
 		if (sec_pipe->stream->timing.flags.DSC == 1) {


