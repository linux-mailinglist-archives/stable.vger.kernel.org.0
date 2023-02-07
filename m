Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1468D139
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 09:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjBGIFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 03:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBGIFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 03:05:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CD9EF80
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 00:05:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B63D6B8171A
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 08:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017D7C433D2;
        Tue,  7 Feb 2023 08:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675757103;
        bh=ZudCAs3udsfNu9Uu5WiVHuoVWsXUUaEka+nTnph6i7g=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=vskXkySn8yDIFlYl1T6j44B1sYdsUDUJeEm45js76Ef+fiN3mzQiP9ZKl687JZPjs
         OKcw6ZeH4A7xZ4uSiWOAkHfPkY1RXMVsjvHg5ZbMY/CLUKXvg75AFUIfc+1sC2x5G+
         UoesxKndITq5kQriyI7cA1+looRU2wfJ5Yr7h2h0=
Date:   Tue, 7 Feb 2023 09:03:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yung-chuan.liao@linux.intel.com, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, rander.wang@intel.com,
        ranjani.sridharan@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: keep prepare/unprepare widgets
 in sink path" failed to apply to 6.1-stable tree
Message-ID: <Y+IFtYzLerjSCGbF@kroah.com>
References: <1675756334196160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675756334196160@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 08:52:14AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> cc755b4377b0 ("ASoC: SOF: keep prepare/unprepare widgets in sink path")
> 0ad84b11f2f8 ("ASoC: SOF: sof-audio: skip prepare/unprepare if swidget is NULL")
> 7d2a67e02549 ("ASoC: SOF: sof-audio: unprepare when swidget->use_count > 0")

Oops, nevermind, I got this to work, sorry for the noise.

greg k-h
