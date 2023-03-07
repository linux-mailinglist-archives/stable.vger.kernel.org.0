Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC216AD61C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 05:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCGERX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 23:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjCGERP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 23:17:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544DD5F229;
        Mon,  6 Mar 2023 20:17:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 39A9BCE1A9E;
        Tue,  7 Mar 2023 04:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2ADC433EF;
        Tue,  7 Mar 2023 04:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678162630;
        bh=S+MzeQ8JVIY+y1oz0pRCgLjiBpJbSV9Scm25NkoH3qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaDDze3hfD+GyJEzV3Rsd26nJfmLEo+Xt06D994o0UPn495CjZTkOOKANAGpcjpQI
         0xqodr0TcQCFXUrNvo5ZdELOn4cVN/72bk7pMuihZ31/gmj2SH7G8SPBUQz/dyHBDg
         7pDvvc4lWsCA9p8Ank2NXMlS36aw2Iq1qJLNfrjeofO1K5P3qG56MqnUDnCwILZzv/
         WOzSt9rVHhtEw+lKbzr8T6hqNfb98gJ+4q1l3CjEgxMsLfTrhKZuCPfZ1B+oX+qkiC
         88F0sXfMAZS0KbCG6JtmLfaQ10nuMISdbDbwMKb/JZ3qaCF06Hoj4aDVNZ2Lic/DBc
         wzfx9mI0TykoA==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     stable@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        srinivas.kandagatla@linaro.org, quic_vkamble@quicinc.com,
        konrad.dybcio@linaro.org, bhupesh.sharma@linaro.org
Subject: Re: [PATCH] arm64: dts: qcom: sm8150: Fix the iommu mask used for PCIe controllers
Date:   Mon,  6 Mar 2023 20:20:34 -0800
Message-Id: <167816282863.1458033.10186697320414777088.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230224080045.6577-1-manivannan.sadhasivam@linaro.org>
References: <20230224080045.6577-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Feb 2023 13:30:45 +0530, Manivannan Sadhasivam wrote:
> The iommu mask should be 0x3f as per Qualcomm internal documentation.
> Without the correct mask, the PCIe transactions from the endpoint will
> result in SMMU faults. Hence, fix it!
> 
> 

Applied, thanks!

[1/1] arm64: dts: qcom: sm8150: Fix the iommu mask used for PCIe controllers
      commit: 672a58fc7c477e59981653a11241566870fff852

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
