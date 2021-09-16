Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535D240DABB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhIPNKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239898AbhIPNKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:10:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C861760FBF;
        Thu, 16 Sep 2021 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797754;
        bh=J1LafoZCYivAXGGbPpmWgeQcjhqAQ5HorKXkh0uPPjs=;
        h=Subject:To:Cc:From:Date:From;
        b=oIksPeU9p1i0StrZCzf1r2NmpDizjqO/jdDx8QQ8843jqOIo1y1CBbE2KutCwmC3p
         VyKIVVBM3+OYwIYuhx9t9s+MPxISl/DKDcoTTb/S0HUnZ0Sb/260VpyrftG9FHzQ/i
         vlC/tQUXhHRWzD+V3+I0iYmGcc/5z7YksMv9fp7A=
Subject: FAILED: patch "[PATCH] drm/amd/display: Remove invalid assert for ODM + MPC case" failed to apply to 5.14-stable tree
To:     eric.bernstein@amd.com, Anson.Jacob@amd.com,
        Dmytro.Laktyushkin@amd.com, alexander.deucher@amd.com,
        daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:09:11 +0200
Message-ID: <163179775125442@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f43a19fd0e976736d8f1b70b6fe1b6b88d6a900b Mon Sep 17 00:00:00 2001
From: Eric Bernstein <eric.bernstein@amd.com>
Date: Mon, 26 Jul 2021 15:53:18 -0400
Subject: [PATCH] drm/amd/display: Remove invalid assert for ODM + MPC case

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Eric Bernstein <eric.bernstein@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 253654d605c2..28e15ebf2f43 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -1788,7 +1788,6 @@ static bool dcn30_split_stream_for_mpc_or_odm(
 		}
 		pri_pipe->next_odm_pipe = sec_pipe;
 		sec_pipe->prev_odm_pipe = pri_pipe;
-		ASSERT(sec_pipe->top_pipe == NULL);
 
 		if (!sec_pipe->top_pipe)
 			sec_pipe->stream_res.opp = pool->opps[pipe_idx];

