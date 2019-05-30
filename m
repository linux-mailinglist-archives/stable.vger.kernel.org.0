Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6AD2F9D7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 11:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfE3Jrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 05:47:51 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:43297 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfE3Jrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 05:47:51 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2019 05:47:50 EDT
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=ian.jackson@eu.citrix.com; spf=Pass smtp.mailfrom=Ian.Jackson@citrix.com; spf=None smtp.helo=postmaster@MIAPEX02MSOL02.citrite.net
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  ian.jackson@eu.citrix.com) identity=pra;
  client-ip=23.29.105.83; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Ian.Jackson@citrix.com";
  x-sender="ian.jackson@eu.citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa2.hc3370-68.iphmx.com: domain of
  Ian.Jackson@citrix.com designates 23.29.105.83 as permitted
  sender) identity=mailfrom; client-ip=23.29.105.83;
  receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Ian.Jackson@citrix.com";
  x-sender="Ian.Jackson@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:23.29.105.83 ip4:162.221.156.50 ~all"
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@MIAPEX02MSOL02.citrite.net) identity=helo;
  client-ip=23.29.105.83; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Ian.Jackson@citrix.com";
  x-sender="postmaster@MIAPEX02MSOL02.citrite.net";
  x-conformance=sidf_compatible
IronPort-SDR: gaEMim3oJQ6Nuz/TJo0XboCjPJ9pIwB6+42CuJR4rRSueVCzlQsQWNz9m5f95NLkbh0KFty/mB
 1PvQgl+YORtKkGDxMfIhdLLgKjh7HYiDUfJKl3eA8Fj3uRft5abeQOc4tE6fr6q/KGLirUbxd3
 PiuBERNdQDyhoTrmre6BgFDHGcOzPsNW0imcIwfP4we0XF9MH6r6iGJ/CUUvZBgT4UcefEQF5A
 d9yJdgeYwrc+TsQmgBPqd+GKO7hHmOY3cEe9B12drAYjAifbKjy5dTc74cBcdoph4QvNodnnc6
 4nk=
X-SBRS: 2.7
X-MesageID: 1092562
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 23.29.105.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.60,530,1549947600"; 
   d="scan'208";a="1092562"
From:   Ian Jackson <ian.jackson@eu.citrix.com>
To:     <xen-devel@lists.xenproject.org>
CC:     Ian Jackson <ian.jackson@eu.citrix.com>, <stable@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: [OSSTEST PATCH] Drop all linux branches 3.18 and earlier
Date:   Thu, 30 May 2019 10:39:50 +0100
Message-ID: <20190530093950.14952-1-ian.jackson@eu.citrix.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.18 doesn't boot on Xen any more and Linux stable upstream say it
will not be fixed because it's EOL.  Thanks to them for that
confirmation.

While we are here, drop all earlier Linux branches too.  We are
wasting our time fetching them, seeing if they have changed, and then
doing nothing.

CC: stable@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
---
 cr-for-branches | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cr-for-branches b/cr-for-branches
index bc9ce2d3..47ad5041 100755
--- a/cr-for-branches
+++ b/cr-for-branches
@@ -31,7 +31,7 @@ scriptoptions="$1"; shift
 LOGFILE=tmp/cr-for-branches.log
 export LOGFILE
 
-: ${BRANCHES:=osstest xen-4.6-testing xen-4.7-testing xen-4.8-testing xen-4.9-testing xen-4.10-testing xen-4.11-testing xen-4.12-testing xen-unstable qemu-mainline qemu-upstream-unstable qemu-upstream-4.6-testing qemu-upstream-4.7-testing qemu-upstream-4.8-testing qemu-upstream-4.9-testing qemu-upstream-4.10-testing qemu-upstream-4.11-testing qemu-upstream-4.12-testing linux-linus linux-4.19 linux-4.14 linux-4.9 linux-4.4 linux-4.1 linux-3.18 linux-3.16 linux-3.14 linux-3.10 linux-3.4 linux-arm-xen seabios ovmf xtf ${EXTRA_BRANCHES}}
+: ${BRANCHES:=osstest xen-4.6-testing xen-4.7-testing xen-4.8-testing xen-4.9-testing xen-4.10-testing xen-4.11-testing xen-4.12-testing xen-unstable qemu-mainline qemu-upstream-unstable qemu-upstream-4.6-testing qemu-upstream-4.7-testing qemu-upstream-4.8-testing qemu-upstream-4.9-testing qemu-upstream-4.10-testing qemu-upstream-4.11-testing qemu-upstream-4.12-testing linux-linus linux-4.19 linux-4.14 linux-4.9 linux-4.4 linux-4.1 linux-arm-xen seabios ovmf xtf ${EXTRA_BRANCHES}}
 export BRANCHES
 
 fetchwlem=$wlem
-- 
2.11.0

