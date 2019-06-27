Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A0D5786B
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfF0AxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbfF0Ac6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:58 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B440C216E3;
        Thu, 27 Jun 2019 00:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595577;
        bh=Zpi+al02WqHVljQ3LutTQXh4ZoBKJpMYuLxnSgB+lO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r33pwCNzIIRxZAcq1ezdNfyudndJGhGqkpsMDDeJfi7B/x+3rcGc99D4Z346R2DSZ
         rxsmCiP08gvh3X50qlrJOQQN6j9ZJbsFM5shGSVJ9Ryf8ym1StpozJOD3TCgyORwUF
         TNDUwDCT/GLgRkhcwSO7TE5uy/2MMfTgBTuydDd8=
Date:   Thu, 27 Jun 2019 08:32:30 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 4.4.184
Message-ID: <20190627003230.GB10733@kroah.com>
References: <20190627003224.GA10733@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627003224.GA10733@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4ac762e01e60..f098274d3ac3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 183
+SUBLEVEL = 184
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bed83990847a..53edd60fd381 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1161,7 +1161,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
