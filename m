Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974CB642D03
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 17:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiLEQiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 11:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiLEQha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 11:37:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D921CE2B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 08:35:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 779C96112C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 16:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9BEC433C1;
        Mon,  5 Dec 2022 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670258112;
        bh=CUS+C7gdBEGPDgo15TkwqVvqPYmb1vhtkNR2Jjwodlg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vmecR3JCQVV+IO0ReL3C9PjZ16zQLGuskX9DnHPLpXF4CxU4MfD6YeR7IlKcP2c+c
         opm2uY0SRVE+LxO7P3/n9DRcwV55Zu6wrzWInFMQ7p10Qg3y1f34IedSTvso4RvyD0
         +M6cQG0OglYtu0BpNGle+VmF1q5eQwAqQ6W6+pOM=
Date:   Mon, 5 Dec 2022 17:35:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org, ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci: Fix voltage switch delay"
 failed to apply to 5.4-stable tree
Message-ID: <Y44dvg/5eNGYyl5b@kroah.com>
References: <1670065118709@kroah.com>
 <95463a7a-c439-1e6b-dc8d-55a986bc0c11@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95463a7a-c439-1e6b-dc8d-55a986bc0c11@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 04:07:12PM +0200, Adrian Hunter wrote:
> On 3/12/22 12:58, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > c981cdfb9925 ("mmc: sdhci: Fix voltage switch delay")
> > fa0910107a9f ("mmc: sdhci: use FIELD_GET for preset value bit masks")
> 
> Yes please cherry-pick fa0910107a9f then c981cdfb9925
> 
> Ditto for 4.19 and 4.14 too please.

All now done, and for 4.9 too.

thanks,

greg k-h
