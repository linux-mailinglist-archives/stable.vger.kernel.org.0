Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C807197FDC
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 17:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgC3Pjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 11:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgC3Pjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 11:39:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F752072E;
        Mon, 30 Mar 2020 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585582789;
        bh=RXukKmZZo9MdjZF0bSbjfbAdbc0UUu3OTOX6WT5sf8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G+eY5ca8tNzgYuLq8Bj2+elfTY/pLUcU1Jvf4FVtWcZV/ex6q6ujW3F8K8dEbgmT0
         KRlOU0guEYOZjZBgzvDGl8D4A4QN2MGbMdogiyJO55j7SG9dRTm8GaIPgBh+OcmB2e
         TYi1Im3NNM2S+T7VWfjg5K8kV0vdLcoQNHTkNg1k=
Date:   Mon, 30 Mar 2020 11:39:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mhiramat@kernel.org, acme@redhat.com, akpm@linux-foundation.org,
        bp@alien8.de, geert@linux-m68k.org, jolsa@redhat.com,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tools: Let O= makes handle a relative
 path with -C option" failed to apply to 4.9-stable tree
Message-ID: <20200330153947.GG4189@sasha-vm>
References: <1585570296177156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1585570296177156@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 02:11:36PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From be40920fbf1003c38ccdc02b571e01a75d890c82 Mon Sep 17 00:00:00 2001
>From: Masami Hiramatsu <mhiramat@kernel.org>
>Date: Sat, 7 Mar 2020 03:32:58 +0900
>Subject: [PATCH] tools: Let O= makes handle a relative path with -C option
>
>When I tried to compile tools/perf from the top directory with the -C
>option, the O= option didn't work correctly if I passed a relative path:
>
>  $ make O=BUILD -C tools/perf/
>  make: Entering directory '/home/mhiramat/ksrc/linux/tools/perf'
>    BUILD:   Doing 'make -j8' parallel build
>  ../scripts/Makefile.include:4: *** O=/home/mhiramat/ksrc/linux/tools/perf/BUILD does not exist.  Stop.
>  make: *** [Makefile:70: all] Error 2
>  make: Leaving directory '/home/mhiramat/ksrc/linux/tools/perf'
>
>The O= directory existence check failed because the check script ran in
>the build target directory instead of the directory where I ran the make
>command.
>
>To fix that, once change directory to $(PWD) and check O= directory,
>since the PWD is set to where the make command runs.
>
>Fixes: c883122acc0d ("perf tools: Let O= makes handle relative paths")
>Reported-by: Randy Dunlap <rdunlap@infradead.org>
>Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Borislav Petkov <bp@alien8.de>
>Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>Cc: Jiri Olsa <jolsa@redhat.com>
>Cc: Masahiro Yamada <masahiroy@kernel.org>
>Cc: Michal Marek <michal.lkml@markovi.net>
>Cc: Peter Zijlstra <peterz@infradead.org>
>Cc: Sasha Levin <sashal@kernel.org>
>Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
>Cc: stable@vger.kernel.org
>Link: http://lore.kernel.org/lkml/158351957799.3363.15269768530697526765.stgit@devnote2
>Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Context conflicts with license changes... Fixed and queued up.

-- 
Thanks,
Sasha
