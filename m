Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CAA21AA7B
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 00:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGIW3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 18:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGIW3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 18:29:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C286A2070E;
        Thu,  9 Jul 2020 22:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594333780;
        bh=E208A14aCfyfhIZEqe3NQHFbrt6g5zBe4tEPba/Vq9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NKqKKc8xnvizQPi2StbY0b8q08RvrvefMq4WRetFnCvzXi4Ubx588t32FpsogtlwB
         kbyEITE2574L4GkNN42uoE0xB/omC4c1XcFwWetzUTLtbuMpjYgVVhZ5X3E03sU90/
         XQ5sErkspJfMvHFH7oTBSHySz/8jCT38FEJ91BVQ=
Date:   Thu, 9 Jul 2020 18:29:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.7 15/53] ASoC: SOF: Intel: add PCI IDs for
 ICL-H and TGL-H
Message-ID: <20200709222938.GC2722994@sasha-vm>
References: <20200702012202.2700645-1-sashal@kernel.org>
 <20200702012202.2700645-15-sashal@kernel.org>
 <20200702111835.GB4483@sirena.org.uk>
 <0baf17f3-1af8-a4a1-644c-ab27490f9b44@linux.intel.com>
 <20200702160528.GL4483@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200702160528.GL4483@sirena.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 05:05:28PM +0100, Mark Brown wrote:
>On Thu, Jul 02, 2020 at 10:42:21AM -0500, Pierre-Louis Bossart wrote:
>> On 7/2/20 6:18 AM, Mark Brown wrote:
>> > On Wed, Jul 01, 2020 at 09:21:24PM -0400, Sasha Levin wrote:
>> > > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>
>> > > [ Upstream commit c8d2e2bfaeffa0f914330e8b4e45b986c8d30b58 ]
>
>> > > Usually the DSP is not traditionally enabled on H skews but this might
>> > > be used moving forward.
>
>> > "This might be used moving forward"?
>
>> There are two conditions for the SOF driver to be used in a distro:
>> a) the DSP needs to be enabled (as reported by the pci class info)
>> b) sound/hda/intel-dsp-config.c needs to contain a quirk to select SOF over
>> the legacy HDaudio, such as presence of DMIC/SoundWire or a known vendor
>> DMI.
>
>> Traditionally for desktops neither a) nor b) are true, but this is changing:
>> we will start adding quirks for specific product lines as requested by OEMs.
>
>> Does this answer to your question?
>
>The question was more of a why is this being backported one - without
>those extra quirks this does nothing, and frankly with them it seems
>like a *major* change someone might see in stable if they update their
>kernel and it suddenly switches to an entirely different DSP software
>stack.

Hey Mark,

It got picked up because the stable rules explicitly call out PCI IDs as
something we take into the stable trees, and so the AUTOSEL brains
picked up on this...

I'll drop this patch as it doesn't do much.

-- 
Thanks,
Sasha
