Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C637B615245
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 20:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiKATay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 15:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKATax (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 15:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070DC10FF6
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 12:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E0ED61718
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5FBC433D6;
        Tue,  1 Nov 2022 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667331051;
        bh=iEEkuMi15rvaPOvgg17EZaGg82CMDfiy6TTC5kbBwDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVH2IO8El9fPPHjYvytJGOF66RylCptuul5Mx2D9tFVLCUZWPnrnruNDRo9sbJUHA
         ZRLxMuQx8g9+4KEVyW3POgo1DoGiAxCMEpI8BAtdjPmUEqWlg5VmY0UjDemldseR6y
         XyxfBDEm5UU3uozEetWm6TaLlLZtetaU1xLSyHBs=
Date:   Tue, 1 Nov 2022 20:31:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Veness <john-linux@pelago.org.uk>
Cc:     stable@vger.kernel.org
Subject: Re: ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106
 devices
Message-ID: <Y2F0IR6YchEOjaYT@kroah.com>
References: <6239ff94-c587-b2ac-9b8b-cdf5e65d0157@pelago.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6239ff94-c587-b2ac-9b8b-cdf5e65d0157@pelago.org.uk>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 31, 2022 at 01:12:21PM +0000, John Veness wrote:
> Hello,
> 
> Please can you consider my "ALSA: usb-audio: Add quirks for MacroSilicon
> MS2100/MS2106 devices" patch, with upstream commit ID
> 6e2c9105e0b743c92a157389d40f00b81bdd09fe for inclusion in all -stable
> kernels. Apart from the device IDs, it is a copy of the similar existing
> patch for MS2109 devices, which is already present in -stable kernels.

That commit is already in the 5.15.56 release.  If you wish to have it
added to older stable kernel trees, please provide a working backport as
it does not apply cleanly.

thanks,

greg k-h
