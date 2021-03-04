Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D2232DB7A
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 21:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCDU4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 15:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhCDU4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 15:56:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C1C64F23;
        Thu,  4 Mar 2021 20:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614891349;
        bh=UPRgvSA47uEnBTvBb8Vj74Drida1Y5zo3ZSzKyWJ9Y4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=co95ogs7z6ntEo7zTvLIs/FdF5Sa/GhXhO5UYk+4Jj/d92bLk0zbXyKMMfURTwdAB
         Arzr4WR5PztUzTiKcD7HS3IG+ibk7AvNOLsyx/uV6AzAwn3Pe1z1rTQjGFx4M/Vzq+
         jRD+HgfAEEXlKLsP/pTasnJWJYkMh2xNV3tP+frCm1v16fO5JwxwTQFzELAXGBVAve
         Ws8VZnuskuwm4N4FhgPgPsO5WQcVwChbvWTfe5q4KK6fZ/LCOLx9OddI/8Vxuww8gS
         wbzkULq9LfUdKkclpUKvE3RA2k7sM6p8kIEvibWomElHrS67CISWDd0dsNBt/WsdCn
         b+2CPtGoANc4w==
Date:   Thu, 4 Mar 2021 15:55:48 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Vivier <laurent@vivier.eu>,
        YunQiang Su <ysu@wavecomp.com>, Helge Deller <deller@gmx.de>
Subject: Re: Please apply commit 2347961b11d4 ("binfmt_misc: pass binfmt_misc
 flags to the interpreter") to 5.10.y and later
Message-ID: <YEFJVENyU9QaO/NK@sashalap>
References: <YD42Sh5n2sjF9tNj@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YD42Sh5n2sjF9tNj@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 01:57:46PM +0100, Salvatore Bonaccorso wrote:
>Hi
>
>2347961b11d4 ("binfmt_misc: pass binfmt_misc flags to the
>interpreter") was applied in mainline and included in 5.12-rc1.
>
>Probably you could argue here on both a bugfix or feature addition.
>
>My intention is the following: In the Debian bugreport
>https://bugs.debian.org/970460 an issue was raised with qemu-user
>which needs to know if it has to preserve the argv[0]. As shown there
>it is an issue with multi-call binaries.
>
>So again, not sure if you want to consider it, but defintively
>Yunqiang Su and others would appreicate. If it gets backported we will
>pick it up automatically.

Given it needs changes in userspace too I'm not sure it qulifies as a
fix per-se. Though as you point out, it's really borderline.

Generally I would just take it, but it affects interactions with
userspace, so I feel less comfortable with this.

-- 
Thanks,
Sasha
