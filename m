Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122B433875A
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 09:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhCLI3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 03:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhCLI3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 03:29:13 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5548AC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 00:29:13 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id p193so24537226yba.4
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 00:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5ET+6RB/ppy8RK6JZE6EAYDj3pVXQIgvxrXN7QzeNg=;
        b=SYGgRYQiJnwwVL3mOyETjDqHQLQ+0biuegmWBmPGvUKWvjiJzC0awjGFiG9+WaeEDA
         5Itlht9g77+OxUj2XfD/KeGpkSIZYWLkF+dHVN3Am8CEOQ4dmh4UhYPKWwOubtKy/REl
         iDPfDk7VVISR6cfXUKiNRcvnwm6CcKHu1sP33vmtjH4w1ZRrpXJ4YI4LRjzElTQ0kSZk
         9VSYRojVK2QKcE2geh1i78B9cKq+JSyq491pUnAeIIAYZRmSnw0AjAUhQzfwNHdOm6SC
         AY7vnAQlW7Xhvk04Cu9FqanspDfXjxMaFiG2IgyhO3BsPy4lusQo6cMi8fyLkaC67N5q
         O4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5ET+6RB/ppy8RK6JZE6EAYDj3pVXQIgvxrXN7QzeNg=;
        b=N7ai6M7MdUqicTALK015M09P5iLZU/ut8I39NHWLSp36ZpGnCVP7wGIC+sIZYNtyFX
         6JGalEcF593Tj5GCHUmLGFFI5MmSkx/3VwvnEGzRFSk4Dp/e83L8KWMfnV/9XoJJM9n3
         Yt37MdHT6aBriWdCSyRLCSSnFYDGrCNIydEsc/DdLrBflZCoRBAVXT00ASZGB/PTvhPz
         5Y7u+u/vP+lWmzdzpNSq7PooddxEqO/1HRJaqZqdhb/tUqtGh8SN0lX3ZXkt1gSNRUm3
         P8dOB5WrYT0e4fNtSyIPxUt4ZFIS5x0RA7X2uf4O5tG150OHNy9ZEFVswYkqP1x48eDs
         PAKw==
X-Gm-Message-State: AOAM530cgkE5Ha4qgZs92IQ2EcgYlJRHEMFcCvcWLK2YxUOwx3YWyo32
        om/vlDU3wDfLUjlrlmVxbLCowB6dHycMxzGn9yIR/M3WFCqLig==
X-Google-Smtp-Source: ABdhPJwmtHaVFWe8PSbC7lE3RqcUZUHGaj2kT1zQxw97YTjipKjkZfK21sSsGe9zXmWUhB09JPqFrywBDGlClsDfWCQ=
X-Received: by 2002:a25:1d88:: with SMTP id d130mr17882155ybd.446.1615537751847;
 Fri, 12 Mar 2021 00:29:11 -0800 (PST)
MIME-Version: 1.0
References: <161548693921823@kroah.com>
In-Reply-To: <161548693921823@kroah.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 12 Mar 2021 09:29:00 +0100
Message-ID: <CANn89iKw_Y7+Thphnncxy++JB1V9pMCsJ5x1PYZV0UTuSWir+A@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tcp: add sanity tests to TCP_QUEUE_SEQ"
 failed to apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, ieatmuttonchuan@gmail.com,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I prepared a patch series of 3, I will send it soon.

490fac7d90caa9e987eaa0b7cbbc9c94a1a0f739 (HEAD) tcp: add sanity tests
to TCP_QUEUE_SEQ
d767f47dde2df49a8b6b7e9199e98be0e9650d6e tcp: annotate tp->write_seq
lockless reads
84a5987c38e374ea16c26cdbba9e622d86219366 tcp: annotate tp->copied_seq
lockless reads
030194a5b292bb7613407668d85af0b987bb9839 (tag: v4.19.180,
origin/linux-4.19.y) Linux 4.19.180

On Thu, Mar 11, 2021 at 7:22 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 8811f4a9836e31c14ecdf79d9f3cb7c5d463265d Mon Sep 17 00:00:00 2001
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 1 Mar 2021 10:29:17 -0800
> Subject: [PATCH] tcp: add sanity tests to TCP_QUEUE_SEQ
>
> Qingyu Li reported a syzkaller bug where the repro
> changes RCV SEQ _after_ restoring data in the receive queue.
>
> mprotect(0x4aa000, 12288, PROT_READ)    = 0
> mmap(0x1ffff000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x1ffff000
> mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
> mmap(0x21000000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x21000000
> socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
> setsockopt(3, SOL_TCP, TCP_REPAIR, [1], 4) = 0
> connect(3, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28) = 0
> setsockopt(3, SOL_TCP, TCP_REPAIR_QUEUE, [1], 4) = 0
> sendmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="0x0000000000000003\0\0", iov_len=20}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 20
> setsockopt(3, SOL_TCP, TCP_REPAIR, [0], 4) = 0
> setsockopt(3, SOL_TCP, TCP_QUEUE_SEQ, [128], 4) = 0
> recvfrom(3, NULL, 20, 0, NULL, NULL)    = -1 ECONNRESET (Connection reset by peer)
>
> syslog shows:
> [  111.205099] TCP recvmsg seq # bug 2: copied 80, seq 0, rcvnxt 80, fl 0
> [  111.207894] WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343 tcp_recvmsg_locked+0x90e/0x29a0
>
> This should not be allowed. TCP_QUEUE_SEQ should only be used
> when queues are empty.
>
> This patch fixes this case, and the tx path as well.
>
> Fixes: ee9952831cfd ("tcp: Initial repair mode")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=212005
> Reported-by: Qingyu Li <ieatmuttonchuan@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index dfb6f286c1de..de7cc8445ac0 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3469,16 +3469,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>                 break;
>
>         case TCP_QUEUE_SEQ:
> -               if (sk->sk_state != TCP_CLOSE)
> +               if (sk->sk_state != TCP_CLOSE) {
>                         err = -EPERM;
> -               else if (tp->repair_queue == TCP_SEND_QUEUE)
> -                       WRITE_ONCE(tp->write_seq, val);
> -               else if (tp->repair_queue == TCP_RECV_QUEUE) {
> -                       WRITE_ONCE(tp->rcv_nxt, val);
> -                       WRITE_ONCE(tp->copied_seq, val);
> -               }
> -               else
> +               } else if (tp->repair_queue == TCP_SEND_QUEUE) {
> +                       if (!tcp_rtx_queue_empty(sk))
> +                               err = -EPERM;
> +                       else
> +                               WRITE_ONCE(tp->write_seq, val);
> +               } else if (tp->repair_queue == TCP_RECV_QUEUE) {
> +                       if (tp->rcv_nxt != tp->copied_seq) {
> +                               err = -EPERM;
> +                       } else {
> +                               WRITE_ONCE(tp->rcv_nxt, val);
> +                               WRITE_ONCE(tp->copied_seq, val);
> +                       }
> +               } else {
>                         err = -EINVAL;
> +               }
>                 break;
>
>         case TCP_REPAIR_OPTIONS:
>
