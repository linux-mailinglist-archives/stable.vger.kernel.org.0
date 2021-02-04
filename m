Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4630F778
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbhBDQQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbhBDQPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 11:15:39 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A22CC0613D6
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 08:14:59 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id c12so4154693wrc.7
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 08:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lGDWM4ZDPx277jZaHlL7zriplUsHdOv42QOl6uz5u9g=;
        b=ClhmVDmXggWOyQ1fLn/HmhCDpDVdZefmw3V2RUY5L+LZDi/ywZ2xC/sAy9OywRpB6Y
         oow236Kw6+QOW0dNMekZvYOvlTxGG10D952V5S6REl4T2Yh5Zp2fClVGxS/HVsIKTEkT
         1heuV1gLXJROVtHZ0RyW+5g/PwVvscy5T1j0Lv4uHSkf6kLh3PokRW+WWh35qGxkv3Rq
         1yDTbnMTlLMoxZT/GEP5G1Nzrr9sMf5bnQ5M7s251i6U/DviPuugDWQtvIRVrwy6HshK
         UYSZIcY5vBCb297yYfw1BSAG1h5Tb1KnjKDanxI40ATeJwTI281HbDS5WWvsPzyGKStg
         lFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lGDWM4ZDPx277jZaHlL7zriplUsHdOv42QOl6uz5u9g=;
        b=Q1uEcWk2TNAjSp4AuTOT26zF0OUqvOY/DQAPKo8b9O8QGhAr3Fv/nyjj+PS8HiqU/g
         XS7trokNZPJ73MUxMwr37JE62ddIYSlpiJwdEyliAsbTqx5F9BPIkKUar68Ug1ym2fkZ
         N+S9dgFIlJSnDPwGYh+awpk0D2OVMqf+yd4kIak2AlhT6JMya0nXX3WDGn3EFhndtJ2T
         NLN8ED4/8BUOjxsHD5sVKOX/choWDzPKPS3IghOWXnYva2ZC5tRfJFwThhGeAe1lN3Kz
         6MO0IkUsapfH12udXW5Y2c3ymxtXXUjKkzlUxG5v+mxLq4no3ps9XaNJz5HbGlxRHLEd
         lnqg==
X-Gm-Message-State: AOAM5337GC4uBj5BvjffUs3YNUjlkfpHp84W2wTCT7d81tDwidrgpm0K
        IDRBJ+9yCelO7Z/8dT7ITjo=
X-Google-Smtp-Source: ABdhPJzT0xtDmvZ5mQUmcNJepxgOfOErp96lCZ00ddGoCc7HCTikzeWKyP2DdiIKhF0QTwvGN1G7Yw==
X-Received: by 2002:a05:6000:12c7:: with SMTP id l7mr54916wrx.103.1612455298180;
        Thu, 04 Feb 2021 08:14:58 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id x9sm7042556wmb.14.2021.02.04.08.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 08:14:57 -0800 (PST)
Date:   Thu, 4 Feb 2021 16:14:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     rafael.j.wysocki@intel.com, saravanak@google.com,
        stable@vger.kernel.org, stephan@gerhold.net
Subject: Re: FAILED: patch "[PATCH] driver core: Extend
 device_is_dependent()" failed to apply to 4.14-stable tree
Message-ID: <YBwdf9Qx0XG72AWH@debian>
References: <161158456921623@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OnPtTHUMrhls4Fk5"
Content-Disposition: inline
In-Reply-To: <161158456921623@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OnPtTHUMrhls4Fk5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 25, 2021 at 03:22:49PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with:
e16f4f3e0b7d ("base: core: Remove WARN_ON from link dependencies check") for
easy backporting.

--
Regards
Sudip

--OnPtTHUMrhls4Fk5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-base-core-Remove-WARN_ON-from-link-dependencies-chec.patch"

From f39c5cb27e89fbfc98d744ba57f50c09928e5b95 Mon Sep 17 00:00:00 2001
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Mon, 16 Jul 2018 13:37:44 +0200
Subject: [PATCH 1/2] base: core: Remove WARN_ON from link dependencies check

commit e16f4f3e0b7daecd48d4f944ab4147c1a6cb16a8 upstream

In some cases the link between between customer and supplier
already exist, for example when a device use its parent as a supplier.
Do not warn about already existing dependencies because device_link_add()
takes care of this case.

Link: http://lkml.kernel.org/r/20180709111753eucas1p1f32e66fb2f7ea3216097cd72a132355d~-rzycA5Rg0378203782eucas1p1C@eucas1p1.samsung.com

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/base/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a11652d77c7f..95641d34ea1b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -109,7 +109,7 @@ static int device_is_dependent(struct device *dev, void *target)
 	struct device_link *link;
 	int ret;
 
-	if (WARN_ON(dev == target))
+	if (dev == target)
 		return 1;
 
 	ret = device_for_each_child(dev, target, device_is_dependent);
@@ -117,7 +117,7 @@ static int device_is_dependent(struct device *dev, void *target)
 		return ret;
 
 	list_for_each_entry(link, &dev->links.consumers, s_node) {
-		if (WARN_ON(link->consumer == target))
+		if (link->consumer == target)
 			return 1;
 
 		ret = device_is_dependent(link->consumer, target);
-- 
2.29.2


--OnPtTHUMrhls4Fk5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-driver-core-Extend-device_is_dependent.patch"

From 65e765891ad85eca6a5817d1966432a72c261d82 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 15 Jan 2021 19:30:51 +0100
Subject: [PATCH 2/2] driver core: Extend device_is_dependent()

commit 3d1cf435e201d1fd63e4346b141881aed086effd upstream

If the device passed as the target (second argument) to
device_is_dependent() is not completely registered (that is, it has
been initialized, but not added yet), but the parent pointer of it
is set, it may be missing from the list of the parent's children
and device_for_each_child() called by device_is_dependent() cannot
be relied on to catch that dependency.

For this reason, modify device_is_dependent() to check the ancestors
of the target device by following its parent pointer in addition to
the device_for_each_child() walk.

Fixes: 9ed9895370ae ("driver core: Functional dependencies tracking support")
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/17705994.d592GUb2YH@kreacher
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/base/core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 95641d34ea1b..92415a748ad2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -96,6 +96,16 @@ void device_links_read_unlock(int not_used)
 }
 #endif /* !CONFIG_SRCU */
 
+static bool device_is_ancestor(struct device *dev, struct device *target)
+{
+	while (target->parent) {
+		target = target->parent;
+		if (dev == target)
+			return true;
+	}
+	return false;
+}
+
 /**
  * device_is_dependent - Check if one device depends on another one
  * @dev: Device to check dependencies for.
@@ -109,7 +119,12 @@ static int device_is_dependent(struct device *dev, void *target)
 	struct device_link *link;
 	int ret;
 
-	if (dev == target)
+	/*
+	 * The "ancestors" check is needed to catch the case when the target
+	 * device has not been completely initialized yet and it is still
+	 * missing from the list of children of its parent device.
+	 */
+	if (dev == target || device_is_ancestor(dev, target))
 		return 1;
 
 	ret = device_for_each_child(dev, target, device_is_dependent);
-- 
2.29.2


--OnPtTHUMrhls4Fk5--
