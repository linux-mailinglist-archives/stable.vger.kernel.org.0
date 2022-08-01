Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A575872BB
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 23:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiHAVIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 17:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiHAVIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 17:08:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAB2186E2;
        Mon,  1 Aug 2022 14:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A16CB8171E;
        Mon,  1 Aug 2022 21:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD2FC433C1;
        Mon,  1 Aug 2022 21:08:07 +0000 (UTC)
Date:   Mon, 1 Aug 2022 17:08:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [for-next][PATCH 21/21] tracing: Use a struct alignof to
 determine trace event field alignment
Message-ID: <20220801170806.061e1268@gandalf.local.home>
In-Reply-To: <a7d202457150472588df0bd3b7334b3f@AcuMS.aculab.com>
References: <20220731190329.641602282@goodmis.org>
        <20220731190435.611455708@goodmis.org>
        <a7d202457150472588df0bd3b7334b3f@AcuMS.aculab.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Aug 2022 07:46:22 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > Define a macro as:
> > 
> >    ALIGN_STRUCTFIELD(type) ((int)(offsetof(struct {char a; type b;}, b)))
> > 
> > which gives the actual alignment of types in a structure.  
> 
> The simpler:
> 	__alignof__(struct {type b;})
> also works.

I'll have to try that out.

For now, as the previous version made it through all my tests, I may be
pushing it, but change it to this for simplicity if that also works and
passes all my test.

Thanks,

-- Steve
