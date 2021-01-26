Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC0830A3FC
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhBAJFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:05:44 -0500
Received: from www.linuxtv.org ([130.149.80.248]:41266 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232691AbhBAJFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 04:05:41 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l6V8B-005hgx-T2; Mon, 01 Feb 2021 09:04:23 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 26 Jan 2021 18:15:54 +0000
Subject: [git:media_tree/master] media: cec: add stm32 driver
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Yannick Fertre <yannick.fertre@foss.st.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l6V8B-005hgx-T2@www.linuxtv.org>
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
 
