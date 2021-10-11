Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB55428FD3
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbhJKOBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236556AbhJKN7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25EBA610EA;
        Mon, 11 Oct 2021 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960582;
        bh=gJg+erxrnR0oZjJPRXuGMlb+bLz/+dfdtcv52Z2+e1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ56J8EL/d21l3pv+QOxTRiWOgYQBqzuTza+ho23C9KYeDptzPC+5iAkzyCAdyd4T
         ckHsXTeo4uOglV9HHrEEMVok/KAcnuEMj1+PHeDGc9s0L6Cafi2b4+eyY9sd0AK1bv
         CtZy7xL63FVvcOzs2+gqqFB8XgA0PXCLDs20IAQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <Zhan.Liu@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Nikola Cornij <nikola.cornij@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 015/151] drm/amd/display: Limit display scaling to up to 4k for DCN 3.1
Date:   Mon, 11 Oct 2021 15:44:47 +0200
Message-Id: <20211011134518.349098117@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

commit a7e397b7c45377e20542146be10231b8afa948d1 upstream.

[why]
The existing limit was mistakenly bigger than 4k for DCN 3.1

Reviewed-by: Zhan Liu <Zhan.Liu@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -928,7 +928,7 @@ static const struct dc_debug_options deb
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
 	.performance_trace = false,
-	.max_downscale_src_width = 7680,/*upto 8K*/
+	.max_downscale_src_width = 3840,/*upto 4K*/
 	.disable_pplib_wm_range = false,
 	.scl_reset_length10 = true,
 	.sanity_checks = false,


