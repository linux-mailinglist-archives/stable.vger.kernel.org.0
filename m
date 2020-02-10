Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A611577B8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgBJMki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbgBJMkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:37 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C912467C;
        Mon, 10 Feb 2020 12:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338435;
        bh=AAeF/Nt9jW2Snoh4pyuqzo4DbptBCEae4ZWqBrdcEeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XA8KGEzUijXbYsWrmbITdQ30eJx3LeCC4U1ILSeymmXVGReRr5TnrZV3cx+Zd8644
         M3QO+b4XtNPIRF6yjPCBdgEQ9PGryrb93GLF72NQ0nROHwGS+TYWQxvvTtJqopVU16
         YeoUyDcMwlkLUsPXzpobMe/dSy0BA7pkC3YujYp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.5 169/367] samples/bpf: Reintroduce missed build targets
Date:   Mon, 10 Feb 2020 04:31:22 -0800
Message-Id: <20200210122440.493021506@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

commit 5984dc6cb5aa6cce342a44f01f984fde09ed05b1 upstream.

Add xdp_redirect and per_socket_stats_example in build targets.
They got removed from build targets in Makefile reorganization.

Fixes: 1d97c6c2511f ("samples/bpf: Base target programs rules on Makefile.target")
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191216071619.25479-1-prashantbhole.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/bpf/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -38,6 +38,8 @@ tprogs-y += tc_l2_redirect
 tprogs-y += lwt_len_hist
 tprogs-y += xdp_tx_iptunnel
 tprogs-y += test_map_in_map
+tprogs-y += per_socket_stats_example
+tprogs-y += xdp_redirect
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_monitor


