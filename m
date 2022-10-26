Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8965260DF0B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 12:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJZKvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 06:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiJZKvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 06:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF68450FB5;
        Wed, 26 Oct 2022 03:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F561B82189;
        Wed, 26 Oct 2022 10:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C6CC433C1;
        Wed, 26 Oct 2022 10:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666781472;
        bh=aY+/5jItrOvxiIkQJpsA7eprTakp4sAWcx0+oME8pWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=haKPWYBZnRSNIDH6LtRb3bpwka+lyv+qQe8Oq+zUU76ONcRByGB3WX4m64FmKCJZm
         WWUOw8w7RPbv8uPO2hzkKzw3ewv1mfxo72y/RE4fTNyrp4jZkoh7IPQUAEPACKaV4h
         iBhqYozkGpN1kAaJnI/wmX+AuuzVvLHC5BuZvxAw=
Date:   Wed, 26 Oct 2022 12:51:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: stable request: 5.19+: clk: tegra: Fix Tegra PWM parent clock
Message-ID: <Y1kRHrH7OPoh9S8/@kroah.com>
References: <8a146e5a-b637-3e3d-49e8-3304bc41f94f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a146e5a-b637-3e3d-49e8-3304bc41f94f@nvidia.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 04:53:09PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> Please can you apply the following mainline change to fix a regression for
> Tegra?
> 
> commit c461c677a8cb19026fd06741a23ff32d0759342b
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Mon Oct 10 11:00:46 2022 +0100
> 
>     clk: tegra: Fix Tegra PWM parent clock
> 

Now queued up, thanks.

greg k-h
