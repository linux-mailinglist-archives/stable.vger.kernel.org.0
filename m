Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DF054FADA
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383129AbiFQQJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 12:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383127AbiFQQJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 12:09:59 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C7835DC9;
        Fri, 17 Jun 2022 09:09:57 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2EXZ-0007dE-0c; Fri, 17 Jun 2022 18:09:45 +0200
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2EXY-000MyH-P3; Fri, 17 Jun 2022 18:09:44 +0200
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
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <26a91f26-8d9c-e5e4-0a2f-4f17746c28b8@iogearbox.net>
Date:   Fri, 17 Jun 2022 18:09:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220617120254.30bb0f15@gandalf.local.home>
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

On 6/17/22 6:02 PM, Steven Rostedt wrote:
> On Fri, 17 Jun 2022 10:26:40 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
>> Steven, we still have this in our patchwork for tracking so it doesn't fall
>> off the radar. The patch is 3 weeks old by now. Has this been picked up yet,
>> or do you want to Ack and we ship the fix via bpf tree? Just asking as I
>> didn't see any further updates ever since.
> 
> Sorry, between traveling for conferences and PTO I fell behind. I'll pull
> this into my urgent queue and start running my tests on it.

Okay, if you pick these fixes up today then I'll toss them from our bpf patchwork.
