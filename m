Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6126133317
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgAGVG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbgAGVGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6DF720678;
        Tue,  7 Jan 2020 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431214;
        bh=kmeNiKw2j4+GhUUPleytjPtvkwYRfFRTecaa6YYhjFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npguQ8Jz+niSJ8V4pSDWsyjiZK3wMbOnoVNKajiiiOo9n1B1bNZjlwgjJEVoj/FuE
         CEQJGUmb/3LA9ES8YYT7MaU9UREckQlPYjcHQjFFwBK4nzbfeUs+vPDDbBm4bCONVQ
         Uv8uUEnNUw1npUAW5GRD1TpoeqruE+S5ki5CsCOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 4.19 079/115] drm/msm: include linux/sched/task.h
Date:   Tue,  7 Jan 2020 21:54:49 +0100
Message-Id: <20200107205304.535942351@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 70082a52f96a45650dfc3d8cdcd2c42bdac9f6f0 upstream.

Without this header file, compile-testing may run into a missing
declaration:

drivers/gpu/drm/msm/msm_gpu.c:444:4: error: implicit declaration of function 'put_task_struct' [-Werror,-Wimplicit-function-declaration]

Fixes: 482f96324a4e ("drm/msm: Fix task dump in gpu recovery")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/msm_gpu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -25,6 +25,7 @@
 #include <linux/pm_opp.h>
 #include <linux/devfreq.h>
 #include <linux/devcoredump.h>
+#include <linux/sched/task.h>
 
 /*
  * Power Management:


