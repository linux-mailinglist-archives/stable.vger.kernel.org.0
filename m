Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6A054F2DD
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 10:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380986AbiFQI1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 04:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380971AbiFQI05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 04:26:57 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B432A6898A;
        Fri, 17 Jun 2022 01:26:55 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o27JR-0006ah-1K; Fri, 17 Jun 2022 10:26:41 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o27JQ-0004sA-NL; Fri, 17 Jun 2022 10:26:40 +0200
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
 <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net>
 <7619DB57-C39B-4A49-808C-7ACF12D58592@goodmis.org>
 <d28e1548-98fb-a533-4fdc-ae4f4568fb75@iogearbox.net>
 <20220608091017.0596dade@gandalf.local.home>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3d535ae1-69cd-dbae-32f6-7d571a88c2d8@iogearbox.net>
Date:   Fri, 17 Jun 2022 10:26:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220608091017.0596dade@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26574/Thu Jun 16 10:06:40 2022)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/22 3:10 PM, Steven Rostedt wrote:
> On Wed, 8 Jun 2022 14:38:39 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
>>>>> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
>>>>
>>>> Steven, I presume you'll pick this fix up?
>>>
>>> I'm currently at Embedded/Kernel Recipes, but yeah, I'll take a look at it. (Just need to finish my slides first ;-)
>>
>> Ok, thanks. If I don't hear back I presume you'll pick it up then.
> 
> Yeah, I'm way behind due to the conference. And I'll be on PTO from
> tomorrow and back on Tuesday. And registration for Linux Plumbers is
> supposed to open today (but of course there's issues with that!), thus, I'm
> really have too much on my plate today :-p

Steven, we still have this in our patchwork for tracking so it doesn't fall
off the radar. The patch is 3 weeks old by now. Has this been picked up yet,
or do you want to Ack and we ship the fix via bpf tree? Just asking as I
didn't see any further updates ever since.

Thanks,
Daniel
