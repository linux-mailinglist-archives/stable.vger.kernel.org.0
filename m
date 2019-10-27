Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708E6E695B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfJ0Vfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfJ0VIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F75020B7C;
        Sun, 27 Oct 2019 21:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210517;
        bh=MbJJGwCPobPXC73iVz1NPLAWQ5aGkr8Eo6NSbR550Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swR2oESTSRZaWjW4oWfksFEOXt90FldNxoMnAeS1FxDV7wWrYdIwULPBzGNjfn5bB
         dobBu674tS9zrsOxg3Vt+7DLcEpr2C1Vk0QyQVLVKGPDO4K8i0YjtUvQswUvm1jMmE
         9P9l+T3VgTMG7TEiMx2RMmHKbxxxRxQmdJuCXAIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 041/119] arm64: Documentation: cpu-feature-registers: Remove RES0 fields
Date:   Sun, 27 Oct 2019 22:00:18 +0100
Message-Id: <20191027203315.175774322@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 847ecd3fa311cde0f10a1b66c572abb136742b1d ]

Remove the invisible RES0 field entries from the table, listing
fields in CPU ID feature registers, as :
 1) We are only interested in the user visible fields.
 2) The field description may not be up-to-date, as the
    field could be assigned a new meaning.
 3) We already explain the rules of the fields which are not
    visible.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ardb: fix up for missing SVE in context]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/cpu-feature-registers.txt |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -110,7 +110,6 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-52] |    n    |
      |--------------------------------------------------|
      | FHM                          | [51-48] |    y    |
      |--------------------------------------------------|
@@ -124,8 +123,6 @@ infrastructure:
      |--------------------------------------------------|
      | RDM                          | [31-28] |    y    |
      |--------------------------------------------------|
-     | RES0                         | [27-24] |    n    |
-     |--------------------------------------------------|
      | ATOMICS                      | [23-20] |    y    |
      |--------------------------------------------------|
      | CRC32                        | [19-16] |    y    |
@@ -135,8 +132,6 @@ infrastructure:
      | SHA1                         | [11-8]  |    y    |
      |--------------------------------------------------|
      | AES                          | [7-4]   |    y    |
-     |--------------------------------------------------|
-     | RES0                         | [3-0]   |    n    |
      x--------------------------------------------------x
 
 
@@ -144,7 +139,8 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-28] |    n    |
+     |--------------------------------------------------|
+     | SVE                          | [35-32] |    y    |
      |--------------------------------------------------|
      | GIC                          | [27-24] |    n    |
      |--------------------------------------------------|


