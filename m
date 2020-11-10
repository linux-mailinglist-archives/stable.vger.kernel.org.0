Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6692AE133
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgKJU6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731558AbgKJU6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:58:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B16CA20665;
        Tue, 10 Nov 2020 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041884;
        bh=+uxsvfWjYly8RBxymxopGOrLecL7W3NlN+XbQKMgbG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW8L8ARzDmwsblCjpiZaZMC38ZMbnQX5jgFmMdXx9LtTvWKxCDm/EZFLElE1iKsLq
         ubfVBGIwccaIx0qpoPTrieIVKGdTMax4fP4PcfEIlMh3PxbR6MfROW0R7ry6SY6j85
         MOh6KKTzRGt3V02hJ56yip8cR/qC3JamUU1Aa1cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.9.243
Date:   Tue, 10 Nov 2020 21:58:58 +0100
Message-Id: <160504192614571@kroah.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <160504192649180@kroah.com>
References: <160504192649180@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index d41de2c1159e..c6fcfe4bfeed 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 242
+SUBLEVEL = 243
 EXTRAVERSION =
 NAME = Roaring Lionus
 
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
