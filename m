Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E819B6021F7
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 05:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiJRDJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 23:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiJRDIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 23:08:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA738A7F0;
        Mon, 17 Oct 2022 20:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B0D61362;
        Tue, 18 Oct 2022 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B967AC43140;
        Tue, 18 Oct 2022 03:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666062417;
        bh=Awbh6Y+FnFx6T9WtgMKGvFzl0+dG6lI/dhljI0/tLn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRNrc6PASVFwwgwVBSYtQ1yXwY6crI4kyv0IxQSEvEinucmx6k9SOSfIRI/ctE8Ww
         e416ngLw4qw/0UDftFF9mfBUFA12GYgiC1GQO7LpYdXuD/x/52uZzDFWUL3G30ceow
         rjXkKfr8L1y34KELkmUxIXVYJ6B18L03NyI6yHr/HKnHgyAbDOxivGPBedgLPbQ43r
         AF044BflaWsynpRzuBSFrXT0RWtGiaGCZFt00u6/fLu9BX3brbQMIK2r+quV+niVqS
         1pJ1u0I+wrIKOxD7fnjy9gONq3XEn5OMxbEijWZYnsQCSbIZd66EO6zQ1E4J6JeeDA
         fFl/5SsS9q8QQ==
From:   Bjorn Andersson <andersson@kernel.org>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        agross@kernel.org, sudeep.holla@arm.com,
        krzysztof.kozlowski@linaro.org, vkoul@kernel.org,
        mollysophia379@gmail.com, wuxilin123@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     stable@vger.kernel.org
Subject: Re: (subset) [PATCH 1/3] arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength
Date:   Mon, 17 Oct 2022 22:05:31 -0500
Message-Id: <166606235841.3553294.8238032621366293269.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220930192039.240486-1-krzysztof.kozlowski@linaro.org>
References: <20220930192039.240486-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Sep 2022 21:20:37 +0200, Krzysztof Kozlowski wrote:
> The pin configuration (done with generic pin controller helpers and
> as expressed by bindings) requires children nodes with either:
> 1. "pins" property and the actual configuration,
> 2. another set of nodes with above point.
> 
> The qup_i2c12_default pin configuration used second method - with a
> "pinmux" child.
> 
> [...]

Applied, thanks!

[1/3] arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength
      commit: fd49776d8f458bba5499384131eddc0b8bcaf50c
[2/3] arm64: dts: qcom: sdm850-samsung-w737: correct I2C12 pins drive strength
      commit: 3638ea010c37e1e6d93474c4b3368f403600413f
[3/3] arm64: dts: qcom: sdm845-xiaomi-polaris: fix codec pin conf name
      commit: 58c4a0b6f4bdf8c3c2b4aad7f980e4019cc0fc83

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
