Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641AB15785B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgBJNHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:07:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbgBJMjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:49 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 924E62080C;
        Mon, 10 Feb 2020 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338388;
        bh=O7sGNl7WZeKRfZ6xnrOj5WfW9QgoZ4rp1AVMGjML9O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdO0Qi8GyE8ROxwISS7Eq6PTMKpUymMzE9qVQftKnY0qttoI7yRDMpNGm83dIGCSI
         DsW856P7GKh/vGeUZXwe+cdKUD60maF6ewkHpOeNQrh1pVArdd5O2m/9pz/Y71yPiD
         uEB8OgKPWmT6fpZb63JmzeNP44gLeB5WD5qQViX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.5 024/367] MAINTAINERS: correct entries for ISDN/mISDN section
Date:   Mon, 10 Feb 2020 04:28:57 -0800
Message-Id: <20200210122426.104933446@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit dff6bc1bfd462b76dc13ec19dedc2c134a62ac59 ]

Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
the terminal slash for the two directories mISDN and hardware. Hence, all
files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
but were considered to be part of "THE REST".

Rectify the situation, and while at it, also complete the section with two
further build files that belong to that subsystem.

This was identified with a small script that finds all files belonging to
"THE REST" according to the current MAINTAINERS file, and I investigated
upon its output.

Fixes: 6d97985072dc ("isdn: move capi drivers to staging")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8808,8 +8808,10 @@ L:	isdn4linux@listserv.isdn4linux.de (su
 L:	netdev@vger.kernel.org
 W:	http://www.isdn4linux.de
 S:	Maintained
-F:	drivers/isdn/mISDN
-F:	drivers/isdn/hardware
+F:	drivers/isdn/mISDN/
+F:	drivers/isdn/hardware/
+F:	drivers/isdn/Kconfig
+F:	drivers/isdn/Makefile
 
 ISDN/CAPI SUBSYSTEM
 M:	Karsten Keil <isdn@linux-pingi.de>


