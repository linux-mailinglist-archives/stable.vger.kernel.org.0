Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA8C17937F
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbgCDPfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:35:09 -0500
Received: from mail1.perex.cz ([77.48.224.245]:38954 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbgCDPfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 10:35:09 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 10:35:08 EST
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id 4A606A003F;
        Wed,  4 Mar 2020 16:26:01 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz 4A606A003F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1583335561; bh=fxtx+XqNIX08h6ygcDl8/zsAP2qz/FDotYgnmDnXe8Q=;
        h=To:Cc:From:Subject:Date:From;
        b=QqKvq68ypRbWiXJ0nKIEjxfek+EKnuAiKDSfJG9UehcMt6vqCrSVRCyPy7cohOdRu
         DMzOie2rV6amQfdJoLSY8VypML4tk3EQ9MgwUMnnvDnOhHexNB4kaeX5wUUsOqa/GP
         tVpvW5hzGDNojrpw7X1Pmya7o4JPJrF/7N4o8BmE=
Received: from p50.perex-int.cz (unknown [192.168.100.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Wed,  4 Mar 2020 16:25:55 +0100 (CET)
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Mark Brown <broonie@kernel.org>,
        Pierre-louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>
From:   Jaroslav Kysela <perex@perex.cz>
Subject: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
Message-ID: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
Date:   Wed, 4 Mar 2020 16:25:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

   could we cherry-pick patch 8cd9956f61c65022209ce6d1e55ed12aea12357d to the 
5.5 stable tree?

8cd9956f61c65022209ce6d1e55ed12aea12357d :
  "ASoC: intel/skl/hda - export number of digital microphones via control 
components"

   Rerefences:

https://gitlab.freedesktop.org/pulseaudio/pulseaudio/issues/817

				Thank you,
					Jaroslav

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.
