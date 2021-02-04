Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71D030F5AE
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 16:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbhBDO6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 09:58:35 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34039 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236954AbhBDO6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 09:58:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E528E19402C8;
        Thu,  4 Feb 2021 09:57:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Feb 2021 09:57:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ReKqu5
        ho9ZdBDMXVRzZvmlh5o8ZEmbCcX/99Q/SQMKM=; b=e/jBIPeW33ot0Gox4soV5a
        DGL5VQVZ4Pp8l56KoO5jHGwj2oVy8kHBSmG1HjnXkjyWiJmltUjdYiunNCOHPb6I
        TbFi7A4rzpTN6IpPVWQ4hXwmN41wiXZ8mjSTcDSXcFTfAN3u0v9Q0yFopLoUP2CK
        5fFf7zVsYVzPPkSglsXbz0wwjTJdKVD7rJ6iaa5PU2v1DKOgeDQ2Mq6NhxoqvyUY
        dHc91Qdeh2iAeIOyC02/5kxc5A3ut4rWewJ99gs2WF2dxdWpQ4cJNr6uAvuoUyf5
        YCjBsZT5qlnE8hvZMLizrk58DjEOJ6G0Od3A46gQN3yw6htgEpBiuPf4LvtJe1yw
        ==
X-ME-Sender: <xms:UgscYI7vbVIp4b3v-JHmLS5dHgbktmEB_1jqdgoOtVVJWOSyOPumMQ>
    <xme:UgscYJ6v5iAHshn0G5Rlt59PCAEjaLhA8h-LFF898a6mtZaSFPzs5OtYDPOZMOOP9
    AsAhMA1nxtWfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeeggdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UgscYHcSCSX6X7XK2iv0st101wpLmsKsNXZX7e-snr7QYPqSCzK-pQ>
    <xmx:UgscYNIyC2iUqSPNN3rhHkVZ122pFphT2nw5Zeko3y-Y1--cQxUBCQ>
    <xmx:UgscYMITSY6ciH63GAc_zVMHUO768vZ1mV1HltlakyNkwCO-YlAUnw>
    <xmx:UgscYGgGsz_DVpGiZjlKKMn0ljqc0H7J5GEcGePrkWSl9Gj3Nzqc_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 688AA1080057;
        Thu,  4 Feb 2021 09:57:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] iwlwifi: mvm: fix the return type for DSM functions 1 and 2" failed to apply to 5.10-stable tree
To:     matt.chen@intel.com, kvalo@codeaurora.org, luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Feb 2021 15:57:20 +0100
Message-ID: <1612450640220130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aefbe5c445c7e2f0e082b086ba1e45502dac4b0e Mon Sep 17 00:00:00 2001
From: Matt Chen <matt.chen@intel.com>
Date: Fri, 22 Jan 2021 14:52:36 +0200
Subject: [PATCH] iwlwifi: mvm: fix the return type for DSM functions 1 and 2

The return type value of functions 1 and 2 were considered to be an
integer inside a buffer, but they can also be only an integer, without
the buffer.  Fix the code in iwl_acpi_get_dsm_u8() to handle it as a
single integer value, as well as packed inside a buffer.

Signed-off-by: Matt Chen <matt.chen@intel.com>
Fixes: 9db93491f29e ("iwlwifi: acpi: support device specific method (DSM)")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.5757092adcd6.Ic24524627b899c9a01af38107a62a626bdf5ae3a@changeid

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 15248b064380..d8b7776a8dde 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -80,19 +80,45 @@ static void *iwl_acpi_get_dsm_object(struct device *dev, int rev, int func,
 }
 
 /*
- * Evaluate a DSM with no arguments and a single u8 return value (inside a
- * buffer object), verify and return that value.
+ * Generic function to evaluate a DSM with no arguments
+ * and an integer return value,
+ * (as an integer object or inside a buffer object),
+ * verify and assign the value in the "value" parameter.
+ * return 0 in success and the appropriate errno otherwise.
  */
-int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func)
+static int iwl_acpi_get_dsm_integer(struct device *dev, int rev, int func,
+				    u64 *value, size_t expected_size)
 {
 	union acpi_object *obj;
-	int ret;
+	int ret = 0;
 
 	obj = iwl_acpi_get_dsm_object(dev, rev, func, NULL);
-	if (IS_ERR(obj))
+	if (IS_ERR(obj)) {
+		IWL_DEBUG_DEV_RADIO(dev,
+				    "Failed to get  DSM object. func= %d\n",
+				    func);
 		return -ENOENT;
+	}
+
+	if (obj->type == ACPI_TYPE_INTEGER) {
+		*value = obj->integer.value;
+	} else if (obj->type == ACPI_TYPE_BUFFER) {
+		__le64 le_value = 0;
 
-	if (obj->type != ACPI_TYPE_BUFFER) {
+		if (WARN_ON_ONCE(expected_size > sizeof(le_value)))
+			return -EINVAL;
+
+		/* if the buffer size doesn't match the expected size */
+		if (obj->buffer.length != expected_size)
+			IWL_DEBUG_DEV_RADIO(dev,
+					    "ACPI: DSM invalid buffer size, padding or truncating (%d)\n",
+					    obj->buffer.length);
+
+		 /* assuming LE from Intel BIOS spec */
+		memcpy(&le_value, obj->buffer.pointer,
+		       min_t(size_t, expected_size, (size_t)obj->buffer.length));
+		*value = le64_to_cpu(le_value);
+	} else {
 		IWL_DEBUG_DEV_RADIO(dev,
 				    "ACPI: DSM method did not return a valid object, type=%d\n",
 				    obj->type);
@@ -100,15 +126,6 @@ int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func)
 		goto out;
 	}
 
-	if (obj->buffer.length != sizeof(u8)) {
-		IWL_DEBUG_DEV_RADIO(dev,
-				    "ACPI: DSM method returned invalid buffer, length=%d\n",
-				    obj->buffer.length);
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ret = obj->buffer.pointer[0];
 	IWL_DEBUG_DEV_RADIO(dev,
 			    "ACPI: DSM method evaluated: func=%d, ret=%d\n",
 			    func, ret);
@@ -116,6 +133,24 @@ int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func)
 	ACPI_FREE(obj);
 	return ret;
 }
