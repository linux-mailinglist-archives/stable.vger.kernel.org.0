Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4552C8AF4
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgK3R1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgK3R1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 12:27:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE816C0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:26:18 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u12so17285363wrt.0
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=2FInVnp5hZW+3Fw12mVGe1Qq7S8Iq01KARhKMDsAJ5k=;
        b=eO/bg/kZBtVsuI6AZE9s+qoj3uEgmFf0JxFE1+7PL8Yzr3qaGFbHNN/HKzDu4kVn9T
         BcAVQWkEZYNP5jzlD/S/OyjfzJpRk02aRnaWZbLImL/Nl8k+pXRANxaSRoNed1kIKpf/
         s0pFap+ZZaKwgnGtY4+3y+1IkDT7l2pYTgohNsiuQPE+r9py+jaj8rLJQ3q+f0iJH8pk
         KlhY9AUZmsjHeM1vysq1EuXmBLJF7KAw4rvYN61HdBBs+ovESH2NEDA91Rn3ni3PWtEH
         5AlU9sifTKki5svux5op3xlQfuMBD4A3/XCgPSY6KTSgWPx9JWIX8rjBKcutIX3JGfvl
         yCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=2FInVnp5hZW+3Fw12mVGe1Qq7S8Iq01KARhKMDsAJ5k=;
        b=HVMwIG8KE3R2Oci+gMMi9/tDmHw6mntd5PMOldvBZ7AWPdJ7ghVrSAzLRlMS2OQqsX
         pQzZs2fjQIaxynosV2B01U7KCVlFlHrwSWgjfMSeTyKOQ7jUNCgNbNAx9l3eIHEoG/4N
         0w1gLHsyQkAYx39wRD+9u8jvHuAVER6Y8VOvQSG3hL5S6Km0yS1onJVlme+B68OUDHm+
         BJz/zkb2RMjMMiWSXG8SC7EPe3o9jNNKDLvGd97DRZUb7bfo/iXY8MgjFEMAW2NV8FyS
         Zr6EkWNOe89pMvKzsM3Ze9bVC1ZcCfqYctqRdMmaxIElcfIQW0/SO51CrpXlWodPv+Up
         9avQ==
X-Gm-Message-State: AOAM532K9PoPa6ROvEOm8uAfeo4aB0NVyNDs6n22kPvc3zO8sMNPHFys
        +NIIYUP34pEMGl8+7AcS8VM=
X-Google-Smtp-Source: ABdhPJx17K7okVA5bjHktiDsxL4I6QPlZDSagFZjWHIhFAUomr3Myx84d8SDpD2DXxSkGpAKRQgNpQ==
X-Received: by 2002:adf:eb08:: with SMTP id s8mr29361142wrn.12.1606757177420;
        Mon, 30 Nov 2020 09:26:17 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id v64sm25932858wme.25.2020.11.30.09.26.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Nov 2020 09:26:16 -0800 (PST)
Date:   Mon, 30 Nov 2020 17:26:15 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mirq-linux@rere.qmqm.pl, a.fatoum@pengutronix.de,
        broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] regulator: avoid resolve_supply()
 infinite recursion" failed to apply to 4.9-stable tree
Message-ID: <20201130172615.gghl3g7vtqrjbbao@debian>
References: <160612320295192@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="doyf26lp3fvyh6vr"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160612320295192@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--doyf26lp3fvyh6vr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 23, 2020 at 10:20:02AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--doyf26lp3fvyh6vr
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-regulator-avoid-resolve_supply-infinite-recursion.patch"
Content-Transfer-Encoding: 8bit

From 3ef096ea5d9ec8353a23109cd4d8a326743c7905 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Fri, 13 Nov 2020 01:20:28 +0100
Subject: [PATCH] regulator: avoid resolve_supply() infinite recursion
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 4b639e254d3d4f15ee4ff2b890a447204cfbeea9 upstream

When a regulator's name equals its supply's name the
regulator_resolve_supply() recurses indefinitely. Add a check
so that debugging the problem is easier. The "fixed" commit
just exposed the problem.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de> # stpmic1
Link: https://lore.kernel.org/r/c6171057cfc0896f950c4d8cb82df0f9f1b89ad9.1605226675.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/regulator/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0a0dd0aac047..89f14e301b4c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1550,6 +1550,12 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 		}
 	}
 
+	if (r == rdev) {
+		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
+			rdev->desc->name, rdev->supply_name);
+		return -EINVAL;
+	}
+
 	/* Recursively resolve the supply of the supply */
 	ret = regulator_resolve_supply(r);
 	if (ret < 0) {
-- 
2.11.0


--doyf26lp3fvyh6vr--
