Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C767FA1A
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 18:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjA1Rwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 12:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjA1Rwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 12:52:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154A813DCB
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 09:52:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF838B80B92
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 17:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132AFC4331D;
        Sat, 28 Jan 2023 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674928350;
        bh=+ToD+2oFiXI72VVfZGhjDjDjCi/u1IoA9mUE6JuHeGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JUVhBmUlQDVnmNRnoorIp0jLqCh+69qPkSBh2MrTqBbeZXbs9zIhcUlQmIiS4NENT
         zfEPoj8hutO+lAxicEzg5MctjP10prjr0rEf2qtXP1N/WagxfsnwmUH65zSduZIa6e
         0RFTSvjV4s6NsQgqzNNcKxaGQRa7aX1cpT1kFWL8=
Date:   Sat, 28 Jan 2023 18:52:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Montleon <jmontleo@redhat.com>
Cc:     casaxa@gmail.com, cezary.rojewski@intel.com, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Message-ID: <Y9Vg26wjGfkCicYv@kroah.com>
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 28, 2023 at 12:09:54PM -0500, Jason Montleon wrote:
> I did a bisect which implicated
> f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 as the first bad commit.
> 
> Reverting this commit on 6.1.8 gives me working sound again.
> 
> I'm not clear why this is breaking 6.1.x since it appears to be in
> 6.0.18 (7494e2e6c55e), which was the last working package in Fedora
> for the 6.0 line. Maybe something else didn't make it into 6.1?
> 
> 

So this is also broken in Linus's tree (6.2-rc5?)

thanks,

greg k-h
