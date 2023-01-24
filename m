Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A70678FB0
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 06:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjAXFJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 00:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjAXFJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 00:09:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9505B90
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 21:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB60AB8100B
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 05:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CDDC4339B;
        Tue, 24 Jan 2023 05:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674536954;
        bh=XCczaqZtBNFHQKqjgQkcJmjySTwAb+jycz3zrHYoxZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gk2oyQACnjE3w2t5BHWmo3Up1Tbw2TBE3/YqCMNEyMW4hlvR1NALK/l8hsyTASCnz
         yEsHQldAkicQiFetyEIJ++UCxc6SCtI4GP1e2O9BpQzpIFil7FYBTfz7tAHxUsKJ/z
         awwKnxKyQALGgMRn12O/+Ibk1HXvsMdPWqE9mt50=
Date:   Tue, 24 Jan 2023 06:09:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasa Ostrouska <casaxa@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Message-ID: <Y89n98fRfTpLmPUg@kroah.com>
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 09:44:34PM +0100, Sasa Ostrouska wrote:
> Hi all, sorry if I put somebody in CC who is not the correct one. I
> have a google pixelbook and using it with Fedora 37.
> The last few kernels supplied by fedora 37, 6.1.6, 6.1.7 but also some
> earlier have no working sound.
> I see the last kernel for me with working sound is 6.0.18.
> On my pixelbook this is showing in dmesg:

Any chance you can use 'git bisect' to track down the offending commit?

thanks,

greg k-h
