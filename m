Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB21BCBC9
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgD1S23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729192AbgD1S21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC69B2085B;
        Tue, 28 Apr 2020 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098507;
        bh=9RzJxy4Upa/s9eKqiIKMjlPo8dJwUDtbafz0tltfjg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umbcx7PdMr6emy1hkFlMB5NkJ5kXsQl5iLUUP+u+FhlQ0YrKQ1o0UgyWYJPCGgjrY
         NTUJWvnnWMq2C42mDEYSwMprgR23fl6eYb8EQsTmPazxPOn9DpyadLWsHrCpUmgBYo
         WzlCRL6PQJZxFVUgswhUyeAltVvXRsiwuhV2yOH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 004/131] crypto: mxs-dcp - make symbols sha1_null_hash and sha256_null_hash static
Date:   Tue, 28 Apr 2020 20:23:36 +0200
Message-Id: <20200428182225.921213644@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit ce4e45842de3eb54b8dd6e081765d741f5b92b56 upstream.

Fixes the following sparse warnings:

drivers/crypto/mxs-dcp.c:39:15: warning:
 symbol 'sha1_null_hash' was not declared. Should it be static?
drivers/crypto/mxs-dcp.c:43:15: warning:
 symbol 'sha256_null_hash' was not declared. Should it be static?

Fixes: c709eebaf5c5 ("crypto: mxs-dcp - Fix SHA null hashes and output length")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/mxs-dcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -37,11 +37,11 @@
  * Null hashes to align with hw behavior on imx6sl and ull
  * these are flipped for consistency with hw output
  */
-const uint8_t sha1_null_hash[] =
+static const uint8_t sha1_null_hash[] =
 	"\x09\x07\xd8\xaf\x90\x18\x60\x95\xef\xbf"
 	"\x55\x32\x0d\x4b\x6b\x5e\xee\xa3\x39\xda";
 
-const uint8_t sha256_null_hash[] =
+static const uint8_t sha256_null_hash[] =
 	"\x55\xb8\x52\x78\x1b\x99\x95\xa4"
 	"\x4c\x93\x9b\x64\xe4\x41\xae\x27"
 	"\x24\xb9\x6f\x99\xc8\xf4\xfb\x9a"


