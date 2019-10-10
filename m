Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E28D24AF
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389841AbfJJItl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389839AbfJJItj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2440B218AC;
        Thu, 10 Oct 2019 08:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697378;
        bh=hjClmTpggnb7L6mcq55UzXAa9IIEoGjT4X6BTvjO7nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXwnPRpfDTRsA+RaSjJASFx8VUh0CkIUN1GC5D+4CafIAHuTQcqy4qWTFa8SOqPjl
         B9eyopdfhoc0C8zuJtlxG+d8hhcjLTZLPjyNXCEvlnBGYltMttiMY4m47kLpd3lA5Q
         TsAspoomustQfmxRJtQW1PmRZT6issoTPayUGwQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.19 091/114] arm64: docs: Document SSBS HWCAP
Date:   Thu, 10 Oct 2019 10:36:38 +0200
Message-Id: <20191010083612.904076126@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit ee91176120bd584aa10c564e7e9fdcaf397190a1 ]

We advertise the MRS/MSR instructions for toggling SSBS at EL0 using an
HWCAP, so document it along with the others.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/elf_hwcaps.txt |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/arm64/elf_hwcaps.txt
+++ b/Documentation/arm64/elf_hwcaps.txt
@@ -178,3 +178,7 @@ HWCAP_ILRCPC
 HWCAP_FLAGM
 
     Functionality implied by ID_AA64ISAR0_EL1.TS == 0b0001.
+
+HWCAP_SSBS
+
+    Functionality implied by ID_AA64PFR1_EL1.SSBS == 0b0010.


