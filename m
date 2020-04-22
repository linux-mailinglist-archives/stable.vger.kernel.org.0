Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F2B1B4182
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgDVKJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgDVKJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:09:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C174320575;
        Wed, 22 Apr 2020 10:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550165;
        bh=no0cu/GcBoa4h31619A2Tv0ZNmB4vF9yJ80qWdtZ6os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqj2st/nlFZeIemZ/GYzBGdaQLjps7KqIkAn79UARvg3+reDi9vkI1rgbmkD6H0ff
         hCs1bFj1R8TmZ9XMa8DrHt5d0krjn+8kTRvc+9fK7tFrpOaW+ergeBdJ+7JObBgzk6
         c7KDBZFgRHjIIowh0sVVIad8VuXsGjVvueM4fkIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gyeongtaek Lee <gt82.lee@samsung.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 035/199] ASoC: topology: use name_prefix for new kcontrol
Date:   Wed, 22 Apr 2020 11:56:01 +0200
Message-Id: <20200422095101.557362470@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
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
@@ -421,7 +421,7 @@ static int soc_tplg_add_kcontrol(struct
 	struct snd_soc_component *comp = tplg->comp;
 
 	return soc_tplg_add_dcontrol(comp->card->snd_card,
-				comp->dev, k, NULL, comp, kcontrol);
+				comp->dev, k, comp->name_prefix, comp, kcontrol);
 }
 
 /* remove a mixer kcontrol */


