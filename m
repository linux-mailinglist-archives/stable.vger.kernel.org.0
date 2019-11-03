Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65389ED33C
	for <lists+stable@lfdr.de>; Sun,  3 Nov 2019 12:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfKCL4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 06:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbfKCL4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Nov 2019 06:56:51 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A35E20679;
        Sun,  3 Nov 2019 11:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572782210;
        bh=ueGmZ0nO5wGoHLHtOebI9Syspuwy7evXxAVwjp5SK4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tb6bQ/Ynsff3KFEw6MqkgxbnOFtdr8i0BCha7KDcDC9+Jg52jkNb/U0hQ0BDBT1bC
         ByInxXlgKQ7XBt7j5krosDU3C387C/MmfrJxQPohsfKnP96Pbo7gKQFHqksJtxwnCO
         ehQ8hE62DT/y+pWUHA3E4yHTglee/tszMasfpsaw=
Date:   Sun, 3 Nov 2019 06:56:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Luciano Coelho <luciano.coelho@intel.com>,
        Thomas Deutschmann <whissi@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Please backport 12e36d98d3e for 5.1+: iwlwifi: exclude GEO SAR
 support for 3168
Message-ID: <20191103115649.GA4787@sasha-vm>
References: <7a5f833a-3183-6a64-cd35-80d131343089@gentoo.org>
 <c93083f278d810e1bebab40dcb1990e9285ee1f4.camel@intel.com>
 <dce53d5b-eb19-cee0-5f0f-936c2199e929@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <dce53d5b-eb19-cee0-5f0f-936c2199e929@mageia.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 02, 2019 at 09:05:18PM +0200, Thomas Backlund wrote:
>Den 02-11-2019 kl. 19:52, skrev Luciano Coelho:
>>Hi Thomas,
>>
>>On Sat, 2019-11-02 at 15:36 +0100, Thomas Deutschmann wrote:
>>>Hi,
>>>
>>>please backport
>>>
>>><<<<snip
>>> From 12e36d98d3e5acf5fc57774e0a15906d55f30cb9 Mon Sep 17 00:00:00 2001
>>>From: Luca Coelho <luciano.coelho@intel.com>
>>>Date: Tue, 8 Oct 2019 13:10:53 +0300
>>>Subject: iwlwifi: exclude GEO SAR support for 3168
>>>
>>>We currently support two NICs in FW version 29, namely 7265D and 3168.
>>>Out of these, only 7265D supports GEO SAR, so adjust the function that
>>>checks for it accordingly.
>>>
>>>Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>>>Fixes: f5a47fae6aa3 ("iwlwifi: mvm: fix version check for
>>>GEO_TX_POWER_LIMIT support")
>>>Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>>>snap>>>
>>>
>>>This was the first patch of a 2 patch patch series. The second patch,
>>>aa0cc7dde17 ("iwlwifi: pcie: change qu with jf devices to use qu
>>>configuration") had "Cc: stable@vger.kernel.org # 5.1+" and was added.
>>>The first one was missed.
>>
>>I sent this earlier for stable v5.1, but it's EOL already, so it won't
>>be merged there anymore.
>>
>
>
>But it's still needed in the active 5.3 tree, and is already queued 
>for 4.19, and since 4.14 also loads api 29, it also needs it...

Luca, does it mean we'd also need fddbfeece9c7 ("iwlwifi: fw: don't send
GEO_TX_POWER_LIMIT command to FW version 36") on 4.14? It says 4.19+ but
if I'm reading the code (and comments) right we need it on 4.14 too?

-- 
Thanks,
Sasha
