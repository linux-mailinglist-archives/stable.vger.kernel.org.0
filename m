Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34B942F3C
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFLSnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 14:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfFLSnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 14:43:23 -0400
Received: from localhost (unknown [131.107.160.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409E7206E0;
        Wed, 12 Jun 2019 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560365003;
        bh=gTgrYSbagDxDrjxvjae5PNzYPQfcuzDXdvc4THZtfcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mgakpK+3bOHLm5dY2ZXB6NsDHRQgqH+cTbbg0hi3m0PmgOOA9x6GH6XI29BM/MQgF
         SR91z/Nbi7rvd0v1WPYC+Iph0xbpowQSOzgTQFD9Y80SJaF7J6KAeiAH1RKH2xY3rc
         7b38pyTHbnjbOlMn/i19iaj8lzDybCrWnTEDPer0=
Date:   Wed, 12 Jun 2019 14:43:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guilherme Piccoli <gpiccoli@canonical.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Message-ID: <20190612184322.GF1513@sasha-vm>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
 <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
 <20190612164958.GB31124@kroah.com>
 <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 03:07:11PM -0300, Guilherme Piccoli wrote:
>On Wed, Jun 12, 2019 at 1:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Wed, Jun 12, 2019 at 01:37:24PM -0300, Guilherme G. Piccoli wrote:
>> > +Greg, Sasha
>>
>> Please resend them in a format that they can be applied in.
>>
>> Also, I need a TON of descriptions about why this differs from what is
>> in Linus's tree, as it is, what you have below does not show that at
>> all, they seem to be valud for 5.2-rc1.
>
>Thanks Greg, I'll work on it. Can this "ton" of description be a cover-letter?

Please just add it to the commit message. We might need to refer to it
in the future and cover letter will just get lost.

--
Thanks,
Sasha
