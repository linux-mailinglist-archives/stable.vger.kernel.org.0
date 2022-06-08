Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC1E543121
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbiFHNKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiFHNKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C223379409;
        Wed,  8 Jun 2022 06:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C433961A7B;
        Wed,  8 Jun 2022 13:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33904C34116;
        Wed,  8 Jun 2022 13:10:19 +0000 (UTC)
Date:   Wed, 8 Jun 2022 09:10:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
Message-ID: <20220608091017.0596dade@gandalf.local.home>
In-Reply-To: <d28e1548-98fb-a533-4fdc-ae4f4568fb75@iogearbox.net>
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
        <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net>
        <7619DB57-C39B-4A49-808C-7ACF12D58592@goodmis.org>
        <d28e1548-98fb-a533-4fdc-ae4f4568fb75@iogearbox.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Jun 2022 14:38:39 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> >>> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>  
> >>
> >> Steven, I presume you'll pick this fix up?  
> > 
> > I'm currently at Embedded/Kernel Recipes, but yeah, I'll take a look at it. (Just need to finish my slides first ;-)  
> 
> Ok, thanks. If I don't hear back I presume you'll pick it up then.

Yeah, I'm way behind due to the conference. And I'll be on PTO from
tomorrow and back on Tuesday. And registration for Linux Plumbers is
supposed to open today (but of course there's issues with that!), thus, I'm
really have too much on my plate today :-p

-- Steve
