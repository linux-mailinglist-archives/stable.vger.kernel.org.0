Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E37649ED6
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 13:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiLLMfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 07:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbiLLMfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 07:35:03 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EFE13CCA
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:34:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so15544440pjr.3
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 04:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWyQujEvk1ZvvBEgjMYf46UtX0tdPlQNyeagksROeaI=;
        b=M+NOjZk3UqxL2qLgCMURy7Ekh48jPeaCcqRn64ULQe7hLXCTrQX/RIV15uLXE6ohIx
         Q2HQnbsrSIbSM3fwr3TKe+sjv/qq6aWEPaxcckJhx/TpQqTtFwU1ndqGT1K+U5ek5cKf
         1duNN7KH4MkKiz/3HAoUeuIgmOFaW4PtKxAD7Pkyn2roSKdAbEftDLUCgfVD8CKh1QtM
         Dng++ZhI/2ylK4xxS2ARFK5UT+ZZLyjtG4M2XZ1xvKrNsCuyotdLqReA4+QAMZ9/zTYi
         KNFh6iGZtfi+Yot+VNHfjOz2/VhOIglbuhXIt+r5ej2duICSXtQ8ttGOCPspoofzc+CK
         SIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWyQujEvk1ZvvBEgjMYf46UtX0tdPlQNyeagksROeaI=;
        b=pAna0f/YW6x22VnY+QpwgNSaJXuuTPtkISIqgKhURUBRMfXeUFksBKKSj7SmURIf/6
         FP193OBedMoB3VmFCvXUsLuppoxlKemG3ikYTmu7GNRWML5Dm4o30Py47k/9P5Wni8jV
         VI5TkLZEbLhInq6D1fX/n2LMO+qjdzIm239KRImfkW4tDQVFIW0FnZrc8xzm3cuCyIhm
         8Zh0YjrD3wioXyBQ373CYpgCg6LqjLpcWQPE4sX5rcU+S8OiMSnFoEv3MUAFwQdymMRz
         LZeuIRaiH5ezMprCdiE+y5rY0GMFBTlv1+HjRvxOIiDfBPFLz/jNvmzE0+nQMTgPblvU
         5PMg==
X-Gm-Message-State: ANoB5pn4lTRITrw3hHfe7qASwrOW+HysycJWZCBY8O+pwyNiY3To+zZs
        lb2LZ+ETMOJr0sW6NNFqho2r
X-Google-Smtp-Source: AA0mqf65XirmVvA0c0kA2Sw63W0K3JpljPLCsrpQEBXohP+sfrTv4TgVx/eA7KLFInbLI/SmVexiqw==
X-Received: by 2002:a17:902:bd03:b0:187:1c7b:207 with SMTP id p3-20020a170902bd0300b001871c7b0207mr15731543pls.38.1670848469266;
        Mon, 12 Dec 2022 04:34:29 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.33])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b00189c93ce5easm6252557plx.166.2022.12.12.04.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:34:28 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 11/13] arm64: dts: qcom: sm6350: Remove reg-names property from LLCC node
Date:   Mon, 12 Dec 2022 18:03:09 +0530
Message-Id: <20221212123311.146261-12-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LLCC block has several banks each with a different base address
and holes in between. So it is not a correct approach to cover these
banks with a single offset/size. Instead, the individual bank's base
address needs to be specified in devicetree with the exact size.

On SM6350, there is only one LLCC bank available. So only change needed is
to remove the reg-names property from LLCC node to conform to the binding.

The driver is expected to parse the reg field based on index to get the
addresses of each LLCC banks.

Cc: <stable@vger.kernel.org> # 5.16
Fixes: ced2f0d75e13 ("arm64: dts: qcom: sm6350: Add LLCC node")
Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 43324bf291c3..1f39627cd7c6 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1174,7 +1174,6 @@ dc_noc: interconnect@9160000 {
 		system-cache-controller@9200000 {
 			compatible = "qcom,sm6350-llcc";
 			reg = <0 0x09200000 0 0x50000>, <0 0x09600000 0 0x50000>;
-			reg-names = "llcc_base", "llcc_broadcast_base";
 		};
 
 		gem_noc: interconnect@9680000 {
-- 
2.25.1

