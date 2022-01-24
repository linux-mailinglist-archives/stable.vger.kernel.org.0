Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1459F499B58
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575153AbiAXVvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53122 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347213AbiAXVns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:43:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D98B8B812A5;
        Mon, 24 Jan 2022 21:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC6FC340E4;
        Mon, 24 Jan 2022 21:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060625;
        bh=cEeNf3jmmVOl8gPLt5Ntuzx6bXre2UP5a4Q4MpBvFYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWaedE3lJAvY7xjZ1UPQ0iRhEdOCuvNRU5S6UTbygjpScg10kx7pxPQEQTM1CSkll
         JQgGABBgB/Q9haBF5vvjkZFQMVgbxocuB0wKKnD+8f2MlaR/0wi+3ywkYecD12Y9wu
         X2pe8rZI93X5g49UyeYZ7r7Acps41nXRgzbzHhbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        anton.ivanov@cambridgegreys.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.16 0977/1039] um: gitignore: Add kernel/capflags.c
Date:   Mon, 24 Jan 2022 19:46:06 +0100
Message-Id: <20220124184158.126983696@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


