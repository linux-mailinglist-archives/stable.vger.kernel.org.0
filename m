Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50394133409
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgAGVXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:23:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbgAGVBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 942A12087F;
        Tue,  7 Jan 2020 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430882;
        bh=AHZfXEucuZbimQcdm3tq3GLPtO6J72ttLah73DEkGLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5T3B35h4SVLS7wEAlJzLjEjOg8XUzwlKYQP6O+Mn0c6bCJ+jI/qUJyitOtf8zq2E
         1gOhmywE82+1d6N8aUxVNr8i55hXndlQKIng7hI2Nfwwo8JuJsdZPTaoiKZrOWfDJ0
         mm64kMplP8dBS3TIGbcHzlURbaGURJ6759ajL3V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.4 136/191] arm64: dts: qcom: msm8998-clamshell: Remove retention idle state
Date:   Tue,  7 Jan 2020 21:54:16 +0100
Message-Id: <20200107205340.245914591@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

commit b40dd23f9a8987c8336df0a00e33f52b1f3f19ad upstream.

The retention idle state does not appear to be supported by the firmware
present on the msm8998 laptops since the state is advertised as disabled
in ACPI, and attempting to enable the state in DT is observed to result
in boot hangs.  Therefore, remove the state from use to address the
observed issues.

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Fixes: 2c6d2d3a580a (arm64: dts: qcom: Add Lenovo Miix 630)
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/qcom/msm8998-clamshell.dtsi |   37 ++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/arch/arm64/boot/dts/qcom/msm8998-clamshell.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-clamshell.dtsi
@@ -23,6 +23,43 @@
 	};
 };
 
+/*
+ * The laptop FW does not appear to support the retention state as it is
+ * not advertised as enabled in ACPI, and enabling it in DT can cause boot
+ * hangs.
+ */
+&CPU0 {
+	cpu-idle-states = <&LITTLE_CPU_SLEEP_1>;
+};
+
+&CPU1 {
+	cpu-idle-states = <&LITTLE_CPU_SLEEP_1>;
+};
+
+&CPU2 {
+	cpu-idle-states = <&LITTLE_CPU_SLEEP_1>;
+};
+
+&CPU3 {
+	cpu-idle-states = <&LITTLE_CPU_SLEEP_1>;
+};
+
+&CPU4 {
+	cpu-idle-states = <&BIG_CPU_SLEEP_1>;
+};
+
+&CPU5 {
+	cpu-idle-states = <&BIG_CPU_SLEEP_1>;
+};
+
+&CPU6 {
+	cpu-idle-states = <&BIG_CPU_SLEEP_1>;
+};
+
+&CPU7 {
+	cpu-idle-states = <&BIG_CPU_SLEEP_1>;
+};
+
 &qusb2phy {
 	status = "okay";
 


