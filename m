Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1FE1EAD58
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgFASoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbgFASKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C77AA2065C;
        Mon,  1 Jun 2020 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035024;
        bh=rcGXyxVBSk7HlozhEm2slr0mzTvuHZEvCmq80wwX4hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LX2iilVGQlHRXGv5q7/Usjfzv081/ibTK39zCnk+wbH4UfrpAcUFldigGpcIHUVGm
         /dEeMeHhVvMH9RREHoj/tmQXJopdl7KzsHiktU64As8Jcx7gQhDh4f+3sdQM/G7jsG
         Bl0bKkTdaCa8JjNB5b3QHcIvRM3Ckn35CZpYEoW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony@phenome.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 119/142] xfrm: fix error in comment
Date:   Mon,  1 Jun 2020 19:54:37 +0200
Message-Id: <20200601174050.163798394@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony@phenome.org>

commit 29e4276667e24ee6b91d9f91064d8fda9a210ea1 upstream.

s/xfrm_state_offload/xfrm_user_offload/

Fixes: d77e38e612a ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Antony Antony <antony@phenome.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/xfrm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -304,7 +304,7 @@ enum xfrm_attr_type_t {
 	XFRMA_PROTO,		/* __u8 */
 	XFRMA_ADDRESS_FILTER,	/* struct xfrm_address_filter */
 	XFRMA_PAD,
-	XFRMA_OFFLOAD_DEV,	/* struct xfrm_state_offload */
+	XFRMA_OFFLOAD_DEV,	/* struct xfrm_user_offload */
 	XFRMA_SET_MARK,		/* __u32 */
 	XFRMA_SET_MARK_MASK,	/* __u32 */
 	XFRMA_IF_ID,		/* __u32 */


