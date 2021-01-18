Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8472FA9B3
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393793AbhARTIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390507AbhARLjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4502322227;
        Mon, 18 Jan 2021 11:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969938;
        bh=mvaNFAlw7j4xFI4gIfaMQt/1iJxGTU0GW3H2ruuMEEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA8zAb96YDaAnGdjrf4ORX6ss3hZ2oal4zCZHVBSZ3YrGWPGMDr8pmP/lAMYnvMbp
         KprD0hdlSkjH9u95ctqDedeGY79x/LebkcOIIBe6oTBC5Z5La7b/6MeL3phmGGxEUK
         0EQkKaMbTYikVIjlKO3nCTSXtgg+JKUCzw0Sa/Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Gupta <ajayg@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/76] usb: typec: Fix copy paste error for NVIDIA alt-mode description
Date:   Mon, 18 Jan 2021 12:34:45 +0100
Message-Id: <20210118113343.140849579@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



