Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3081749956A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441809AbiAXUvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41582 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391233AbiAXUrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48BD060916;
        Mon, 24 Jan 2022 20:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE25C340E5;
        Mon, 24 Jan 2022 20:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057225;
        bh=9wTFvCDXsLGr2ff4ZSyAlfnhmj5VqNbcLjP9DYhL73E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hybSJX8ILAJiv4/NCK/UEJQe7qHMIShAm2Kz43zlALuKvgGnkkZzWadshCVS7Ltfw
         AMUjtOGAPH2jOKsuKVps1XBu3D5GWqlhh/UowGX2x7QWRli43Kekyfp7JrBhf8lL3J
         gCzw73MCfMoR893fVOFOOjqiFBtShZiIwTYknbNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 742/846] Documentation: fix firewire.rst ABI file path error
Date:   Mon, 24 Jan 2022 19:44:19 +0100
Message-Id: <20220124184126.592261209@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit b0ac702f3329cdc8a06dcaac73183d4b5a2b942d upstream.

Adjust the path of the ABI files for firewire.rst to prevent a
documentation build error. Prevents this problem:

Sphinx parallel build error:
docutils.utils.SystemMessage: Documentation/driver-api/firewire.rst:22: (SEVERE/4) Problems with "include" directive path:
InputError: [Errno 2] No such file or directory: '../Documentation/driver-api/ABI/stable/firewire-cdev'.

Fixes: 2f4830ef96d2 ("FireWire: add driver-api Introduction section")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Akira Yokosawa <akiyks@gmail.com>
Link: https://lore.kernel.org/r/20220119033905.4779-1-rdunlap@infradead.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/firewire.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/driver-api/firewire.rst
+++ b/Documentation/driver-api/firewire.rst
@@ -19,7 +19,7 @@ of kernel interfaces is available via ex
 Firewire char device data structures
 ====================================
 
-.. include:: /ABI/stable/firewire-cdev
+.. include:: ../ABI/stable/firewire-cdev
     :literal:
 
 .. kernel-doc:: include/uapi/linux/firewire-cdev.h
@@ -28,7 +28,7 @@ Firewire char device data structures
 Firewire device probing and sysfs interfaces
 ============================================
 
-.. include:: /ABI/stable/sysfs-bus-firewire
+.. include:: ../ABI/stable/sysfs-bus-firewire
     :literal:
 
 .. kernel-doc:: drivers/firewire/core-device.c


