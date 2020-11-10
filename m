Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95412AE13B
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKJU6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJU6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:58:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E46020665;
        Tue, 10 Nov 2020 20:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041928;
        bh=/TH21YMRVN0lmStgFLZYKVIeY7FXbqOo83+vzPhYdOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMDF5PVsNfT4echeEkk0VUrSOUXGuj2NazU5DjdKKMzAOA4Pz//j/brLkqIk/itPO
         +PsnkQk+O797/PBMLFxoR8Le0BQ4z/7wjqInVlypZjNwYiubnOjsjOxljWO1X6v3BP
         Gu/6Zc7Fig9mGQSXbMWn5jDpqSZDaYSRBZycxiow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.157
Date:   Tue, 10 Nov 2020 21:59:41 +0100
Message-Id: <16050419702634@kroah.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <160504197091230@kroah.com>
References: <160504197091230@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 82891b34e19e..245bcd8dd7b7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 156
+SUBLEVEL = 157
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 9e2f274bd44f..60c8375c3c81 100644
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
