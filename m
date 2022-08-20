Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5A159AE60
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344987AbiHTNK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 09:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345677AbiHTNK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 09:10:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD016544;
        Sat, 20 Aug 2022 06:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0673B80B3B;
        Sat, 20 Aug 2022 13:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2224C433C1;
        Sat, 20 Aug 2022 13:10:50 +0000 (UTC)
Date:   Sat, 20 Aug 2022 09:11:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/eprobes: Have event probes be consistent
 with kprobes and uprobes
Message-ID: <20220820091104.4dad095b@gandalf.local.home>
In-Reply-To: <20220820220442.776e1ddaf8836e82edb34d01@kernel.org>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.395997394@goodmis.org>
        <20220820220442.776e1ddaf8836e82edb34d01@kernel.org>
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

On Sat, 20 Aug 2022 22:04:42 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> > For "comm", if "comm" is used and the event being attached to does not
> > have the "comm" field, then make it the "$comm" that kprobes has. This is
> > consistent to the way histograms and filters work.  
> 
> Hmm, I think I would better allow user to use $COMM to get comm string
> for kprobe/uprobe event users too. (There are many special variables...)
> Anyway, this looks good to me.
> 
> Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

I could add this on top of the patch series.

-- Steve
