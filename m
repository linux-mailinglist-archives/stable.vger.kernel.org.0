Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725C73837A3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244064AbhEQPq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243080AbhEQPnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:43:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC86D61D16;
        Mon, 17 May 2021 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262558;
        bh=R1Fvj/L7WXR8WMm7RlsYiWv6gaCSm3yqHPRsfjL1YJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+mq3+d3Z1cNyNZ4LJrq1UB+HpLOfvN4VRDuh6mTOif7cO/H2SOmYt2tm/ZUCO9cg
         d0+RX2EY9+W+mrlyUOAnAB+Fa+EZRL7rUjq0JNozMq1NQYMertbIkXGvIL21iG2BqY
         +0mSTSToSc+x5qFGQCKzG4FzC1ZpT0RDdIksfg/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 320/329] media: rkvdec: Remove of_match_ptr()
Date:   Mon, 17 May 2021 16:03:51 +0200
Message-Id: <20210517140312.913598065@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit c2357dd9cbafc8ed37156e32c24884cfa8380b2f upstream.

When building with CONFIG_OF not set, the following clang
build warning is seen:

>> drivers/staging/media/rkvdec/rkvdec.c:967:34: warning: unused variable 'of_rkvdec_match' [-Wunused-const-variable]

Fix the warning by removing the unnecessary of_match_ptr().

Reported-by: kernel test robot <lkp@intel.com>
Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/rkvdec/rkvdec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -1072,7 +1072,7 @@ static struct platform_driver rkvdec_dri
 	.remove = rkvdec_remove,
 	.driver = {
 		   .name = "rkvdec",
-		   .of_match_table = of_match_ptr(of_rkvdec_match),
+		   .of_match_table = of_rkvdec_match,
 		   .pm = &rkvdec_pm_ops,
 	},
 };


