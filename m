Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F27C498E83
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346288AbiAXTm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:42:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37660 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355211AbiAXTkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D1EF6153D;
        Mon, 24 Jan 2022 19:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75482C340E5;
        Mon, 24 Jan 2022 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053212;
        bh=vwRGDU4N4TbEApmcUFKQ4hpx5acenT08Vv9AbCWceh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGGbO5yH3okHFASZyKbZ6qc6YgSQt677DGCmKh8qggMeDlgIJGbOuNX6CaBD7n6wf
         ETnPbgQCa5cxSsfC+yvhV5fmWwLMv6v7R09U0b/hoWsb+IHcS47RHgFUoC6SNAdWBp
         gJsyeosvORYxTTWT9rYp+P3Hw8gXMRPtX469b+X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.4 279/320] Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization
Date:   Mon, 24 Jan 2022 19:44:23 +0100
Message-Id: <20220124184003.466568032@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
 


