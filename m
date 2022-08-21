Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC5259B51F
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 17:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiHUPkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 11:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiHUPkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 11:40:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960EE1CB0F;
        Sun, 21 Aug 2022 08:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35E0560EFF;
        Sun, 21 Aug 2022 15:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFB4C433C1;
        Sun, 21 Aug 2022 15:40:38 +0000 (UTC)
Date:   Sun, 21 Aug 2022 11:40:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 5/6] tracing/probes: Have kprobes and uprobes use
 $COMM too
Message-ID: <20220821114053.1ba9fc65@gandalf.local.home>
In-Reply-To: <20220822001902.170ae2e078bba021581279e2@kernel.org>
References: <20220820134316.156058831@goodmis.org>
        <20220820134401.317014913@goodmis.org>
        <20220822001902.170ae2e078bba021581279e2@kernel.org>
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

On Mon, 22 Aug 2022 00:19:02 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> This looks good to me.
> 
> Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks Masami. I was holding off sending these in hoping that you would
give an ack ;-)

> 
> (Note that kprobes/uprobes doesn't need to record cpu/pid, because those
>  are a part of common field and can be accessed from filter or histogram.
>  Only comm must be recorded as string.)

Same for eprobes.

-- Steve
