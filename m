Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1FE4093E6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245748AbhIMOZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344205AbhIMOWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DB86159A;
        Mon, 13 Sep 2021 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540866;
        bh=/aeM0nKRuFKXwYv5VlQpAM6LhcfpYnf7ULc5SzJRo+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJhDvT9XBenjbHSUoO4Xt0MJqm0LGsQuQGF1fFnwUruS+sSST6MOwezH1QXn5WVo9
         8b2IwNEnI19N55gcMPYjAoz63V0k0AYeZ6UkQzPbRIsBaMEVgrzSdgx/8eexNLnX5+
         5HPvCslQnthoLOC5aZfk8bgyC98UchlaUbpPPcyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 034/334] crypto: qat - do not export adf_iov_putmsg()
Date:   Mon, 13 Sep 2021 15:11:28 +0200
Message-Id: <20210913131114.568937616@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 645ae0af1840199086c33e4f841892ebee73f615 ]

The function adf_iov_putmsg() is only used inside the intel_qat module
therefore should not be exported.
Remove EXPORT_SYMBOL for the function adf_iov_putmsg().

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 663638bb5c97..efa4bffb4f60 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -186,7 +186,6 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(adf_iov_putmsg);
 
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
-- 
2.30.2



