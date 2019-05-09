Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9363190DE
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfEISt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfEISt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:49:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6865217F5;
        Thu,  9 May 2019 18:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427798;
        bh=sluI6ywh67Hf4Em0DA1/OQqFn2niaEOSF97FgzeYugY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px41kV4nozqm+atIWIvpkPaQzEU8kUKeYCrCw++VYXr6fkWX8VvM+bTlTivclzB0Q
         A778X5UQCAGYDZtvFQsI/ukXj4MS7NFxN1trswwjOeev0uU3IfQTZ8CUCM7HxCPD87
         3tbosPhdBTxUk7LJ/HrM3Gy781ZXkjx3acbxXmbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/66] ASoC: Intel: kbl: fix wrong number of channels
Date:   Thu,  9 May 2019 20:42:19 +0200
Message-Id: <20190509181306.500387669@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d6ba3f815bc5f3c4249d15c8bc5fbb012651b4a4 ]

Fix wrong setting on number of channels.  The context wants to set
constraint to 2 channels instead of 4.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
index a892b37eab7c9..b8a03f58ac8cc 100644
--- a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
@@ -406,7 +406,7 @@ static const struct snd_pcm_hw_constraint_list constraints_dmic_channels = {
 };
 
 static const unsigned int dmic_2ch[] = {
-	4,
+	2,
 };
 
 static const struct snd_pcm_hw_constraint_list constraints_dmic_2ch = {
-- 
2.20.1



