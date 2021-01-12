Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9962F30AF
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbhALNJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404886AbhALM6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B3C23133;
        Tue, 12 Jan 2021 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456239;
        bh=mvaNFAlw7j4xFI4gIfaMQt/1iJxGTU0GW3H2ruuMEEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCxR+cETfXj1P0A953751xwwVGDivpKeME+1HOZ2F7I6B/Um6kBOFnKGRnUYmBlV9
         TOWUR7vVgMXH7ostqELSMwFKXG1CixGCDAwsWT9/Ux5Vv5pRR9IDzHpcWjwGJ+mU5P
         KR6n/Nrdp6gOKR2RfbRysLMzvg2dliD2Ckfvll/eoM5toHSc+5skfNMKWjYo2/PsVV
         g2kSGHvgUQzh1ZIb3oim9bZGufz0QJED/B9hSj224lrMdQPI8ttwJrh9ojA7opSzNN
         ZS+DkWKZwDSxgfX5M9BKYVKbS16gTYNPk9+71tSPYwiu7kF6m7F8PgQl+qlygHJy0B
         MlrLvYlkOmw4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Ajay Gupta <ajayg@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/28] usb: typec: Fix copy paste error for NVIDIA alt-mode description
Date:   Tue, 12 Jan 2021 07:56:41 -0500
Message-Id: <20210112125645.70739-25-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 41952a66015466c3208aac96b14ffd92e0943589 ]

The name of the module for the NVIDIA alt-mode is incorrect as it
looks to be a copy-paste error from the entry above, update it to
the correct typec_nvidia module name.

Cc: Ajay Gupta <ajayg@nvidia.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20210106001605.167917-1-pbrobinson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/altmodes/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/altmodes/Kconfig b/drivers/usb/typec/altmodes/Kconfig
index 187690fd1a5bd..60d375e9c3c7c 100644
--- a/drivers/usb/typec/altmodes/Kconfig
+++ b/drivers/usb/typec/altmodes/Kconfig
@@ -20,6 +20,6 @@ config TYPEC_NVIDIA_ALTMODE
 	  to enable support for VirtualLink devices with NVIDIA GPUs.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called typec_displayport.
+	  module will be called typec_nvidia.
 
 endmenu
-- 
2.27.0

