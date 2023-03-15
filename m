Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972756BB4D3
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjCONgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbjCONgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:36:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDDD97B55;
        Wed, 15 Mar 2023 06:36:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54FF961D89;
        Wed, 15 Mar 2023 13:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9909C433EF;
        Wed, 15 Mar 2023 13:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678887365;
        bh=V4eEh0FWKxJj++/8SncL6Dl3c1Y/ElU+NNFA8EJbxd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJKrioXEUgNZ112Xj25aokZn1Epb0XEqHuvHWzUk188MVyIVBk/Dx9TC8+8CL8zZg
         vOlDVFTHMLf1RHW0ll1CU0uEBESWACAaX+aHuPONsgBpjO32FVPMBv0+lwg8cZ7ImW
         EydpkuVkNXbv2nr65F7T5HzfEM9252x1heTNGmuX9ppncieTHViM7KcfzE7LUFiq7i
         E06xGkrTuc5xlKXvBzUbSocaEOCpRsjd6Z3FT3ZDrm8WUwDBfBYovWMLSB/ERYTKvu
         ryCzBb+9MAK0qRJDjwpoakMKl5oVtpDHKuN2/BrGWO9fd4WnT632EDkt1tRacdv6QH
         kQqUIShzY95CA==
Date:   Wed, 15 Mar 2023 19:06:00 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] soundwire: qcom: correct setting ignore bit on v1.5.1
Message-ID: <ZBHJwHN1rcqMmSHT@matsya>
References: <20230222140343.188691-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222140343.188691-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-02-23, 15:03, Krzysztof Kozlowski wrote:
> According to the comment and to downstream sources, the
> SWRM_CONTINUE_EXEC_ON_CMD_IGNORE in SWRM_CMD_FIFO_CFG_ADDR register
> should be set for v1.5.1 and newer, so fix the >= operator.

Applied, thanks

-- 
~Vinod
