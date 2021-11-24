Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288D545C624
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243622AbhKXOFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353745AbhKXOCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA94063317;
        Wed, 24 Nov 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759411;
        bh=0s7/qoo3hpqoGGgSlonTCdXJFWmv7YJODyyyzMqCkw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4JalsC+I2OPFdl5V6ceJGVlSSorZJAq6044ZTOtPTZvSrcHw6uOolrBNUI3An2mr
         k61Mk5rIKDKr+flqxmyvUGKEJPUiTBN+GAx5YDhgPbO5U7BKRjKweXNUqD5lWK7t48
         PE/ihhwj8Xpf5/S3MyyYgNM02l/MRtRxQ9j+HJpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 189/279] Revert "mark pstore-blk as broken"
Date:   Wed, 24 Nov 2021 12:57:56 +0100
Message-Id: <20211124115725.257448881@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit d1faacbf67b1944f0e0c618dc581d929263f6fe9 upstream.

This reverts commit d07f3b081ee632268786601f55e1334d1f68b997.

pstore-blk was fixed to avoid the unwanted APIs in commit 7bb9557b48fc
("pstore/blk: Use the normal block device I/O path"), which landed in
the same release as the commit adding BROKEN.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20211116181559.3975566-1-keescook@chromium.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -173,7 +173,6 @@ config PSTORE_BLK
 	tristate "Log panic/oops to a block device"
 	depends on PSTORE
 	depends on BLOCK
-	depends on BROKEN
 	select PSTORE_ZONE
 	default n
 	help


