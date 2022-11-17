Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB23462D662
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbiKQJUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239850AbiKQJU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:20:29 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE183697CC
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:27 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k7-20020a256f07000000b006cbcc030bc8so1004099ybc.18
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jxKPojKq0bq8eDKJkwre5ZD4W1zir1ytk8t+kbxa/Rg=;
        b=FQg8YpZ3lgTBgCcnh39goHpz3xKBIGA8hwRet8gI59rkIKFmlBugePqfjUSIi5Lvyo
         gRKA98K78qubu35GekjWtvT6CYF1hhDQ5QCFV9NE8udd1H0vXhMwIAfycekth6xNPbby
         eqpwOhenUk4zPP+DjZ9dBSZt8x0sQrHCRThOko772Xpo61aRlV6hQcgWM7PZ7SDaDKf6
         vOg/svzM1RSjfuzxXBZhuYmDW4vwyl0mgxxcwfAZXZ6LDt1moYZfrbFPDijtZ0rKUD+5
         fWB4aBgUTCrLNqmvZM+PeMdY6OOReS076XvI9dTqHQjYFAFVv42Szr7V8WtKKeV2prhW
         Rt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jxKPojKq0bq8eDKJkwre5ZD4W1zir1ytk8t+kbxa/Rg=;
        b=K2nVvr6cpgvo2zkRd1335R9FFL6EISK7TBlRfcx2ZmfgMboa95iP9FQRREh4rWJlS7
         DwiL+iKS+n2e4YzAURQt55FhOvCRBoM7q36iqAxf9hofMJGU1CoyCHfQrlVDVY2X/8lv
         q94F9nS00zqmk6lg+GM64dmRD8ItJXxj5aBvBtb17uEl7tnkB1BVbBIXkx/2rA8/fBMx
         sAM24v7Nm9EQh+fI1rBHdt/lnsL0NPEls17JDjwbp1LrpXAfUkLTZ9ZKtVOnlV3r+Iyu
         HuMw7aaUdzUYUTw5XUwwFqUAXZODasfQsDsKdrURIcD2aKngVwPn87U+MoMCpmfQdwt2
         dQ6w==
X-Gm-Message-State: ACrzQf26Tf+WMKcvR8TBJ9i+THeNErCAakt/VJ+O0VQX9qaZhorIqzq2
        qfqCE/YmZeepr8zKEZh+bv4uCjc2FR/C3/EAE0zQidOcfDPT0PbkPHIs4TEdgqGEgXBIvmmltuC
        kcNmU85wwPcV9aVmQvAupVEACo1n27Ir5vykGUOCJ+wxvnA8/EPRvATvpnLJSsA/SJfw=
X-Google-Smtp-Source: AMsMyM51mV+ku+h5YLr/+gxHupWW+8xKfuQlPYLSw/gfKcR5cI7UXGaqV8DlhWQtjJ9Z+NzgeZ50/YEBt0Lf1Q==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a05:6902:1508:b0:6ca:7182:444 with SMTP
 id q8-20020a056902150800b006ca71820444mr66317382ybu.512.1668676826128; Thu,
 17 Nov 2022 01:20:26 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:24 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-7-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 06/34] x86/cpu: Add consistent CPU match macros
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

commit 20d437447c0089cda46c683db219d3b4e2cde40e upstream.

Finding all places which build x86_cpu_id match tables is tedious and the
logic is hidden in lots of differently named macro wrappers.

Most of these initializer macros use plain C89 initializers which rely on
the ordering of the struct members. So new members could only be added at
the end of the struct, but that's ugly as hell and C99 initializers are
really the right thing to use.

Provide a set of macros which:

  - Have a proper naming scheme, starting with X86_MATCH_

  - Use C99 initializers

The set of provided macros are all subsets of the base macro

    X86_MATCH_VENDOR_FAM_MODEL_FEATURE()

which allows to supply all possible selection criteria:

      vendor, family, model, feature

The other macros shorten this to avoid typing all arguments when they are
not needed and would require one of the _ANY constants. They have been
created due to the requirements of the existing usage sites.

Also add a few model constants for Centaur CPUs and QUARK.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lkml.kernel.org/r/20200320131508.826011988@linutronix.de
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpu_device_id.h | 140 +++++++++++++++++++++++++--
 arch/x86/include/asm/intel-family.h  |   6 ++
 arch/x86/kernel/cpu/match.c          |  13 ++-
 3 files changed, 146 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index a28dc6ba5be1..f11770fac73a 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -5,21 +5,143 @@
 /*
  * Declare drivers belonging to specific x86 CPUs
  * Similar in spirit to pci_device_id and related PCI functions
- */
-#include <linux/mod_devicetable.h>
-
-/*
+ *
  * The wildcard initializers are in mod_devicetable.h because
  * file2alias needs them. Sigh.
  */
+#include <linux/mod_devicetable.h>
+/* Get the INTEL_FAM* model defines */
+#include <asm/intel-family.h>
+/* And the X86_VENDOR_* ones */
+#include <asm/processor.h>
 
