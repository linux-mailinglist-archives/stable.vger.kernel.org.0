Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1233B628
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhCON5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhCON4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 774FD64EB6;
        Mon, 15 Mar 2021 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816606;
        bh=sdWnjAJvlnqJ2n9U+Zkd63cqwHEfAh4fXY7VV+tHcpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWg+jwVNnfQjT9OLEq8jON/Ld+7222HgwrYczzMtTsCjKLy28cN5fTiJV1eX07C9j
         fyAyb50dwDZqkTXoKFIoU7LhQohmgmaJswlk4mLCauxIbgAFjwS6+/kQ7VXzLySpmi
         sCIFIHIWSy02qiW4b0zE3cBQHwGD8/XvOhfoAyqA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 001/168] uapi: nfnetlink_cthelper.h: fix userspace compilation error
Date:   Mon, 15 Mar 2021 14:53:53 +0100
Message-Id: <20210315135550.382080702@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dmitry V. Levin <ldv@altlinux.org>

commit c33cb0020ee6dd96cc9976d6085a7d8422f6dbed upstream.

Apparently, <linux/netfilter/nfnetlink_cthelper.h> and
<linux/netfilter/nfnetlink_acct.h> could not be included into the same
compilation unit because of a cut-and-paste typo in the former header.

Fixes: 12f7a505331e6 ("netfilter: add user-space connection tracking helper infrastructure")
Cc: <stable@vger.kernel.org> # v3.6
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/netfilter/nfnetlink_cthelper.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/netfilter/nfnetlink_cthelper.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cthelper.h
@@ -5,7 +5,7 @@
 #define NFCT_HELPER_STATUS_DISABLED	0
 #define NFCT_HELPER_STATUS_ENABLED	1
 
-enum nfnl_acct_msg_types {
+enum nfnl_cthelper_msg_types {
 	NFNL_MSG_CTHELPER_NEW,
 	NFNL_MSG_CTHELPER_GET,
 	NFNL_MSG_CTHELPER_DEL,


