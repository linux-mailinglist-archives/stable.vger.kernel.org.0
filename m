Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B349129BE5
	for <lists+stable@lfdr.de>; Tue, 24 Dec 2019 00:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfLWXwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 18:52:15 -0500
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:38176 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLWXwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 18:52:15 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id xBNNqCmm031437; Tue, 24 Dec 2019 08:52:12 +0900
X-Iguazu-Qid: 2wHHVKvLvcCRfbYH7h
X-Iguazu-QSIG: v=2; s=0; t=1577145132; q=2wHHVKvLvcCRfbYH7h; m=lVDnz+fWCN4HY4OtdTMDufOGJe60M/Oyq2nCTZ8wdzU=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1113) id xBNNqBkB026138;
        Tue, 24 Dec 2019 08:52:11 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBNNqBKw020686
        for <stable@vger.kernel.org>; Tue, 24 Dec 2019 08:52:11 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBNNqBSS031816
        for <stable@vger.kernel.org>; Tue, 24 Dec 2019 08:52:11 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Subject: [PATCH for 4.4, 4.9, 4.14, 4.19] uio: make symbol 'uio_class_registered' static
Date:   Tue, 24 Dec 2019 08:52:10 +0900
X-TSB-HOP: ON
Message-Id: <20191223235210.2312-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 6011002c1584d29c317e0895b9667d57f254537a upstream.

Fixes the following sparse warning:

drivers/uio/uio.c:277:6: warning:
 symbol 'uio_class_registered' was not declared. Should it be static?

Fixes: ae61cf5b9913 ("uio: ensure class is registered before devices")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/uio/uio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 2762148c169d..6c8114f77cfa 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -274,7 +274,7 @@ static struct class uio_class = {
 	.dev_groups = uio_groups,
 };
 
-bool uio_class_registered;
+static bool uio_class_registered;
 
 /*
  * device functions
-- 
2.23.0

