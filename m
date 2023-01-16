Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA2A66B6F5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 06:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjAPFqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 00:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjAPFqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 00:46:36 -0500
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1FD868D;
        Sun, 15 Jan 2023 21:46:35 -0800 (PST)
Received: by mail-wr1-f54.google.com with SMTP id t5so21949115wrq.1;
        Sun, 15 Jan 2023 21:46:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ij+Fr1khqSzHk9heKO9nWr6VaTDuNgkAMouf15x4tOs=;
        b=WYUyuVwRvVVj6qy7ZQnHhY0CHOKCUu/vXHyDWJADCnGbOAOT+MCvVrcCfcuNjKEDfc
         DFPaFoSn/t+/XUFovDldH93I0dBMgLtXv7vZW0MLu0YBOcNgoQuOc+K+CNedjoFmrqhL
         HUY+5hMRfrjnHyuEraY2vjDmKhRS3SunqyjqbzjXtBOHCvnbZIPAxq1PAzpFH5V7B+7D
         HtIE+7FZxIpB/J42chLaLBqILHawdqtZfl7H/vj/xmRxECzAm67V5CA3GED5CrWrncEf
         lyyGUr6ZGkSjGzv4M+tDZBO3YPs1dzghW0c+AFmID4C75oTHuW7Rv2oc93fEnAgUMfI3
         E5JA==
X-Gm-Message-State: AFqh2kp6bNY6+p4/PpSfbUyAuJeFnamKCowLEy7aDDO7KUlxBuoDuZ0n
        IpQ+iizt5N+H3rWC1UvvQwOYonSTAAo=
X-Google-Smtp-Source: AMrXdXtiv0rVXISQvtDiWF1IwLUvKhJ/TdveM3E9DZjGRY4vk+Yd/yR7gZS4PgUl44ZBjq3TQwFu4w==
X-Received: by 2002:a05:6000:408c:b0:2bd:fcd8:c778 with SMTP id da12-20020a056000408c00b002bdfcd8c778mr3879153wrb.31.1673847993845;
        Sun, 15 Jan 2023 21:46:33 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id u14-20020adfdd4e000000b002366e3f1497sm25605422wrm.6.2023.01.15.21.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 21:46:33 -0800 (PST)
Message-ID: <e518370c-2926-e8ec-d25c-93b2b2304602@kernel.org>
Date:   Mon, 16 Jan 2023 06:46:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: +
 revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        stable@vger.kernel.org, regressions@leemhuis.info,
        pbonzini@redhat.com, mlevitsk@redhat.com, mhocko@kernel.org,
        mgorman@techsingularity.net, vbabka@suse.cz
References: <20230114041117.B372AC43392@smtp.kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230114041117.B372AC43392@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14. 01. 23, 5:11, Andrew Morton wrote:
> The patch titled
>       Subject: Revert "mm/compaction: fix set skip in fast_find_migrateblock"
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: Revert "mm/compaction: fix set skip in fast_find_migrateblock"
> Date: Fri, 13 Jan 2023 18:33:45 +0100
> 
> This reverts commit 7efc3b7261030da79001c00d92bc3392fd6c664c.
> 
> We have got openSUSE reports (Link 1) for 6.1 kernel with khugepaged
> stalling CPU for long periods of time.  Investigation of tracepoint data
> shows that compaction is stuck in repeating fast_find_migrateblock() based
> migrate page isolation, and then fails to migrate all isolated pages.
> Commit 7efc3b726103 ("mm/compaction: fix set skip in
> fast_find_migrateblock") was suspected as it was merged in 6.1 and in
> theory can indeed remove a termination condition for
> fast_find_migrateblock() under certain conditions, as it removes a place
> that always marks a scanned pageblock from being re-scanned.  There are
> other such places, but those can be skipped under certain conditions,
> which seems to match the tracepoint data.
> 
> Testing of revert also appears to have resolved the issue, thus revert the
> commit until a more robust solution for the original problem is developed.




> It's also likely this will fix qemu stalls with 6.1 kernel reported in
> Link 2, but that is not yet confirmed.

Preliminary tests suggest this is also fixed:
Tested-by: Jiri Slaby <jirislaby@kernel.org>

> Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
> Link: https://lore.kernel.org/kvm/b8017e09-f336-3035-8344-c549086c2340@kernel.org/
> Link: https://lkml.kernel.org/r/20230113173345.9692-1-vbabka@suse.cz
> Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
> Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
> Cc: Jiri Slaby <jirislaby@kernel.org>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
> 
> --- a/mm/compaction.c~revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock
> +++ a/mm/compaction.c
> @@ -1839,6 +1839,7 @@ static unsigned long fast_find_migratebl
>   					pfn = cc->zone->zone_start_pfn;
>   				cc->fast_search_fail = 0;
>   				found_block = true;
> +				set_pageblock_skip(freepage);
>   				break;
>   			}
>   		}
> _
> 
> Patches currently in -mm which might be from vbabka@suse.cz are
> 
> revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch
> 

thanks,
-- 
js
suse labs

