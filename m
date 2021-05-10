Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3F937815B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhEJK0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhEJKZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BAB861480;
        Mon, 10 May 2021 10:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642268;
        bh=Cfbvts6t1USftschfsI5m1DCpxuEC2PcEzK6HAk6UpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFrDTb8BYpLtQ5yXledyplTbQa5qxGDIUhFdGm1EYiBWqd9Z5+tDYC7lnCTvuBmWJ
         uwC2TwvUqFN1z0y4TlKF0Cn46UiKjAFtlDQ0Pwhzv5Bq0bQuIXpL4XQbWTOR7kRdUQ
         LtCk5mxSwBO0qjVVpZWAia6aF5Rab5yeBRVV5Aok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 027/184] modules: unexport __module_text_address
Date:   Mon, 10 May 2021 12:18:41 +0200
Message-Id: <20210510101951.126552484@linuxfoundation.org>
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
@@ -4655,7 +4655,6 @@ struct module *__module_text_address(uns
 	}
 	return mod;
 }
-EXPORT_SYMBOL_GPL(__module_text_address);
 
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)


