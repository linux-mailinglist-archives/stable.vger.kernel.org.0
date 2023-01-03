Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC08A65BD53
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 10:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbjACJlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 04:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbjACJlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 04:41:44 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4162D2;
        Tue,  3 Jan 2023 01:41:43 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 176253824A;
        Tue,  3 Jan 2023 09:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672738902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=INe1fRfDJG3P7PcSGiSjhLagJ0XMpmhGUZjZv1725PQ=;
        b=DyhqLbWcmkJ8E4l+8lrj+YTGgJHJxZ+gwmkvvc7cJqIc481jWHw6QFzlER7icrSxINhysN
        WGF+kmr/GGDDMCBofEIbnTIdii8KNbAN4EgH39qeb22mI1Px3/Gl5FqQbvrYLdt9/NENk0
        gxkaPnS1zbKplJ3LZMFimW73X75tWM0=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9DA752C141;
        Tue,  3 Jan 2023 09:41:41 +0000 (UTC)
Date:   Tue, 3 Jan 2023 10:41:39 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
        linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] docs: gdbmacros: print newest record
Message-ID: <Y7P4UwjRQG8Tov1D@alley>
References: <20221229134339.197627-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229134339.197627-1-john.ogness@linutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 2022-12-29 14:49:39, John Ogness wrote:
> @head_id points to the newest record, but the printing loop
> exits when it increments to this value (before printing).
> 
> Exit the printing loop after the newest record has been printed.
> 
> The python-based function in scripts/gdb/linux/dmesg.py already
> does this correctly.
> 
> Fixes: e60768311af8 ("scripts/gdb: update for lockless printk ringbuffer")
> Cc: stable@vger.kernel.org
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Great catch!

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
