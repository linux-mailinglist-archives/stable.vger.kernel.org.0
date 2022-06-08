Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D043054320E
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbiFHN7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiFHN7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:59:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87CD2BBBE3;
        Wed,  8 Jun 2022 06:59:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7AA61B0C;
        Wed,  8 Jun 2022 13:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150EBC34116;
        Wed,  8 Jun 2022 13:59:04 +0000 (UTC)
Date:   Wed, 8 Jun 2022 09:59:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
Message-ID: <20220608095903.79c0b5d9@gandalf.local.home>
In-Reply-To: <CAADnVQLhP1++YSGXrDTRPU6LR98Qkb5dNrcO1zs8HTUhTr9yHw@mail.gmail.com>
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
        <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net>
        <7619DB57-C39B-4A49-808C-7ACF12D58592@goodmis.org>
        <d28e1548-98fb-a533-4fdc-ae4f4568fb75@iogearbox.net>
        <20220608091017.0596dade@gandalf.local.home>
        <CAADnVQLhP1++YSGXrDTRPU6LR98Qkb5dNrcO1zs8HTUhTr9yHw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SHORT_SHORTNER,
        SPF_HELO_NONE,SPF_PASS,T_PDS_SHORTFWD_URISHRT_FP,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Jun 2022 06:57:00 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> you missed Davem's presentation at KR about importance of delegation.
> You need watch it:
> https://youtu.be/ELPENQrtUas?t=9085

It's on my TODO list.

-- Steve
