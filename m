Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602E359AE6F
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346799AbiHTNTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 09:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiHTNTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 09:19:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD620656D;
        Sat, 20 Aug 2022 06:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B45CB80B93;
        Sat, 20 Aug 2022 13:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62859C433D7;
        Sat, 20 Aug 2022 13:19:13 +0000 (UTC)
Date:   Sat, 20 Aug 2022 09:19:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing/eprobes: Do not hardcode $comm as a string
Message-ID: <20220820091926.6ecc7250@gandalf.local.home>
In-Reply-To: <20220820220920.e42fa32b70505b1904f0a0ad@kernel.org>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.035925907@goodmis.org>
        <20220820201824.5637c4feff4a7674aebde60a@kernel.org>
        <20220820084837.4d6a95e4@gandalf.local.home>
        <20220820090038.591e3b32@gandalf.local.home>
        <20220820220920.e42fa32b70505b1904f0a0ad@kernel.org>
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

On Sat, 20 Aug 2022 22:09:20 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> > My mistake. It was "common_cpu" not "common_comm". The filter and histogram
> > just use "comm" or "COMM". I'll leave this as it.  
> 
> Yeah, this is a bit confusing me. histogram allows common_cpu but filter allows
> only CPU. Shouldn't we unify those?

I can do that too.

-- Steve
