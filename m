Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3809C133415
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgAGVXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728515AbgAGVBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4118F24672;
        Tue,  7 Jan 2020 21:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430874;
        bh=SkUyblwU99iMDKO/k+Wj2C3RYecw+KxgIPrwyZ+Sh90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bage4CU+UYCi0YMjJhNWBhehanUbVrkAddaVebJsqm98WSBajsdv5STGtoKzvh77K
         SQJg63/EhpQFI4ndQvDzVCKhUpAbqyx+Iaz71Em9rpwVHd5KQ6D12vIwFjDBwTmE6C
         fhe2UnZ2qq2pl7ibIOC7eE3GF5bd54/ZI/Xjwmhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.4 133/191] drm/msm: include linux/sched/task.h
Date:   Tue,  7 Jan 2020 21:54:13 +0100
Message-Id: <20200107205340.088032750@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
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
@@ -16,6 +16,7 @@
 #include <linux/pm_opp.h>
 #include <linux/devfreq.h>
 #include <linux/devcoredump.h>
+#include <linux/sched/task.h>
 
 /*
  * Power Management:


