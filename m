Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92CD49A5C8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371129AbiAYAHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2362629AbiAXXmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:42:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35906C0FCECE;
        Mon, 24 Jan 2022 13:38:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E89F3B8121C;
        Mon, 24 Jan 2022 21:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBBEC340E4;
        Mon, 24 Jan 2022 21:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060336;
        bh=vwRGDU4N4TbEApmcUFKQ4hpx5acenT08Vv9AbCWceh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWJo4+MXs8juUGHnYUcYkMd5YtKkvijh/4bnQE9AcPQ12km19/8UtpG6LN3uhCthI
         DW1cylHLOxiEa2It5YAuUOL8NXAbilCv2WiiTNoxqkhIZqb/vt1l2YMg0kDZYuVxqs
         GU2YTioeRAobYDGEF7dQ9vdp1+sRLaWHfmFYAqw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.16 0915/1039] Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization
Date:   Mon, 24 Jan 2022 19:45:04 +0100
Message-Id: <20220124184156.054826542@linuxfoundation.org>
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

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit 82ca67321f55a8d1da6ac3ed611da3c32818bb37 upstream.

The config RANDOMIZE_SLAB does not exist, the authors probably intended to
refer to the config RANDOMIZE_BASE, which provides kernel address-space
randomization. They probably just confused SLAB with BASE (these two
four-letter words coincidentally share three common letters), as they also
point out the config SLAB_FREELIST_RANDOM as further randomization within
the same sentence.

Fix the reference of the config for kernel address-space randomization to
the config that provides that.

Fixes: 6e88559470f5 ("Documentation: Add section about CPU vulnerabilities for Spectre")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20211230171940.27558-1-lukas.bulwahn@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -468,7 +468,7 @@ Spectre variant 2
    before invoking any firmware code to prevent Spectre variant 2 exploits
    using the firmware.
 
-   Using kernel address space randomization (CONFIG_RANDOMIZE_SLAB=y
+   Using kernel address space randomization (CONFIG_RANDOMIZE_BASE=y
    and CONFIG_SLAB_FREELIST_RANDOM=y in the kernel configuration) makes
    attacks on the kernel generally more difficult.
 


