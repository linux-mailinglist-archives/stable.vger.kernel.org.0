Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DB963D8B8
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 16:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiK3PCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 10:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiK3PCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 10:02:34 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859132AC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:02:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so2205065pjc.3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bAiUVAVMBHvHdImMNL/5roTtNhp0qUcjyhtLJnn/aqo=;
        b=axzbGQB/DVP2ROYhCiI3Et3IZBHx3Jg45dEq5eNU71GtEUBgHAczDaXP8QH4cPvVlB
         lB0FGjY9mPg90kKm/lRvbykCrWmUYHdAu5DTmDqryzMe3jjoX7aVNFWXrjqgezLmmLVi
         SCEjq1gJ2aMu3qnUWX//wBSNVYwZaJK/8k7EMPgTuySxoSP0I4G4/y5cigFO2OIENcuz
         h/+sIEp6EhnnmiLSkWP6mIvlWjLAxShhStaT/TjL1Qy6uICtyZg/NDwl3buS52tA/M7i
         n1oD33om7v2HbbmDT4OL21Z0DSMp/ZIjgGBpnnVPhq2a6ZGaiCG9IOIpttmop41O9aYA
         sFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAiUVAVMBHvHdImMNL/5roTtNhp0qUcjyhtLJnn/aqo=;
        b=SchuiOOUbOy42kx80gAc56wF/xMCAJijYbL0lVtH0yTZsDKQvw2MST4e8aNsfvGhQ7
         zMcziH4rO4Hz2Vsle5IQL84a46phkLjXPbXGAP1YVnFzykiZqpzxM9VPZgtMqcU+KTrC
         FFsSWcCAwcp8tc5ixkaknd4E82kTAgqeyWM0B8iQ1dPZMgvqz31EPdUS51ceV8PHd9pf
         E3Hu8Mg9fGAMhSi095zcz7xVHdwR48/EHyjTlKRfWekuFSxNkMLhlmKWmRE0Hcrl0V4N
         Lzwr6MOVsH2ZSmsOkE6y5GBDdNJT8vW4m+hPbYlsKuWScoQNC7IOYSuzh5H5WBT9BHBC
         fB4w==
X-Gm-Message-State: ANoB5pmRiOeLKGf6Is43NRjg2qc0K7EnEdnq4/VnsJOQT0dbVArR6aEm
        L7rV2YP31fGKvU82C7Pu2yD2pw==
X-Google-Smtp-Source: AA0mqf7wiy9QTt8vPIkpfVgyb7rxNT7hhm2lw3u7InJKSLS2+BldtKKt+SRNMlCopPFhDdjrUcnVxA==
X-Received: by 2002:a17:902:6804:b0:189:907c:8380 with SMTP id h4-20020a170902680400b00189907c8380mr13310535plk.104.1669820550708;
        Wed, 30 Nov 2022 07:02:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ce8600b001743ba85d39sm1611512plg.110.2022.11.30.07.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:02:30 -0800 (PST)
Date:   Wed, 30 Nov 2022 15:02:26 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH 5.15] binder: validate alloc->mm in ->mmap() handler
Message-ID: <Y4dwgn5JgatoIP1+@google.com>
References: <20221123180922.1502550-1-cmllamas@google.com>
 <Y4dPWkfBkDzCq71A@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4dPWkfBkDzCq71A@kroah.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 01:40:58PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 23, 2022 at 06:09:21PM +0000, Carlos Llamas wrote:
> > commit 3ce00bb7e91cf57d723905371507af57182c37ef upstream.
> > 
> > Since commit 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr
> > dereference") binder caches a pointer to the current->mm during open().
> > This fixes a null-ptr dereference reported by syzkaller. Unfortunately,
> > it also opens the door for a process to update its mm after the open(),
> > (e.g. via execve) making the cached alloc->mm pointer invalid.
> > 
> > Things get worse when the process continues to mmap() a vma. From this
> > point forward, binder will attempt to find this vma using an obsolete
> > alloc->mm reference. Such as in binder_update_page_range(), where the
> > wrong vma is obtained via vma_lookup(), yet binder proceeds to happily
> > insert new pages into it.
> > 
> > To avoid this issue fail the ->mmap() callback if we detect a mismatch
> > between the vma->vm_mm and the original alloc->mm pointer. This prevents
> > alloc->vm_addr from getting set, so that any subsequent vma_lookup()
> > calls fail as expected.
> > 
> > Fixes: 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr dereference")
> > Reported-by: Jann Horn <jannh@google.com>
> > Cc: <stable@vger.kernel.org> # 5.15+
> > Signed-off-by: Carlos Llamas <cmllamas@google.com>
> > Acked-by: Todd Kjos <tkjos@google.com>
> > Link: https://lore.kernel.org/r/20221104231235.348958-1-cmllamas@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [cmllamas: renamed alloc->mm since missing e66b77e50522]
> > Signed-off-by: Carlos Llamas <cmllamas@google.com>
> > ---
> >  drivers/android/binder_alloc.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> 
> This too is already in the 5.15 queue, is this a different version?
> 
> thanks,
> 
> greg k-h

It's the same version, please ignore this one too. Thanks.
