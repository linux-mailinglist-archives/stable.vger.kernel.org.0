Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E507A3FDAD7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344045AbhIAMfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343620AbhIAMeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:34:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4854560F56;
        Wed,  1 Sep 2021 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499549;
        bh=PzCgjfTuh/oMzoxhM2fp43PaR8VE2mLLNoVwKQnKsn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fn68D24BXJSsZHhGWCdglE4+9J6ngjS6EHmMMN5X7n9nZM7qBez3JVcU+71ODqoy/
         1B01Tht/F0p4ndGYBGxkHzLhMjW5M7F61h/x/N58D82qcMLDo3nL851v85NOhxJcfM
         WK74/Ro3r61/PvENKAMZ2GuL/ZsdNWZENVEtylA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.4 43/48] arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88
Date:   Wed,  1 Sep 2021 14:28:33 +0200
Message-Id: <20210901122254.802140520@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <petr.vorel@gmail.com>

commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 upstream.

Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
application CPUs (causes reboot). Yet another fix similar to
9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").

Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -30,3 +30,7 @@
 		};
 	};
 };
+
+&msmgpio {
+	gpio-reserved-ranges = <85 4>;
+};


