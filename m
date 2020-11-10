Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03212AE119
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKJUzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJUzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:55:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52D5620665;
        Tue, 10 Nov 2020 20:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041742;
        bh=65xJIsaF4flpz7VQcMhjXCmGfD/zMk45iFc6aGIqSso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9I5L6LwIqgJB3oiHKDCkyYHymCnqkXJYawTfILbBwoYRZG6QQ7KE49gT5wAp1yIr
         IbvPARMXNqIJ3JVMw0OUSozmvDWydSH/8Kbolg2fKYSyWGwpB56BeZpt3yl8d2BDIT
         Z5K1e5aAR7nGgW0Ytv7lkmIcfSZ2AvHEKnhri5R4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.9.8
Date:   Tue, 10 Nov 2020 21:56:41 +0100
Message-Id: <1605041246144149@kroah.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1605041246232108@kroah.com>
References: <1605041246232108@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 035d86a0d291..ac292d6dd262 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 9
-SUBLEVEL = 7
+SUBLEVEL = 8
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index f808c5fa9838..3f0b8e2ef3d4 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -367,9 +367,9 @@ static void create_power_zone_common_attributes(
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
