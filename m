Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A27420C57
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbhJDNE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhJDNDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:03:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC26961A6E;
        Mon,  4 Oct 2021 12:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352384;
        bh=x5Kpa+sCFAuZLMbSwCGEjCSK6Nh9LCy8OSs8IJv5z6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnupJTZtGONim16vkF5P2GciuIAUMViQBSS8hblpWAARtMYXUd4RwZrPWqGD5qVOD
         zEvKLQzrJRHHb7xqImEPBu0TqUihVY3YWvDoJEVblLmpfMzZBkRbr/6uDe+mRUcFd0
         C9YAu0Y5l9tCxlz2hv1k0I0PYFvLHi2hs1rLiqDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        Julian Sikorski <belegdol+github@gmail.com>
Subject: [PATCH 4.14 09/75] Re-enable UAS for LaCie Rugged USB3-FW with fk quirk
Date:   Mon,  4 Oct 2021 14:51:44 +0200
Message-Id: <20211004125031.840082949@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Sikorski <belegdol@gmail.com>

commit ce1c42b4dacfe7d71c852d8bf3371067ccba865c upstream.

Further testing has revealed that LaCie Rugged USB3-FW does work with
uas as long as US_FL_NO_REPORT_OPCODES and US_FL_NO_SAME are enabled.

Link: https://lore.kernel.org/linux-usb/2167ea48-e273-a336-a4e0-10a4e883e75e@redhat.com/
Cc: stable <stable@vger.kernel.org>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Link: https://lore.kernel.org/r/20210913181454.7365-1-belegdol+github@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -63,7 +63,7 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x99
 		"LaCie",
 		"Rugged USB3-FW",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
+		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI


