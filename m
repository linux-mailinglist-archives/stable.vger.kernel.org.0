Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6879E44182F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhKAJpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234017AbhKAJnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14152613A2;
        Mon,  1 Nov 2021 09:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758947;
        bh=QinaQSqFBKR8xCGVS98FfYr+efFmbJ4TmPDXuj9BQc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GR4KsNrRl1JDevpkHCqpJtpBOh+z1/SqCqmj6Mqts+3YwS1iE2XZeQ00YgmvUIr5Y
         otBUjr5wQmMcd6aSvnLC2U5sZiO7zeOJB1plpu3he1sR0LCAN12FySuYMIjbN2YrFi
         grjZJ0ie8dG/EPKtm5aVT7TnEhCDsXKhENidt4ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <Aric.Cyr@amd.com>,
        Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>,
        Nikola Cornij <nikola.cornij@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 050/125] drm/amd/display: Limit display scaling to up to true 4k for DCN 3.1
Date:   Mon,  1 Nov 2021 10:17:03 +0100
Message-Id: <20211101082542.686110905@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

commit c21b105380cf86e829c68586ca1315cfc253ad8c upstream.

[why]
The requirement is that image width up to 4096 shall be supported

Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>
Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
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
-	.max_downscale_src_width = 3840,/*upto 4K*/
+	.max_downscale_src_width = 4096,/*upto true 4K*/
 	.disable_pplib_wm_range = false,
 	.scl_reset_length10 = true,
 	.sanity_checks = false,


