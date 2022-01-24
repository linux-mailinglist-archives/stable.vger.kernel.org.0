Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6B49A5C9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371139AbiAYAHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2362636AbiAXXmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:42:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347E6C0FCED3;
        Mon, 24 Jan 2022 13:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE47FB8123A;
        Mon, 24 Jan 2022 21:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8FAC340E4;
        Mon, 24 Jan 2022 21:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060339;
        bh=9wTFvCDXsLGr2ff4ZSyAlfnhmj5VqNbcLjP9DYhL73E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBgNh3yAdHUczciJxBxhQYcUIbwFzmPfGMz+AY5TJQ/Jwv0WlFeU0Cz8bnqur0OjI
         ppsNvQLcva3XaKSQ2H2um6u9MXJHiZbHs6Q039DC8eFHPLbOAn6LwboB+dckzd+yVN
         3OraCji/JPHeCIeXCyBoN82akUTC8Sy3/cWRBZUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.16 0916/1039] Documentation: fix firewire.rst ABI file path error
Date:   Mon, 24 Jan 2022 19:45:05 +0100
Message-Id: <20220124184156.084771133@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


