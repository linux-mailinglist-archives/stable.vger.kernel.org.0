Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D266420C38
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfEPQC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42702 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbfEPP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImH-0006zr-EN; Thu, 16 May 2019 16:58:41 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Rz-OO; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.353868316@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 70/86] x86/speculation/l1tf: Document l1tf in sysfs
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

The vulnerabilties/l1tf attribute was added by commit 17dbca119312
"x86/speculation/l1tf: Add sysfs reporting for l1tf", which has
already been backported to 3.16, but only documented in commit
d90a7a0ec83f "x86/bugs, kvm: Introduce boot-time control of L1TF
mitigations", which has not and probbaly won't be.

Add just that line of documentation for now.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -230,6 +230,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/spectre_v1
 		/sys/devices/system/cpu/vulnerabilities/spectre_v2
 		/sys/devices/system/cpu/vulnerabilities/spec_store_bypass
+		/sys/devices/system/cpu/vulnerabilities/l1tf
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities

