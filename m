Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0D5823D8
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 12:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiG0KIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 06:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiG0KIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 06:08:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE49A252AA
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 03:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E5B6183C
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 10:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C49CC433C1;
        Wed, 27 Jul 2022 10:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658916495;
        bh=L3lNKd4nGzsf+Ne+y/6+O88DiC4yTrbu4zWFg+4MJCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HhnmxNcBzmPZhqZRXyve47kM1RoF+VDO9oyF8a3P/2A2RN5TDsaPiXw12wfos8Zvl
         KkFHejdR7s7uirT8/GYGrM5+qj6WPIHzoiQY6QMRg7XBtbRNNjWQQdq7K9kYO5oSvA
         EwLvKdpuCagDvcCIxJuSDrjwAZIBDEsjPytv0u6c=
Date:   Wed, 27 Jul 2022 12:08:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org
Subject: Re: [PATCH v2 0/3][5.18.y backport] ASoC: SOF: Intel: fix resume
 from hibernate
Message-ID: <YuEOjDFEPQa5sSke@kroah.com>
References: <20220725180449.12742-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725180449.12742-1-pierre-louis.bossart@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 01:04:46PM -0500, Pierre-Louis Bossart wrote:
> Backport for 5.18 stable, the first two patches were not modified,
> only the third patch had a missing dependency with 2a68ff846164
> ("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")
> 
> v2: updated commit IDs - no code change
> 
> Pierre-Louis Bossart (3):
>   ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
>   ASoC: SOF: pm: add definitions for S4 and S5 states
>   ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5
>     states
> 
>  sound/soc/sof/intel/hda-loader.c |  3 ++-
>  sound/soc/sof/pm.c               | 21 ++++++++++++++++++++-
>  sound/soc/sof/sof-priv.h         |  2 ++
>  3 files changed, 24 insertions(+), 2 deletions(-)

All now queued up, thanks.

greg k-h
