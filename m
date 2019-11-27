Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BFE10BDBB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfK0Uyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbfK0Uyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:54:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E84AD2086A;
        Wed, 27 Nov 2019 20:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888090;
        bh=8y4F4zJ/0YdErinTJKC1KPDel9bHpHfwd6bZFxlFhc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFp6MsBHpSVinPUUgK7cxQr3H2Bmx3fyMnfxfykD1nCUKrDc8STfiuIBqfRbcYBAw
         sU4VmE7Bx2GjoYDiCyY70MVqEs8wSGB3ZJFYypwcBWkeZFL5V29C4L7xUrX5zL2wIJ
         gLRQtV0Dq+7gUAhCiWvY9E6kFQXLIyw3mEPYRlPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 211/211] x86/hyperv: mark hyperv_init as __init function
Date:   Wed, 27 Nov 2019 21:32:24 +0100
Message-Id: <20191127203113.461864801@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org>

This change was done upstream as part of 6b48cb5f8347 ("X86/Hyper-V:
Enlighten APIC access"), but that commit introduced a lot of new
functionality we don't want to backport.

This change eliminates a build warning.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/hyperv/hv_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -125,7 +125,7 @@ static int __init hv_pci_init(void)
  * 1. Setup the hypercall page.
  * 2. Register Hyper-V specific clocksource.
  */
-void hyperv_init(void)
+void __init hyperv_init(void)
 {
 	u64 guest_id, required_msrs;
 	union hv_x64_msr_hypercall_contents hypercall_msr;


