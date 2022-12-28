Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCCF65857E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 19:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiL1SNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 13:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiL1SNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 13:13:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EF417078;
        Wed, 28 Dec 2022 10:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DF9DB818B9;
        Wed, 28 Dec 2022 18:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E081FC43392;
        Wed, 28 Dec 2022 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672251229;
        bh=XSlxKgFnM+rkJnSuzByNSUGQriIVV3inYNbPunGEF3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSm5sHNr/1NhZBHmTwggnnuuR7pd1aTogYO+yoNjiZ5nErc700+E5fHgJeiPT1Ky2
         wLDQWGcUEckWLDsZ4L7I7+D4HR0rHODgofpZl6puN8ldih4BWlB9uR6nuL4UP9TheY
         r9GNJ039/nqpSlTdIYS1CuF7c1hk2n4fGgcknaJ9Fn6YmZru5/8YipRwc18DmlJR8O
         hU0XjORPdaVzRvOMazf3aJZ+GKguGjsKaQFjYxw2aBRZGWRMJpFLJMeYRieL5N/u7T
         K25lmS1Re/PTOdcVRRySo5ET4VmPgxL9Ui5wV+sfTzycdxRikdxURjSPEShDbeByVI
         W1hV7AuDs+kKA==
From:   Bjorn Andersson <andersson@kernel.org>
To:     krzysztof.kozlowski@linaro.org, konrad.dybcio@linaro.org,
        bhupesh.sharma@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: qcom: apq8084-ifc6540: fix overriding SDHCI
Date:   Wed, 28 Dec 2022 12:13:43 -0600
Message-Id: <167225121526.949655.13443428227538668523.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221204084614.12193-1-krzysztof.kozlowski@linaro.org>
References: <20221204084614.12193-1-krzysztof.kozlowski@linaro.org>
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

On Sun, 4 Dec 2022 09:46:14 +0100, Krzysztof Kozlowski wrote:
> While changing node names of APQ8084 SDHCI, the ones in IFC6540 board
> were not updated leading to disabled and misconfigured SDHCI.
> 
> 

Applied, thanks!

[1/1] ARM: dts: qcom: apq8084-ifc6540: fix overriding SDHCI
      commit: 0154252a3b87f77db1e44516d1ed2e82e2d29c30

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
