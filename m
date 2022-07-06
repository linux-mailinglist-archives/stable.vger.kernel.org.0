Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98127568F85
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiGFQpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 12:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiGFQpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 12:45:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0047286D4;
        Wed,  6 Jul 2022 09:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EE4961DA8;
        Wed,  6 Jul 2022 16:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E07C3411C;
        Wed,  6 Jul 2022 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657125939;
        bh=UexN+rlmJSiLQCAdT+rimBN77NKCwmVWbryXHRMEbgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lWVzK7xjaV5efxKrA8ESlKU5Z2Gzp5DmgvYQjW9Dv1W/G+ukRRc6SYv6tL/rAXOWS
         EHbtTesPZctKLcXAvNyoJkx2wss1tSORhEzdhFinzOZ0yZC4qwlUtDWpNjvuZvd2KJ
         mTS0Q9MSnMlzM3sOGR6va4Xzwq/uQWBzCToB4DmwL046nZnNlPxBE1vB62Xqqawd+H
         cAbTBHfRS9oHpvM9aVmJ3EryElfNzKVPAVhPbpQZVXpb+S0uXRnufdsbqFvXz9Bbxz
         jV7ghZ+9FSfyMUbnDO31aAmJc4RdFnLO6Kvy+wj+xuEFROMUR7zSyf9UIgHJoi+bDB
         dP6xy2F97CdMA==
Date:   Wed, 6 Jul 2022 22:15:34 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] soundwire: qcom: Check device status before reading devid
Message-ID: <YsW8Lnhu19Wn2fZJ@matsya>
References: <20220706095644.5852-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706095644.5852-1-srinivas.kandagatla@linaro.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06-07-22, 10:56, Srinivas Kandagatla wrote:
> As per hardware datasheet its recommended that we check the device
> status before reading devid assigned by auto-enumeration.
> 
> Without this patch we see SoundWire devices with invalid enumeration
> addresses on the bus.

Applied, thanks

-- 
~Vinod
