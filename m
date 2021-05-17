Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47197383858
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245274AbhEQPvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344009AbhEQPtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1286761D48;
        Mon, 17 May 2021 14:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262730;
        bh=+6mSZR8I9erVDXuGgE3bnDP4G0hXIV/fcvao60XbwlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ksa01dzihdUc+dptb1Xw5NubYeA9eaRpuEqwbh0U5kb/kawjyrDAZza+0N5P2wkzA
         eMRs6U8fTQZQkwC8mOjFh7b+VIXDbj63GjvR+JAxiNqnT/aLLLlf3Izsj6XVNi0O61
         GjXIRphhvf7c0SkgcSLt+8SrIG7o8RgSoBWL/qDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 282/289] media: rkvdec: Remove of_match_ptr()
Date:   Mon, 17 May 2021 16:03:27 +0200
Message-Id: <20210517140314.634915079@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
@@ -1107,7 +1107,7 @@ static struct platform_driver rkvdec_dri
 	.remove = rkvdec_remove,
 	.driver = {
 		   .name = "rkvdec",
-		   .of_match_table = of_match_ptr(of_rkvdec_match),
+		   .of_match_table = of_rkvdec_match,
 		   .pm = &rkvdec_pm_ops,
 	},
 };


