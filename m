Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB627B80D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 01:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgI1XZb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 28 Sep 2020 19:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgI1XZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 19:25:31 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD7BE221EF;
        Mon, 28 Sep 2020 22:09:43 +0000 (UTC)
Date:   Mon, 28 Sep 2020 18:09:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH 4.19 38/92] kprobes: Fix NULL pointer dereference at
 kprobe_ftrace_handler
Message-ID: <20200928180942.100aa6c8@oasis.local.home>
In-Reply-To: <CA+G9fYvdQv2Ukvs-UKiEgYaDdBthsWsY=35cQ4YpvMhA0hU5Gg@mail.gmail.com>
References: <20200820091537.490965042@linuxfoundation.org>
        <20200820091539.592290034@linuxfoundation.org>
        <CA+G9fYvdQv2Ukvs-UKiEgYaDdBthsWsY=35cQ4YpvMhA0hU5Gg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 01:32:59 +0530
Naresh Kamboju <naresh.kamboju@linaro.org> wrote:

> stable rc branch 4.19 build warning on arm64.
> 
> ../kernel/kprobes.c: In function ‘kill_kprobe’:
> ../kernel/kprobes.c:1070:33: warning: statement with no effect [-Wunused-value]
>  1070 | #define disarm_kprobe_ftrace(p) (-ENODEV)
>       |                                 ^
> ../kernel/kprobes.c:2090:3: note: in expansion of macro ‘disarm_kprobe_ftrace’
>  2090 |   disarm_kprobe_ftrace(p);
>       |   ^~~~~~~~~~~~~~~~~~~~

Seems to affect upstream as well.

-- Steve
