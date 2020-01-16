Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56A613FD3C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387907AbgAPXXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbgAPXXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86AE92072B;
        Thu, 16 Jan 2020 23:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217013;
        bh=/tMsTo/oT215hjzh8eb0XtXBCFW3sjzqs2fUAmL6W9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPQbWsAxJdpCuKxw+vAz/aFjd8Uylwl8xM3i9ub2hX8oZ1Ecqr91fbFANiSdZmrwy
         jb31rAevGqeQoQMMO72dKfoKpJ0YrhQUXNo60iGRgx2w2arInoyzxOsBgHjOAFetqP
         wadj5Hv36nb/6f2DkQ9rr1ASfB+4acLr3KN3OefM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 5.4 112/203] clk: meson: axg-audio: fix regmap last register
Date:   Fri, 17 Jan 2020 00:17:09 +0100
Message-Id: <20200116231755.253573192@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 255cab9d27d78703f7450d720859ee146d0ee6e1 upstream.

Since the addition of the g12a, the last register is
AUDIO_CLK_SPDIFOUT_B_CTRL.

Fixes: 075001385c66 ("clk: meson: axg-audio: add g12a support")
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/meson/axg-audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/meson/axg-audio.c
+++ b/drivers/clk/meson/axg-audio.c
@@ -1001,7 +1001,7 @@ static const struct regmap_config axg_au
 	.reg_bits	= 32,
 	.val_bits	= 32,
 	.reg_stride	= 4,
-	.max_register	= AUDIO_CLK_PDMIN_CTRL1,
+	.max_register	= AUDIO_CLK_SPDIFOUT_B_CTRL,
 };
 
 struct audioclk_data {


