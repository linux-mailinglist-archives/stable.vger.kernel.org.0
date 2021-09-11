Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7174078DE
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 16:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhIKOj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 10:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhIKOj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 10:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9ABA60FDC;
        Sat, 11 Sep 2021 14:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631371094;
        bh=YBIF5J36ij9usGPWBSbRlHUOMTdFl+Nmw41emmyuPD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YSRXYdid9WF1FS3P6uX3QK970zK80deaRUyrE/VadNYI3HkO/CRozr0ytsLBTQpXU
         bY93JsNMfuv/wJ57SORREkJ7EldrWK+FXVdwuU1RgZxHvdf7cfcQs2rpaoO6Bnvt5z
         BdKJ6p1YuWkf12LvDW3VHF6rtgnJm/NEhVgEQo0KaviltIX2NryKcupZuz9A3zHx16
         QtLLicV4Ap15FhDUJgjplsRLwutHoRZMzW4ATtPanW5e1BqyDYgoum/qiDpj5hN2X/
         KiD81dmOw4mebaehNiSH535uP44ooHoHfXL9Uek2fDZLRI2EOKBFcDypDi0lhp4dRk
         OXIPSLV2IRC3g==
Date:   Sat, 11 Sep 2021 10:38:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.13 176/219] ASoC: intel: atom: Revert PCM
 buffer address setup workaround again
Message-ID: <YTy/VWNFechDAFMB@sashalap>
References: <20210909114635.143983-1-sashal@kernel.org>
 <20210909114635.143983-176-sashal@kernel.org>
 <s5h5yvaq80i.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <s5h5yvaq80i.wl-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 01:54:21PM +0200, Takashi Iwai wrote:
>On Thu, 09 Sep 2021 13:45:52 +0200,
>Sasha Levin wrote:
>>
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> [ Upstream commit e28ac04a705e946eddc5e7d2fc712dea3f20fe9e ]
>>
>> We worked around the breakage of PCM buffer setup by the commit
>> 65ca89c2b12c ("ASoC: intel: atom: Fix breakage for PCM buffer address
>> setup"), but this isn't necessary since the CONTINUOUS buffer type
>> also sets runtime->dma_addr since commit f84ba106a018 ("ALSA:
>> memalloc: Store snd_dma_buffer.addr for continuous pages, too").
>> Let's revert the change again.
>>
>> Link: https://lore.kernel.org/r/20210822072127.9786-1-tiwai@suse.de
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop.  It's only for 5.15.

Dropped, thanks!

-- 
Thanks,
Sasha
