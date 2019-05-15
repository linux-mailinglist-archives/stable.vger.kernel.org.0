Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385AC1EDA1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbfEOLL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbfEOLL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDBB20843;
        Wed, 15 May 2019 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918716;
        bh=lUJwJXLleX1GoZA5bjxOOiZuWZ48uRlI6KfbkI/IBX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2Qv3bkdVaOO2ve/u+hRlyXN2HnCnHsS16TqWg2kK5LyZYpZgr8kXl0qmBaUypCD4
         /PnJGhVmB5mU3GBCB9plsORAK22Y4LqAs1JphAfp4aZsbgt4l5dWGpWelfmriUNB0w
         P2ZW6dB2fKWWXgMhEMiBvn4Ri4TGpMStfqh5j2nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 237/266] x86/speculation/l1tf: Document l1tf in sysfs
Date:   Wed, 15 May 2019 12:55:44 +0200
Message-Id: <20190515090731.018358379@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

The vulnerabilties/l1tf attribute was added by commit 17dbca119312
"x86/speculation/l1tf: Add sysfs reporting for l1tf", which has
already been backported to 3.16, but only documented in commit
d90a7a0ec83f "x86/bugs, kvm: Introduce boot-time control of L1TF
mitigations", which has not and probbaly won't be.

Add just that line of documentation for now.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -277,6 +277,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/spectre_v1
 		/sys/devices/system/cpu/vulnerabilities/spectre_v2
 		/sys/devices/system/cpu/vulnerabilities/spec_store_bypass
+		/sys/devices/system/cpu/vulnerabilities/l1tf
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities


