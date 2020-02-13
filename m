Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC0C15C2EC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbgBMPi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbgBMP3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:14 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C9F62467D;
        Thu, 13 Feb 2020 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607753;
        bh=KA/MyvMwJ+jw7ZYC4Oz1VoKvr9CaBEm6TUKSIkAN5ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2bfN7QSwTNLy0oJ2oRNJePWDLfngexqF1FuNtRpADSgZDv/sfGNnEnrofqVF+vyN
         oga3XihD8H+3AAdwv9hL3Z52QXB2o3thh9meaIam/6Ed0sC7bRT9a/+NiaFHJeNqb7
         SrXHAL1DeRZzMhWbljvphUzVOAk/tyOcHIrxvxRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 098/120] crypto: caam/qi2 - fix typo in algorithms driver name
Date:   Thu, 13 Feb 2020 07:21:34 -0800
Message-Id: <20200213151933.989219152@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit 53146d152510584c2034c62778a7cbca25743ce9 upstream.

Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg_qi2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -2481,7 +2481,7 @@ static struct caam_aead_alg driver_aeads
 				.cra_name = "echainiv(authenc(hmac(sha256),"
 					    "cbc(des)))",
 				.cra_driver_name = "echainiv-authenc-"
-						   "hmac-sha256-cbc-desi-"
+						   "hmac-sha256-cbc-des-"
 						   "caam-qi2",
 				.cra_blocksize = DES_BLOCK_SIZE,
 			},


