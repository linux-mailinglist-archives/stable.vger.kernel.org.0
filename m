Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E4B4D4BCE
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbiCJOVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243937AbiCJOSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:18:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF911693A8;
        Thu, 10 Mar 2022 06:15:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DAC2B82615;
        Thu, 10 Mar 2022 14:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CDFC340EB;
        Thu, 10 Mar 2022 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921706;
        bh=/sdHsyS+hr3Sal/XN/Ek01i3/VYlSRYBbNSleu30DIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAipqprAzDAdDI9Kd1SwlQvA76DlBTCZrEaTEYncuhFZ+5f62nBI0w9u+l99sRpxL
         p/Tknzf6TLgO4bK8fewEVEZ3SDjLdQl6jBUnuNgC7NKo+6vTsqAh6y6MS/HWvvV+HB
         7opWGX208YzNGny62nSfXkc7O9kDPxq0HgTx4/+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 06/38] Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization
Date:   Thu, 10 Mar 2022 15:13:19 +0100
Message-Id: <20220310140808.323981477@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[bwh: Backported to 4.9: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hw-vuln/spectre.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/hw-vuln/spectre.rst
+++ b/Documentation/hw-vuln/spectre.rst
@@ -468,7 +468,7 @@ Spectre variant 2
    before invoking any firmware code to prevent Spectre variant 2 exploits
    using the firmware.
 
-   Using kernel address space randomization (CONFIG_RANDOMIZE_SLAB=y
+   Using kernel address space randomization (CONFIG_RANDOMIZE_BASE=y
    and CONFIG_SLAB_FREELIST_RANDOM=y in the kernel configuration) makes
    attacks on the kernel generally more difficult.
 


