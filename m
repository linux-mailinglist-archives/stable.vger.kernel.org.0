Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7993499722
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446874AbiAXVJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbiAXVFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CEBC06809E;
        Mon, 24 Jan 2022 12:05:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C5D8B8122F;
        Mon, 24 Jan 2022 20:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF41C340E5;
        Mon, 24 Jan 2022 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054752;
        bh=T91MD1sr3C3+oB/nrJKahFEPd8Ny8PdZEwPdZdZ4y68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewYiTgURx4iqcurWVQNy8U3QxE8ikbuIEyzr1DGlzs7Ypdicbv5WUGfDigrZ8I5UL
         ioP4+pQJeQ9ISJIsbtGRft0llgQKRIZjizg9O0VrqiSOBBKdkVlSWRip2jAKhiAf/R
         lZCaiguVieFQegsTWMKL6tCQp55t7plnBgki4w00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 490/563] media: correct MEDIA_TEST_SUPPORT help text
Date:   Mon, 24 Jan 2022 19:44:15 +0100
Message-Id: <20220124184041.394183297@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit 09f4d1513267d0ab712f5d29e7bd136535748709 upstream.

Fix grammar/wording in the help text for MEDIA_TEST_SUPPORT.

Fixes: 4b32216adb01 ("media: split test drivers from platform directory")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -142,10 +142,10 @@ config MEDIA_TEST_SUPPORT
 	prompt "Test drivers" if MEDIA_SUPPORT_FILTER
 	default y if !MEDIA_SUPPORT_FILTER
 	help
-	  Those drivers should not be used on production Kernels, but
-	  can be useful on debug ones. It enables several dummy drivers
-	  that simulate a real hardware. Very useful to test userspace
-	  applications and to validate if the subsystem core is doesn't
+	  These drivers should not be used on production kernels, but
+	  can be useful on debug ones. This option enables several dummy drivers
+	  that simulate real hardware. Very useful to test userspace
+	  applications and to validate if the subsystem core doesn't
 	  have regressions.
 
 	  Say Y if you want to use some virtual test driver.


