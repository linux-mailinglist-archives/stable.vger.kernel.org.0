Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7895CA828
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389182AbfJCQWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390246AbfJCQWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 055D420659;
        Thu,  3 Oct 2019 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119726;
        bh=oRV+leRlKcDaDL3Mq6cSLuxvma0IMKsByFJp4UgJ0xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Egudr22gVQmt3IU5tMs30jzub8AeM/rHR2J3UFax1AF6DSJHq0up3UV713YGDbpYd
         t2eojIhzjdnaQUjnPFQVM7k9G78zk1ZyGNFXR3ktTAOP46I0/a7He9CJCfutM0vWcE
         IDyTV5M0BQqHBjATyRoUxSwboeG4BjakEv3NMOzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 171/211] ASoC: Intel: NHLT: Fix debug print format
Date:   Thu,  3 Oct 2019 17:53:57 +0200
Message-Id: <20191003154526.280940544@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@intel.com>

commit 855a06da37a773fd073d51023ac9d07988c87da8 upstream.

oem_table_id is 8 chars long, so we need to limit it, otherwise it
may print some unprintable characters into dmesg.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
Link: https://lore.kernel.org/r/20190827141712.21015-7-amadeuszx.slawinski@linux.intel.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/skylake/skl-nhlt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/skylake/skl-nhlt.c
+++ b/sound/soc/intel/skylake/skl-nhlt.c
@@ -231,7 +231,7 @@ int skl_nhlt_update_topology_bin(struct
 	struct hdac_bus *bus = skl_to_bus(skl);
 	struct device *dev = bus->dev;
 
-	dev_dbg(dev, "oem_id %.6s, oem_table_id %8s oem_revision %d\n",
+	dev_dbg(dev, "oem_id %.6s, oem_table_id %.8s oem_revision %d\n",
 		nhlt->header.oem_id, nhlt->header.oem_table_id,
 		nhlt->header.oem_revision);
 


