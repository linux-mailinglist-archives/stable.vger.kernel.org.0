Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E936C27CC
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 03:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCUCGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 22:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCUCGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 22:06:39 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5416311E3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:06:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h8so14518772plf.10
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679364397;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9RCARuzcC+kq2t0rbFk8spXGJsCL8Dzdll9EAJiUgDk=;
        b=BaZqCOEep4bJYQKMP1fnq48BdpDt7MufTif/KshPMkeTrbYvBlx3h4F7f9QKkP0cfd
         ogXc0vDhwt+0ispMn4J2vIf2uN6L/dSyH11usJ8yVOWzF/PvbgMScVCafOKnMKoWSSBo
         EvDPvuCjc2EFgD3nn4C9kXRgaxtv/S0VqM5E/fS0CoM+nIqKH9KDjeQ7kwbhQuwt0jmx
         Ip4Z8xSNGg71rmblxzTZTPfeL+7u95xBkU1BsptzrA1BOATB2Dr0yMbl9u9DnkIo2GDI
         AX+pmcg2UxRpCZoRzY9X+cvIvBTKg7hm0fvoQRCbkViU2EG9y1Xn26lx/LlMmCvCRkbN
         MUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679364397;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9RCARuzcC+kq2t0rbFk8spXGJsCL8Dzdll9EAJiUgDk=;
        b=Oz2eKNW/aM28voRmx33Q6HObL1kHOo+Gxy7KgG+453lVVQNR/OPzyQ+j98x96JeG/F
         vezYolR8GeWFHiY2zG+GonbMeDgvoWmjbI7wULW/dqBAeq27m3DaQC19gaL99VB2cDwe
         dWciHUeH+LK0CGnGj9DOvdEGC8dudC455Zj3ZVIc4BzYtb4u/PQfMo5KQbtZjZ+cKRYH
         XbGYoPWsTNd7JZ383a8HzQImVtYtWgcesF91op/ODlmuK2tFdgt/iut0slYD9VBBGaq0
         m6CsX7wwi5fmH2Rr62158FyH87JPzUtkA2YnDOw3uQfN8W0mx+tgQ+0BmHB6xlLzDbSt
         Q1Uw==
X-Gm-Message-State: AO0yUKWAv6nzgfS1rhv9pn0408wMwzXpis5c+PoWJWAYE348xrmBfzQD
        QKy1h8d84PFZQPAPKz7oUic=
X-Google-Smtp-Source: AK7set/E2fIgBBV0BWEhQriFnseD1pJJrKzDQuKEuUyWbfc9iYhf6TcwHuN1xHG2zSQ7pVoOy741iQ==
X-Received: by 2002:a05:6a20:66b0:b0:da:267a:d740 with SMTP id o48-20020a056a2066b000b000da267ad740mr647019pzh.14.1679364397250;
        Mon, 20 Mar 2023 19:06:37 -0700 (PDT)
Received: from [30.221.130.251] ([47.246.101.59])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79185000000b0062612b97cfdsm6933377pfa.123.2023.03.20.19.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 19:06:36 -0700 (PDT)
Message-ID: <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com>
Date:   Tue, 21 Mar 2023 10:06:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [Ocfs2-devel] FAILED: patch "[PATCH] ocfs2: fix data corruption
 after failed write" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, ocfs2-devel@oss.oracle.com,
        akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
        stable@vger.kernel.org
References: <1679313445246112@kroah.com>
From:   Joseph Qi <jiangqi903@gmail.com>
In-Reply-To: <1679313445246112@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
It can be cleanly applied for linux-5.10.y and linux-4.19.y in my desktop.
I'm not sure how it happens.

Thanks,
Joseph

On 3/20/23 7:57 PM, gregkh--- via Ocfs2-devel wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
> git checkout FETCH_HEAD
> git cherry-pick -x 90410bcf873cf05f54a32183afff0161f44f9715
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679313445246112@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..
> 
> Possible dependencies:
> 
> 90410bcf873c ("ocfs2: fix data corruption after failed write")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 90410bcf873cf05f54a32183afff0161f44f9715 Mon Sep 17 00:00:00 2001
> From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
> Date: Thu, 2 Mar 2023 16:38:43 +0100
> Subject: [PATCH] ocfs2: fix data corruption after failed write
> 
> When buffered write fails to copy data into underlying page cache page,
> ocfs2_write_end_nolock() just zeroes out and dirties the page.  This can
> leave dirty page beyond EOF and if page writeback tries to write this page
> before write succeeds and expands i_size, page gets into inconsistent
> state where page dirty bit is clear but buffer dirty bits stay set
> resulting in page data never getting written and so data copied to the
> page is lost.  Fix the problem by invalidating page beyond EOF after
> failed write.
> 
> Link: https://lkml.kernel.org/r/20230302153843.18499-1-jack@suse.cz
> Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 1d65f6ef00ca..0394505fdce3 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1977,11 +1977,26 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  	}
>  
>  	if (unlikely(copied < len) && wc->w_target_page) {
> +		loff_t new_isize;
> +
>  		if (!PageUptodate(wc->w_target_page))
>  			copied = 0;
>  
> -		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
> -				       start+len);
> +		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
> +		if (new_isize > page_offset(wc->w_target_page))
> +			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
> +					       start+len);
> +		else {
> +			/*
> +			 * When page is fully beyond new isize (data copy
> +			 * failed), do not bother zeroing the page. Invalidate
> +			 * it instead so that writeback does not get confused
> +			 * put page & buffer dirty bits into inconsistent
> +			 * state.
> +			 */
> +			block_invalidate_folio(page_folio(wc->w_target_page),
> +						0, PAGE_SIZE);
> +		}
>  	}
>  	if (wc->w_target_page)
>  		flush_dcache_page(wc->w_target_page);
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
