Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAC4328E42
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbhCAT0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241409AbhCATVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72151651FE;
        Mon,  1 Mar 2021 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619820;
        bh=PX0rVoXaMNn/kgd+GCuXKMTMZ33NL8AfcbZNsNsG9oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PB8FHBsW6dEkOlohni1/SbT6zZ0wTOsH1P9WuIlx1jktUyydrgO7iBNgddo+xWmWV
         hFG0SOGcgnNq40Eg3F299dsdfH3qcoTELsZzy708+guQAoySFMldzzdvvO5mcHGUng
         Eu9sp5bgg9BxFRy7TmA2VHoaKXK0y5HC5MAn/GPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Georgi Bakalski <georgi.bakalski@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 563/663] media: ir_toy: add another IR Droid device
Date:   Mon,  1 Mar 2021 17:13:31 +0100
Message-Id: <20210301161209.717370316@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
 


