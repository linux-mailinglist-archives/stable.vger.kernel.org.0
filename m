Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AB3499AE1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379039AbiAXVrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58642 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456908AbiAXVkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:40:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C73460917;
        Mon, 24 Jan 2022 21:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D54DC340E4;
        Mon, 24 Jan 2022 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060421;
        bh=ynCVUXTQ7FnnlhknExewIhvw4SXgBbC5W0Plz7G5ZNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qi+J/KVunaGM9jIRnboI5Tc741k0Vz0/MpwyywX+IORPvx7FYp/rOE86iIJfLkh8c
         WS9Z0zebgmxP/l6kIjI1EZUPO+AXoz9VDTD2W2No4Vxhnx07kS7Qs/UdCnZLZUKPdf
         awTklIUuaWW2S6IWZuBSSUhCTMKb0LB1CUeUbSrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.16 0909/1039] media: correct MEDIA_TEST_SUPPORT help text
Date:   Mon, 24 Jan 2022 19:44:58 +0100
Message-Id: <20220124184155.851593460@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -141,10 +141,10 @@ config MEDIA_TEST_SUPPORT
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


