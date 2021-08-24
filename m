Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C2B3F696F
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhHXTDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 15:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbhHXTDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 15:03:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C50C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:02:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z9so32718735wrh.10
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TsFsBLXV+mXOTPdELKw9RkT0BKa/0Z19mbCyhJErhVE=;
        b=AQmHZCt8tWk+cplOW48+LR8JWagIpz0AmEZxq1BO7Ah/VZGiUxwurxt1+2uP9oNqTn
         z0BR6zXzbwaAhHw10QO0G/Q5h/o+nLq8AVN8H+u3HlmUdQTvlIVPBIzJWUAQnNDweQeB
         FnUHwVsh82ubtXfvry0ZzPnQF0jTe8cToxGzEUJQ2MK9YW7YeWn/1l9nycXyvp7podHP
         KsH5y+HR9txh/Gs+hPioqQ5wFEOfnPhLCK/icDlKiOQpoknS9CgxyVGyEC/sYgkd0N2/
         kwsBvhOIMC9mL3jOU33jyweSnQMZlTFJOkOYLnea0q7c20WQpHVPBoztk+SA4bLzd6dw
         kbNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TsFsBLXV+mXOTPdELKw9RkT0BKa/0Z19mbCyhJErhVE=;
        b=W9twsovmZlg2mfQ6Q9fjxSuwQ/6lle886d0HdzLQhQjCUC7B8EH2OZWfunAPPoappl
         KZ/cG1iQwDcUR4Br8ttSBwSaGdHs3Nk+V5TxFtXXz/nKvYz983BMN9mrs+aSGO6wk7N7
         K0EmOu5D4T5PK+kabDofwcOibossAnDPjfWx7pL76LGnhVBjK2qjiOTgogMVSuFUVHXn
         RrDiHJLFuaN0/8qznratTBDvfBNJOHArY5xO7Tl/0EjwiJK5AowGMQJXRZCEj4CONTTV
         zGbx4l0kt2Jr/HyrAfFNapTx57PhUGEF9MvwR49kTfTLPN3PZH1zR+a00bqY0ZsfYtC4
         4PyQ==
X-Gm-Message-State: AOAM532X9cv380TZ7oXdDnKMYayAxMO1oVJTr8bNP6BMBz+njB+XrBZJ
        GK9b6ndahM6Q36Yvp5IzPFoc/88+ru6jhWj9
X-Google-Smtp-Source: ABdhPJyB2KpsHlD7iyOZCYfMNiUHd/xdQ7m9BR4VYbS8ARRgvV1fgMFXy2u1C1mERmK6VXK3RtIjBQ==
X-Received: by 2002:a5d:634f:: with SMTP id b15mr1009463wrw.220.1629831738967;
        Tue, 24 Aug 2021 12:02:18 -0700 (PDT)
Received: from dell5510.suse.de (gw1.ms-free.net. [185.243.124.10])
        by smtp.gmail.com with ESMTPSA id z11sm2299138wrw.53.2021.08.24.12.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 12:02:18 -0700 (PDT)
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 1/1] arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88
Date:   Tue, 24 Aug 2021 21:02:04 +0200
Message-Id: <20210824190204.22312-1-petr.vorel@gmail.com>
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

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
For 5.13.y

 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
index 801995af3dfc..c096b7758aa0 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -36,3 +36,7 @@ serial@f991e000 {
 		};
 	};
 };
+
+&tlmm {
+	gpio-reserved-ranges = <85 4>;
+};
-- 
2.32.0

