Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87C94759C1
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhLONel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:34:41 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:35789 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231935AbhLONel (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:34:41 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 552DA32006F5;
        Wed, 15 Dec 2021 08:34:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 15 Dec 2021 08:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=lf4LldtAu0UDilm7qYTPDv1f1LV
        a9b4P6lApIfRcJtw=; b=bS2zMXeA8p87I693ehhYpIxsazy9Stt9TGEba3hNtPf
        YS6Ll1Xb7T/lUwR3I+7RJKgeJmpIheZJC2IHKE6NJqgNdgI9eYYwNs4olTLSJnVJ
        DEmmeWHK82YZVdbMY+JxhMuy8xSVRCaX21T22xsiKiWwOv/gxpjy/MdH1JyoAJS5
        W2o8Go4FS5YMP/VBzCReW3wL55Ll8dtwjsjYpTASJ6jhwbeUg0pHcY8n/38K1/d2
        T+OaNG+1Mj0/ywyI1AMX4539IkEgtoAIDpatOTLs9SFn/QN3YMX5iDMYxNKGqKby
        yaah0ObrXpUjWj2zkkf+cLOA/KEXxh7M/jF/P1Eydqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lf4Lld
        tAu0UDilm7qYTPDv1f1LVa9b4P6lApIfRcJtw=; b=SXgzmQAW1duuqaRZf8p+4J
        9R1ewdRKJPRMydLy9zYU3JknGkjPpWDkbdHi8fibwv0b1wrilImFbI3NOpWe8S6v
        BXa71fI8REXGAcvNbVSHew1YX1pfamhfCh4i0K5dnPu/LceqslmLfRV3OeXjwsR1
        sfy25lKr8B1D4HL0lcDHB42R9JUNpsyKIVySVixQguJ9PhKqV/bQbZnvytWwESHq
        d2TbWnqQqfQPXxKtaL6GxUyjoy6ofPkekv4utm5pIknwO3htnWKjBUBB7ig3+bJb
        cx78GuVQ2C7OphJLNwnFVzu09xXyUbKslRF4RcJCFCjBZHF/cfZxhX+IWODlDIyA
        ==
X-ME-Sender: <xms:7-65Ybb4WpuEqmFSnUBYPiuWezHcibUKyJEEN8hMRH9oGFjOkzMOpQ>
    <xme:7-65YaaF7URYzNZ0gPddxVvu4-OE1uAjtAInkxEgbwNR69QGV7uK4Iq9VIhHv6ZDY
    cPzibgHXqFSPw>
X-ME-Received: <xmr:7-65Yd9jnd_CeeikzNCAXlffHOmHX1p6Ur2d7bX7DXpCyYmeFk-hp9rrq-8m6YzD5yHnmK2MhV1ks6mUz2nnUfYDj7ib8YIn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrledvgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:7-65YRpMNVZgxZolAhn7FXpKqyaRuacyp0xiXb1U3n8evvGfH9efJA>
    <xmx:7-65YWqHTIf2sv5lISkTKRxn3UN0AGa1NZDzvok_9CZcyIb7Q9Wovw>
    <xmx:7-65YXSA3Z9fh3n5hfNPBbKrJzDAaOYzt7vx5dufXOIaQf0O11ebXA>
    <xmx:7-65YXf378X0qnCtlrPGhaQYhZoatGVhdNDb0_UnOIyV4UfqPiH2CA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Dec 2021 08:34:39 -0500 (EST)
Date:   Wed, 15 Dec 2021 14:34:36 +0100
From:   Greg KH <greg@kroah.com>
To:     Connor O'Brien <connoro@google.com>
Cc:     stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH] bpf: fix panic due to oob in bpf_prog_test_run_skb
Message-ID: <Ybnu7GMXglGpcU5A@kroah.com>
References: <20211215000310.113753-1-connoro@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215000310.113753-1-connoro@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 12:03:10AM +0000, Connor O'Brien wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> commit 6e6fddc78323533be570873abb728b7e0ba7e024 upstream.
> 
> sykzaller triggered several panics similar to the below:
> 
>   [...]
>   [  248.851531] BUG: KASAN: use-after-free in _copy_to_user+0x5c/0x90
>   [  248.857656] Read of size 985 at addr ffff8808017ffff2 by task a.out/1425
>   [...]
>   [  248.865902] CPU: 1 PID: 1425 Comm: a.out Not tainted 4.18.0-rc4+ #13
>   [  248.865903] Hardware name: Supermicro SYS-5039MS-H12TRF/X11SSE-F, BIOS 2.1a 03/08/2018
>   [  248.865905] Call Trace:
>   [  248.865910]  dump_stack+0xd6/0x185
>   [  248.865911]  ? show_regs_print_info+0xb/0xb
>   [  248.865913]  ? printk+0x9c/0xc3
>   [  248.865915]  ? kmsg_dump_rewind_nolock+0xe4/0xe4
>   [  248.865919]  print_address_description+0x6f/0x270
>   [  248.865920]  kasan_report+0x25b/0x380
>   [  248.865922]  ? _copy_to_user+0x5c/0x90
>   [  248.865924]  check_memory_region+0x137/0x190
>   [  248.865925]  kasan_check_read+0x11/0x20
>   [  248.865927]  _copy_to_user+0x5c/0x90
>   [  248.865930]  bpf_test_finish.isra.8+0x4f/0xc0
>   [  248.865932]  bpf_prog_test_run_skb+0x6a0/0xba0
>   [...]
> 
> After scrubbing the BPF prog a bit from the noise, turns out it called
> bpf_skb_change_head() for the lwt_xmit prog with headroom of 2. Nothing
> wrong in that, however, this was run with repeat >> 0 in bpf_prog_test_run_skb()
> and the same skb thus keeps changing until the pskb_expand_head() called
> from skb_cow() keeps bailing out in atomic alloc context with -ENOMEM.
> So upon return we'll basically have 0 headroom left yet blindly do the
> __skb_push() of 14 bytes and keep copying data from there in bpf_test_finish()
> out of bounds. Fix to check if we have enough headroom and if pskb_expand_head()
> fails, bail out with error.
> 
> Another bug independent of this fix (but related in triggering above) is
> that BPF_PROG_TEST_RUN should be reworked to reset the skb/xdp buffer to
> it's original state from input as otherwise repeating the same test in a
> loop won't work for benchmarking when underlying input buffer is getting
> changed by the prog each time and reused for the next run leading to
> unexpected results.
> 
> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> Reported-by: syzbot+709412e651e55ed96498@syzkaller.appspotmail.com
> Reported-by: syzbot+54f39d6ab58f39720a55@syzkaller.appspotmail.com
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> [connoro: drop test_verifier.c changes not applicable to 4.14]
> Signed-off-by: Connor O'Brien <connoro@google.com>
> ---
> Hello,
> 
> This is a backport for the 4.14 stable tree.

Now queued up, thanks.

greg k-h
