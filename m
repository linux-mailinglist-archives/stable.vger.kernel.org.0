Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC914081D0
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 23:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhILV15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 17:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236427AbhILV15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 17:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29A6C60F56;
        Sun, 12 Sep 2021 21:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631482002;
        bh=BcXMonNRj+Qy+7xb7JdXVCoadCtdi/wA4Otl1L6sI8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WptiwguHCkRNmCk8xm9iF/EDCE5K2M8qu3VqOAxQX+5L+Zoe+gmKNOtgzXaGgLEkY
         FgYKPX2APcK0bO+KgTUKvCZzQE6aR4RdRMqJL5L04CFiYRZilTzKv7mLsXYPLd5sRL
         2SR+SzQLG8LQZ6twBgfFLGvDv7VdYnQXit243p4gsLxgebEjZRDVK19dpC7ODui3F9
         zklup6Q3CyCMm5BufKc8FX3XXBNZSerWfnQreGknadjnuouoQ2Cyk9lYHyapRhZO6L
         E6PhuFTL5VCahkMj8E654ttCLVB+FqcjMJFnazv7O4XICNG0V5xQ9RFYgKgiRgNTfV
         wlNrr5eqgihmA==
Date:   Sun, 12 Sep 2021 17:26:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 4.4 29/35] ASoC: intel: atom: Revert PCM buffer
 address setup workaround again
Message-ID: <YT5wkTuK6buIssE+@sashalap>
References: <20210909120116.150912-1-sashal@kernel.org>
 <20210909120116.150912-29-sashal@kernel.org>
 <s5hv93aosul.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <s5hv93aosul.wl-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 02:07:14PM +0200, Takashi Iwai wrote:
>On Thu, 09 Sep 2021 14:01:10 +0200,
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
>Please drop this.

Will do, thanks!

-- 
Thanks,
Sasha
