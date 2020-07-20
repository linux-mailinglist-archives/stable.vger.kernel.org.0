Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D9622681C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387943AbgGTQRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388143AbgGTQQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB2D42176B;
        Mon, 20 Jul 2020 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261786;
        bh=30CXrEdiYVz1AylAF1x57ZnlAb8SkFQ3PCeoPQOpcKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNr274B41mELVgCk4w9Diw3SSkSIP4ZWm+t/SHtgm/XOQCouF0We/etZdlMogXEf9
         yPLM6w/uDy+dQ0rbHF3q9XpJV1IQmqIVyG4NNVjLyjtJmXxSj2Q0oJdhkqMJtEMhoc
         1zdVQRk9eJiRjpQ7lXVh1jgk5gNqgINsrE6tRwNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Alex Hung <alex.hung@canonical.com>
Subject: [PATCH 5.7 211/244] thermal: int3403_thermal: Downgrade error message
Date:   Mon, 20 Jul 2020 17:38:02 +0200
Message-Id: <20200720152835.889846161@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Hung <alex.hung@canonical.com>

commit f3d7fb38976b1b0a8462ba1c7cbd404ddfaad086 upstream.

Downgrade "Unsupported event" message from dev_err to dev_dbg to avoid
flooding with this message on some platforms.

Cc: stable@vger.kernel.org # v5.4+
Suggested-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Alex Hung <alex.hung@canonical.com>
[ rzhang: fix typo in changelog ]
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20200615223957.183153-1-alex.hung@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
@@ -74,7 +74,7 @@ static void int3403_notify(acpi_handle h
 						   THERMAL_TRIP_CHANGED);
 		break;
 	default:
-		dev_err(&priv->pdev->dev, "Unsupported event [0x%x]\n", event);
+		dev_dbg(&priv->pdev->dev, "Unsupported event [0x%x]\n", event);
 		break;
 	}
 }


