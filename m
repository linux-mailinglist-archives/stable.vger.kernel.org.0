Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9C03961FF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhEaOto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232955AbhEaOrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:47:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34CA961C92;
        Mon, 31 May 2021 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469373;
        bh=a5VTzrLKP9RQ6TwF9Jji3H8ox0Oh06g7F13/6DiQhdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lx1UQTV2cuNMahpujZjn5/OaZgqR2czJ3Ux2C98x7T+HSlHQGgLat/7Hru2Gsl/wx
         ISzBrfe9kfq8l8u2kzx04bKCz6WR2prukS1WoFqUq6d2oqQ8vAeIFt2/mjIs5mxS+J
         FIxX/h+tyOOgLZvH3xsdLmHUMqg/rPLE/eho0ox4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 138/296] sctp: add the missing setting for asoc encap_port
Date:   Mon, 31 May 2021 15:13:13 +0200
Message-Id: <20210531130708.522584824@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 297739bd73f6e49d80bac4bfd27f3598b798c0d4 upstream.

This patch is to add the missing setting back for asoc encap_port.

Fixes: 8dba29603b5c ("sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4473,6 +4473,7 @@ static int sctp_setsockopt_encap_port(st
 				    transports)
 			t->encap_port = encap_port;
 
+		asoc->encap_port = encap_port;
 		return 0;
 	}
 


