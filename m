Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC781078D7
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVTxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfKVTt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CA462075B;
        Fri, 22 Nov 2019 19:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452168;
        bh=p9dduV/SfO6VK/Wj1E1+PzJhUj70IKevY3pdThcKypY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm+RifkNfby/xkg9lSkr/GFiqAz+WNcbo0Y5hjHP8HueFB9y6dRPdR+HJVi9zu7Ch
         6Y6lMr+9k+E+g/CB+0wwYMGe9fK8dz+2z6VjTorTdiYYg8eHzy+rfkhwcwdMbFEMVz
         Ep/D1vh6yW4B1BOVQXwOc/pK5eu1FHMPtoZ8TUbY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/25] Input: synaptics - enable RMI mode for X1 Extreme 2nd Generation
Date:   Fri, 22 Nov 2019 14:48:57 -0500
Message-Id: <20191122194859.24508-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194859.24508-1-sashal@kernel.org>
References: <20191122194859.24508-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 768ea88bcb235ac3a92754bf82afcd3f12200bcc ]

Just got one of these for debugging some unrelated issues, and noticed
that Lenovo seems to have gone back to using RMI4 over smbus with
Synaptics touchpads on some of their new systems, particularly this one.
So, let's enable RMI mode for the X1 Extreme 2nd Generation.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://lore.kernel.org/r/20191115221814.31903-1-lyude@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 06cebde2422ea..afdb9947d8af9 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -180,6 +180,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN0096", /* X280 */
 	"LEN0097", /* X280 -> ALPS trackpoint */
 	"LEN009b", /* T580 */
+	"LEN0402", /* X1 Extreme 2nd Generation */
 	"LEN200f", /* T450s */
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
-- 
2.20.1

