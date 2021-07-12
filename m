Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E253C4BEF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242525AbhGLHAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242485AbhGLHAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A8461156;
        Mon, 12 Jul 2021 06:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073042;
        bh=8VWhnlooXYMQHdbWzrlpCM6p2aSc25q8pmPyeBK0T2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGhQMGi9IP36K7FyKNOvrU65YgCAvGDPlFbnXFgg4n+UT0K3SzdTDkxpJEbB8fzbV
         1Mo4Kv1jNaAB+/CtI6Ct5/+7hEOFEoUuC03rUGeEJE9XThEYsOIQhcgsDB3htMF3OX
         YBKbtUfB/DPD7pqrXrS9LL0Sd9jBGoKrGt/m8eiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.12 106/700] x86/gpu: add JasperLake to gen11 early quirks
Date:   Mon, 12 Jul 2021 08:03:09 +0200
Message-Id: <20210712060939.810011284@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>

commit 31b77c70d9bc04d3b024ea56c129523f9edc1328 upstream.

Let's reserve JSL stolen memory for graphics.

JasperLake is a gen11 platform which is compatible with
ICL/EHL changes.

This was missed in commit 24ea098b7c0d ("drm/i915/jsl: Split
EHL/JSL platform info and PCI ids")

V2:
    - Added maintainer list in cc
    - Added patch ref in commit message
V1:
    - Added Cc: x86@kernel.org

Fixes: 24ea098b7c0d ("drm/i915/jsl: Split EHL/JSL platform info and PCI ids")
Cc: <stable@vger.kernel.org> # v5.11+
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210608053411.394166-1-tejaskumarx.surendrakumar.upadhyay@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/early-quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -549,6 +549,7 @@ static const struct pci_device_id intel_
 	INTEL_CNL_IDS(&gen9_early_ops),
 	INTEL_ICL_11_IDS(&gen11_early_ops),
 	INTEL_EHL_IDS(&gen11_early_ops),
+	INTEL_JSL_IDS(&gen11_early_ops),
 	INTEL_TGL_12_IDS(&gen11_early_ops),
 	INTEL_RKL_IDS(&gen11_early_ops),
 };


