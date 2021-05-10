Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245AD378160
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhEJK0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231324AbhEJKZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D98F761466;
        Mon, 10 May 2021 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642273;
        bh=zxd5eny5ya7eBQtNqC7eOkuBTpNB4TU/Hvtzjj1Dsp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUuOvblT3VN0YcHYkV8V6Oyd0byUqgD/gH1G9NcOxPz/IrF1KQa8VK3ViGr0wq0I7
         x/cXMzl2J5lzr1R9ATrNDX3gIK/JV9DDnCR02GIhhU+R/lD6MLExKBpD0FJ2nEUdOg
         VebCGmWdfAs3WHVNot17cbSe0bya1Wm5yV8+N7Ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 028/184] modules: unexport __module_address
Date:   Mon, 10 May 2021 12:18:42 +0200
Message-Id: <20210510101951.157944243@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 34e64705ad415ed7a816e60ef62b42fe6d1729d9 upstream.

__module_address is only used by built-in code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4616,7 +4616,6 @@ struct module *__module_address(unsigned
 	}
 	return mod;
 }
-EXPORT_SYMBOL_GPL(__module_address);
 
 /*
  * is_module_text_address - is this address inside module code?


