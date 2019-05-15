Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314051ECD9
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfEOLCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbfEOLCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43FE2173C;
        Wed, 15 May 2019 11:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918142;
        bh=d5wo8vYGjA4ushj1FhSQfwmlG17KPj5N5uvUqTaxhnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/LDOCZUBzvmFFK3CY1Ep1dMQF/B3310dIkeiLrSTq6a8qu0LQRlGphsWdP4yrdvh
         ZXx0Zn88AI6Zx9Qzq5875HChBFV1FVaQmwEn2KnSHIHw6Bk53HiOjYByglCF5ow10A
         rnxM1eUFPqXynwJmuvdeZ9GWq/65n5icJLfnU6bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 021/266] powerpc/pseries: Add new H_GET_CPU_CHARACTERISTICS flags
Date:   Wed, 15 May 2019 12:52:08 +0200
Message-Id: <20190515090723.311161132@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit c4bc36628d7f8b664657d8bd6ad1c44c177880b7 upstream.

Add some additional values which have been defined for the
H_GET_CPU_CHARACTERISTICS hypercall.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/hvcall.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -292,6 +292,9 @@
 #define H_CPU_CHAR_L1D_FLUSH_ORI30	(1ull << 61) // IBM bit 2
 #define H_CPU_CHAR_L1D_FLUSH_TRIG2	(1ull << 60) // IBM bit 3
 #define H_CPU_CHAR_L1D_THREAD_PRIV	(1ull << 59) // IBM bit 4
+#define H_CPU_CHAR_BRANCH_HINTS_HONORED	(1ull << 58) // IBM bit 5
+#define H_CPU_CHAR_THREAD_RECONFIG_CTRL	(1ull << 57) // IBM bit 6
+#define H_CPU_CHAR_COUNT_CACHE_DISABLED	(1ull << 56) // IBM bit 7
 
 #define H_CPU_BEHAV_FAVOUR_SECURITY	(1ull << 63) // IBM bit 0
 #define H_CPU_BEHAV_L1D_FLUSH_PR	(1ull << 62) // IBM bit 1


