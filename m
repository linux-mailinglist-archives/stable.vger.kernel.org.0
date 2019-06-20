Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE414D7C3
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbfFTSKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbfFTSKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 408A021530;
        Thu, 20 Jun 2019 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054208;
        bh=NyC9PH7p/AXAVNh4o5PPa/b01sXVyxqXRA3P2gRCTl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sb2MTtVyYKgc/4/51R6xtVBrBW47N1jrPdBJbDhpZU1csQSUjOT1ZUOawBGjjp35l
         p1yLuet5CcZWPsk7VGN6+VjLT1xtDF3lnqYB/s5dDxYe7I5L/ke0/CWQJYy22vL9Js
         kRSyaHdxwjNxECGrnT+cPHCok9DgIiaBe6/N5/c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 03/61] hv_netvsc: Set probe mode to sync
Date:   Thu, 20 Jun 2019 19:56:58 +0200
Message-Id: <20190620174338.037054513@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 9a33629ba6b26caebd73e3c581ba1e6068c696a7 ]

For better consistency of synthetic NIC names, we set the probe mode to
PROBE_FORCE_SYNCHRONOUS. So the names can be aligned with the vmbus
channel offer sequence.

Fixes: af0a5646cb8d ("use the new async probing feature for the hyperv drivers")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2405,7 +2405,7 @@ static struct  hv_driver netvsc_drv = {
 	.probe = netvsc_probe,
 	.remove = netvsc_remove,
 	.driver = {
-		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };
 


