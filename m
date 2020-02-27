Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D2D171D6F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389341AbgB0OSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389803AbgB0OSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70CAF20801;
        Thu, 27 Feb 2020 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813079;
        bh=bDVVnOPiBJFbAwok1eeBcXQx8jGyj50nZqeS8zCYhbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02E2ojJl2cxMsEVQAWqknldqPTFTUWnb/YWaPMR8H4psSoIjm3uCbHYzb2eVNBbL6
         yrf0dAUN1ubHhBf2kZ/hl+waPuRu7n1/eaGX+hkm+0B6bqGt75Ir5Qgq8qfP3TjdC5
         UGY1rz7rq4pzJbGNtbm69cZlv4DET9Qz5IHHChQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.5 129/150] crypto: rename sm3-256 to sm3 in hash_algo_name
Date:   Thu, 27 Feb 2020 14:37:46 +0100
Message-Id: <20200227132251.624312135@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 6a30e1b1dcad0ba94fae757f797812d7d8dcb72c upstream.

The name sm3-256 is defined in hash_algo_name in hash_info, but the
algorithm name implemented in sm3_generic.c is sm3, which will cause
the sm3-256 algorithm to be not found in some application scenarios of
the hash algorithm, and an ENOENT error will occur. For example,
IMA, keys, and other subsystems that reference hash_algo_name all use
the hash algorithm of sm3.

Fixes: 5ca4c20cfd37 ("keys, trusted: select hash algorithm for TPM2 chips")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/hash_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/hash_info.c
+++ b/crypto/hash_info.c
@@ -26,7 +26,7 @@ const char *const hash_algo_name[HASH_AL
 	[HASH_ALGO_TGR_128]	= "tgr128",
 	[HASH_ALGO_TGR_160]	= "tgr160",
 	[HASH_ALGO_TGR_192]	= "tgr192",
-	[HASH_ALGO_SM3_256]	= "sm3-256",
+	[HASH_ALGO_SM3_256]	= "sm3",
 	[HASH_ALGO_STREEBOG_256] = "streebog256",
 	[HASH_ALGO_STREEBOG_512] = "streebog512",
 };


