Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DE51E0B79
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 12:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389407AbgEYKMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 06:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbgEYKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 06:12:15 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FA0C061A0E;
        Mon, 25 May 2020 03:12:14 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1jdA5a-0006V6-TE; Mon, 25 May 2020 12:12:11 +0200
Date:   Mon, 25 May 2020 12:12:09 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 04/25] block: nr_sects_write(): Disable preemption on
 seqcount write
Message-ID: <20200525101208.GC370823@debian-buster-darwi.lab.linutronix.de>
References: <20200519214547.352050-5-a.darwish@linutronix.de>
 <20200522001237.A00E8206BE@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522001237.A00E8206BE@mail.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> wrote:
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: c83f6bf98dc1 ("block: add partition resize function to blkpg ioctl").
>
> The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.
>
> v5.6.13: Failed to apply! Possible dependencies:
...
> v5.4.41: Failed to apply! Possible dependencies:
...
> v4.19.123: Failed to apply! Possible dependencies:
...
> v4.14.180: Failed to apply! Possible dependencies:
...
> v4.9.223: Failed to apply! Possible dependencies:
...
> v4.4.223: Failed to apply! Possible dependencies:
...
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>

The v5.7-rc1 commit 581e26004a09 ("block: move block layer internals out
of include/linux/genhd.h") moved the part_nr_sects_write() static inline
function from include/linux/genhd.h to block/blk.h.

After review, I'll send a rebased patch to stable.

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
