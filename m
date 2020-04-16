Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6582D1AC7F2
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgDPO7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898856AbgDPNyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F70921927;
        Thu, 16 Apr 2020 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045276;
        bh=g0JPxNPuqoHUzF/vEU+fleh3hf32aKcWMVB7AZyvb9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FQgdAFTyyIzPZMHVsOOYpPmAAmjYSL46dmDjZ1UXFEF6kLuZIYO/lSAo6WHVbtiH
         RS9TRLavEAYCVCEJE1RFezHfhbA8GQ9oxNFSPlqLbi8usREJZxLQaCHeoyKfYK61Eq
         Ey+/xnn8zfJL8/lffqVVQPbszCK2qZYQO92XQ2rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gyeongtaek Lee <gt82.lee@samsung.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 069/254] ASoC: topology: use name_prefix for new kcontrol
Date:   Thu, 16 Apr 2020 15:22:38 +0200
Message-Id: <20200416131334.504109395@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 이경택 <gt82.lee@samsung.com>

commit abca9e4a04fbe9c6df4d48ca7517e1611812af25 upstream.

Current topology doesn't add prefix of component to new kcontrol.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Link: https://lore.kernel.org/r/009b01d60804$ae25c2d0$0a714870$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -362,7 +362,7 @@ static int soc_tplg_add_kcontrol(struct
 	struct snd_soc_component *comp = tplg->comp;
 
 	return soc_tplg_add_dcontrol(comp->card->snd_card,
-				comp->dev, k, NULL, comp, kcontrol);
+				comp->dev, k, comp->name_prefix, comp, kcontrol);
 }
 
 /* remove a mixer kcontrol */


