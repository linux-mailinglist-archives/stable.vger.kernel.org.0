Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52292C8B3E
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387719AbgK3Rfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387718AbgK3Rfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 12:35:44 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2B8C0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:34:58 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k10so165wmi.3
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=nl1vF1qnQqqnKv1efG5fhZvzavliL644p9JgP5iHWaY=;
        b=Imwve/J2MCcF9i9OPI1mgpVbU5j6u8o0qbgqG3e5oCc0pAtr9FvrUoKi1n23zLA4Of
         y04v7t/s82Dq8bPB4qe/lNrhsQzz6NIILlIgq9KyzN8y//fFuvcBWu8O2rCbh/8DQXvR
         5XJ4qqdClHxgmJ0gxizeYDOE75uDV7W7ezjHFT/6prKQz1hySAdmEGvtbPCBaMG+8c5w
         9EVAu4jgz49mOuIJsO5Unj0kHhMorIez8ua4H7usE90Mt1EtaqfQd/yeQAIq+5ZXR1+p
         DOE8PyxPjmcRN+2DEYZJGEKeYWpV/yYUN0V3RZTCRlAnGU5HTlJI3hw7EAhe2dCQv6IP
         03qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=nl1vF1qnQqqnKv1efG5fhZvzavliL644p9JgP5iHWaY=;
        b=RMkrqB15/TWtZZsYDyoiOsDAGyBCfP6D+v/NImDDlMmev4GMedSOv5ogRxNC9W15m+
         OeBJuWaJ9lfkL/XIa1Gh0EVj/iqXBhMWpRmcRljw/a0uZxtr8EAApEn4sR4Frq+eqSzw
         GUAsCxnf6U8f9ezHFNXXJCbSvQSAW8LszJbxmh/nfGX7zDqTUvmBq/l9COu6FXhEZ+3Q
         pK53m65PCKU3hFmCg9ON7YWyTfQfCUaHGvLFYX4ooq7cPEAOZjGEcHTuJJ+xvIMT+4qI
         /YH/m5B4CB+HQfNMd6BvK/XcDtitEVfcmUvG7qHzIxR4vSjFC+7e6ScxyKSS7tu8jlow
         H1iw==
X-Gm-Message-State: AOAM530szy1/nrbvZLuPVQp1HlsfXYWJsHYHeY8a75+SL3dMU2gQEELV
        r4d/vYYMCrQjeHru3QTu1MGsXP2wNJ6/Xw==
X-Google-Smtp-Source: ABdhPJwXT2mdP6wvOOmlaBtAXQIPq4CYAVj5MCtOvzoPaH0nVzEnFz3Uivpc67GIwgNN+631Vjqezw==
X-Received: by 2002:a1c:6484:: with SMTP id y126mr8497433wmb.76.1606757697049;
        Mon, 30 Nov 2020 09:34:57 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id k11sm19282872wmj.42.2020.11.30.09.34.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Nov 2020 09:34:56 -0800 (PST)
Date:   Mon, 30 Nov 2020 17:34:54 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mirq-linux@rere.qmqm.pl, a.fatoum@pengutronix.de,
        broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] regulator: workaround self-referent
 regulators" failed to apply to 4.9-stable tree
Message-ID: <20201130173454.7wknj2obm23f4an7@debian>
References: <160612321754170@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pet2zb7wzyoug5qf"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160612321754170@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pet2zb7wzyoug5qf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 23, 2020 at 10:20:17AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. It needs to be applied after the backport of
4b639e254d3d ("regulator: avoid resolve_supply() infinite recursion")
which is in the separate 'failed' mail.

--
Regards
Sudip

--pet2zb7wzyoug5qf
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-regulator-workaround-self-referent-regulators.patch"
Content-Transfer-Encoding: 8bit

From abc4b7b56078b9b796305d3f3707ebcdf136d106 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Fri, 13 Nov 2020 01:20:28 +0100
Subject: [PATCH] regulator: workaround self-referent regulators
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit f5c042b23f7429e5c2ac987b01a31c69059a978b upstream

Workaround regulators whose supply name happens to be the same as its
own name. This fixes boards that used to work before the early supply
resolving was removed. The error message is left in place so that
offending drivers can be detected.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de> # stpmic1
Link: https://lore.kernel.org/r/d703acde2a93100c3c7a81059d716c50ad1b1f52.1605226675.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/regulator/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 89f14e301b4c..23323add5b0b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1553,7 +1553,10 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
-		return -EINVAL;
+		if (!have_full_constraints())
+			return -EINVAL;
+		r = dummy_regulator_rdev;
+		get_device(&r->dev);
 	}
 
 	/* Recursively resolve the supply of the supply */
-- 
2.11.0


--pet2zb7wzyoug5qf--
