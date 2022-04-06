Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13ECA4F64AD
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiDFQCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbiDFQAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:00:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66CD34AD2B
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 06:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 637D7B823D8
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 13:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DA6C385A9;
        Wed,  6 Apr 2022 13:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649251885;
        bh=rr+fBOB68jvddMkAX7rGg+8xIjXA6DJIqpfGShGQ1ZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IkQb3QNLCndUT3IfJxLChzNmKDBa4lKlzn88V0/GJBL5uf+y+PE8/AZ+vualTlWWx
         s9hNc0DgcCBPfWDi8Jt3FauqCoo/DmHVcDdD/dW22dY+lZlCIa4Hp0LN75u8Mm3CIx
         C2VNlUxWm3jvaTlelJlvy74cBDPK8HqDduaVlcS4=
Date:   Wed, 6 Apr 2022 15:31:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: stable-rc: 4.19: include/linux/blk-mq.h:309:27: error: invalid
 use of undefined type 'struct request'
Message-ID: <Yk2WKoKVboTZCRO7@kroah.com>
References: <CA+G9fYumiL8RtdJusNZtW2Ut7GJgjA7Q0n87PubBL6eMADRBog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYumiL8RtdJusNZtW2Ut7GJgjA7Q0n87PubBL6eMADRBog@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 03:29:30PM +0530, Naresh Kamboju wrote:
> Linux stable-rc 4.19 branch build breaks on all architecture for
> allnoconfig and tinyconfig.
> 
> arch/x86/entry/entry_64.S: Assembler messages:
> arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic
> suffix given and no register operands; using default for `sysret'
> In file included from include/linux/blk-cgroup.h:24,
>                  from include/linux/backing-dev.h:18,
>                  from include/linux/nfs_fs_sb.h:6,
>                  from include/linux/nfs_fs.h:39,
>                  from init/do_mounts.c:22:
> include/linux/blk-mq.h:145:9: error: unknown type name 'softirq_done_fn'
>   145 |         softirq_done_fn         *complete;
>       |         ^~~~~~~~~~~~~~~
> In file included from arch/x86/include/asm/atomic.h:265,
>                  from include/linux/atomic.h:7,
>                  from include/linux/jump_label.h:185,
>                  from arch/x86/include/asm/string_64.h:6,
>                  from arch/x86/include/asm/string.h:5,
>                  from include/linux/string.h:20,
>                  from include/linux/bitmap.h:9,
>                  from include/linux/cpumask.h:12,
>                  from arch/x86/include/asm/cpumask.h:5,
>                  from arch/x86/include/asm/msr.h:11,
>                  from arch/x86/include/asm/processor.h:21,
>                  from arch/x86/include/asm/cpufeature.h:5,
>                  from arch/x86/include/asm/thread_info.h:53,
>                  from include/linux/thread_info.h:39,
>                  from arch/x86/include/asm/preempt.h:7,
>                  from include/linux/preempt.h:81,
>                  from include/linux/spinlock.h:51,
>                  from include/linux/seqlock.h:36,
>                  from include/linux/time.h:6,
>                  from include/linux/stat.h:19,
>                  from include/linux/module.h:10,
>                  from init/do_mounts.c:1:
> include/linux/blk-mq.h: In function 'blk_mq_mark_complete':
> include/linux/blk-mq.h:309:27: error: invalid use of undefined type
> 'struct request'
>   309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
>       |                           ^~
> include/asm-generic/atomic-instrumented.h:420:16: note: in definition
> of macro 'cmpxchg'
>   420 |         typeof(ptr) __ai_ptr = (ptr);
>          \
>       |                ^~~
> include/linux/blk-mq.h:309:27: error: invalid use of undefined type
> 'struct request'
>   309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
>       |                           ^~
> include/asm-generic/atomic-instrumented.h:420:33: note: in definition
> of macro 'cmpxchg'
>   420 |         typeof(ptr) __ai_ptr = (ptr);
>          \
>       |                                 ^~~
> include/asm-generic/atomic-instrumented.h:421:44: error: invalid type
> argument of unary '*' (have 'int')
>   421 |         kasan_check_write(__ai_ptr, sizeof(*__ai_ptr));
>          \
>       |                                            ^~~~~~~~~
> include/linux/blk-mq.h:309:16: note: in expansion of macro 'cmpxchg'
>   309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
>       |                ^~~~~~~
> include/asm-generic/atomic-instrumented.h:421:27: warning: passing
> argument 1 of 'kasan_check_write' makes pointer from integer without a
> cast [-Wint-conversion]
>   421 |         kasan_check_write(__ai_ptr, sizeof(*__ai_ptr));
>          \
>       |                           ^~~~~~~~
>       |                           |
>       |                           int
> include/linux/blk-mq.h:309:16: note: in expansion of macro 'cmpxchg'
>   309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
>       |                ^~~~~~~
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for the report, should now be fixed up.

greg k-h
