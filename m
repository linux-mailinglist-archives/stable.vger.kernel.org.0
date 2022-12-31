Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1F865A3D6
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 12:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiLaL4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 06:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLaL4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 06:56:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D94BE7
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 03:56:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC3360AE1
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 11:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26361C433EF;
        Sat, 31 Dec 2022 11:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672487792;
        bh=y7FDnjFBu3e/3H0LEwXpx2IH6IV/Qn2D78/Sz5JDXxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zl1n9N4gsKVmhzdtgaRiGnR9ka6rm+pUt49sAmz2j0b0C3kvi+hFbheByvN7z4bt6
         VGxjDHR+D3ZrbmBDVpfGB5SK8ycqRJr8cUfZvTFAwIq3CjdDO2bTh214kU/T5T49MJ
         xos5+hLJAx9ujrx13yX9jNIpdC+F7JyG6KafNT5Y=
Date:   Sat, 31 Dec 2022 12:56:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 557/731] phy: qcom-qmp: create copies of QMP PHY
 driver
Message-ID: <Y7Ajbc0hKami540L@kroah.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144312.695000223@linuxfoundation.org>
 <Y6xzgWqijrtJl6oJ@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6xzgWqijrtJl6oJ@matsya>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 10:19:05PM +0530, Vinod Koul wrote:
> On 28-12-22, 15:41, Greg Kroah-Hartman wrote:
> > From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > 
> > [ Upstream commit 94a407cc17a445ddb3f7315cee0b0916d35d177c ]
> > 
> > In order to split and cleanup the single monstrous QMP PHY driver,
> > create blind copies of the current file. They will be used for:
> > - PCIe (and a separate msm8996 PCIe PHY driver)
> > - UFS
> > - USB
> > - Combo DP + USB
> 
> Greg,
> 
> Please drop this. This is a full driver rework and code reorg thus not
> suitable for stable

Now dropped, something went wrong with Sasha's scripts in that the
"dep-of" is not in the tree here so this isn't needed either.

thanks,

greg k-h
