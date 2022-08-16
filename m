Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5915960BB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 19:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiHPRBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 13:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiHPRBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 13:01:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2B67C50E;
        Tue, 16 Aug 2022 10:01:20 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ch17-20020a17090af41100b001fa74771f61so1859185pjb.0;
        Tue, 16 Aug 2022 10:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=DSgs9FXvT0o0PS270q9G9zIUeRmTOeFz5O3WONwu3Mk=;
        b=cVYr3H5SygxO+XmAclLhhXc7RtFloxydR//dRTs4yJGOtAqMVsO899vZ6hxX+VMRaO
         UUpwA56b/35VyN63TGCZwUT01AtbQw7nTWErn/GlAu2E3gVxW6m+Irjki4x4rwPWsrLc
         sOOXKvn33jURA2xT84NFPjPR1dmmxLCiflfjtStrZx3cu/VEmz+s928EWHnUU4fElYYM
         Da65Em2BrchCTE/RLAuR3W0tW5NsLuYOl+N/+nsdXR97aIgRbxRaSeSPkuwt09Xc7uNz
         qSlP8MhplPw8KeWy5WbM8qmfFIpxooVZzuPDVVC9e6WXrwDDspC8l5XBoBlrCm+sXPaV
         fWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=DSgs9FXvT0o0PS270q9G9zIUeRmTOeFz5O3WONwu3Mk=;
        b=mVbkBm7eD1YDsvDZrixGMXm9tkhPsM8RV8HBsNSv3YdpbRSI7zwNQymYgBaHrlTeCn
         /W19uNH2Yn9FtYL6NNDDz+9cxYJqQCdo+dXCQPcMiyUXjCTasENfa5HDBLtZiTfnebvZ
         xd6GsL4EPX5Blkh276OovxTSm6p6tpwjhtmtxUbwgoLvRF4RPWX5Ukz8YRnbOD2gDAOb
         KqDvZ8+ByXsxCi/MxQ7y97NKy5K2eupHgIJYvCV0U5M+vL+SyHdD6tDDlfu49HVu6adq
         YZ0M1Ix7eAu6dhRLAUeWi9KZG9E6YUEW8bLZFA8SRqX+TaY+O7SYJlHUg3DN7Qdw84RT
         ZS8g==
X-Gm-Message-State: ACgBeo178BTpjeF6CCPNEXJ6JfxIod0v8KvKzo26/rZbCj0Yt9V4OGE+
        SslsNYR0dkH4wy5bb9hJKQw=
X-Google-Smtp-Source: AA6agR5cNmTS7DV8fDmfAQnwCliasLqsFugEiciNPzXT4UUDQ0TfkEogwl0eiMTrZNWEkpL/8s/SNg==
X-Received: by 2002:a17:90b:1389:b0:1f3:a782:ab28 with SMTP id hr9-20020a17090b138900b001f3a782ab28mr23804741pjb.181.1660669279541;
        Tue, 16 Aug 2022 10:01:19 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:7229])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902a38600b0017150330889sm9285711pla.189.2022.08.16.10.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 10:01:18 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 16 Aug 2022 07:01:17 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, marcan@marcan.st,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <YvvNXdkrtlmKZRex@slm.duckdns.org>
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
 <20220816134156.GB11202@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816134156.GB11202@willie-the-truck>
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

Hello, Will.

On Tue, Aug 16, 2022 at 02:41:57PM +0100, Will Deacon wrote:
> /**
>  * test_and_set_bit - Set a bit and return its old value
>  * @nr: Bit to set
>  * @addr: Address to count from
>  *
>  * This operation is atomic and cannot be reordered.
>  * It may be reordered on other architectures than x86.
>  * It also implies a memory barrier.
>  */
> 
> so while Peter and I were trying to improve the documentation for
> atomics and memory barriers we clearly ended up making the wrong call
> trying to treat this like e.g. a cmpxchg() (which has the
> unordered-on-failure semantics).

I think the doc can be improved here. atomic_t.txt says under ORDERING:

 - RMW operations that have a return value are fully ordered;

 - RMW operations that are conditional are unordered on FAILURE,
   otherwise the above rules apply.

But nothing spells out what's conditional. Maybe it's okay to expect people
to read this doc and extrapolate how it applies, but I think it'd be better
if we spell out clearly per operaiton so that readers can search for a
speicific operation and then follow what the rules are from there.

It bothers me that there doesn't seem to be a comprehensive
operation-indexed doc on the subject. memory-barrier.txt doesn't cover which
operations do what barriers. atomic_t.txt and atomic_bitops.txt cover the
atomic_t operations but not in a comprehensive or searchable manner (e.g.
does test_and_set_bit() return 0 or 1 on success?) and it's not clear where
to look for non-atomic_t atomic operations. I guess it's implied that they
follow the same rules as atomic_t counterparts but I can't seem to find that
spelled out anywhere. The source code docs are layered and dispersed for
generic and arch implemetnations making them difficult to follow.

It'd be awesome if the documentation situation can be improved.

Thanks.

-- 
tejun
