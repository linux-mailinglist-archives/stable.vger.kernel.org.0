Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59BC506F4
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfFXKCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfFXKCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:02:55 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E652212F5;
        Mon, 24 Jun 2019 10:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370574;
        bh=Y30VzVqRXuj3EzenoEznsQ/OHxiai93FNLZhsQqxhoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qbyzh72U6j3sbBivptl/ZQAnzAqHaeJJPzP0CyAvCeoThBtafCS5Tlrrzn+NoVSuX
         E+XPlb3iOi5+orvfX919/W9mgXOI+ZOWRnUy72C7QfDbMz6xLPOukDrO7WfaT3GO7v
         65lkossP4fRI2txbtJkdl/CBn4QgRkr3U7B5Xc6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Smith <danct12@disroot.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 25/90] Input: silead - add MSSL0017 to acpi_device_id
Date:   Mon, 24 Jun 2019 17:56:15 +0800
Message-Id: <20190624092315.792567321@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Smith <danct12@disroot.org>

commit 0e658060e5fc50dc282885dc424a94b5d95547e5 upstream.

On Chuwi Hi10 Plus, the Silead device id is MSSL0017.

Signed-off-by: Daniel Smith <danct12@disroot.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/silead.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/silead.c
+++ b/drivers/input/touchscreen/silead.c
@@ -604,6 +604,7 @@ static const struct acpi_device_id silea
 	{ "MSSL1680", 0 },
 	{ "MSSL0001", 0 },
 	{ "MSSL0002", 0 },
+	{ "MSSL0017", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, silead_ts_acpi_match);


