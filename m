Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C23D3F6976
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 21:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhHXTDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 15:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbhHXTDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 15:03:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C1DC061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:02:59 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e5so16213639wrp.8
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 12:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YuXlkxSKqnspHXFVsA94uRrKEXIyNt2689b9VOkPPrA=;
        b=H9id2tZuHLsphmy9qxPDvDUdK29b3FXo6z+Tf1fktWbB9J2fAoq9VyKqXig9j+UyhO
         eZCFF47WiWASIuVG3+rd5rijU5uOHlCu9GvN6Qx/zDroaGtk9E3+o1ug056tQdC4FiGg
         OFzgCaBy26PAJY2McS9/NfMKHk5oNQ8h/s6qxF0TsVOdf1eZfynrVtInMetFuGfvWU8F
         mSrc7nilOCgQ2n5wSKunqkDnH0dhvQKoRJgIkr5qGKc5+nEPjAMhglieLSYQcMP6Gb8I
         bUMdT9GskLsIY93Evw0i1ffgk8xFT0VH1Isfg2lK3TmjarC50wnF4QX+N1sqfognwljC
         VFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YuXlkxSKqnspHXFVsA94uRrKEXIyNt2689b9VOkPPrA=;
        b=FmLBrTsI2WuCCeBLV0iNZyWi6WXNT0SBTO05n9PEOQmFBCK3iexir/D0Jb95fde74F
         qle9qRtEa710R4SLllYBLt4D0VuKiyVHlQ288KvdzYXiW+B+zV5zdi1ulwJ05FUIcTOk
         kOJ/LER177C4TOnvA8j15cQe5Sqzug2v9fay5NK7Yf+kLubRiY4mFIA9DNDtd1tCYaMC
         zKU4WFsLawuNpmjI+TZ/NJyBjHxlKXuS3VHHO0f/jlvlp51xBsn8jz1Kjp4/qftnBlwI
         bUTwe6GBB0ftfYjb/I5jLCis8kTQupt7xTT26Xg+/AZ/9/5RORWs6lqN9fYchoQ/gX9o
         9HwQ==
X-Gm-Message-State: AOAM532Rj3ziWfP3Coe5fI98rBvZJs1mHwOF6NAyDKba/OoR821NXrsJ
        vL7Vbts2fSPA4JB5u7YyQ5XV7Guup0uA/UHo
X-Google-Smtp-Source: ABdhPJw2GAGCgWaf+Ga4z5s7mQuvEX4pRRFzt2d0OUCmPIGA/EuODdbDbxKRkqhj9L3ywJXaP8oyyg==
X-Received: by 2002:a5d:4ec4:: with SMTP id s4mr21219582wrv.245.1629831778132;
        Tue, 24 Aug 2021 12:02:58 -0700 (PDT)
Received: from dell5510.suse.de (gw1.ms-free.net. [185.243.124.10])
        by smtp.gmail.com with ESMTPSA id s12sm19046398wru.41.2021.08.24.12.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 12:02:57 -0700 (PDT)
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 1/1] arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88
Date:   Tue, 24 Aug 2021 21:02:47 +0200
Message-Id: <20210824190247.22484-1-petr.vorel@gmail.com>
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
For 5.10.y

 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
index baa55643b40f..ffe1a9bd8f70 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -32,3 +32,7 @@ serial@f991e000 {
 		};
 	};
 };
+
+&tlmm {
+	gpio-reserved-ranges = <85 4>;
+};
-- 
2.32.0

