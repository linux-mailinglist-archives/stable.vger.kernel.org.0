Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261543ADE62
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 14:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhFTM62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 08:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229768AbhFTM61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Jun 2021 08:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F35F96113C;
        Sun, 20 Jun 2021 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624193775;
        bh=mle5POcyGAwOEaVpNpreYRodWHXhggRb8oNFCnkiLo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dxDuC9pjzJlmID05Me0Wq2dflZcC1ChKNmkrOEy1ZU1spgliJXS7UfSwbV7I/YJ79
         WWPoy9W1jqBOzdFEYjvwG3nSIoelLmrY8bwN3nI0ZSy763hykkK263e0hJzJCc8Eyi
         C+366cLoNIKBLTCFz/j9Y0onX7e89zMFYa4O1yntvmQ9vAHby+a9PvBNC/bo9MX3pl
         6WFYcokahheYYCk12wlUREU9/FyY38bU+AH8RybfV9G3AHgx5HfAVWDBr5ZXV8Farf
         5ZtNQYrxMKilFcTgiGRVSx+9iGm1MrcDhujpdZ0IV48yI3Km6aX15YJDTZov5mbrfW
         VxuJeZlBWorCw==
Date:   Sun, 20 Jun 2021 08:56:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Gabriel Craciunescu <nix.or.die@gmail.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.12 11/33] ASoC: AMD Renoir - add DMI entry for
 Lenovo 2020 AMD platforms
Message-ID: <YM867lR9trmMWKAc@sashalap>
References: <20210615154824.62044-1-sashal@kernel.org>
 <20210615154824.62044-11-sashal@kernel.org>
 <20210615155607.GN5149@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210615155607.GN5149@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 04:56:07PM +0100, Mark Brown wrote:
>On Tue, Jun 15, 2021 at 11:48:02AM -0400, Sasha Levin wrote:
>> From: Mark Pearson <markpearson@lenovo.com>
>>
>> [ Upstream commit 19a0aa9b04c5ab9a063b6ceaf7211ee7d9a9d24d ]
>>
>> More laptops identified where the AMD ACP bridge needs to be blocked
>> or the microphone will not work when connected to HDMI.
>>
>> Use DMI to block the microphone PCM device for these platforms.
>
>You've backported the fix that reverts this a couple of patches later in
>the series but might be as well to just not backport either, the end
>result is the same.

Good point, I'll drop it.

-- 
Thanks,
Sasha
