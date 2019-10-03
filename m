Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F27DC9BE9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 12:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfJCKOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 06:14:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:44174 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728356AbfJCKOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 06:14:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2359ABC4;
        Thu,  3 Oct 2019 10:14:35 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     alsa-devel@alsa-project.org
Cc:     Michal Suchanek <msuchanek@suse.de>, Vinod Koul <vkoul@kernel.org>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 2/2] soundwire: depend on ACPI || OF
Date:   Thu,  3 Oct 2019 12:13:55 +0200
Message-Id: <0b89b4ea16a93f523105c81a2f718b0cd7ec66f2.1570097621.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002081717.GA4015@kitsune.suse.cz>
References: <20191002081717.GA4015@kitsune.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now devicetree is supported for probing soundwire as well.

On platforms built with !ACPI !OF (ie s390x) the device still cannot be
probed and gives a build warning.

Cc: stable@vger.kernel.org
Fixes: a2e484585ad3 ("soundwire: core: add device tree support for slave devices")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/soundwire/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.23.0

