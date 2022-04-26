Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC950F599
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245290AbiDZIse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346757AbiDZIpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA58B17072;
        Tue, 26 Apr 2022 01:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2056B81CED;
        Tue, 26 Apr 2022 08:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6FDC385A0;
        Tue, 26 Apr 2022 08:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962124;
        bh=uKEYDWt3OoW+HTLnKcurD0UcjrAlNyV6usIFyO9hi1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inmLl7Xbh0MShLQgvz4u2pK41cHrTyXNroEmO4tLOlg4zlMk8C4N8GsoVZVls53XY
         pCl3cOqJoHCiPVzY/0YRxe8KJr0VxJqMUXCylqvzjCl9MPUPw/gq76Vm8MVf2Bds9N
         cufpSo1rC7FpJ3S2vTLIECJ28cw5sdT1LjLfH/D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Jianjian <wangjianjian3@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 78/86] ext4, doc: fix incorrect h_reserved size
Date:   Tue, 26 Apr 2022 10:21:46 +0200
Message-Id: <20220426081743.459556094@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
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


