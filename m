Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2538A644
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhETKZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235980AbhETKXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C1ED61474;
        Thu, 20 May 2021 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504131;
        bh=qmevDvHt37cbYpa05jEqQrvorBEuUHuklTFg70A+woc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TurbggTlK69LH5LzmcLWaLxn4+hT01G2gv4C6naKlxrGWTQUEGZ+Eer6vHtlFndD3
         uSw3GxIFO0GonJX1lYaY5n09BrhSJZPXxhom+79QM6cOaaRYoSSfSZD8d1shgecRUm
         7OKH/F2e7NfylnYlUrCORWDRgUAHfaD79M3pXv5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.14 107/323] modules: unexport __module_address
Date:   Thu, 20 May 2021 11:19:59 +0200
Message-Id: <20210520092123.770398260@linuxfoundation.org>
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
@@ -4324,7 +4324,6 @@ struct module *__module_address(unsigned
 	}
 	return mod;
 }
-EXPORT_SYMBOL_GPL(__module_address);
 
 /*
  * is_module_text_address - is this address inside module code?


