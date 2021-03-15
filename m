Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E5733B7EC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhCOOBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhCON7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4C9264F2E;
        Mon, 15 Mar 2021 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816751;
        bh=AznuqpOkkSuA+4G6CX9T30XzHXgyKop5MLAUA3jqGwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4qWwAKXsnK2ekJLiE18wexkusZ5Ygtx6gOyARkraYilwjSrhAQWfYDcB0Z4iSnY1
         x39BvTw8nQizBkyVEZMz2awuV2YlfOdCX7QO5KV7uoQQ2wvE2f7+Rdqn5p/TwG9BPM
         5fYToRnZSLZGdu1iPHQ/RU2pYKZ/GS2eXLlzq5+s=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 103/306] drm/amdgpu/display: dont assert in set backlight function
Date:   Mon, 15 Mar 2021 14:52:46 +0100
Message-Id: <20210315135511.122637199@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alex Deucher <alexander.deucher@amd.com>

commit dfd8b7fbd985ec1cf76fe10f2875a50b10833740 upstream.

It just spams the logs.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2571,7 +2571,6 @@ bool dc_link_set_backlight_level(const s
 			if (pipe_ctx->plane_state == NULL)
 				frame_ramp = 0;
 		} else {
-			ASSERT(false);
 			return false;
 		}
 


