Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB3644B9C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 19:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiLFSXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 13:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiLFSWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 13:22:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05365209BB;
        Tue,  6 Dec 2022 10:20:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C4761862;
        Tue,  6 Dec 2022 18:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F071C4314A;
        Tue,  6 Dec 2022 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670350817;
        bh=22EI+lJnTGMMXVuQdm7Xnzkv0CVe6RifDMjM55t/TWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGXlqIdPGq2YhuuPk/OBcoai13yYBtgj2Tkmp7rNzoDQc9QEy72pTYzrBJXHV4q+7
         wf9r6n6oKcL7FSUqTYum08EfArbPfq+pROsn9EgboODHEUXewxzIlpg0vo+4odDQtO
         d0RV6m8OU7R+Unzm1zz5oDYHWPlwUmAiAlgAf9qsYNhM4MuEL5vbz2muX/AKNA0EJT
         yzIFjnNhMSBMg6VY625CkPSb9PjSXFBY1wToMJwiLZQZDhOyZTJnJ/Emr1zDPyucmW
         L4/3hro9GYjm61z7liJcPrA/tGBAP17QH3lWRfnxEj5awufGVrq+l5Fjedu8J5FFdj
         mzORyArMlxqeg==
From:   Bjorn Andersson <andersson@kernel.org>
To:     krzysztof.kozlowski@linaro.org,
        Manivannan Sadhasivam <mani@kernel.org>
Cc:     konrad.dybcio@somainline.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: Select REMAP_MMIO for ICC_BWMON driver
Date:   Tue,  6 Dec 2022 12:19:23 -0600
Message-Id: <167035076349.3155086.6465898439773083884.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221129072022.41962-1-manivannan.sadhasivam@linaro.org>
References: <20221129072022.41962-1-manivannan.sadhasivam@linaro.org>
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

On Tue, 29 Nov 2022 12:50:22 +0530, Manivannan Sadhasivam wrote:
> ICC_BWMON driver uses REGMAP_MMIO for accessing the hardware registers.
> So select the dependency in Kconfig. Without this, there will be errors
> while building the driver with COMPILE_TEST only:
> 
> ERROR: modpost: "__devm_regmap_init_mmio_clk" [drivers/soc/qcom/icc-bwmon.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:126: Module.symvers] Error 1
> make: *** [Makefile:1944: modpost] Error 2
> 
> [...]

Applied, thanks!

[1/1] soc: qcom: Select REMAP_MMIO for ICC_BWMON driver
      commit: a84160fbf4f2c8c5ffa588e19ea8f92eabd7ad17

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
