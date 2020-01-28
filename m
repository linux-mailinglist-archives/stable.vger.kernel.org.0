Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2F814B91F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733160AbgA1O1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgA1O1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3982624688;
        Tue, 28 Jan 2020 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221642;
        bh=P4toyX1phPD8DHkO7o7ZqzgsPhOtbkIHQOc2UTMIMZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr7CH5GFayI4lA3C4jleah37dfDNkWg/FvWDjVB/BuMvW1YPpnmv6iNLjT3/DMkcA
         5ei72aUxqMXxxcf2yOJgf23+PVU8uADjPmDcuCB/ONJXSvM0cSGMWNTqQigEjQ2+L+
         gDNwAlB8zHYyryUP155C2j4GAU/eheq/X4RgxP+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.19 32/92] Documentation: Document arm64 kpti control
Date:   Tue, 28 Jan 2020 15:08:00 +0100
Message-Id: <20200128135813.180124998@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

commit de19055564c8f8f9d366f8db3395836da0b2176c upstream.

For a while Arm64 has been capable of force enabling
or disabling the kpti mitigations. Lets make sure the
documentation reflects that.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1946,6 +1946,12 @@
 			Built with CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y,
 			the default is off.
 
+	kpti=		[ARM64] Control page table isolation of user
+			and kernel address spaces.
+			Default: enabled on cores which need mitigation.
+			0: force disabled
+			1: force enabled
+
 	kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.
 			Default is 0 (don't ignore, but inject #GP)
 


