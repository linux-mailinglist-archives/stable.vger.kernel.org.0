Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4CD65D16F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 12:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjADLbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 06:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbjADLbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 06:31:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09462EAF;
        Wed,  4 Jan 2023 03:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD62AB81615;
        Wed,  4 Jan 2023 11:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24DCC433EF;
        Wed,  4 Jan 2023 11:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672831901;
        bh=v+0G+kQjDPZcgzyLAonltcocpIDs/oeo0yIa+WxMioo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jaW9/2IEM6Wvyg0dBgFkIqCUmk40O7invRLZNi5z3G6eRQS0M/I8BJCxXeDt6jZu2
         itU3Ge1LXKNw1pubUjO1rVPjB3O81IxgjffO85Ushs/3Fno6PE4MU1lJTTrBeHlu29
         SvE+gXqm/dD+yOdwidUi09q+SuhjN5JJK/qDuIGU=
Date:   Wed, 4 Jan 2023 12:31:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org,
        =?iso-8859-1?Q?P=C1LFFY_D=E1niel?= <dpalffy@gmail.com>,
        Alsa-devel <alsa-devel@alsa-project.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Mark Brown <broonie@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Sergey <zagagyka@basealt.ru>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: Request for cherry-picks for sound (Re: [regression, 5.10.y] Bug
 216861)
Message-ID: <Y7Vjmod9m/Zmp4v2@kroah.com>
References: <bebd692d-7d21-6648-6b7a-c91063bb51c2@leemhuis.info>
 <Y7K1WDmPYi3EMOn1@eldamar.lan>
 <87wn65umye.wl-tiwai@suse.de>
 <CALp6mkJhM1zDcNr9X_7WL09+uqcaAhNFFMhrjme0r7584O+Lgw@mail.gmail.com>
 <CALp6mk+rdqGXySUowxZv3kEEVWrh96m_x-h8xcFNQ9YZPkbc5w@mail.gmail.com>
 <87h6x7r7w6.wl-tiwai@suse.de>
 <87sfgrpos6.wl-tiwai@suse.de>
 <87wn62obhm.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wn62obhm.wl-tiwai@suse.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 11:11:33AM +0100, Takashi Iwai wrote:
> Greg, just in case you missed my previous post.
> 
> Could you cherry-pick the following two commits to 5.10.y and 5.15.y
> stable trees?
> 
> e8444560b4d9302a511f0996f4cfdf85b628f4ca
>     ASoC/SoundWire: dai: expand 'stream' concept beyond SoundWire
>  
> 636110411ca726f19ef8e87b0be51bb9a4cdef06
>     ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio

Took a bit of work, but both now queued up, thanks.

greg k-h
