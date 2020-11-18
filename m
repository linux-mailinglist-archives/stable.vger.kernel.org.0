Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFF82B7E74
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 14:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgKRNlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 08:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgKRNk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 08:40:59 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C4C221FC;
        Wed, 18 Nov 2020 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605706859;
        bh=Q8EnKLbZ+KP3QY4ay3tjDNACIR9hufECfy9ZeRD8YqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AaVb+CKT2uj+ILKfcwOFTFFZl8fAQml4P1+x0Oc7QJ4RO+TzHmTNgKeeTyBsEfFvR
         0U9i1LOmlBY1IwU/IJVNV8cZVzIG/LwS+rQ3gRfcAEQWM0wwwci/QBW56AO9P7h9qE
         MNh6PRR5qb/904G5r00T+5yjIv2XKC1z5El5F2Yk=
Date:   Wed, 18 Nov 2020 08:40:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 031/101] ALSA: hda: Reinstate runtime_allow() for
 all hda controllers
Message-ID: <20201118134057.GB629656@sasha-vm>
References: <20201117122113.128215851@linuxfoundation.org>
 <20201117122114.605040102@linuxfoundation.org>
 <20201118104316.GA8364@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201118104316.GA8364@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 11:43:16AM +0100, Pavel Machek wrote:
>Hi!
>
>> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>
>> [ Upstream commit 9fc149c3bce7bdbb94948a8e6bd025e3b3538603 ]
>>
>> The broken jack detection should be fixed by commit a6e7d0a4bdb0 ("ALSA:
>> hda: fix jack detection with Realtek codecs when in D3"), let's try
>> enabling runtime PM by default again.
>
>I believe experiments should be done in mainline, not in stable.
>
>Worse problem is that a6e7d0a4bdb0 is not in 4.19-stable, so this will
>likely break jack detection.

I've dropped it from 4.19, thanks!

-- 
Thanks,
Sasha