+
+/*
+ * Evaluate a DSM with no arguments and a u8 return value,
+ */
+int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func, u8 *value)
+{
+	int ret;
+	u64 val;
+
+	ret = iwl_acpi_get_dsm_integer(dev, rev, func, &val, sizeof(u8));
+
+	if (ret < 0)
+		return ret;
+
+	/* cast val (u64) to be u8 */
+	*value = (u8)val;
+	return 0;
+}
 IWL_EXPORT_SYMBOL(iwl_acpi_get_dsm_u8);
 
 union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 042dd247d387..1cce30d1ef55 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #ifndef __iwl_fw_acpi__
 #define __iwl_fw_acpi__
@@ -99,7 +99,7 @@ struct iwl_fw_runtime;
 
 void *iwl_acpi_get_object(struct device *dev, acpi_string method);
 
-int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func);
+int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func, u8 *value);
 
 union acpi_object *iwl_acpi_get_wifi_pkg(struct device *dev,
 					 union acpi_object *data,
@@ -159,7 +159,8 @@ static inline void *iwl_acpi_get_dsm_object(struct device *dev, int rev,
 	return ERR_PTR(-ENOENT);
 }
 
-static inline int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func)
+static inline
+int iwl_acpi_get_dsm_u8(struct device *dev, int rev, int func, u8 *value)
 {
 	return -ENOENT;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0637eb1cff4e..313e9f106f46 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1090,20 +1090,22 @@ static void iwl_mvm_tas_init(struct iwl_mvm *mvm)
 
 static u8 iwl_mvm_eval_dsm_indonesia_5g2(struct iwl_mvm *mvm)
 {
+	u8 value;
+
 	int ret = iwl_acpi_get_dsm_u8((&mvm->fwrt)->dev, 0,
-				      DSM_FUNC_ENABLE_INDONESIA_5G2);
+				      DSM_FUNC_ENABLE_INDONESIA_5G2, &value);
 
 	if (ret < 0)
 		IWL_DEBUG_RADIO(mvm,
 				"Failed to evaluate DSM function ENABLE_INDONESIA_5G2, ret=%d\n",
 				ret);
 
-	else if (ret >= DSM_VALUE_INDONESIA_MAX)
+	else if (value >= DSM_VALUE_INDONESIA_MAX)
 		IWL_DEBUG_RADIO(mvm,
-				"DSM function ENABLE_INDONESIA_5G2 return invalid value, ret=%d\n",
-				ret);
+				"DSM function ENABLE_INDONESIA_5G2 return invalid value, value=%d\n",
+				value);
 
-	else if (ret == DSM_VALUE_INDONESIA_ENABLE) {
+	else if (value == DSM_VALUE_INDONESIA_ENABLE) {
 		IWL_DEBUG_RADIO(mvm,
 				"Evaluated DSM function ENABLE_INDONESIA_5G2: Enabling 5g2\n");
 		return DSM_VALUE_INDONESIA_ENABLE;
@@ -1114,25 +1116,26 @@ static u8 iwl_mvm_eval_dsm_indonesia_5g2(struct iwl_mvm *mvm)
 
 static u8 iwl_mvm_eval_dsm_disable_srd(struct iwl_mvm *mvm)
 {
+	u8 value;
 	int ret = iwl_acpi_get_dsm_u8((&mvm->fwrt)->dev, 0,
-				      DSM_FUNC_DISABLE_SRD);
+				      DSM_FUNC_DISABLE_SRD, &value);
 
 	if (ret < 0)
 		IWL_DEBUG_RADIO(mvm,
 				"Failed to evaluate DSM function DISABLE_SRD, ret=%d\n",
 				ret);
 
-	else if (ret >= DSM_VALUE_SRD_MAX)
+	else if (value >= DSM_VALUE_SRD_MAX)
 		IWL_DEBUG_RADIO(mvm,
-				"DSM function DISABLE_SRD return invalid value, ret=%d\n",
-				ret);
+				"DSM function DISABLE_SRD return invalid value, value=%d\n",
+				value);
 
-	else if (ret == DSM_VALUE_SRD_PASSIVE) {
+	else if (value == DSM_VALUE_SRD_PASSIVE) {
 		IWL_DEBUG_RADIO(mvm,
 				"Evaluated DSM function DISABLE_SRD: setting SRD to passive\n");
 		return DSM_VALUE_SRD_PASSIVE;
 
-	} else if (ret == DSM_VALUE_SRD_DISABLE) {
+	} else if (value == DSM_VALUE_SRD_DISABLE) {
 		IWL_DEBUG_RADIO(mvm,
 				"Evaluated DSM function DISABLE_SRD: disabling SRD\n");
 		return DSM_VALUE_SRD_DISABLE;

