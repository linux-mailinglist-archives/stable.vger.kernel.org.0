Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAAB38A643
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhETKZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233847AbhETKXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1053C61A1D;
        Thu, 20 May 2021 09:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504129;
        bh=YPGyLXhMbze5n27xjquJtyDQbHRqbqSMTF1EbWGUv4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pErN/BFx+wVgkgvd1IkfotyS3ipm0ZKe57CYLua1RU6HTZoxHpuBuJ4JClKl48DM4
         wQ0QTESVDWM0qT3xYgBD/vwca6psK+35gydPbMAR5mSP+dbQ8hVxtpmzAHGO+ndisK
         XJzLTMf2z851qwgfnutlJTXMVJ8LsPJE8ACZHDbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.14 106/323] modules: unexport __module_text_address
Date:   Thu, 20 May 2021 11:19:58 +0200
Message-Id: <20210520092123.738361819@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 3fe1e56d0e68b623dd62d8d38265d2a052e7e185 upstream.

__module_text_address is only used by built-in code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4363,7 +4363,6 @@ struct module *__module_text_address(uns
 	}
 	return mod;
 }
-EXPORT_SYMBOL_GPL(__module_text_address);
 
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)


