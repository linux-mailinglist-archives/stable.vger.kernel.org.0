Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF2F7CC7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfKKStk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbfKKStj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E9BF2196E;
        Mon, 11 Nov 2019 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498179;
        bh=D03FbkINy8pWphCDkromMYehvnnp0DVM830IyFvIAPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ltrnrr7PTCy50/7RC/zp8pRReVW6fqMMpvA+Gjrl9ayrv43wbubGnHaMGbuA7V/Hz
         xhsHEYgcSNo+j+zNG/ZKFr+YizMYNdEwjSmdiyhUwiilDi19OtpM/47iGrb6gYWUVc
         MFyYY3Kn2VSOG70Ip72Ul2S3/ODQdNWL1PI94bNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.3 045/193] soundwire: depend on ACPI
Date:   Mon, 11 Nov 2019 19:27:07 +0100
Message-Id: <20191111181504.298610860@linuxfoundation.org>
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

commit 52eb063d153ac310058fbaa91577a72c0e7a7169 upstream.

The device cannot be probed on !ACPI and gives this warning:

drivers/soundwire/slave.c:16:12: warning: ‘sdw_slave_add’ defined but
not used [-Wunused-function]
 static int sdw_slave_add(struct sdw_bus *bus,
            ^~~~~~~~~~~~~

Cc: stable@vger.kernel.org
Fixes: 7c3cd189b86d ("soundwire: Add Master registration")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Link: https://lore.kernel.org/r/bd685232ea511251eeb9554172f1524eabf9a46e.1570097621.git.msuchanek@suse.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soundwire/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soundwire/Kconfig
+++ b/drivers/soundwire/Kconfig
@@ -5,6 +5,7 @@
 
 menuconfig SOUNDWIRE
 	tristate "SoundWire support"
+	depends on ACPI
 	help
 	  SoundWire is a 2-Pin interface with data and clock line ratified
 	  by the MIPI Alliance. SoundWire is used for transporting data


