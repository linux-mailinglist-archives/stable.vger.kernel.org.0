Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20DD333C34
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCJMG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhCJMGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 07:06:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A7C64FEE;
        Wed, 10 Mar 2021 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615378010;
        bh=GVRxbE5XCkimPxYjriDb+gFAOIRYYFsaiOlWdBVZhf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rbBzgN3MceSCRkawOIYTVt/xQ29z/XcWin60DdHq+4t3a/B0LVY/mKbiokW4bZtoK
         oNix2OYalCr/M9TuKN90rPdlMW/qksckaZY45Ge7xU1GUFJiz/osyofoA15Qdkvh/E
         HShx3s9rSS1csqtcEqZmAwRrGfkkjbesqFz5Siv4=
Date:   Wed, 10 Mar 2021 13:06:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        David Ward <david.ward@ll.mit.edu>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2] ASoC: SOF: Intel: broadwell: fix mutual exclusion
 with catpt driver
Message-ID: <YEi2Vwid7ESsBRCb@kroah.com>
References: <20210309221618.246754-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309221618.246754-1-pierre-louis.bossart@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 04:16:18PM -0600, Pierre-Louis Bossart wrote:
> In v5.10, the "haswell" driver was replaced by the "catpt" driver, but
> the mutual exclusion with the SOF driver was not updated. This leads
> to errors with card names and UCM profiles not being loaded by
> PulseAudio.
> 
> This fix should only be applied on v5.10-stable, the mutual exclusion
> was removed in 5.11.
> 
> Reported-by: David Ward <david.ward@ll.mit.edu>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211985
> Fixes: 6cbfa11d2694 ("ASoC: Intel: Select catpt and deprecate haswell")
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
> Acked-by: Mark Brown <broonie@kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sasha Levin <sashal@kernel.org>
> ---
> v2: added Mark and Cezary tags, fixed stable address, added
> maintainers
> 

Now queued up, thanks.

greg k-h
