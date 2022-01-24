Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7452499173
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344255AbiAXUKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49108 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378014AbiAXUGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:06:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F4F9B8122D;
        Mon, 24 Jan 2022 20:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83794C340E5;
        Mon, 24 Jan 2022 20:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054765;
        bh=9wTFvCDXsLGr2ff4ZSyAlfnhmj5VqNbcLjP9DYhL73E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWfekx0k/06pvM6pp+8QTpWgs74DQ/UATHzuYUs1L+CYSyEMuUK81L+a69ytaFifO
         UO10j/WLD1SFHvILFETExhVFgQfQqDNkotiKgh4suKI2zlAWTyG0Cx+8s8cSEhQIyL
         PqPT2f9bDRoL1ozGIGpj+nXUdO7i/tHqZRda4FgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.10 494/563] Documentation: fix firewire.rst ABI file path error
Date:   Mon, 24 Jan 2022 19:44:19 +0100
Message-Id: <20220124184041.539349566@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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


