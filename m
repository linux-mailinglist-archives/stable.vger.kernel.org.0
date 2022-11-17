Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4756C62D660
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiKQJU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239849AbiKQJUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:20:22 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AAA697D5
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:21 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ch21-20020a17090af41500b0021879d85859so204430pjb.8
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i9ZosGBX4Bq8wQCRpvB185DV6OPq8cyeohibbBGrcrE=;
        b=ToMHYFkPuOYNXp9IQAewYgR+fgFvLYE4KAwDJiDAyN2Z2yytZa5DQq7/Xuo1r+zSh9
         j5YtQjoC49nwEBl23zIO8okYpLi17MFd0FLqbAYV+4aksn7z38cb/0BXdssvVynkqK8U
         g7wUGqG2A/eqNPjjqRWFOCc7vu63vnkisbhzr1S3khr8gR7WkHxktmIbTe+uiNHlx0tZ
         WN+y9iPrH3SNm7e2BMNLSoPytHLTVho3b4lceWakJ2rJcuP5R9KGUN/AHaLZroCE36di
         zt1l3erCRw7392gVOJnwhUglECZbLizcI/IopV668ImmodOXE1Pk8eR6l/Qu2QPj3zkj
         G+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i9ZosGBX4Bq8wQCRpvB185DV6OPq8cyeohibbBGrcrE=;
        b=ZMgsR6iN186WB/fNttuj7G/kR7vZ8Bk1RlXpAP1zGbd+J3dtrFvDA1HWh0AbVeclM1
         HaNZ6QvtWC3mCbJQUwdEgeSCqq1Pl+yTkuLc4T+Rukp/cqRx4nDzOxuxLp8JCzjoZ+Dq
         BYV8gPnTc3e2lY3HZsIihSN3qEmatP/VtxssWq2A7tAurUthbjWWw2g/lOAHN08aLFRX
         mQiUMDc4Y2vEejUpKk80h0/DhsjwPvRABIPHiVRlXlLN3O8vC2KFODF65uoJT0g+4NiO
         VY1EUBdatwIVkOVUrD5pRicDmjCpyJEBz8rHGFuUVH4sx36cgQbg+EkRXBFyHoIB3hiF
         AkGw==
X-Gm-Message-State: ANoB5pmO38sciLC2FQQTQptXnHWhbYj+md3esVc2mYl52gTseiGNN30b
        rnqtUNznZKm6vrw2NHsbgNGM+rWZ89z7WlWbLvp9K5x7XUFx70cK+SenzFksOGhPeLQNQ7KPgbn
        97kCGXGzcublP6vg6/soCYOg0dCE6fz9ximdjQCpqJtBiiXEvsTtq5H7raKggAd46TNc=
X-Google-Smtp-Source: AA0mqf4YbSx4bAbBEyvSzygJfHvBIQnKGb20BztsV0Djbrhspk7H3djXZTm399Z7C7RyNhM7+i/wg/1E0Mk2ag==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a63:4c63:0:b0:477:103:d1c4 with SMTP id
 m35-20020a634c63000000b004770103d1c4mr1240692pgl.369.1668676821007; Thu, 17
 Nov 2022 01:20:21 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:23 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-6-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 05/34] x86/devicetable: Move x86 specific macro out of
 generic code
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit ba5bade4cc0d2013cdf5634dae554693c968a090 upstream.

There is no reason that this gunk is in a generic header file. The wildcard
defines need to stay as they are required by file2alias.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lkml.kernel.org/r/20200320131508.736205164@linutronix.de
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[suleiman: vmx.c moved]
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpu_device_id.h   | 13 ++++++++++++-
 arch/x86/kvm/svm.c                     |  1 +
 arch/x86/kvm/vmx.c                     |  1 +
 drivers/cpufreq/acpi-cpufreq.c         |  1 +
 drivers/cpufreq/amd_freq_sensitivity.c |  1 +
 include/linux/mod_devicetable.h        |  4 +---
 6 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 31c379c1da41..a28dc6ba5be1 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -6,9 +6,20 @@
  * Declare drivers belonging to specific x86 CPUs
  * Similar in spirit to pci_device_id and related PCI functions
  */
-
 #include <linux/mod_devicetable.h>
 
+/*
+ * The wildcard initializers are in mod_devicetable.h because
+ * file2alias needs them. Sigh.
+ */
+
+#define X86_FEATURE_MATCH(x) {			\
+	.vendor		= X86_VENDOR_ANY,	\
+	.family		= X86_FAMILY_ANY,	\
+	.model		= X86_MODEL_ANY,	\
+	.feature	= x,			\
+}
+
 /*
  * Match specific microcode revisions.
  *
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e1492a67e988..5b68ec68fc13 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -50,6 +50,7 @@
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
+#include <asm/cpu_device_id.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c0ea3b82ff00..88c2027d9305 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -41,6 +41,7 @@
 
 #include <asm/asm.h>
 #include <asm/cpu.h>
+#include <asm/cpu_device_id.h>
 #include <asm/io.h>
 #include <asm/desc.h>
 #include <asm/vmx.h>
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 9e86404a361f..40c969432f45 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -47,6 +47,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
index be926d9a66e5..4b4f128c3488 100644
--- a/drivers/cpufreq/amd_freq_sensitivity.c
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -21,6 +21,7 @@
 
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
 
 #include "cpufreq_ondemand.h"
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index c30839a15f50..c3c4037f001f 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -631,9 +631,7 @@ struct x86_cpu_id {
 	kernel_ulong_t driver_data;
 };
 
-#define X86_FEATURE_MATCH(x) \
-	{ X86_VENDOR_ANY, X86_FAMILY_ANY, X86_MODEL_ANY, x }
-
+/* Wild cards for x86_cpu_id::vendor, family, model and feature */
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
-- 
2.38.1.431.g37b22c650d-goog

