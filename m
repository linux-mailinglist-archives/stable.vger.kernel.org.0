Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF32847273B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbhLMJ7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39548 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbhLMJxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:53:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DCB5B80E65;
        Mon, 13 Dec 2021 09:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66111C53FAD;
        Mon, 13 Dec 2021 09:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389219;
        bh=6amkUwpgz8wWI6K4R6BPHbJK1Aq9AVhrM9vRnF3KMR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeV/4Sg7I93l0sOufNM1W18EGsm6qCHv3yr51uY1rUN7StqPjWA1DOT91mTJMSfzo
         29diaMPHWN1fE2jgVUUW1UhG+t2TyLrynMjVLo+guOIDzYPFwDGaptOq78j653YJ0d
         0jvGq80wDVLvurJL44p5WxWtUr1dQWfdKv1E4SWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 006/171] HID: add USB_HID dependancy to hid-prodikeys
Date:   Mon, 13 Dec 2021 10:28:41 +0100
Message-Id: <20211213092945.305111089@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 30cb3c2ad24b66fb7639a6d1f4390c74d6e68f94 upstream.

The prodikeys HID driver only controls USB devices, yet did not have a
dependancy on USB_HID.  This causes build errors on some configurations
like nios2 when building due to new changes to the prodikeys driver.

Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211203081231.2856936-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -245,7 +245,7 @@ config HID_MACALLY
 
 config HID_PRODIKEYS
 	tristate "Prodikeys PC-MIDI Keyboard support"
-	depends on HID && SND
+	depends on USB_HID && SND
 	select SND_RAWMIDI
 	help
 	Support for Prodikeys PC-MIDI Keyboard device support.


