Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4AD2DD1DA
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 14:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgLQNGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 08:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQNGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 08:06:48 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CBFC061794
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 05:06:08 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u18so57140076lfd.9
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 05:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZtWGzuysSWKbzOtA9aKqff+RXT8SeMJQrKTIiGkLXlA=;
        b=skT21vv8lIa2uvSWRLVkO0L4xDW1tkdv0vL+Oxl2rQ9REMRw1ikTL/FTTNzk/XgJxx
         7eN+7GELuVusEB/bY8DcdGb6S8YWTnQgFxJzGTRhbUBN7ZwfsArssi9fu2copLhoS0wX
         dRa4yoJ5y/eJNAWGDAAEvu5DGPI3siis+1CjVkaVc6GAwCDpftNXXSvuJUq+PwvwTqjc
         dPHuV7O/zXFYuayKhOkM9RIY6iGSHe6cfbT0Zzjd/lLTCsppyRLmGiiUu0g7JuQ0yqsC
         Am3JUt5hYrwWKBG87yNHYYOTZdNJmcJkjiBQuSF6d8fDzV0XqVtWIn56D94Mw/9/8+VM
         ePiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZtWGzuysSWKbzOtA9aKqff+RXT8SeMJQrKTIiGkLXlA=;
        b=eanD42pJp6wrjWmX8rGi6txNmwZxBmn9No912xK1Fu+qT+9L2yPZqS/2wh+EIe82jk
         bx0tCLgYHcwJHEHr+nxLq9MDOoeeIhP9NOOpML9b8dhxYHVuJx1ezO+W6r0EG2ww4/9U
         W1RMAWWDLrpJzj9zOQ2GnawfiymGUjaDFXrYtdAC8ZNUVeS2I6GmUA8DtuO5pn2sCRry
         7+cCYtkiQnQigy/LqFCsEIKDzutCj6DBwD9JnBltaJVTSteBJLuTJXSNlbplEHTLRi2f
         ECBTo4PIkCOR8kLNR4yf7rzmBf5tWLkU4pYx6UKEsb4WghMZoxUvYzIswW3PtNkgjisE
         f3Hw==
X-Gm-Message-State: AOAM533qKuuhNT0+Jd/9Xf6KByZhyJKvVcBTVdXvKDDVphw9e4awAjz+
        WeQKfY7Ptpu1Iw8AiKkrpwLsZA==
X-Google-Smtp-Source: ABdhPJwwPduYP2ZedrJ0ohGFfg/MCXb/WkmLVdkdQBc1tvJGT8d58jzhHiGaw+o0Ok5LrtYH3ZgyIw==
X-Received: by 2002:a19:f11e:: with SMTP id p30mr14449368lfh.395.1608210366471;
        Thu, 17 Dec 2020 05:06:06 -0800 (PST)
Received: from localhost.localdomain (89-70-221-122.dynamic.chello.pl. [89.70.221.122])
        by smtp.gmail.com with ESMTPSA id n10sm656201ljg.139.2020.12.17.05.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 05:06:05 -0800 (PST)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alex Levin <levinale@google.com>,
        Guenter Roeck <groeck@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] ASoC: Intel: Skylake: Check the kcontrol against NULL
Date:   Thu, 17 Dec 2020 14:04:39 +0100
Message-Id: <20201217130439.141943-1-lma@semihalf.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201210121438.7718-1-lma@semihalf.com>
References: <20201210121438.7718-1-lma@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is no check for the kcontrol against NULL and in some cases
it causes kernel to crash.

Fixes: 2d744ecf2b984 ("ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHLT")
Cc: <stable@vger.kernel.org> # 5.4+
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Reviewed-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
---
 sound/soc/intel/skylake/skl-topology.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)
 v1 -> v2: fixed coding style

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index ae466cd592922..8f0bfda7096a9 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -3618,12 +3618,18 @@ static void skl_tplg_complete(struct snd_soc_component *component)
 	int i;
 
 	list_for_each_entry(dobj, &component->dobj_list, list) {
-		struct snd_kcontrol *kcontrol = dobj->control.kcontrol;
-		struct soc_enum *se =
-			(struct soc_enum *)kcontrol->private_value;
-		char **texts = dobj->control.dtexts;
+		struct snd_kcontrol *kcontrol;
+		struct soc_enum *se;
+		char **texts;
 		char chan_text[4];
 
+		kcontrol = dobj->control.kcontrol;
+		if (!kcontrol)
+			continue;
+
+		se = (struct soc_enum *)kcontrol->private_value;
+		texts = dobj->control.dtexts;
+
 		if (dobj->type != SND_SOC_DOBJ_ENUM ||
 		    dobj->control.kcontrol->put !=
 		    skl_tplg_multi_config_set_dmic)
-- 
2.25.1

