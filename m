Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A262A254763
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 16:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgH0Oto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 10:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgH0Otg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 10:49:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84BDE2054F;
        Thu, 27 Aug 2020 14:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598539775;
        bh=WwxIAleRWd4L80tFxRs8dqMtJpIsSDjiyjRXR5sNbS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q99Hs1SJQN056VstqwwoeDWmbnabxbjgXz4CpVRVhLxJgl+HIQRD75sGkomGQolhT
         1S0upNPLsJ3AYyx0e0K94mhbxdQnQBVLX3QpKpiVZ0e/eRqWLshX2QK+P3IKs0xvPF
         s9KoKCoIkYfKW/v6VrQregRYOj0pY+a9Li0NWW3s=
Date:   Thu, 27 Aug 2020 10:49:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        ranjani.sridharan@linux.intel.com,
        Rander Wang <rander.wang@linux.intel.com>,
        kuninori.morimoto.gx@renesas.com,
        pierre-louis.bossart@linux.intel.com
Subject: Re: [PATCH] ASoC: intel/skl/hda - fix probe regression on systems
 without i915
Message-ID: <20200827144934.GN8670@sasha-vm>
References: <20200714132804.3638221-1-kai.vehmanen@linux.intel.com>
 <159542547442.19620.11983281044239009101.b4-ty@kernel.org>
 <alpine.DEB.2.22.394.2008271002260.3186@eliteleevi.tm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2008271002260.3186@eliteleevi.tm.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 10:14:18AM +0300, Kai Vehmanen wrote:
>Hi,
>
>+stable
>
>On Wed, 22 Jul 2020, Mark Brown wrote:
>> Applied to
>>
>>    https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next
>[...]
>>
>> [1/1] ASoC: intel/skl/hda - fix probe regression on systems without i915
>>       commit: ffc6d45d96f07a32700cb6b7be2d3459e63c255a
>
>please apply this to stable kernels as well. Without the patch, audio is
>broken with 5.8.x on many laptops (with Intel audio and non-Intel
>graphics). One more recent bug filed:
>https://github.com/thesofproject/sof/issues/3345
>
>This does _not_ affect 5.7.x and older, plus already fixed in 5.9-rc.

Applied to 5.8, thanks!

-- 
Thanks,
Sasha