-#define X86_FEATURE_MATCH(x) {			\
-	.vendor		= X86_VENDOR_ANY,	\
-	.family		= X86_FAMILY_ANY,	\
-	.model		= X86_MODEL_ANY,	\
-	.feature	= x,			\
+/* Centaur FAM6 models */
+#define X86_CENTAUR_FAM6_C7_A		0xa
+#define X86_CENTAUR_FAM6_C7_D		0xd
+#define X86_CENTAUR_FAM6_NANO		0xf
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL_FEATURE - Base macro for CPU matching
+ * @_vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@_vendor
+ * @_family:	The family number or X86_FAMILY_ANY
+ * @_model:	The model number, model constant or X86_MODEL_ANY
+ * @_feature:	A X86_FEATURE bit or X86_FEATURE_ANY
+ * @_data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * Use only if you need all selectors. Otherwise use one of the shorter
+ * macros of the X86_MATCH_* family. If there is no matching shorthand
+ * macro, consider to add one. If you really need to wrap one of the macros
+ * into another macro at the usage site for good reasons, then please
+ * start this local macro with X86_MATCH to allow easy grepping.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL_FEATURE(_vendor, _family, _model,	\
+					   _feature, _data) {		\
+	.vendor		= X86_VENDOR_##_vendor,				\
+	.family		= _family,					\
+	.model		= _model,					\
+	.feature	= _feature,					\
+	.driver_data	= (unsigned long) _data				\
 }
 
+/**
+ * X86_MATCH_VENDOR_FAM_FEATURE - Macro for matching vendor, family and CPU feature
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM_FEATURE(vendor, family, feature, data)	\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(vendor, family,		\
+					   X86_MODEL_ANY, feature, data)
+
+/**
+ * X86_MATCH_VENDOR_FEATURE - Macro for matching vendor and CPU feature
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FEATURE(vendor, feature, data)			\
+	X86_MATCH_VENDOR_FAM_FEATURE(vendor, X86_FAMILY_ANY, feature, data)
+
+/**
+ * X86_MATCH_FEATURE - Macro for matching a CPU feature
+ * @feature:	A X86_FEATURE bit
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_FEATURE(feature, data)				\
+	X86_MATCH_VENDOR_FEATURE(ANY, feature, data)
+
+/* Transitional to keep the existing code working */
+#define X86_FEATURE_MATCH(feature)	X86_MATCH_FEATURE(feature, NULL)
+
+/**
+ * X86_MATCH_VENDOR_FAM_MODEL - Match vendor, family and model
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @model:	The model number, model constant or X86_MODEL_ANY
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set to wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, data)		\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(vendor, family, model,	\
+					   X86_FEATURE_ANY, data)
+
+/**
+ * X86_MATCH_VENDOR_FAM - Match vendor and family
+ * @vendor:	The vendor name, e.g. INTEL, AMD, HYGON, ..., ANY
+ *		The name is expanded to X86_VENDOR_@vendor
+ * @family:	The family number or X86_FAMILY_ANY
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * All other missing arguments to X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are
+ * set of wildcards.
+ */
+#define X86_MATCH_VENDOR_FAM(vendor, family, data)			\
+	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, X86_MODEL_ANY, data)
+
+/**
+ * X86_MATCH_INTEL_FAM6_MODEL - Match vendor INTEL, family 6 and model
+ * @model:	The model name without the INTEL_FAM6_ prefix or ANY
+ *		The model name is expanded to INTEL_FAM6_@model internally
+ * @data:	Driver specific data or NULL. The internal storage
+ *		format is unsigned long. The supplied value, pointer
+ *		etc. is casted to unsigned long internally.
+ *
+ * The vendor is set to INTEL, the family to 6 and all other missing
+ * arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are set to wildcards.
+ *
+ * See X86_MATCH_VENDOR_FAM_MODEL_FEATURE() for further information.
+ */
+#define X86_MATCH_INTEL_FAM6_MODEL(model, data)				\
+	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 6, INTEL_FAM6_##model, data)
+
 /*
  * Match specific microcode revisions.
  *
diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index db06f16627b0..1f2f52a34086 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -13,6 +13,9 @@
  * that group keep the CPUID for the variants sorted by model number.
  */
 
+/* Wildcard match for FAM6 so X86_MATCH_INTEL_FAM6_MODEL(ANY) works */
+#define INTEL_FAM6_ANY			X86_MODEL_ANY
+
 #define INTEL_FAM6_CORE_YONAH		0x0E
 
 #define INTEL_FAM6_CORE2_MEROM		0x0F
@@ -101,6 +104,9 @@
 #define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
 #define INTEL_FAM6_XEON_PHI_KNM		0x85 /* Knights Mill */
 
+/* Family 5 */
+#define INTEL_FAM5_QUARK_X1000		0x09 /* Quark X1000 SoC */
+
 /* Useful macros */
 #define INTEL_CPU_FAM_ANY(_family, _model, _driver_data)	\
 {								\
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 6dd78d8235e4..d3482eb43ff3 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -16,12 +16,17 @@
  * respective wildcard entries.
  *
  * A typical table entry would be to match a specific CPU
- * { X86_VENDOR_INTEL, 6, 0x12 }
- * or to match a specific CPU feature
- * { X86_FEATURE_MATCH(X86_FEATURE_FOOBAR) }
+ *
+ * X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6, INTEL_FAM6_BROADWELL,
+ *				      X86_FEATURE_ANY, NULL);
  *
  * Fields can be wildcarded with %X86_VENDOR_ANY, %X86_FAMILY_ANY,
- * %X86_MODEL_ANY, %X86_FEATURE_ANY or 0 (except for vendor)
+ * %X86_MODEL_ANY, %X86_FEATURE_ANY (except for vendor)
+ *
+ * asm/cpu_device_id.h contains a set of useful macros which are shortcuts
+ * for various common selections. The above can be shortened to:
+ *
+ * X86_MATCH_INTEL_FAM6_MODEL(BROADWELL, NULL);
  *
  * Arrays used to match for this should also be declared using
  * MODULE_DEVICE_TABLE(x86cpu, ...)
-- 
2.38.1.431.g37b22c650d-goog

