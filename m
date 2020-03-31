Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1342B198FB4
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgCaJFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgCaJFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAD4220787;
        Tue, 31 Mar 2020 09:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645537;
        bh=6+miePqbsWnqPWj5QsrnY3qI0o3oL7KNQ57soRmKgJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAZmUqtVxU/FwwkYDI+EZM4GLSFnG8dvUzmT18Tr0HV1udOr21kDhiO6diqBBQYWz
         RvyYYOx+ZO2yzWiYDvRNjmzbTwEoXQWCUMiW2HhCnPknVgRK1FxNehdkpzZLH8kEzf
         sSCSSllmn5p/g8DFecAfm1N6sZOnlvQYFwxpRUcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yussuf Khalil <dev@pp3345.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.5 084/170] Input: synaptics - enable RMI on HP Envy 13-ad105ng
Date:   Tue, 31 Mar 2020 10:58:18 +0200
Message-Id: <20200331085433.226214381@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yussuf Khalil <dev@pp3345.net>

commit 1369d0abe469fb4cdea8a5bce219d38cb857a658 upstream.

This laptop (and perhaps other variants of the same model) reports an
SMBus-capable Synaptics touchpad. Everything (including suspend and
resume) works fine when RMI is enabled via the kernel command line, so
let's add it to the whitelist.

Signed-off-by: Yussuf Khalil <dev@pp3345.net>
Link: https://lore.kernel.org/r/20200307213508.267187-1-dev@pp3345.net
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -186,6 +186,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
+	"SYN3257", /* HP Envy 13-ad105ng */
 	NULL
 };
 


