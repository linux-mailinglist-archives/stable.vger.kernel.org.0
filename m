Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F10E60CF8A
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 16:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiJYOuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 10:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiJYOuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 10:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF6F57DE3;
        Tue, 25 Oct 2022 07:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD06861989;
        Tue, 25 Oct 2022 14:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EC4C433D6;
        Tue, 25 Oct 2022 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666709413;
        bh=VCltjqERKRXqiEIpoMVQ9binZrINHP3djXjLUsnrY/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPChzJNVdFp0eS17oqBoQV6rW+/XvI85cf5PLyQwbF0TnsSuv/BhDtqoqshmAjMxN
         SGfaZTjo+kAKd38XCblRNqbxEX3Z9mYImDfNHMXnvt3tUKjHbs+tkK04RKoqRvh4Ss
         J1xfZiUhXXqbMlsIH4r+nyyCOKf0SvajwNt9dyso=
Date:   Tue, 25 Oct 2022 16:50:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, tiwai@suse.com,
        alsa-devel@alsa-project.org, peter.ujfalusi@linux.intel.com,
        mkumard@nvidia.com
Subject: Re: [PATCH AUTOSEL 6.0 07/44] ALSA: hda: Fix page fault in
 snd_hda_codec_shutdown()
Message-ID: <Y1f3opiid6pvKINq@kroah.com>
References: <20221009234932.1230196-1-sashal@kernel.org>
 <20221009234932.1230196-7-sashal@kernel.org>
 <24d084e1-700d-da77-d93e-2d330aac2f63@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24d084e1-700d-da77-d93e-2d330aac2f63@linux.intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 09:27:32AM -0500, Pierre-Louis Bossart wrote:
> 
> 
> On 10/9/22 18:48, Sasha Levin wrote:
> > From: Cezary Rojewski <cezary.rojewski@intel.com>
> > 
> > [ Upstream commit f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 ]
> 
> This commit on linux-stable seems to have broken a number of platforms.
> 
> 6.0.2 worked fine.
> 6.0.3 does not
> 
> reverting this commit solves the problem, see
> https://github.com/thesofproject/linux/issues/3960 for details.
> 
> Are we missing a prerequisite patch for this commit?

Please see https://lore.kernel.org/r/20221024143931.15722-1-tiwai@suse.de

Does that solve it for you?

thanks,

greg k-h
