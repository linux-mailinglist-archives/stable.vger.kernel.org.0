Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3F138A2F8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhETJrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233526AbhETJpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C95E261459;
        Thu, 20 May 2021 09:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503219;
        bh=CFH5O1Tt+AUZ8R4EwwDAFIjTTq14CmXEpB1agV01dxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hw8i+5qql64pzv5PYAQJXx8bViX06PSBf8A0g4dafP2/1MD4Jc660Or+CudTcLSb0
         QQBhqKbHlJstPJFzL2WsQO2OqM1ZMW9i9yRgIcugm8PSQQ0o4LkYbpjd6nwjpM/PZp
         UdqH6YS9n2ee1t5s1V1zjVrKKAu32hPSn+/qdQdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 123/425] modules: unexport __module_address
Date:   Thu, 20 May 2021 11:18:12 +0200
Message-Id: <20210520092135.477618826@linuxfoundation.org>
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
@@ -4381,7 +4381,6 @@ struct module *__module_address(unsigned
 	}
 	return mod;
 }
-EXPORT_SYMBOL_GPL(__module_address);
 
 /*
  * is_module_text_address - is this address inside module code?


