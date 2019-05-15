Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256051F357
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfEOLFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbfEOLFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:05:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D06A2173C;
        Wed, 15 May 2019 11:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918311;
        bh=sb0bao1y/xAg9q+Mt9oaQ9Mqs1ec3BH3q5+p89URtCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnxy1tJi2h0GxRYezUvJdVzDeEC+bk3X7MasqqnnARfYACyzjojkmkt1yRI3TpDOq
         oYy1gR6taieBZnKTj9q+z52+FEE9lp5ZfaKAYcvG6VVr+c6UM7uq8D6+8av8rJXmLy
         DhCRv46qiFtXCR9j96fNgApdf4r1k1+qQZ9gc+F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 086/266] Documentation: Add nospectre_v1 parameter
Date:   Wed, 15 May 2019 12:53:13 +0200
Message-Id: <20190515090725.353417056@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 26cb1f36c43ee6e89d2a9f48a5a7500d5248f836 upstream.

Currently only supported on powerpc.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/kernel-parameters.txt |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2450,6 +2450,10 @@ bytes respectively. Such letter suffixes
 
 	nohugeiomap	[KNL,x86] Disable kernel huge I/O mappings.
 
+	nospectre_v1	[PPC] Disable mitigations for Spectre Variant 1 (bounds
+			check bypass). With this option data leaks are possible
+			in the system.
+
 	nospectre_v2	[X86,PPC_FSL_BOOK3E] Disable all mitigations for the Spectre variant 2
 			(indirect branch prediction) vulnerability. System may
 			allow data leaks with this option, which is equivalent


