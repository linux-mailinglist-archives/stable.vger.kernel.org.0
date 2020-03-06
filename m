Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138FD17BDEF
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgCFNPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgCFNPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 08:15:40 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25D87208CD;
        Fri,  6 Mar 2020 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583500540;
        bh=E/f+bLvJLqlhlD+mFGhRfo1gCXWCKu7vlRaUNiP7+Ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=urcIwNtosruNBfci/IOqGg7iZ3A1Uv/iHVPYEzTcGAFBZNzUommtj4TISKc/DTVSD
         hPXcoZOHaFmJ1hFyF9CE5Z83ZtT/gwj4YvXvZsGXrE6bGniufVDsEjIejhf8PJB+JX
         RAOhcF8KmzAVKi4L64Y7ZU2R8NNSaqACXEeRruvo=
Date:   Fri, 6 Mar 2020 08:15:39 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jaroslav Kysela <perex@perex.cz>
Cc:     stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Pierre-louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
Message-ID: <20200306131539.GO21491@sasha-vm>
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 04:25:54PM +0100, Jaroslav Kysela wrote:
>Hi,
>
>  could we cherry-pick patch 8cd9956f61c65022209ce6d1e55ed12aea12357d 
>to the 5.5 stable tree?

Queued up for 5.5, thank you.

-- 
Thanks,
Sasha
