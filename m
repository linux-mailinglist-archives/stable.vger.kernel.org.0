Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600985AB074
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiIBMy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238183AbiIBMyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:54:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2FDFB0D4;
        Fri,  2 Sep 2022 05:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52F78B81CCF;
        Fri,  2 Sep 2022 12:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEFDC433D6;
        Fri,  2 Sep 2022 12:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122297;
        bh=c31q+IW89ihYQRKSLITRP4pNQjWAJu3GDTGfRjPGQTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzbcDYplGPVslKHfDzgivSNFWgyB3DObB4Z1PhdlzHDUV4zu5/zzN73Ii5yAxMNQK
         8yeWTn7I3t6ntXBdS57VqJS/i4HFsIXpf3kvNto1N1ahyuodNh9qApgazZcS6lJteP
         HFrB7Va6He00fOIH2HCwUNEZ2kU72+qK2igDzcc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 59/72] drm/amdgpu: Add decode_iv_ts helper for ih_v6 block
Date:   Fri,  2 Sep 2022 14:19:35 +0200
Message-Id: <20220902121406.703709588@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 1af9add1f1512b10d9ce44ec7137612bc81ff069 ]

Was missing.  Add it.

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c b/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
index 92dc60a9d2094..085e613f3646d 100644
--- a/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
@@ -727,6 +727,7 @@ static const struct amd_ip_funcs ih_v6_0_ip_funcs = {
 static const struct amdgpu_ih_funcs ih_v6_0_funcs = {
 	.get_wptr = ih_v6_0_get_wptr,
 	.decode_iv = amdgpu_ih_decode_iv_helper,
+	.decode_iv_ts = amdgpu_ih_decode_iv_ts_helper,
 	.set_rptr = ih_v6_0_set_rptr
 };
 
-- 
2.35.1



