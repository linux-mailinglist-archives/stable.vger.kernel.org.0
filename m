Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00D9472437
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhLMJe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:34:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58774 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhLMJeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:34:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C850CE0E80;
        Mon, 13 Dec 2021 09:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7475EC341C8;
        Mon, 13 Dec 2021 09:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388049;
        bh=QjdaLbiw6/LNQx4pLtEM/V8Ju6WDBpt/VOhOLjDxbRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeKWYJzTJhFIj4vRmsDuUrxIQv/LNfBZ/32/iqVd1vzNlnJsVvLFGM2Ti86qLRHFR
         8+kKsrDM4VUdKsgvQKcn7DuHc3nkvzvvIr5tkBx7GA7KkHtbMqGa+MNHEslp+rjlTc
         eJ7nd3Zh+EFxhzReDF9jZutlrBSUSFTngLCbgUsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.9 03/42] HID: add USB_HID dependancy to hid-prodikeys
Date:   Mon, 13 Dec 2021 10:29:45 +0100
Message-Id: <20211213092926.689680730@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
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
@@ -194,7 +194,7 @@ config HID_CORSAIR
 
 config HID_PRODIKEYS
 	tristate "Prodikeys PC-MIDI Keyboard support"
-	depends on HID && SND
+	depends on USB_HID && SND
 	select SND_RAWMIDI
 	---help---
 	Support for Prodikeys PC-MIDI Keyboard device support.


