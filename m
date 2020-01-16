Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06B414000E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390686AbgAPXUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390664AbgAPXUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B2BE2082F;
        Thu, 16 Jan 2020 23:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216838;
        bh=8HFTOHFdpVn8DqOi9ioDRy1zz3Sz9X+4Nb7QxL9ae6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLaqdDo/et75HaTM8zvkgka/iQF2OF+meGY8ulxArqzrXUbf9dt2CDrc96CUgRT+6
         vCSSkCf7iWmNDP8jqshz7gmPBCk0ENp2NGroaeJJftuhrjnaEFM6KysiEJVByk83jF
         6DSFQLRY20lqidNu7eDCqsMGAN9+tJonUGP9FSdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 040/203] MAINTAINERS: Append missed file to the database
Date:   Fri, 17 Jan 2020 00:15:57 +0100
Message-Id: <20200116231747.557078308@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 44fe5cb32c7599a4059931a98794e0418619aa96 upstream.

When gpiolib.h internal header had been split to few, the commit 77cb907abe6c
("gpiolib: acpi: Split ACPI stuff to gpiolib-acpi.h") in particular missed
the MAINTAINERS database update. Do it here.

Fixes: 77cb907abe6c ("gpiolib: acpi: Split ACPI stuff to gpiolib-acpi.h")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6973,6 +6973,7 @@ L:	linux-acpi@vger.kernel.org
 S:	Maintained
 F:	Documentation/firmware-guide/acpi/gpio-properties.rst
 F:	drivers/gpio/gpiolib-acpi.c
+F:	drivers/gpio/gpiolib-acpi.h
 
 GPIO IR Transmitter
 M:	Sean Young <sean@mess.org>


