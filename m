Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26805499412
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357366AbiAXUim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385518AbiAXUd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F8DC07E2A0;
        Mon, 24 Jan 2022 11:45:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDFD96135E;
        Mon, 24 Jan 2022 19:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD21C340E5;
        Mon, 24 Jan 2022 19:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053543;
        bh=xRnyQmwYcD9vW2Ti96mi22e8rUe5cVVNvbs1/irgqsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnXDZXPKm8O758/O6CbmKUw8mw5pfs8wjU0OrIdL+jPB+JPLFBn+/qHWNwW0nEYDJ
         3Neaoy6j4dKE1sZ7KhRa10TnvN3rR/TM9ZhuYTcbBl3q1ZCcizaOfL0Urw3Kna5JTk
         KiDntC9pxVo5p7ztVVbzI1rYIdOKxedl1uGhpuEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/563] crypto: qat - fix spelling mistake: "messge" -> "message"
Date:   Mon, 24 Jan 2022 19:37:43 +0100
Message-Id: <20220124184027.789163111@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

[ Upstream commit f17a25cb1776c5712e950aaf326528ae652a086c ]

Trivial fix to spelling mistake in adf_pf2vf_msg.c and adf_vf2pf_msg.c.
s/messge/message/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 2 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index d7ca222f0df18..e3da97286980e 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -176,7 +176,7 @@ out:
  * @msg:	Message to send
  * @vf_nr:	VF number to which the message will be sent
  *
- * Function sends a messge from the PF to a VF
+ * Function sends a message from the PF to a VF
  *
  * Return: 0 on success, error code otherwise.
  */
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index 54b738da829d8..3e25fac051b25 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -8,7 +8,7 @@
  * adf_vf2pf_notify_init() - send init msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
- * Function sends an init messge from the VF to a PF
+ * Function sends an init message from the VF to a PF
  *
  * Return: 0 on success, error code otherwise.
  */
@@ -31,7 +31,7 @@ EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
  * adf_vf2pf_notify_shutdown() - send shutdown msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
- * Function sends a shutdown messge from the VF to a PF
+ * Function sends a shutdown message from the VF to a PF
  *
  * Return: void
  */
-- 
2.34.1



