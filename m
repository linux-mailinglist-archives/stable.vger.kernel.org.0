Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21D4DA5D3
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 23:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244735AbiCOW7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 18:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237649AbiCOW7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 18:59:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1551C4BFFF;
        Tue, 15 Mar 2022 15:58:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso3200801pjb.0;
        Tue, 15 Mar 2022 15:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tpBIy3wDvQGfwH9ls4xR2jLiqxVzU1kgqh+8V0SkolM=;
        b=qhVli5fhBKxbJaOS2y1VJDUNLLAHqtWf2jL00Tb9InM7nKWn4akLb4Dppd9KqCQKqi
         29cdJh6WElt9yN+hN0MGEAy86fyKb97KzWJeXa5y5Py0+U53ADdqfSOIUXPz/3KD0aCx
         LYg309WkcuTmxoUEewGSXr5AmEYfaMpG17srZRwbk1T6+BZTFGLsmTPDE4D11BJMD5lF
         7qtxuk/B1mwpl/dYL30r5UXrw4xtVlhwUSI9lz/0KcxWl9SWxD02iBLzrQqIOYNa3U0a
         8tzs9T/kBvbHrxh92yWpOTQmjEta9rsFny/9HualjYsEDQlNDdMilYFxEO84SAEQjnO9
         OffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tpBIy3wDvQGfwH9ls4xR2jLiqxVzU1kgqh+8V0SkolM=;
        b=iU611Tun+AOcpaD5GdclD5ZLwIN0f5/F6MBOWHY1RuWvEj9C2tXNBZNQ+CpmqyZmHN
         sjve7JwPVQGbhstK64zp6TVe9Y8uMYtsvyg45RVmBuKENKWyThY+l7owRW7EZUqn7j2C
         VFDm/MbxJcabwTLd/y76a4Xxfkf6y8Wkanti4v3ohbqzCGTMhup/Rx+4ZupAPuchM6Zd
         TizuigVxg8/AD2/yGUW1qBYh/32/GZdtE5u5h/0x7XEp3dW9yAEPJVRXuaco5YHDj40n
         jo3eRCQ5dGr8NgAeSQJEq3YDygumrx26WUWBtoYYiisdeDV++LBsGYrGwBBZlfL6GhGJ
         jyIQ==
X-Gm-Message-State: AOAM532BSuLxttdDiVJX3/1DpCtMrI80mKsnuMOlbQ4jZmf7J9bwMdg1
        qQhjiJo6HDIf2Q9bnqTxbkA=
X-Google-Smtp-Source: ABdhPJzvr4L3c32sdszzPbBKgCVWu3n+sX8w08P6WyBLH8X2gU41vVQJ2efLIV0AJFg2T4fNGpVv0A==
X-Received: by 2002:a17:90b:4c41:b0:1be:f5d3:78eb with SMTP id np1-20020a17090b4c4100b001bef5d378ebmr7001311pjb.187.1647385111454;
        Tue, 15 Mar 2022 15:58:31 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:7484:dc22:fe49:91cb])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm139387pfc.182.2022.03.15.15.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:58:30 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Tue, 15 Mar 2022 15:58:28 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     akpm@linux-foundation.org, surenb@google.com, vbabka@suse.cz,
        rientjes@google.com, sfr@canb.auug.org.au, edgararriaga@google.com,
        nadav.amit@gmail.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <YjEaFBWterxc3Nzf@google.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 08:59:06PM +0530, Charan Teja Kalla wrote:
> The process_madvise() system call is expected to skip holes in vma
> passed through 'struct iovec' vector list. But do_madvise, which
> process_madvise() calls for each vma, returns ENOMEM in case of unmapped
> holes, despite the VMA is processed.
> Thus process_madvise() should treat ENOMEM as expected and consider the
> VMA passed to as processed and continue processing other vma's in the
> vector list. Returning -ENOMEM to user, despite the VMA is processed,
> will be unable to figure out where to start the next madvise.
> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
> Cc: <stable@vger.kernel.org> # 5.10+

Hmm, not sure whether it's stable material since it changes semantic of
API. It would be better to change the semantic from 5.19 with man page
update to specify the change.


> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> ---
> Changes in V2:
>   -- Fixed handling of ENOMEM by process_madvise().
>   -- Patch doesn't exist in V1.
> 
>  mm/madvise.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index e97e6a9..14fb76d 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1426,9 +1426,16 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>  
>  	while (iov_iter_count(&iter)) {
>  		iovec = iov_iter_iovec(&iter);
> +		/*
> +		 * do_madvise returns ENOMEM if unmapped holes are present
> +		 * in the passed VMA. process_madvise() is expected to skip
> +		 * unmapped holes passed to it in the 'struct iovec' list
> +		 * and not fail because of them. Thus treat -ENOMEM return
> +		 * from do_madvise as valid and continue processing.
> +		 */
>  		ret = do_madvise(mm, (unsigned long)iovec.iov_base,
>  					iovec.iov_len, behavior);
> -		if (ret < 0)
> +		if (ret < 0 && ret != -ENOMEM)
>  			break;
>  		iov_iter_advance(&iter, iovec.iov_len);
>  	}
> -- 
> 2.7.4
> 
