Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F3854FE0B
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 22:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbiFQT7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 15:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiFQT7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 15:59:17 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0B259B92;
        Fri, 17 Jun 2022 12:59:16 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2I7W-000Caq-Jx; Fri, 17 Jun 2022 21:59:06 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2I7W-0002t7-Bo; Fri, 17 Jun 2022 21:59:06 +0200
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
 <3d535ae1-69cd-dbae-32f6-7d571a88c2d8@iogearbox.net>
 <20220617120254.30bb0f15@gandalf.local.home>
 <26a91f26-8d9c-e5e4-0a2f-4f17746c28b8@iogearbox.net>
 <20220617134815.5e1a97de@gandalf.local.home>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cdf7e29f-306b-92af-4e12-0d440156ee5c@iogearbox.net>
Date:   Fri, 17 Jun 2022 21:59:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220617134815.5e1a97de@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26575/Fri Jun 17 10:08:05 2022)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/17/22 7:48 PM, Steven Rostedt wrote:
> On Fri, 17 Jun 2022 18:09:44 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
>>> Sorry, between traveling for conferences and PTO I fell behind. I'll pull
>>> this into my urgent queue and start running my tests on it.
>>
>> Okay, if you pick these fixes up today then I'll toss them from our bpf patchwork.
> 
> This patch I'll take, but please keep the fprobe/rethook one, as that's
> specific to your tree.

Ok, sounds good to me. I just applied them with the comment suggestion added.
