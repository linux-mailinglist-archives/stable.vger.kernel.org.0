Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8176360D25
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhDOO5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhDOOzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B53AD613B7;
        Thu, 15 Apr 2021 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498438;
        bh=kbFwtFEh//YvyBN7dfsrfNYpnD3Pij9751BCXfFasNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1whxzd5lyxVMPDIVTUKYmts91rzvLc1N0vDaIunlnGFi9msZ6LQ3pc6OcOhLr/xt
         dN8t2f/APLgHKEMsYdwXJITy5Ow7ERc6V/e+eJGrGyl/670J1+uRjdqtQjnllFybZh
         E+KOXcrCKsQMRa2EN++XhhCWJAEdt+n2tOmeJfjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 39/68] net/ncsi: Make local function ncsi_get_filter() static
Date:   Thu, 15 Apr 2021 16:47:20 +0200
Message-Id: <20210415144415.747698821@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 5a6d80034471d4407052c4bf3758071df5cadf33 upstream.

Fixes the following sparse warnings:

net/ncsi/ncsi-manage.c:41:5: warning:
 symbol 'ncsi_get_filter' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -38,7 +38,7 @@ static inline int ncsi_filter_size(int t
 	return sizes[table];
 }
 
-u32 *ncsi_get_filter(struct ncsi_channel *nc, int table, int index)
+static u32 *ncsi_get_filter(struct ncsi_channel *nc, int table, int index)
 {
 	struct ncsi_channel_filter *ncf;
 	int size;


