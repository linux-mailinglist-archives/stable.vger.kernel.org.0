Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521186046CF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiJSNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiJSNUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:20:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1499F10326F;
        Wed, 19 Oct 2022 06:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D36D9CE21E3;
        Wed, 19 Oct 2022 09:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0916AC433C1;
        Wed, 19 Oct 2022 09:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666171145;
        bh=ywJ2pvR9X6bnB/eunhk7eprZc1I8H8qEl72p2crfhpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EyA/B4RsZKZzw4PSqKudcvlbLml/0hAJmfHmS76dyxbDf6NwGv+LJt2GoS9iSEPSU
         0/OC2bF4Hnq00r6RMbxxrGm8nO/1T+5FMRfiGFXF3aBOMZL2Ln8zXQ7oj/dgJNcuHU
         Ypmg+6M6xMDFXeCPSIbjP/EV/oJZEHcOWPD+ubi/eZDvLNI9rhhhqiwaDo3D6e3hoT
         90+86TiGevgFWQMYj+qvmwrPJD5X3EtW8sMfs9udcbw+fapufsdibFdBEmE4qwBOW4
         t140YuxCa+ew9j1xxFdHxYqraX/CNV/FxHkxDiBSrXi/NTBMEIgRNau9oIcy9gjitS
         shk5gjJCVXjOw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol5Dx-00058N-6Q; Wed, 19 Oct 2022 11:18:53 +0200
Date:   Wed, 19 Oct 2022 11:18:53 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 527/862] phy: qcom-qmp-ufs: fix memleak on probe
 deferral
Message-ID: <Y0/A/VNDBuFEBrBB@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083313.259607297@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083313.259607297@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:30:14AM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit ef74a97f0df8758efe4476b4645961286aa86f0d ]
> 
> Switch to using the device-managed of_iomap helper to avoid leaking
> memory on probe deferral and driver unbind.
> 
> Note that this helper checks for already reserved regions and may fail
> if there are multiple devices claiming the same memory.

Again, because of the above, this should not be backported. Please drop.

> Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220916102340.11520-6-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Johan
