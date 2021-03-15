Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEA533B4F8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCONxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhCONwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1C964E83;
        Mon, 15 Mar 2021 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816357;
        bh=OWJwJ/RfU9eoP+lt2ixvaneMue5Og0CGiVdowaQOylU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMossYmCJY1VL9UWwJ5SQX24g4HLm4xbX2NxAc2OrWfGY2Y1wCMI1g9+jmknbDZ6S
         mkFTWw1aquEGwDz5Vioeg9EAF0KwN4g7z7TNujZgrqpHR/X26gWkWamno4+fy10kds
         aMlaRRaIErcEi6vRpiDJvNsvH3Kd29g7WFj+7UTk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 01/75] uapi: nfnetlink_cthelper.h: fix userspace compilation error
Date:   Mon, 15 Mar 2021 14:51:15 +0100
Message-Id: <20210315135208.304195409@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
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
@@ -4,7 +4,7 @@
 #define NFCT_HELPER_STATUS_DISABLED	0
 #define NFCT_HELPER_STATUS_ENABLED	1
 
-enum nfnl_acct_msg_types {
+enum nfnl_cthelper_msg_types {
 	NFNL_MSG_CTHELPER_NEW,
 	NFNL_MSG_CTHELPER_GET,
 	NFNL_MSG_CTHELPER_DEL,


