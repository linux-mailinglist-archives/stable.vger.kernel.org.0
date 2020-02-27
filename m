Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6E171E18
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgB0OZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388707AbgB0OLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D504421D7E;
        Thu, 27 Feb 2020 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812695;
        bh=bDVVnOPiBJFbAwok1eeBcXQx8jGyj50nZqeS8zCYhbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwuM4j7QeuZeMS58/anQnEUqbchWL3Gj06m4cxjwnlcbTAPFHCRxCdLRTHfRE5Wvx
         SCDLe8XAJtUr44Nj/YWkFJu/OhUtYDxkm+5FtC98zaEZWl9gkTzgfE8rHZ53a04iZd
         IWfsTE1pL2Dt7oLQZLqWNJlRg7Bj2gSsxYfNxhfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.4 117/135] crypto: rename sm3-256 to sm3 in hash_algo_name
Date:   Thu, 27 Feb 2020 14:37:37 +0100
Message-Id: <20200227132246.727382171@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
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


