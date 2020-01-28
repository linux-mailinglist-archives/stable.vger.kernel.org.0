Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4072C14B98C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbgA1OZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbgA1OZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4245B24688;
        Tue, 28 Jan 2020 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221532;
        bh=d6t38KmNhUDEuUvcJNktAouqmu9+LhdyI+BO0ertFG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPCqlqR/7J4Z2r7whlE2bzoaKkcylGtcwUDa3xYXzWEsB08IAspH4rLOMx50oxaIz
         9HX9nvvmgcTnyzy46b8ub3KwfULpitrKefNiYGB7NzcpgiUUiW0mfx2PKVI7tIunBk
         pthvBjZQ8mo4akP+4DVJsWmuoZRp2KR3+3nlEAgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.9 261/271] Documentation: Document arm64 kpti control
Date:   Tue, 28 Jan 2020 15:06:50 +0100
Message-Id: <20200128135912.026352539@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
[florian: patch the correct file]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/kernel-parameters.txt |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1965,6 +1965,12 @@ bytes respectively. Such letter suffixes
 			kmemcheck=2 (one-shot mode)
 			Default: 2 (one-shot mode)
 
+	kpti=		[ARM64] Control page table isolation of user
+			and kernel address spaces.
+			Default: enabled on cores which need mitigation.
+			0: force disabled
+			1: force enabled
+
 	kstack=N	[X86] Print N words from the kernel stack
 			in oops dumps.
 


