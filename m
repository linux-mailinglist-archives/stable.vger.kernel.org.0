Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8BE2AE12C
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbgKJU5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJU5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:57:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 309BF20665;
        Tue, 10 Nov 2020 20:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041861;
        bh=vG0QlI/0jEVIMZKSfOIneqzYtF6UafznSHvTr3XYblg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAxKXqMRjMGWCCKaU7xjl6EMQMU0uWp3uMYQLpxlHmJCCXsAcXAWOOHcMnttkSyGB
         0I1s8ApLN9qExMSPyJhftEgz24t/Pjz+6MjPaazLSRtjUSR4yBAGJhBT4ubVNGk6Rd
         6QXu7EQLy1zEXjKhJoJO8kFFWohrBBnV8B/Jlsic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.243
Date:   Tue, 10 Nov 2020 21:58:35 +0100
Message-Id: <1605041892233115@kroah.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <160504189255146@kroah.com>
References: <160504189255146@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0ba3fd914426..99badda272d7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 242
+SUBLEVEL = 243
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index fd12ccc11e26..2313bb93f5c2 100644
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
