Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194476111FF
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJ1M4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJ1M4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:56:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74ED1BFBA6;
        Fri, 28 Oct 2022 05:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1D473CE2B27;
        Fri, 28 Oct 2022 12:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF42C433C1;
        Fri, 28 Oct 2022 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666961765;
        bh=VHuzHyK/ptJnT7l0y3XH9UJ/iKdBdii83zZaQVjzLGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qJK0uSjCKHOuaBdb8fohf3eG1Ezo4BX544vlCK2s//gCGhInnaT0Y3Xh5qduPhxVo
         1xJoCClTBT1I/iAGPMIZjp1q3pBJGSE1VkBpeWg19qtZxpJ3eYGh92wPjSNUXikuAF
         1dy22fZ5u/q0+2M1wBMKsVqxqtut6tdeWxJhkP2PPDvyFoOoxklODSzWQSuTXp8xSZ
         7Us2KxxmzFn99c1rpOtNvVzLir8Nmw8bF7F5n3dwp1WcYi+Ixvit93imqOsWYWuDus
         TzjKR/P+cjwYi/DTQecG5tUinB/wj0YeFJjBTAwjts7u7VTd5Gmjiex6ecadXqWHms
         cMvd68M5hNUpw==
Date:   Fri, 28 Oct 2022 18:26:00 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] phy: qcom-qmp-combo: fix NULL-deref on runtime resume
Message-ID: <Y1vRYIl1eaAzfmEG@matsya>
References: <20221026162116.26462-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026162116.26462-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26-10-22, 18:21, Johan Hovold wrote:
> Commit fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate
> PCS_USB region") started treating the PCS_USB registers as potentially
> separate from the PCS registers but used the wrong base when no PCS_USB
> offset has been provided.
> 
> Fix the PCS_USB base used at runtime resume to prevent dereferencing a
> NULL pointer on platforms that do not provide a PCS_USB offset (e.g.
> SC7180).

Applied, thanks

-- 
~Vinod
