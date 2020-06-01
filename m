Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349961EAE79
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgFASCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFASB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB0E206E2;
        Mon,  1 Jun 2020 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034519;
        bh=/4637NbNSalGR1WbQ+D0T8p0c9koBNKpPYJadN9wFaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrb0lcH7qd4mjVXR5wDBk1iqQmMMevKGpcPYZ2rH74Z1NoRj0yLChZQnnPPrHS6bw
         blyVjRwYVa/9K/dndgO8c+/UmpgTpcES0VHOuTv/EPs7ayhdyRQoJLdWxhdAeDxSDZ
         PbgozBcJE+JywDNVJLUEgVHqrXPCBuAs+Xn5NxI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony@phenome.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.14 60/77] xfrm: fix error in comment
Date:   Mon,  1 Jun 2020 19:54:05 +0200
Message-Id: <20200601174026.810456440@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
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
 	XFRMA_OUTPUT_MARK,	/* __u32 */
 	__XFRMA_MAX
 


