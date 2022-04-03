Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CF24F08B7
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 12:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiDCK05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 06:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiDCK04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 06:26:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37DE3703B;
        Sun,  3 Apr 2022 03:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87E5BB80A09;
        Sun,  3 Apr 2022 10:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A416FC340ED;
        Sun,  3 Apr 2022 10:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648981499;
        bh=RvHM58+WCVSmdblL+XcB4dmfmhFU3wC8gZT9rrOz3DY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtvY7jHbpQ0hk9paN5/seBFJmvgS7OB/skxReyOVy25PKTDkHbZIXjtPyvNtp4efi
         pH07baedTwQD2WyOQxBiuKoECvft8ECfBQk4gzgQDOHlQFvTF37qBe2plosclWSxLq
         lJgFirF+EEvFH+1nsHa8v8EAqJShGHYRcDcP55c4=
Date:   Sun, 3 Apr 2022 12:24:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     stable@vger.kernel.org, Daniel Baluta <daniel.baluta@nxp.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Keyon Jie <yang.jie@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org
Subject: Re: [PATCH for-stable] ASoC: SOF: Intel: Fix NULL ptr dereference
 when ENOMEM
Message-ID: <Ykl18HLtHn/xwtdC@kroah.com>
References: <20220402163026.11299-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402163026.11299-1-ammarfaizi2@gnuweeb.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 11:30:26PM +0700, Ammar Faizi wrote:
> 
> Hello Greg,
> 
> commit b7fb0ae09009d076964afe4c1a2bde1ee2bd88a9 upstream.
> 
> Please take these two backport patches:
> 1. For Linux 5.4 LTS.
> 2. For Linux 5.10 LTS.
> 
> Both will be sent as a reply to this email.
> 
> Thank you!
> 
> =====
> 
> 5.4 failed report:
> https://lore.kernel.org/stable/164889915082249@kroah.com/
> 
> 
> 5.10 failed report:
> https://lore.kernel.org/stable/164889914960214@kroah.com/
> 
> -- 
> Ammar Faizi
> 

Both now queued up, thanks!

greg k-h
