Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954731757F
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfEHJ5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:57:36 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:13514 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfEHJ5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:57:35 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2019 05:57:34 EDT
Received: from [81.155.195.4] (helo=[192.168.1.118])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1hOItA-0006Nd-4w; Wed, 08 May 2019 10:29:24 +0100
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Song Liu <liu.song.a23@gmail.com>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com>
 <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
 <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5CD2A172.4010302@youngman.org.uk>
Date:   Wed, 8 May 2019 10:29:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/05/19 22:07, Song Liu wrote:
> Could you please run a quick test with raid5? I am wondering whether
> some race condition could get us into similar crash. If we cannot easily
> trigger the bug, we can process with this version.

Bear in mind I just read the list and write documentation, but ...

My gut feeling is that if it can theoretically happen for all raid
modes, it should be fixed for all raid modes. What happens if code
changes elsewhere and suddenly it really does happen for say raid-5?

On the other hand, if fixing it in md.c only gets tested for raid-0, how
do we know it will actually work for other raids if they do suddenly
start falling through.

Academic purity versus engineering practicality :-)

Cheers,
Wol
