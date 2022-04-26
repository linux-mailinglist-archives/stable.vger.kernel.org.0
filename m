Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0BA50F90A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346595AbiDZJLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346341AbiDZJIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD84179E94;
        Tue, 26 Apr 2022 01:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3838360C43;
        Tue, 26 Apr 2022 08:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A0EC385A4;
        Tue, 26 Apr 2022 08:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962942;
        bh=uKEYDWt3OoW+HTLnKcurD0UcjrAlNyV6usIFyO9hi1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WasNxWZgZqdkkTDAbfUiRPLApHdqdwFVlKO3d+s43sRzp2Ita2X0FKd5PMtN+g6jX
         SdTPmH2PePGlBAy+Q6XBCR94ye9og73Fg4nxJUZ7ZselTNHGk/3rWyLuYbIinq3X53
         Dh6KahyMry7KulFxiV2NcO3X5BX1VMqj1VUot+no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Jianjian <wangjianjian3@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.17 138/146] ext4, doc: fix incorrect h_reserved size
Date:   Tue, 26 Apr 2022 10:22:13 +0200
Message-Id: <20220426081753.938064677@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wangjianjian (C) <wangjianjian3@huawei.com>

commit 7102ffe4c166ca0f5e35137e9f9de83768c2d27d upstream.

According to document and code, ext4_xattr_header's size is 32 bytes, so
h_reserved size should be 3.

Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
Link: https://lore.kernel.org/r/92fcc3a6-7d77-8c09-4126-377fcb4c46a5@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/ext4/attributes.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/ext4/attributes.rst
+++ b/Documentation/filesystems/ext4/attributes.rst
@@ -76,7 +76,7 @@ The beginning of an extended attribute b
      - Checksum of the extended attribute block.
    * - 0x14
      - \_\_u32
-     - h\_reserved[2]
+     - h\_reserved[3]
      - Zero.
 
 The checksum is calculated against the FS UUID, the 64-bit block number


