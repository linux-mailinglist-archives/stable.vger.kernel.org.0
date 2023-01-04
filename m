Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98AC65D9B9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbjADQ1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240009AbjADQ1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:27:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E0343191
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC27617A7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A980C433EF;
        Wed,  4 Jan 2023 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849638;
        bh=77Y/fKw5+sCoJcuGF2qllAqjhim4poxFL2Dp7ppYt4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7skiva5WburHw3Nw5kSxBob9d27ob3IrJQgr7rAK0YhC8H4wr6nNjIaYKXEWSxaH
         9uv7GaRfyPe62d8ICa0IKyvYslUNNjz6zWdj2DehtekNDsun/UCVXdLnzyH5gFfljU
         ttJvTLGfgJIXLcBoBphvVZGe0AzyplD1O5bQ1lVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 169/177] drm/amd/display: Add DCN314 display SG Support
Date:   Wed,  4 Jan 2023 17:07:40 +0100
Message-Id: <20230104160512.798886030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Yifan Zhang <yifan1.zhang@amd.com>

commit fe6872adb05e85bde38f2cdec01a0f4cfb826998 upstream.

Add display SG support for DCN 3.1.4.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1511,6 +1511,7 @@ static int amdgpu_dm_init(struct amdgpu_
 		case IP_VERSION(3, 0, 1):
 		case IP_VERSION(3, 1, 2):
 		case IP_VERSION(3, 1, 3):
+		case IP_VERSION(3, 1, 4):
 		case IP_VERSION(3, 1, 5):
 		case IP_VERSION(3, 1, 6):
 			init_data.flags.gpu_vm_support = true;


