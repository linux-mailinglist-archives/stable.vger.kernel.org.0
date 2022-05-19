Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C0F52D5F1
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbiESOZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 10:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238743AbiESOZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 10:25:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C4233A;
        Thu, 19 May 2022 07:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 288DCB8235B;
        Thu, 19 May 2022 14:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEE5C385AA;
        Thu, 19 May 2022 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652970343;
        bh=+T85u1w+QhCqYi0g3KVADzqqPPq+a5WCICuQFpYVIOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fOtb/kFu8S3WqRS+DlCAXhDrUYoKPYoozNHwLIhpK2ecdgqCPffmwqEMtOkscpasA
         3VJ/nUyCFQtssPDZ2bIxbWRYEdA/eVgzsdysPaDzmfWo+Ss9iuMAHhRLVNbgyVxKvp
         1ro3XWT7uSWs3tjM8OgN8LeXS7XijQ/oGNvyoAgU=
Date:   Thu, 19 May 2022 16:25:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>,
        "open list:MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND..." 
        <linux-mmc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, alcooperx@gmail.com,
        kdasu.kdev@gmail.com
Subject: Re: [PATCH stable 5.4 0/3] MMC timeout back ports
Message-ID: <YoZTW06LhILvkkwc@kroah.com>
References: <20220517180911.246016-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517180911.246016-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 11:09:08AM -0700, Florian Fainelli wrote:
> These 3 commits from upstream allow us to have more fine grained control
> over the MMC command timeouts and this solves the following timeouts
> that we have seen on our systems across suspend/resume cycles:
> 
> [   14.907496] usb usb2: root hub lost power or was reset
> [   15.216232] usb 1-1: reset high-speed USB device number 2 using
> xhci-hcd
> [   15.485812] bcmgenet 8f00000.ethernet eth0: Link is Down
> [   15.525328] mmc1: error -110 doing runtime resume
> [   15.531864] OOM killer enabled.
> 
> Thanks!
> 
> Ulf Hansson (3):
>   mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
>   mmc: block: Use generic_cmd6_time when modifying
>     INAND_CMD38_ARG_EXT_CSD
>   mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
> 
>  drivers/mmc/core/block.c   |  6 +++---
>  drivers/mmc/core/mmc_ops.c | 25 +++++++++++++------------
>  2 files changed, 16 insertions(+), 15 deletions(-)
> 
> -- 
> 2.25.1
> 

All now queued up, thanks!

greg k-h
