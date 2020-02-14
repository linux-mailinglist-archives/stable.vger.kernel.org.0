Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585C015F1B1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbgBNPyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731241AbgBNPyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F1FE24676;
        Fri, 14 Feb 2020 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695693;
        bh=MpOLrtBpFCiszf4oe87gUXnv6QKAfqqQwxxRDU9gY+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXINiA4tQ/z7WmhSii7nfOaOxTuxWgj1sNoDbKeNEcvEjlSizmEr4FdbspK8IeP2j
         0I8GT3fGR5twOWil88spVScnqZjVNUQsMqGUJKT+SbvC/9z0+rt+PUtytSmnhWGe7w
         ut8FOPFhr1hxrJn5Qh0aL0kK603Ns55PCNeqoQS8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Rosin <peda@axentia.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 276/542] fbdev: fix numbering of fbcon options
Date:   Fri, 14 Feb 2020 10:44:28 -0500
Message-Id: <20200214154854.6746-276-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit fd933c00ebe220060e66fb136a7050a242456566 ]

Three shall be the number thou shalt count, and the number of the
counting shall be three. Four shalt thou not count...

One! Two! Five!

Fixes: efb985f6b265 ("[PATCH] fbcon: Console Rotation - Add framebuffer console documentation")
Signed-off-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190827110854.12574-2-peda@axentia.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/fb/fbcon.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/fb/fbcon.rst b/Documentation/fb/fbcon.rst
index ebca41785abea..65ba402551374 100644
--- a/Documentation/fb/fbcon.rst
+++ b/Documentation/fb/fbcon.rst
@@ -127,7 +127,7 @@ C. Boot options
 	is typically located on the same video card.  Thus, the consoles that
 	are controlled by the VGA console will be garbled.
 
-4. fbcon=rotate:<n>
+5. fbcon=rotate:<n>
 
 	This option changes the orientation angle of the console display. The
 	value 'n' accepts the following:
@@ -152,21 +152,21 @@ C. Boot options
 	Actually, the underlying fb driver is totally ignorant of console
 	rotation.
 
-5. fbcon=margin:<color>
+6. fbcon=margin:<color>
 
 	This option specifies the color of the margins. The margins are the
 	leftover area at the right and the bottom of the screen that are not
 	used by text. By default, this area will be black. The 'color' value
 	is an integer number that depends on the framebuffer driver being used.
 
-6. fbcon=nodefer
+7. fbcon=nodefer
 
 	If the kernel is compiled with deferred fbcon takeover support, normally
 	the framebuffer contents, left in place by the firmware/bootloader, will
 	be preserved until there actually is some text is output to the console.
 	This option causes fbcon to bind immediately to the fbdev device.
 
-7. fbcon=logo-pos:<location>
+8. fbcon=logo-pos:<location>
 
 	The only possible 'location' is 'center' (without quotes), and when
 	given, the bootup logo is moved from the default top-left corner
-- 
2.20.1

