Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC6B66E23
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfGLMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729180AbfGLMbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141D8208E4;
        Fri, 12 Jul 2019 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934695;
        bh=C2kVbOxnYchY6oyzR+KFZl/MXbCAOU6/w+nsh/3S6nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=os8q6EYYPyD+lMkZGWjTUJkqnSOOvzser9E+9KqjyPCnnYv8Ei1REbWvIooZVz86n
         MQNHiMbw1OHqcqVjDA5/WymL5ndCMrhl7NT11ux8w5sBws3g4quOe4FjAIaUcp0xPy
         9t/7iDzDH7qIyCBk038Q68G0VWU9oOvG+GIiAHH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: [PATCH 5.1 122/138] staging: mt7621-pci: fix PCIE_FTS_NUM_LO macro
Date:   Fri, 12 Jul 2019 14:19:46 +0200
Message-Id: <20190712121633.424283813@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit 0ae0cf509d28d8539b88b5f7f24558f5bfe57cdf upstream.

Add missing parenthesis to PCIE_FTS_NUM_LO macro to do the
same it was being done in original code.

Fixes: a4b2eb912bb1 ("staging: mt7621-pci: rewrite RC FTS configuration")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/mt7621-pci/pci-mt7621.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -40,7 +40,7 @@
 /* MediaTek specific configuration registers */
 #define PCIE_FTS_NUM			0x70c
 #define PCIE_FTS_NUM_MASK		GENMASK(15, 8)
-#define PCIE_FTS_NUM_L0(x)		((x) & 0xff << 8)
+#define PCIE_FTS_NUM_L0(x)		(((x) & 0xff) << 8)
 
 /* rt_sysc_membase relative registers */
 #define RALINK_PCIE_CLK_GEN		0x7c


