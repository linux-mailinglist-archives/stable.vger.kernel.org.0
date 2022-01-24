Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0372E4995A5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352750AbiAXUxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48840 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391924AbiAXUuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:50:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7439BB80CCF;
        Mon, 24 Jan 2022 20:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F1CC340E5;
        Mon, 24 Jan 2022 20:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057401;
        bh=cEeNf3jmmVOl8gPLt5Ntuzx6bXre2UP5a4Q4MpBvFYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMb/Onp78ur2tmhBIZDWSF7H/9mCMs2/Xf2AVS1wWLRL37yekrTijfH7f+7XR9gSC
         XqKnn6sM5Ge1tVrZhZmCqsFeEZKNnUNYPrqMSJzahKtwJm2Q1pxZK/eNyFVbhcBTh3
         M/xrWjxcRj5zUPb8YTqzb2GNjSi2HpT0llbyCmcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        anton.ivanov@cambridgegreys.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 801/846] um: gitignore: Add kernel/capflags.c
Date:   Mon, 24 Jan 2022 19:45:18 +0100
Message-Id: <20220124184128.570992096@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 4b86366fdfbedec42f8f7ee037775f2839921d34 upstream.

This file is generated, we should ignore it.

Fixes: d8fb32f4790f ("um: Add support for host CPU flags and alignment")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-By: anton.ivanov@cambridgegreys.com
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/.gitignore
+++ b/arch/um/.gitignore
@@ -2,3 +2,4 @@
 kernel/config.c
 kernel/config.tmp
 kernel/vmlinux.lds
+kernel/capflags.c


