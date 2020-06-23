Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F5B205E16
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389850AbgFWUTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389846AbgFWUTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0337C20EDD;
        Tue, 23 Jun 2020 20:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943585;
        bh=FEBNMVsQfbahJqBSgdhnH+a1KU53iGwucQZwhHPz97k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1BsTJ4kS4tvQ3YGb7GTwUNxT9hqEW4UFRB2vVhdSKKmMD2Lz8PAxwcwcmhVoy8nD
         IBTmy+P/gcw7Oyj1U5un9ukbSp4yoReAMmwzs4kUI4bOFc/MPknq4AcVrLajSsBVRd
         GVzK6ON6soXMabKEFeaz1VoB1ErC7Y5hL2RaX/DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Khaled Almahallawy <khaled.almahallawy@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 450/477] drm/i915/tc: fix the reset of ln0
Date:   Tue, 23 Jun 2020 21:57:27 +0200
Message-Id: <20200623195428.807845801@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khaled Almahallawy <khaled.almahallawy@intel.com>

commit a43555ac908c604f45ed98628805aec9355b9737 upstream.

Setting ln0 similar to ln1

Fixes: 3b51be4e4061b ("drm/i915/tc: Update DP_MODE programming")
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200608204537.28468-1-khaled.almahallawy@intel.com
(cherry picked from commit 4f72a8ee819d57d7329d88f487a2fc9b45153177)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_ddi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2866,7 +2866,7 @@ icl_program_mg_dp_mode(struct intel_digi
 		ln1 = intel_de_read(dev_priv, MG_DP_MODE(1, tc_port));
 	}
 
-	ln0 &= ~(MG_DP_MODE_CFG_DP_X1_MODE | MG_DP_MODE_CFG_DP_X1_MODE);
+	ln0 &= ~(MG_DP_MODE_CFG_DP_X1_MODE | MG_DP_MODE_CFG_DP_X2_MODE);
 	ln1 &= ~(MG_DP_MODE_CFG_DP_X1_MODE | MG_DP_MODE_CFG_DP_X2_MODE);
 
 	/* DPPATC */


