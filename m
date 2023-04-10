Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0ED6DCADB
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 20:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjDJSii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 14:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJSih (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 14:38:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA02E63;
        Mon, 10 Apr 2023 11:38:36 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kt17so2308552ejb.11;
        Mon, 10 Apr 2023 11:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681151915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6ES1jInJXE7evTAiiVvJ4B0LrnjwfrosLFdTS3njiZg=;
        b=B6iBCVkG+cR1+fOZY7qGISLD3lPYamnsZFSnIJgz4z39cFNgWIXaehNf6CcN5NndBX
         s6TvA4Opw5WNuKngwKpDeTVOu1zI2x4rTS2f3JjxCnz5dTzlM6lEVbF78o+1tVTLCgF3
         6gSa30AaUOXu0s9o538zAICZ/1I9IZGZ1ZcyyaRRrED5774h+JN5S3adMFLwacEG4FV/
         2KgfNQra6k6aIUphWlXbapGV0YAlgOxcZMRf5pTKP1j5ceTmSbJ6LA7uroJAuX0A16A/
         4M/bmiexcHYQjkTJxfwZPdz8XO1P4jL8zAYuMhWjetHLZlwZ3jTGCBBrG83M0vxnmpPM
         aJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681151915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ES1jInJXE7evTAiiVvJ4B0LrnjwfrosLFdTS3njiZg=;
        b=iQ/ORwxsKacIZKi33UR11WpaqJXshftyscVHJq1d3SXZIPTXDlas8F0fLUN0wKBr4j
         e+h7YTf0V6Ux5pxJnXEVxu3+gho3bbCQmi0tjPpHKXY3mRP+257IL6GIcmOngtf1+VwJ
         nnUgQDV2aGXx+dEecrcenaMpUhLNlxNQR4/5NiqJXo8T/wajzu3rzGQ/2vgz6ieOmT10
         MzZhJhac4zsmiDpBVieq0nou2WwXxKxbJFWBu69rGqPGjpdc4ECw5Jx6CF2nlS55oixQ
         G6JSR/gZ1WKaUQuQTruoKX4r2LQiPiAE/kHBiXFswjzPc3tZnnBzYgkmVF1x/8rQVHPp
         XpSw==
X-Gm-Message-State: AAQBX9fqTKNnQe5xOVKRLK1O+HiWdsP6LqK2TSXwCeWEcN4MTU44dHEz
        +gL+dtjnryTiQZQ4eO2Cwn60eGrlRYEnJYltFGbwBQ==
X-Google-Smtp-Source: AKy350Y1LpknC1jb9Ian0Ak1N5oFZUyx8RoVLld7pvmNpHG3eGxr7/Byws4lR1g9PV0WnXEFDvccwQ==
X-Received: by 2002:a17:907:7d92:b0:94a:5195:7b6c with SMTP id oz18-20020a1709077d9200b0094a51957b6cmr7359536ejc.35.1681151915002;
        Mon, 10 Apr 2023 11:38:35 -0700 (PDT)
Received: from localhost.localdomain ([213.152.187.230])
        by smtp.gmail.com with ESMTPSA id jg7-20020a170907970700b0094bb4c75695sm630283ejc.194.2023.04.10.11.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 11:38:34 -0700 (PDT)
From:   Cem Kaya <cemkaya.boun@gmail.com>
To:     cemkaya.boun@gmail.com, tiwai@suse.com, perex@perex.cz
Cc:     mario.limonciello@amd.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        broonie@kernel.org, stable@vger.kernel.org
Subject: [PATCH v5] ASoC: amd: Add Dell G15 5525 to quirks list
Date:   Mon, 10 Apr 2023 20:38:15 +0200
Message-Id: <20230410183814.260518-1-cemkaya.boun@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add Dell G15 5525 Ryzen Edition to quirks list for acp6x so that
internal mic works.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217155
Cc: <stable@vger.kernel.org>
Signed-off-by: Cem Kaya <cemkaya.boun@gmail.com>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index a428e17f0325..e044d811496e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,13 @@ static struct snd_soc_card acp6x_card = {
 };

 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5525"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
--
2.40.0

