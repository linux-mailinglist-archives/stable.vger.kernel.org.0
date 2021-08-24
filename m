Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B173F6979
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 21:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhHXTE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 15:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhHXTE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 15:04:27 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B630DC061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:03:42 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q11so5834760wrr.9
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pd7krVLSYqOVORjTSvZbw0T/VrcPlxusoZklkJIMEGc=;
        b=YlsnjIrvaueUB91atpJ092/PcNI+EY1IoOmti4nomwqeji8Dt59vFDZ8gAKpMWQoBy
         OBD2YCkRAVjOalLg5SHkdmB24SsHzd/FPSu4++vXzUkIDsGg/Il6P0SYpeJZaDMa7VeT
         c1KRpT9ff513gQjc+1P5oR3sPsskzLagqyfw5g4QfML6dqhJf2w4we6rPwq1F+NUFOLi
         xT0ILssQa32lXk3AC3KBp4htbbmhWduqSqrXnj8mgiobAmIn4t7MB+rZ/uwef4NHY9gU
         XbbzTxZsy36CtGdPnWtk8QzhWKt+bwNGHhGNGs0DCCoFKUCiw55DnPh9l2OwGvTkyFjD
         PH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pd7krVLSYqOVORjTSvZbw0T/VrcPlxusoZklkJIMEGc=;
        b=Jt/QA3qY1w2iMr0SZ0SVCXe0/S2SjMip4bv6k7xGR9wkWfvjwm8TYrCTbAjX/niXZU
         t3onctVHlJOwTebTg9OVACMopzaHUTZJBGOZk8MgPWzNsok9+SkACYE7m6yHxRtpZe4N
         OaE6JArH0NsiyMsj5Dr2t8C6z1VgqTARt0G1j7qZ7XVKKRp5AeUULj+yK4T96l1lCUBX
         Ks+dq6jKox3NpdPHz76Gr0YELmYRFMUoneMKt4kU87mTx0nfvuKHsO51enX2IxoDe655
         A2jj9w+6Jg0jNAGWu0w0Ymv+J5duLSnZ/KbXCU7lEVhUNjMO/jmIBi9ooF/HfAFR250A
         2vkQ==
X-Gm-Message-State: AOAM5330DY+xz6QsG4SxFwlJrsjjVdIEhZUp2zLFK/J6SlqChEzM0y4T
        3ueQ2sDAaTA19XpG9NoxXJHwzVer3iP1AYgx
X-Google-Smtp-Source: ABdhPJwEhZn+D+ILsD2Q/IQt678CtWGZsD85e4pQ12gZvOfAbdFfy50Kl4YXLk+PiMDBfcEUvmD0dg==
X-Received: by 2002:a5d:658e:: with SMTP id q14mr21103462wru.142.1629831821345;
        Tue, 24 Aug 2021 12:03:41 -0700 (PDT)
Received: from dell5510.suse.de (gw1.ms-free.net. [185.243.124.10])
        by smtp.gmail.com with ESMTPSA id z7sm3019155wmi.4.2021.08.24.12.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 12:03:40 -0700 (PDT)
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 1/1] arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88
Date:   Tue, 24 Aug 2021 21:03:31 +0200
Message-Id: <20210824190332.22657-1-petr.vorel@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 upstream.

Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
application CPUs (causes reboot). Yet another fix similar to
9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").

Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")

[ pvorel: rebased for 5.4: tlmm -> msmgpio ]
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
For 5.4.y

 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
index a5f9a6ab512c..9b989cc30edc 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -30,3 +30,7 @@ serial@f991e000 {
 		};
 	};
 };
+
+&msmgpio {
+	gpio-reserved-ranges = <85 4>;
+};
-- 
2.32.0

