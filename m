Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDC83ED5D7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhHPNP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237255AbhHPNNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6B6361BE5;
        Mon, 16 Aug 2021 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119457;
        bh=pSC9uHmNqEbnVQpAQ+mdo3/sbjNz+deH84yn10Sq5F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziJTAkRE0f/H9QtDVxuNa76bJCBZ3+0KZWDh5y294+xag2oOvJT2IivlZcx3b1uWw
         PbLoWzmzopLBP4lKffcqBDg3Bqud8HcoNK3Ohp45LbCfKn2EJ4Vv0jUMrBO8ozc6Jx
         gpE6BsBxS4NE7y8uYpjiNrhO69byA4sDhWbFAygc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Eric Bernstein <eric.bernstein@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 034/151] drm/amd/display: Remove invalid assert for ODM + MPC case
Date:   Mon, 16 Aug 2021 15:01:04 +0200
Message-Id: <20210816125445.197656689@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
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
@@ -1788,7 +1788,6 @@ static bool dcn30_split_stream_for_mpc_o
 		}
 		pri_pipe->next_odm_pipe = sec_pipe;
 		sec_pipe->prev_odm_pipe = pri_pipe;
-		ASSERT(sec_pipe->top_pipe == NULL);
 
 		if (!sec_pipe->top_pipe)
 			sec_pipe->stream_res.opp = pool->opps[pipe_idx];


