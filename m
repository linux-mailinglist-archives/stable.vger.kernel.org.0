Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4C068D3FB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 11:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjBGKXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 05:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBGKXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 05:23:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4381D923
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 02:23:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE70A612D6
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 10:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD51C433D2;
        Tue,  7 Feb 2023 10:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675765414;
        bh=SxEA/PYtHYvpKTwSmbQSVQXK2tx5kfeBv5H3Kg0i5o0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pEvnLR44HCX4B9OcC/GBw52jtrdDNFlT65NNg2rX0PVPBzLSp7IhJA0m33cBLCAMB
         v3AoHB286esL4w5xUlKezSY+O2k2U0OuK9gI8WFe+L7tLlbtdheOYwS+Nt1NDsuXKN
         ZekJvx9eLSHaRBhu9G/KnIGTbqrg7dwOuuf7W+M8=
Date:   Tue, 7 Feb 2023 11:23:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc:     yung-chuan.liao@linux.intel.com, broonie@kernel.org,
        pierre-louis.bossart@linux.intel.com, rander.wang@intel.com,
        ranjani.sridharan@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: keep prepare/unprepare widgets
 in sink path" failed to apply to 6.1-stable tree
Message-ID: <Y+Imo5Y81TcjPwfz@kroah.com>
References: <1675756334196160@kroah.com>
 <Y+IFtYzLerjSCGbF@kroah.com>
 <833c56f9-b438-41f7-b37a-be8c0c14a413@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <833c56f9-b438-41f7-b37a-be8c0c14a413@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 12:02:26PM +0200, Péter Ujfalusi wrote:
> Hi Greg,
> 
> On 07/02/2023 10:03, Greg KH wrote:
> > On Tue, Feb 07, 2023 at 08:52:14AM +0100, gregkh@linuxfoundation.org wrote:
> >>
> >> The patch below does not apply to the 6.1-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git commit
> >> id to <stable@vger.kernel.org>.
> >>
> >> Possible dependencies:
> >>
> >> cc755b4377b0 ("ASoC: SOF: keep prepare/unprepare widgets in sink path")
> >> 0ad84b11f2f8 ("ASoC: SOF: sof-audio: skip prepare/unprepare if swidget is NULL")
> >> 7d2a67e02549 ("ASoC: SOF: sof-audio: unprepare when swidget->use_count > 0")
> > 
> > Oops, nevermind, I got this to work, sorry for the noise.
> 
> I was about to take a look at this to assist you.
> Sorry for being late, I guess all is good now?

All should be good, see the other emails saying this was applied to
verify it please.

thanks,

greg k-h
