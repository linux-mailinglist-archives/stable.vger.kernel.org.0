Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C971FBB74
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgFPPhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbgFPPha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:37:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6E821475;
        Tue, 16 Jun 2020 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321850;
        bh=FD53rO+fysM1m9xUdrgMsKK/8LhBRRYiQHHK8cczxf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fPK7IJ+iIcMClRWYVyRrqwc2Yy0x1I8NuHHdDleOdgBAth4e+j3M4+sBV9nj+mC2
         ygxPUtipP2nuGQlCfb+yUuhLjlJmgBJ1IjR4VRYj0EfhKojvhDyhQzo7JPtCrC1vUf
         6wrjV31Qo0QCCN1MmpkpVrmqRFKiV/WelA7zfvAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Kadioglu <denk@eclipso.email>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/134] Input: synaptics - add a second working PNP_ID for Lenovo T470s
Date:   Tue, 16 Jun 2020 17:33:16 +0200
Message-Id: <20200616153101.280335153@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Kadioglu <denk@eclipso.email>

[ Upstream commit 642aa86eaf8f1e6fe894f20fd7f12f0db52ee03c ]

The Lenovo Thinkpad T470s I own has a different touchpad with "LEN007a"
instead of the already included PNP ID "LEN006c". However, my touchpad
seems to work well without any problems using RMI. So this patch adds the
other PNP ID.

Signed-off-by: Dennis Kadioglu <denk@eclipso.email>
Link: https://lore.kernel.org/r/ff770543cd53ae818363c0fe86477965@mail.eclipso.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4d2036209b45..758dae8d6500 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -170,6 +170,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN005b", /* P50 */
 	"LEN005e", /* T560 */
 	"LEN006c", /* T470s */
+	"LEN007a", /* T470s */
 	"LEN0071", /* T480 */
 	"LEN0072", /* X1 Carbon Gen 5 (2017) - Elan/ALPS trackpoint */
 	"LEN0073", /* X1 Carbon G5 (Elantech) */
-- 
2.25.1



