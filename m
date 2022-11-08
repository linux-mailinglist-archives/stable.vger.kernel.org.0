Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D656215E1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiKHOQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiKHOQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D937E7057B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74088615B2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8276FC433D6;
        Tue,  8 Nov 2022 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916983;
        bh=MkF6y4LxICyGUfj+kHmanrTVupiF607lKL6F2qERphM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEqW8xdYargutp58t2iTGw4NSLn5c5cEXv9Q/0xw7Z+ITCXA8Mb7r5tQxn4i0lE6P
         WV5D7HgaBeQj8Aina1xivp8r+3+zLQKLG3Pr1VZQqSrw+oQZtxuJ8JOKKTCc1hsaop
         n/k6FOjnrjR3+z7BIQ6Oa5ay8AIdaVjWz5u80pYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Broadworth <mark.broadworth@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Leo Chen <sancchen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 194/197] drm/amd/display: Update DSC capabilitie for DCN314
Date:   Tue,  8 Nov 2022 14:40:32 +0100
Message-Id: <20221108133403.673536559@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Chen <sancchen@amd.com>

commit 341421084d705475817f7f0d68e130370d10b20d upstream.

dcn314 has 4 DSC - conflicted hardware document updated and confirmed.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Leo Chen <sancchen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -847,7 +847,7 @@ static const struct resource_caps res_ca
 	.num_ddc = 5,
 	.num_vmid = 16,
 	.num_mpc_3dlut = 2,
-	.num_dsc = 3,
+	.num_dsc = 4,
 };
 
 static const struct dc_plane_cap plane_cap = {


