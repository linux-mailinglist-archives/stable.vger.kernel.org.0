Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527FE1308C2
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 16:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAEPak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 10:30:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgAEPak (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 10:30:40 -0500
Received: from localhost (unknown [73.61.17.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118A020801;
        Sun,  5 Jan 2020 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578238239;
        bh=ZkiRfHZglT0lasFVG7b5RxLqwyxF3NGLHxSOFnCrxxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y/Boz9n+QZFqJvZXiDOTGT1J4y5Cku/sHK2PGokgmCnWvaWBOAGfqF4sun7a5m2XR
         CUQC3OcssriFtWn5V2KNeeN7watuCxX7IAfLPd/hveaaJkkG0KguuQ51A5bgZ0PAxT
         7IKDfIBo4LE0LQrM6bjCDbqrtLTGpKzsfQ5O7ZHo=
Date:   Sun, 5 Jan 2020 10:30:38 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.4 006/187] ASoC: max98090: exit workaround
 earlier if PLL is locked
Message-ID: <20200105153038.GO16372@sasha-vm>
References: <20191227174055.4923-1-sashal@kernel.org>
 <20191227174055.4923-6-sashal@kernel.org>
 <20191227224430.GO27497@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191227224430.GO27497@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 27, 2019 at 10:44:30PM +0000, Mark Brown wrote:
>On Fri, Dec 27, 2019 at 12:37:54PM -0500, Sasha Levin wrote:
>> From: Tzung-Bi Shih <tzungbi@google.com>
>>
>> [ Upstream commit 6f49919d11690a9b5614445ba30fde18083fdd63 ]
>>
>> According to the datasheet, PLL lock time typically takes 2 msec and
>> at most takes 7 msec.
>
>Same here and for the other max98090 patch - once things are
>fixed it'll be OK.

I've dropped both. Could you ping me when this is settled and I'll grab
these and any follow up fixes?

-- 
Thanks,
Sasha
