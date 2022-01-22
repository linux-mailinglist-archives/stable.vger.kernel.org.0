Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5C1496D66
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 19:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiAVSnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 13:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiAVSny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 13:43:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94162C06173B;
        Sat, 22 Jan 2022 10:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0DA98CE0920;
        Sat, 22 Jan 2022 18:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2834CC004E1;
        Sat, 22 Jan 2022 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642877031;
        bh=X6SuqDo+tYPoRwTyTzq7rfjoDJogWGx5G7aUZbbFhWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mCWI4Kb5fvOlNlcrPkqDvxOIhiR5v44VcpZWFDJIUQFlpQWJD3rFZjLQpdUhmc7Qs
         XcQLJJ9xe7PpHnfk+GMcBGRCFeDTLuBw6eq18AFUxDwDoOjLFRpvusqv8wT9qRjIgq
         ngjlystwW4CDkBndmG7cyLV6GLMFo6y7TVS3x1uCfDm1Ewk6BCJofxU9Od1tToiTPp
         LxuzhTE3vVDyajTrQ6m/eE8DNsIXESP34yibw0IA3nOna/TfAaVt8j7vftcDZb5rIa
         pcyxcWWPOAyB7atwGfozmI0LhVDR2rEygxNS/FKXC6PZF/wTPpcA4zzGz7TCss41yT
         sWBix593YQHcg==
Date:   Sat, 22 Jan 2022 13:43:47 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        vsujithkumar.reddy@amd.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.16 50/52] ASoC: amd: acp: acp-mach: Change
 default RT1019 amp dev id
Message-ID: <YexQY68hekHawpRa@sashalap>
References: <20220117165853.1470420-1-sashal@kernel.org>
 <20220117165853.1470420-50-sashal@kernel.org>
 <YeboZaJQLVejZCRg@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YeboZaJQLVejZCRg@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 04:18:45PM +0000, Mark Brown wrote:
>On Mon, Jan 17, 2022 at 11:58:51AM -0500, Sasha Levin wrote:
>> From: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
>>
>> [ Upstream commit 7112550890d7e415188a3351ec0a140be60f6deb ]
>>
>> RT1019 components was initially registered with i2c1 and i2c2 but
>> now changed to i2c0 and i2c1 in most of our AMD platforms. Change
>> default rt1019 components to 10EC1019:00 and 10EC1019:01 which is
>> aligned with most of AMD machines.
>
>This seems like a disruptive change to be backporting into stable...

I'll drop it, thanks!

-- 
Thanks,
Sasha
