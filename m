Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B4A60D3A2
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 20:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiJYSe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 14:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiJYSeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 14:34:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF86D18FD
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 11:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666722861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f3ngkylt5FBWl4cdAT7Bl1Z+Wly/kdFZ4oAqXwN3yHQ=;
        b=Qe0i/E9NaqihU6hBfKiJV4NrKVX7bh9S3/sFJU/fYKmo2vh5ve9dUefR9EsIrtfyBgGwLT
        XrvZK+zRcOlk3KyZNjcACpVag8eZV6/2xSDTCYZgQ/qDTvakjEaIjO+9aHLtFvDjtXhG9c
        j/ROB02KHrZCZSAPQyyMvsF30DTwPGk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-8VCuqrwbOduCWGrTT2JCgA-1; Tue, 25 Oct 2022 14:34:20 -0400
X-MC-Unique: 8VCuqrwbOduCWGrTT2JCgA-1
Received: by mail-qt1-f200.google.com with SMTP id cb19-20020a05622a1f9300b0039cc64d84edso9641394qtb.15
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 11:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3ngkylt5FBWl4cdAT7Bl1Z+Wly/kdFZ4oAqXwN3yHQ=;
        b=s7ZcB55HiNjVN83YGODLDU75iUSFBIS4itvqDUTtdJaU+203v7hU13Q1l1CTEuqPBj
         VpyoMTYduMOAcK9QxRJvj5g3ib30DOVB1Lo6e5llsEh4Fn+sbA0D00+/26v1mk5hKZYl
         2n5CSfx2IuG/UIjTYw8KlF54t6YGwXjL/z1Bth9ZKo2KpLt8p1E5+L6urv+n7tIhs1Vm
         gPH51d8W+v2mFPx//3voALrBo0bGnF/f59bwBmIVC6I92smPkcLKljAy+o8JrbU0r2eD
         b26aleaY3HTDfp2xJvzcIZWIy9kiqMz6MfjuxIcLdEitXUmpl+p/6v1X6DjxI/UXb/WI
         ySaw==
X-Gm-Message-State: ACrzQf1C2+24G95nKEmZFe/QZwToxoLalDMDVCYYIEZLPs/CuNXilSKZ
        TgECcz/n1S2AAWYST3oP6GFo3U8ie1NQKBZB7rGUdQ1DPeEYFEiq8QGg9RnBForrQbTkvJai2mC
        1kYJr8N1f+hCsPoVF
X-Received: by 2002:a05:622a:547:b0:39c:bbbf:f78a with SMTP id m7-20020a05622a054700b0039cbbbff78amr32939049qtx.97.1666722860120;
        Tue, 25 Oct 2022 11:34:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5j3RDlpzN8gLaGUoESfHl7ZzuveQzxrapog2PSUrCFSjZOBW/giWOh0jzA6j5VoTDBo2pl4w==
X-Received: by 2002:a05:622a:547:b0:39c:bbbf:f78a with SMTP id m7-20020a05622a054700b0039cbbbff78amr32939034qtx.97.1666722859876;
        Tue, 25 Oct 2022 11:34:19 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bm25-20020a05620a199900b006ed138e89f2sm2409440qkb.123.2022.10.25.11.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 11:34:19 -0700 (PDT)
Date:   Tue, 25 Oct 2022 14:34:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: wake on unregister for minor faults as well
 as missing
Message-ID: <Y1gsKdfXdIzkidpN@x1n>
References: <20221025182149.3076870-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221025182149.3076870-1-axelrasmussen@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 11:21:49AM -0700, Axel Rasmussen wrote:
> This was an overlooked edge case when minor faults were added. In
> general, minor faults have the same rough edge here as missing faults:
> if we unregister while there are waiting threads, they will just remain
> waiting forever, as there is no way for userspace to wake them after
> unregistration. To work around this, userspace needs to carefully wake
> everything before unregistering.
> 
> So, wake for minor faults just like we already do for missing faults as
> part of the unregistration process.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7677f7fd8be7 ("userfaultfd: add minor fault registration mode")
> Reported-by: Lokesh Gidra <lokeshgidra@google.com>
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  fs/userfaultfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 07c81ab3fd4d..7daee4b9481c 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1606,7 +1606,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  			start = vma->vm_start;
>  		vma_end = min(end, vma->vm_end);
>  
> -		if (userfaultfd_missing(vma)) {
> +		if (userfaultfd_missing(vma) || userfaultfd_minor(vma)) {
>  			/*
>  			 * Wake any concurrent pending userfault while
>  			 * we unregister, so they will not hang
> -- 
> 2.38.0.135.g90850a2211-goog

Thanks, Axel.  Is wr-protect mode also prone to this?  Would a test case
help too?

-- 
Peter Xu

