Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96CB3291A2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhCAU2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:28:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243258AbhCAUX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7754A65404;
        Mon,  1 Mar 2021 18:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621935;
        bh=PX0rVoXaMNn/kgd+GCuXKMTMZ33NL8AfcbZNsNsG9oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6rsfJLpHpua5kYVXdjVzJaP4Stf/Os6OKr2h+TSOhlIPQu1ngDzlOlEO3egNboWd
         xheZWMwZpnwewltwosy9uLSn2s7yy9kDDcTJZMu0SrtoumW7bOC1UlsT1wqngF8AK0
         92GiyM8obKDAEbF3QqdvZPeB4e4vtTXWvkpVnevo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Georgi Bakalski <georgi.bakalski@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 667/775] media: ir_toy: add another IR Droid device
Date:   Mon,  1 Mar 2021 17:13:55 +0100
Message-Id: <20210301161234.343813140@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 4487e0215560392bd11c9de08d60824d72c89cd9 upstream.

This device is also supported.

Cc: stable@vger.kernel.org
Tested-by: Georgi Bakalski <georgi.bakalski@gmail.com>
Reported-by: Georgi Bakalski <georgi.bakalski@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/ir_toy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -491,6 +491,7 @@ static void irtoy_disconnect(struct usb_
 
 static const struct usb_device_id irtoy_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x04d8, 0xfd08, USB_CLASS_CDC_DATA) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x04d8, 0xf58b, USB_CLASS_CDC_DATA) },
 	{ }
 };
 


