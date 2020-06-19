Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C48201867
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbgFSOjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387945AbgFSOi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:38:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B21920DD4;
        Fri, 19 Jun 2020 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577537;
        bh=4JFtDNHFFW5pg3sH6TQO9VaAPDJzQon9y+GOPrV4sBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFTivql9sd/kEwN9TllJMNa7KyDyQHaFBmFmaDzjd6S6CkoGw2Vy344ml1fgMlomJ
         VWujn3ChaffkgqLfcv/epGJfx1grEglAWjkaP/Oi1Np9YDgfdtaAX0xAYDs9R35isJ
         BN7YOiVnR1s6OGId0rycAwQWtj1zkmsNoFOGm9d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.4 090/101] power: vexpress: add suppress_bind_attrs to true
Date:   Fri, 19 Jun 2020 16:33:19 +0200
Message-Id: <20200619141618.685917411@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit 73174acc9c75960af2daa7dcbdb9781fc0d135cb upstream.

Make sure that the POWER_RESET_VEXPRESS driver won't have bind/unbind
attributes available via the sysfs, so lets be explicit here and use
".suppress_bind_attrs = true" to prevent userspace from doing something
silly.

Link: https://lore.kernel.org/r/20200527112608.3886105-2-anders.roxell@linaro.org
Cc: stable@vger.kernel.org
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/reset/vexpress-poweroff.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -150,6 +150,7 @@ static struct platform_driver vexpress_r
 	.driver = {
 		.name = "vexpress-reset",
 		.of_match_table = vexpress_reset_of_match,
+		.suppress_bind_attrs = true,
 	},
 };
 


