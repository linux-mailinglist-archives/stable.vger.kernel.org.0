Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB215A5608
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 23:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiH2VUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 17:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiH2VUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 17:20:48 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC8053D07
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 14:20:47 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id jm11so9177373plb.13
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 14:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=vKVUa93sxM19Uy1dmsGVMayUSmR5dADcgyx6lBR87O4=;
        b=o0LkaGgz5n3SnWPqJiKQhayAyC2kHhqiXcctuKpfeMBE9PThPrnVXe2lpwAFT8TKyg
         BzSb9YYI8InyJTmV1CYben0Mwmlj9AcfTK5cUzkmGAoniCmH91JR2rtM72o7MaWGx906
         xn/NkMKz7eT9KTbLEHiZKfjT8XkTE9GPNVwPDAOH8a0tfbS4mAw4UqQdUjHwaIVV/jK2
         rjyBY/HSX2TI997mjbQD5IwZbWRcqXmU3auEN+qyI+SDyMrin8OlK8mmMN79krEarJn0
         n0+YwmrL/Kn6rCPXuG/osXvQ8/zsMUqLM1q1Q/dJ8Uwwvt+m9O/yYeF1Ji2VoXcW0OKS
         a0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=vKVUa93sxM19Uy1dmsGVMayUSmR5dADcgyx6lBR87O4=;
        b=NbJp9OVdbeXuRyHG0M/d5toUOBcKK3hfFCTqo8aIz1T8Y4wrwKIF1N4VGIFg7HMvvB
         yXQle4o1rVJ5cVK8UwbnaKcP/292jW97bm4Efct5UChXalHnLqL767+Iyn1Wsqa5S4Yf
         qWhnEd0bBpHtth/v9LbHq3xfIa9M0hrNwC5yqp4RQGNuBqlWI3y5t0uof8ma5BJ6QHYP
         HYNYg4ff+p6Ws/SxudvnR79c609Bqe8ba9nPzQjFfnjfVv0/SoPzt2ahgeeMvjrZlr56
         Dh8bBQCEWJSZwmeHEuw7Qh6S2HiskIyJp58b2Jpm5oWkd4UH6GQs4pT3zT/EfA7AmHYC
         EyLg==
X-Gm-Message-State: ACgBeo2+wYR3uJP/MXkuEnXRQDxT6p2t5D3bYejr2+ude3yk449XGuG2
        WgcVu5HTvZ4yu5eGkzaKvMOVWg==
X-Google-Smtp-Source: AA6agR4lDhKCnCY7kbEGog1W8meT77I95HpBbeYp1dmJtakPrSgvGnCq/4YUm5o4yKdEV/lI6SSNZA==
X-Received: by 2002:a17:90b:1d0b:b0:1f5:72f:652c with SMTP id on11-20020a17090b1d0b00b001f5072f652cmr20176010pjb.38.1661808047093;
        Mon, 29 Aug 2022 14:20:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b0016d6963cb12sm8044038plh.304.2022.08.29.14.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 14:20:45 -0700 (PDT)
Date:   Mon, 29 Aug 2022 21:20:42 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        kernel-team@android.com,
        syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com,
        syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] binder: fix alloc->vma_vm_mm null-ptr dereference
Message-ID: <Yw0tqreGRPOwyAaX@google.com>
References: <20220829201254.1814484-1-cmllamas@google.com>
 <20220829201254.1814484-2-cmllamas@google.com>
 <20220829133452.cd4d9abe858c940126557c41@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829133452.cd4d9abe858c940126557c41@linux-foundation.org>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 01:34:52PM -0700, Andrew Morton wrote:
> On Mon, 29 Aug 2022 20:12:48 +0000 Carlos Llamas <cmllamas@google.com> wrote:
> 
> > Syzbot reported a couple issues introduced by commit 44e602b4e52f
> > ("binder_alloc: add missing mmap_lock calls when using the VMA"), in
> > which we attempt to acquire the mmap_lock when alloc->vma_vm_mm has not
> > been initialized yet.
> > 
> > This can happen if a binder_proc receives a transaction without having
> > previously called mmap() to setup the binder_proc->alloc space in [1].
> > Also, a similar issue occurs via binder_alloc_print_pages() when we try
> > to dump the debugfs binder stats file in [2].
> 
> Thanks.  I assume you'll be merging all these into mainline?

Yes, I believe Greg will pick up these patches into his char-misc tree.

> 
> > 
> > Fixes: 44e602b4e52f ("binder_alloc: add missing mmap_lock calls when using the VMA")
> > Reported-by: syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com
> > Reported-by: syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com
> > Cc: <stable@vger.kernel.org> # v5.15+
> 
> 44e602b4e52f is only present in 6.0-rcX?

Right, it was just added to the stable queue earlier today:
https://lore.kernel.org/all/20220829105814.857786586@linuxfoundation.org/
https://lore.kernel.org/all/20220829105809.855177179@linuxfoundation.org/
