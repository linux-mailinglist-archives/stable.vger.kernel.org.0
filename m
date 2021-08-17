Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82823EE9B4
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 11:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhHQJ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 05:29:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35242 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbhHQJ27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 05:28:59 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A601F21E2E;
        Tue, 17 Aug 2021 09:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629192505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uSz0qBmjS9Oie0OcboEtBo514k1ie0fSH0PaWE6RX64=;
        b=wt6P/diQH3RbdGN7pndS+lACfxzsrFjNHKVMSsG49U8U98GCt7ch1VCLWfY6lnnLI2hnc4
        p4rVzvv4H/TMv9jgfrB0nRzaTAewu5mORvJQr+hZI9actPo8iqfpC6F9TyLv2iNSmaeDlx
        kmT6v4gAcF5I/Ltk1IkYSYQMc/5tY+o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629192505;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uSz0qBmjS9Oie0OcboEtBo514k1ie0fSH0PaWE6RX64=;
        b=S3e91dfXKcp/RbRIm7zsTJChVBBTBHg5ZycM9l2AlV+cOz0Af1iiJOl4ltuFKC/41P1TTh
        nl6QUdQ+xQGk+QDw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 86DD7A3B91;
        Tue, 17 Aug 2021 09:28:25 +0000 (UTC)
Date:   Tue, 17 Aug 2021 11:28:25 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tracing: define needed config DYNAMIC_FTRACE_WITH_ARGS
In-Reply-To: <20210806211808.6d927880@oasis.local.home>
Message-ID: <alpine.LSU.2.21.2108171126040.26111@pobox.suse.cz>
References: <20210806195027.16808-1-lukas.bulwahn@gmail.com> <20210806211808.6d927880@oasis.local.home>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I placed it in my queue to go into the 5.14-rc cycle.
> 
> Since this affects live kernel patching, can I get a Tested-by from one
> of the live kernel patching  folks?

I see it got merged, but anyway it looks good to me. Thanks for fixing it.

Miroslav
