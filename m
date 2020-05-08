Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27D51CACD0
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgEHM4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgEHM4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:56:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA122054F;
        Fri,  8 May 2020 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942567;
        bh=UMbNeAzVD4RlNGqFhkHtIRN6vWzT1o2zrOI16auknhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoAlC5SHtJLsZhhovvdLvR6au3OlcuWThH+yT2UDvIoFuzkDFLEaCPLxzE6XQ2EuV
         LfrQvPYhAJZxa0FQQABtYaPhuq4PltE+IFF4ySiyVkEchCHLref4ZrqNKKgXomKXbN
         ePdbse2KmoE8pJp3AOlVkXQt4x9xV2hzCwlBYKPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.6 46/49] ACPI: PM: s2idle: Fix comment in acpi_s2idle_prepare_late()
Date:   Fri,  8 May 2020 14:36:03 +0200
Message-Id: <20200508123049.245893715@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 243a98894dc525ad2fbeb608722fcb682be3186d upstream.

Fix a comment in acpi_s2idle_prepare_late() that has become outdated
after commit f0ac20c3f613 ("ACPI: EC: Fix flushing of pending work").

Fixes: f0ac20c3f613 ("ACPI: EC: Fix flushing of pending work")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -982,10 +982,7 @@ static int acpi_s2idle_prepare_late(void
 
 static void acpi_s2idle_sync(void)
 {
-	/*
-	 * The EC driver uses the system workqueue and an additional special
-	 * one, so those need to be flushed too.
-	 */
+	/* The EC driver uses special workqueues that need to be flushed. */
 	acpi_ec_flush_work();
 	acpi_os_wait_events_complete(); /* synchronize Notify handling */
 }


