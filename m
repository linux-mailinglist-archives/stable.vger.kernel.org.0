Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BE8CA825
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390224AbfJCQV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390208AbfJCQV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:21:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC2A2054F;
        Thu,  3 Oct 2019 16:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119717;
        bh=ZYCCv+T4GyOSEM7sSveA086+4vtEk0XaVhStkGR/kfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWgYrk8VElaSq/wrTS7e1XfLMsPmI7UmpQsiZrLTLsyIllPulogUctNBJCI8iaJZQ
         Upl7zda1PAd0AXdgVM+p8I7ykZb8zO0gknK8Vr5oRtSMfsctD9FyCGgR0WS1qkFRZU
         IiY6kBif4Z5kxXfqHm0urRe462koUrZbf5ArtCbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 168/211] media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
Date:   Thu,  3 Oct 2019 17:53:54 +0200
Message-Id: <20191003154525.987598969@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 7e0bb5828311f811309bed5749528ca04992af2f upstream.

Like a bunch of other MSI laptops the MS-1039 uses a 0c45:627b
SN9C201 + OV7660 webcam which is mounted upside down.

Add it to the sn9c20x flip_dmi_table to deal with this.

Cc: stable@vger.kernel.org
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/sn9c20x.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -133,6 +133,13 @@ static const struct dmi_system_id flip_d
 		}
 	},
 	{
+		.ident = "MSI MS-1039",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1039"),
+		}
+	},
+	{
 		.ident = "MSI MS-1632",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),


