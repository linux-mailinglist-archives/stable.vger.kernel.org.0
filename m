Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0721E2AE136
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgKJU6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731949AbgKJU6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:58:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB8A220665;
        Tue, 10 Nov 2020 20:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041904;
        bh=2GXfM0b/FcS1N5PHUoJprNLc+/TDgwwpSdvlHJ9em1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGlLbJzGP3qK/zyCZNC92UoJCgmtJTSgyXTiOGBw1qc4w3znJyXQ7Rew0BHslfRpp
         1R+GDK5oxo6ghywYMU8ZFBS7DsyiMPsO8q+a14lb80YgXVBKP2Yx6SxzBm9lZNqpaf
         NKClsBWYqkGXdT2658MvfJXmVqBiZgOs6aSXcp1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.206
Date:   Tue, 10 Nov 2020 21:59:18 +0100
Message-Id: <1605041949181194@kroah.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <160504194952147@kroah.com>
References: <160504194952147@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index fff3ca75d35a..2d5ec8b7bcf5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 205
+SUBLEVEL = 206
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 5b10b50f8686..5c064df7d81f 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -379,9 +379,9 @@ static void create_power_zone_common_attributes(
 					&dev_attr_max_energy_range_uj.attr;
 	if (power_zone->ops->get_energy_uj) {
 		if (power_zone->ops->reset_energy_uj)
-			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUGO;
+			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUSR;
 		else
-			dev_attr_energy_uj.attr.mode = S_IRUGO;
+			dev_attr_energy_uj.attr.mode = S_IRUSR;
 		power_zone->zone_dev_attrs[count++] =
 					&dev_attr_energy_uj.attr;
 	}
