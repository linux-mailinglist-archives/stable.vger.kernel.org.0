Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B802B87FF
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 00:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgKRW7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 17:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgKRW7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 17:59:25 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB6FC0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 14:59:42 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id d142so5017040wmd.4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 14:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sNpwScfO3Y0odblfUrCk4hNby4XeGQMrWrWkh9Hjmlc=;
        b=T6y1ZpgFXBbct9bvpA0ku9CUq8jBTyYWnpr6mSQuBsHboef+z/kTk2A2Hjnm3KBvds
         j5YlCDKm/bxc5YLl59H4sLTKwwxJTnfuBNq2JxVardhaPv6r/dmBOKiaC2b/2Lkq+7jq
         kP54a3GQj7Sgd3NTn39G31/4RD0sR9FLFc9hqaO62BWsavgwnRlKV98GrP7+6z+CdZmB
         cHO964hY4h09WmXKX9x2rJ9zyf3/xn4bruRgKrjToHxhkU4Fy7JIgmdvIUv/L4DzHOD/
         0OCxUH5UEHE9+k8SDlAysT73fpPVXSgpqHg+yyUK1ViFBPdU4dD96MZqBMnoWtUQgD8S
         C2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sNpwScfO3Y0odblfUrCk4hNby4XeGQMrWrWkh9Hjmlc=;
        b=JnuqNOKuu9z/8zZOCMIyQIaPEOu8UFPJaRUB0DzmBFawAxa/RjL0GM6AFVkfhpQN9T
         qIkwMnT5z7omFAaSl6tNonvzsc4sKALWhR75Wk64/tqGc6wLGvWi7/o1Lkqmlyujlrhq
         zM7dcZtTjKE5XUGOnyIdq5CN2Yph0FEsSJewlVGYKVStM74XW3a4Z1Bk1pZqBzgk4vne
         2VsDgys3SjaWt/TPt97ax17Q3YyjA9JwJdynKrO81BVEtMfsEt93G1/dFA+Grs57+Qk+
         t7fqKXHh/YvWuorIw6DrlevIQVtHUJ/jzaeF16dDW14zN09pFGzDYfmCwEzP7dwnF/jN
         mcZg==
X-Gm-Message-State: AOAM5310HZmN5E+x876hFwp6AgK1HKdvp5LgojcAbMrwzWo8l3ZtCI+S
        9ihPepjr6Wm06Tfeb4nIT9U=
X-Google-Smtp-Source: ABdhPJwMBVZRxCGh08pdAVUZaDI71ufKnh+lf4zuMiYm4vPPHWdyTf+BjxiGlY+udIiqvyX7LUv9tQ==
X-Received: by 2002:a1c:7f90:: with SMTP id a138mr1394417wmd.61.1605740380616;
        Wed, 18 Nov 2020 14:59:40 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id 36sm19212488wrf.94.2020.11.18.14.59.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Nov 2020 14:59:39 -0800 (PST)
Date:   Wed, 18 Nov 2020 22:59:38 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ultracoolguy@tutanota.com, pavel@ucw.cz, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] leds: lm3697: Fix out-of-bound access"
 failed to apply to 5.9-stable tree
Message-ID: <20201118225938.5nvkjdhc4st2zs57@debian>
References: <160440470667193@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wi7653cylwlgecbf"
Content-Disposition: inline
In-Reply-To: <160440470667193@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wi7653cylwlgecbf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Tue, Nov 03, 2020 at 12:58:26PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Please consider for 5.9-stable.

--
Regards
Sudip

--wi7653cylwlgecbf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-leds-lm3697-Fix-out-of-bound-access.patch"

From cbaecee1e0a2aee549ecbe7f2f66a767794faef8 Mon Sep 17 00:00:00 2001
From: Gabriel David <ultracoolguy@tutanota.com>
Date: Fri, 2 Oct 2020 18:27:00 -0400
Subject: [PATCH] leds: lm3697: Fix out-of-bound access

commit 98d278ca00bd8f62c8bc98bd9e65372d16eb6956 upstream

If both LED banks aren't used in device tree, an out-of-bounds
condition in lm3697_init occurs because of the for loop assuming that
all the banks are used.  Fix it by adding a variable that contains the
number of used banks.

Signed-off-by: Gabriel David <ultracoolguy@tutanota.com>
[removed extra rename, minor tweaks]
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: stable@kernel.org
[sudip: use client->dev]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/leds/leds-lm3697.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lm3697.c b/drivers/leds/leds-lm3697.c
index 024983088d59..31f5ed486839 100644
--- a/drivers/leds/leds-lm3697.c
+++ b/drivers/leds/leds-lm3697.c
@@ -78,6 +78,7 @@ struct lm3697 {
 	struct mutex lock;
 
 	int bank_cfg;
+	int num_banks;
 
 	struct lm3697_led leds[];
 };
@@ -180,7 +181,7 @@ static int lm3697_init(struct lm3697 *priv)
 	if (ret)
 		dev_err(&priv->client->dev, "Cannot write OUTPUT config\n");
 
-	for (i = 0; i < LM3697_MAX_CONTROL_BANKS; i++) {
+	for (i = 0; i < priv->num_banks; i++) {
 		led = &priv->leds[i];
 		ret = ti_lmu_common_set_ramp(&led->lmu_data);
 		if (ret)
@@ -307,8 +308,8 @@ static int lm3697_probe(struct i2c_client *client,
 	int ret;
 
 	count = device_get_child_node_count(&client->dev);
-	if (!count) {
-		dev_err(&client->dev, "LEDs are not defined in device tree!");
+	if (!count || count > LM3697_MAX_CONTROL_BANKS) {
+		dev_err(&client->dev, "Strange device tree!");
 		return -ENODEV;
 	}
 
@@ -322,6 +323,7 @@ static int lm3697_probe(struct i2c_client *client,
 
 	led->client = client;
 	led->dev = &client->dev;
+	led->num_banks = count;
 	led->regmap = devm_regmap_init_i2c(client, &lm3697_regmap_config);
 	if (IS_ERR(led->regmap)) {
 		ret = PTR_ERR(led->regmap);
-- 
2.11.0


--wi7653cylwlgecbf--
