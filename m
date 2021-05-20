Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE6C38A2F4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhETJrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233587AbhETJpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:45:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A1D3613C8;
        Thu, 20 May 2021 09:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503217;
        bh=joXcTRyBO6+RIlxlmILKbbz79RVU1EeeGmgAzuv5BtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXf7RvYAZulLNT+HpRfS5CEUEFqvB+X5o7u6RVRp/c6FKPpAhAYcMvp1k601sctAp
         KWdjXXWM4M3fBK3ohXeMVgjD7iLNuDRZQg7HQwnHhGWndXSjNAxwcC7hQMlFQWvZOg
         nSkASQiBCF/c1CkRH2DwV3phfujdD0DRArBad1zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 122/425] modules: unexport __module_text_address
Date:   Thu, 20 May 2021 11:18:11 +0200
Message-Id: <20210520092135.447672729@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -4420,7 +4420,6 @@ struct module *__module_text_address(uns
 	}
 	return mod;
 }
-EXPORT_SYMBOL_GPL(__module_text_address);
 
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)


