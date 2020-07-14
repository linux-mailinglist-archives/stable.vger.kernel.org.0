Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CAB21E776
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 07:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgGNFcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 01:32:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:43622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgGNFco (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 01:32:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1CAACB004;
        Tue, 14 Jul 2020 05:32:46 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     colin.king@canonical.com, david.abdurachmanov@gmail.com,
        dvyukov@google.com, linux-riscv@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] RISC-V: Double the stack size on rv64
References: <20200714011922.138617-1-palmerdabbelt@google.com>
X-Yow:  Didn't KIERKEGAARD wear out his TIRES in VIENNA during a SNOWSTORM of
 FREUD's unpaid DENTAL BILLS?
Date:   Tue, 14 Jul 2020 07:32:42 +0200
In-Reply-To: <20200714011922.138617-1-palmerdabbelt@google.com> (Palmer
        Dabbelt's message of "Mon, 13 Jul 2020 18:19:23 -0700")
Message-ID: <87v9iq4q6d.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Jul 13 2020, Palmer Dabbelt wrote:

> This was suggested in the syzkaller thread as a fix for a bunch of issues.  It
> seems in line with what other architectures are doing, and while I haven't
> personally figured out how to reproduce the issues they seem believable enough
> to just change it.
>
> Fixes: 7db91e57a0ac ("RISC-V: Task implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> ---
> I've put this on fixes as I don't see a patch from anyone on that thread, and
> it seems straight-forward enough to just do it.  If there's any issues I'm
> happy to listen, otherwise this is going up later this week.

See
<https://lore.kernel.org/linux-riscv/20200708145625.GA438@infradead.org/T/>.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
