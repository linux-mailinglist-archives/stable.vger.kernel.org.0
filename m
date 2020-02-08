Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011FD156625
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgBHScL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34712 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727963AbgBHS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:49 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-0003iT-VS; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-000CXV-AE; Sat, 08 Feb 2020 18:29:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michal Marek" <mmarek@suse.cz>,
        "Asbjoern Sloth Toennesen" <asbjorn@asbjorn.biz>
Date:   Sat, 08 Feb 2020 18:21:24 +0000
Message-ID: <lsq.1581185941.538669830@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 145/148] deb-pkg: remove obsolete -isp option to
 dpkg-gencontrol
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>

commit 4204111c028d492019e4440d12e9e3d062db4283 upstream.

The -isp option has been deprecated, after it became the default
behaviour back in 2006.

Since dpkg 1.17.11, dpkg-gencontrol emits a warning on -isp usage.

References: https://bugs.debian.org/215233
Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/package/builddeb | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -64,7 +64,7 @@ create_package() {
 	fi
 
 	# Create the package
-	dpkg-gencontrol -isp $forcearch -Vkernel:debarch="${debarch:-$(dpkg --print-architecture)}" -p$pname -P"$pdir"
+	dpkg-gencontrol $forcearch -Vkernel:debarch="${debarch:-$(dpkg --print-architecture)}" -p$pname -P"$pdir"
 	dpkg --build "$pdir" ..
 }
 

