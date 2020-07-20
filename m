Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19658226706
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733262AbgGTQIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733254AbgGTQIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 005492064B;
        Mon, 20 Jul 2020 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261292;
        bh=crdC/FcSNnFfmvavFML0b9RIg1+uRvGXlo87yIAceSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/rp/gOpnxs6DgEh/29VcJpzcMqlTTUjo533q4koRfsWdJOGW5zuK92V6kAqnFSRA
         lDQuv6OtVUmzQRs0raRx6qfsS+ueXHBi8EbiE/urJerQ4qp3JaebwBhi5kNdQhYf/F
         i+tV+BJZZWeQhfzOjsknGlkOCflXDYkn6q9XFGok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Ranostay <matt.ranostay@konsulko.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.7 063/244] iio: core: add missing IIO_MOD_H2/ETHANOL string identifiers
Date:   Mon, 20 Jul 2020 17:35:34 +0200
Message-Id: <20200720152828.852572415@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Ranostay <matt.ranostay@konsulko.com>

commit 25f02d3242ab4d16d0cee2dec0d89cedb3747fa9 upstream.

Add missing strings to iio_modifier_names[] for proper modification
of channels.

Fixes: b170f7d48443d (iio: Add modifiers for ethanol and H2 gases)
Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/industrialio-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -130,6 +130,8 @@ static const char * const iio_modifier_n
 	[IIO_MOD_PM2P5] = "pm2p5",
 	[IIO_MOD_PM4] = "pm4",
 	[IIO_MOD_PM10] = "pm10",
+	[IIO_MOD_ETHANOL] = "ethanol",
+	[IIO_MOD_H2] = "h2",
 };
 
 /* relies on pairs of these shared then separate */


