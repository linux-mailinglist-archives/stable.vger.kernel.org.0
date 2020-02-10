Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD8157943
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgBJNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgBJMii (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:38 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93CD62080C;
        Mon, 10 Feb 2020 12:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338317;
        bh=8cs4vnXlsHK6BO/SsjAWbXAI1jheAttXscHTh9YVgcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPnSb9zweQyC2HguOmjvgJws9zuVdDYXHH6l3MtinUPTBiyCI5mWUn70xfIkfipXu
         TWY/XL9YuoaWRAe3wIFGYvrRKJyO6THIxDW26dLHOfexMEmBKZ+BTQTm8Gm6WDXOC/
         u+M2yeyCOYp4bFbkFjCVDWwFa9SXMOfHkd+QEM9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.4 246/309] drm: msm: mdp4: Adjust indentation in mdp4_dsi_encoder_enable
Date:   Mon, 10 Feb 2020 04:33:22 -0800
Message-Id: <20200210122430.151268854@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 251e3cb1418ff3f5061ee31335e346e852b16573 upstream.

Clang warns:

../drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c:124:3: warning:
misleading indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
         mdp4_crtc_set_config(encoder->crtc,
         ^
../drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c:121:2: note:
previous statement is here
        if (mdp4_dsi_encoder->enabled)
        ^

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 776638e73a19 ("drm/msm/dsi: Add a mdp4 encoder for DSI")
Link: https://github.com/ClangBuiltLinux/linux/issues/792
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c
@@ -121,7 +121,7 @@ static void mdp4_dsi_encoder_enable(stru
 	if (mdp4_dsi_encoder->enabled)
 		return;
 
-	 mdp4_crtc_set_config(encoder->crtc,
+	mdp4_crtc_set_config(encoder->crtc,
 			MDP4_DMA_CONFIG_PACK_ALIGN_MSB |
 			MDP4_DMA_CONFIG_DEFLKR_EN |
 			MDP4_DMA_CONFIG_DITHER_EN |


