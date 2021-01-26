Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325F9304BE7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbhAZV5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:57:14 -0500
Received: from www.linuxtv.org ([130.149.80.248]:51906 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394543AbhAZSR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 13:17:56 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l4Sts-00F4Dj-Eq; Tue, 26 Jan 2021 18:17:12 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 26 Jan 2021 18:15:54 +0000
Subject: [git:media_tree/fixes] media: cec: add stm32 driver
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Yannick Fertre <yannick.fertre@foss.st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l4Sts-00F4Dj-Eq@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cec: add stm32 driver
Author:  Yannick Fertre <yannick.fertre@foss.st.com>
Date:    Fri Jan 15 15:31:44 2021 +0100

Missing stm32 directory to Makefile.

Signed-off-by: Yannick Fertre <yannick.fertre@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 4be5e8648b0c ("media: move CEC platform drivers to a separate directory")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/cec/platform/Makefile | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/cec/platform/Makefile b/drivers/media/cec/platform/Makefile
index 3a947159b25a..ea6f8ee8161c 100644
--- a/drivers/media/cec/platform/Makefile
+++ b/drivers/media/cec/platform/Makefile
@@ -10,5 +10,6 @@ obj-$(CONFIG_CEC_MESON_AO)	+= meson/
 obj-$(CONFIG_CEC_SAMSUNG_S5P)	+= s5p/
 obj-$(CONFIG_CEC_SECO)		+= seco/
 obj-$(CONFIG_CEC_STI)		+= sti/
+obj-$(CONFIG_CEC_STM32)		+= stm32/
 obj-$(CONFIG_CEC_TEGRA)		+= tegra/
 
