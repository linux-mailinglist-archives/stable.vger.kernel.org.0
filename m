Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5113F7CC9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfKKStn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbfKKStm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B413D2196E;
        Mon, 11 Nov 2019 18:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498182;
        bh=RF3i8XQXA/P8MCYULmJjtjJcPHkH+pOzPdHHvAymfSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZ6PAFpiNm0FPNKcPhGGKcBaMPmxgGwEtj+5fnMdzXHVDcCRrCQnsCEEcxwOQNnlV
         jREJ6lyPILq9oR0tLMBGxoZKh00J2b3Qf2xV8c4pZDP+wO5YoE393cMImA1W4pTXU3
         AOYWKd6jWGaq1JSrfP3ClgkP3urj81+GJArzcuaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.3 046/193] soundwire: depend on ACPI || OF
Date:   Mon, 11 Nov 2019 19:27:08 +0100
Message-Id: <20191111181504.364113786@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

commit 0f8c0f8a7782178c40157b2feb6a532493cbadd3 upstream.

Now devicetree is supported for probing soundwire as well.

On platforms built with !ACPI !OF (ie s390x) the device still cannot be
probed and gives a build warning.

Cc: stable@vger.kernel.org
Fixes: a2e484585ad3 ("soundwire: core: add device tree support for slave devices")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Link: https://lore.kernel.org/r/0b89b4ea16a93f523105c81a2f718b0cd7ec66f2.1570097621.git.msuchanek@suse.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/soundwire/Kconfig b/drivers/soundwire/Kconfig
index c73bfbaa2659..c8c80df090d1 100644
--- a/drivers/soundwire/Kconfig
+++ b/drivers/soundwire/Kconfig
@@ -5,7 +5,7 @@
 
 menuconfig SOUNDWIRE
 	tristate "SoundWire support"
-	depends on ACPI
+	depends on ACPI || OF
 	help
 	  SoundWire is a 2-Pin interface with data and clock line ratified
 	  by the MIPI Alliance. SoundWire is used for transporting data


