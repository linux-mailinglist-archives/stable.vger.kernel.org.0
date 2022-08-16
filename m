Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FA7595E9D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiHPOzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiHPOzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:55:24 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBCC7C53F;
        Tue, 16 Aug 2022 07:55:23 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id a15so7853517qko.4;
        Tue, 16 Aug 2022 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc;
        bh=gxYOKsxsXJmki/+vEtBZZUCSGEmDNVwMzZme1Kv5JPQ=;
        b=oHv0nRrH4OjbqSf0YZva9bZJkRPFQDIgV3sV3qqWubKONpzsoWtahzVo/9loZqkH5/
         Z/5fiVS1teCxU50jfill4DcU7u133kjv18PIzQXF/OgByGysoyjj5JV3Oeasm1+/Ui74
         wks5SP13eqkIc7k6FXKljPalwIbB3Dla03Zq6d+roL4LGPd+an070rs64HRIlJNyL3oP
         JO7XPbmXrPSpXqwonWtdNrq78DtSgb4NltZHHB2nCUh9HPLRbNZuun+l66lW3X4iylqS
         BxPYjFB4wjSZdX6vZe824jBUOsLWMEV98sbYdUtWgJ6S0AY1HixmMD4jaNL9H7tHFhQv
         xETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc;
        bh=gxYOKsxsXJmki/+vEtBZZUCSGEmDNVwMzZme1Kv5JPQ=;
        b=qlZp5P4VSjv3RoquRrE6oDiP6oIVAzFesKUtWwx/ovfU8dwl/Lco6GkqtBm4l2zVxA
         ulZTfoBUK/zd3TA1tyR0OxZlwOv9LSBT9w/S+HPc6yWPnQcIcNtvTGpz1lXpxD97U6NC
         9wYJMz3DAsQYbCAG7oSsHqdgsCyDtyqh6R0OA8uVkUjFLlIXXSLEwmqITlUOsOIiYKtp
         M5NMYmG4WsypJvi+geN4xz9elcN+bYDzyThCVdFgiebJr1hfBLxHpFkdvsU9XecnngM9
         yVxB/R4gK9Bpt7PSnCQ0QI6shq/GzJIDCMNX2FTSg7RdG/uNG+qXnHUESkd1NjbIiULb
         RdZA==
X-Gm-Message-State: ACgBeo1LH82hZN60J1Yik0BLQEgrjF/iJf9eFTZ2YTFYZs3Ize/aSAgI
        Kyc5+AKbo+J48fSAOarS3TU=
X-Google-Smtp-Source: AA6agR6SS3ghBjBBwO40ZhKFxXAbIo+dsAek2ZtGeMKH9avpifJeI+f9OW7aV4IZ4n16oDBr4pa6kA==
X-Received: by 2002:a05:620a:b02:b0:6bb:ebe:248b with SMTP id t2-20020a05620a0b0200b006bb0ebe248bmr8942546qkg.420.1660661722224;
        Tue, 16 Aug 2022 07:55:22 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id bp34-20020a05620a45a200b006b929a56a2bsm12263901qkb.3.2022.08.16.07.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:55:21 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id A645527C0054;
        Tue, 16 Aug 2022 10:55:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 16 Aug 2022 10:55:20 -0400
X-ME-Sender: <xms:1q_7Ykw_un8ErZ9OcmtFqBK6S-yVdCrqel1NFkHplljtHIbO1L3T2g>
    <xme:1q_7YoRXMUGTWz2lO1BU9mdA0CbrCzeUcynBAx1xQdUT80S0VR-Q-KPAw3n7c1t6Q
    GHFYu8hvBREhFsWPA>
X-ME-Received: <xmr:1q_7YmUzszP4tgsPpl7T5v3qfFkYfP0E4KY0EWzGJIE_DYDI_55OiNNXYJy_vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehgedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeeitdefvefhteeklefgtefhgeelkeefffelvdevhfehueektdevhfettddv
    teevvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:1q_7YigMeT_ve0D0IKAAoyvoy5Uhz-7pO_Y_CVnry5IcWcrxvFRHyw>
    <xmx:1q_7YmDhmegVtcFk-vPLUeMIhame9ohGPvDSariVCF1ZIsoehL47-g>
    <xmx:1q_7YjLSZ8-nfMbrpBjJBkAfuOeMR6XnExdWbpg2E5GNhzD3GYRp7g>
    <xmx:2K_7YsRu9Fzww-RFsZ935JK6fx8fJ6VHusVxJvBUi8wq3_v_o53XXw>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Aug 2022 10:55:17 -0400 (EDT)
Date:   Tue, 16 Aug 2022 07:55:02 -0700
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Will Deacon <will@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tejun Heo <tj@kernel.org>, marcan@marcan.st,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <YvuvxnfHIRUAuCrD@boqun-archlinux>
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
 <20220816134156.GB11202@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816134156.GB11202@willie-the-truck>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:41:57PM +0100, Will Deacon wrote:
> On Mon, Aug 15, 2022 at 10:27:10PM -0700, Linus Torvalds wrote:
> > On Mon, Aug 15, 2022 at 9:15 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > Please revert this as test_and_set_bit was always supposed to be
> > > a full memory barrier.  This is an arch bug.
> > 
> > Yes, the bitops are kind of strange for various legacy reasons:
> > 
> >  - set/clear_bit is atomic, but without a memory barrier, and need a
> > "smp_mb__before_atomic()" or similar for barriers
> > 
> >  - test_and_set/clear_bit() are atomic, _and_ are memory barriers
> > 
> >  - test_and_set_bit_lock and test_and_clear_bit_unlock are atomic and
> > _weaker_ than full memory barriers, but sufficient for locking (ie
> > acquire/release)
> > 
> > Does any of this make any sense at all? No. But those are the
> > documented semantics exactly because people were worried about
> > test_and_set_bit being used for locking, since on x86 all the atomics
> > are also memory barriers.
> > 
> > From looking at it, the asm-generic implementation is a bit
> > questionable, though. In particular, it does
> > 
> >         if (READ_ONCE(*p) & mask)
> >                 return 1;
> > 
> > so it's *entirely* unordered for the "bit was already set" case.
> > 
> > That looks very wrong to me, since it basically means that the
> > test_and_set_bit() can return "bit was already set" based on an old
> > value - not a memory barrier at all.
> > 
> > So if you use "test_and_set_bit()" as some kind of "I've done my work,
> > now I am going to set the bit to tell people to pick it up", then that
> > early "bit was already set" code completely breaks it.
> > 
> > Now, arguably our atomic bitop semantics are very very odd, and it
> > might be time to revisit them. But that code looks very very buggy to
> > me.
> > 
> > The bug seems to go back to commit e986a0d6cb36 ("locking/atomics,
> > asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs"), and the
> > fix looks to be as simple as just removing that early READ_ONCE return
> > case (test_and_clear has the same bug).
> > 
> > Will?
> 
> Right, this looks like it's all my fault, so sorry about that.
> 
> In an effort to replace the spinlock-based atomic bitops with a version
> based on atomic instructions in e986a0d6cb36, I inadvertently added this
> READ_ONCE() shortcut to test_and_set_bit() because at the time that's
> what we had (incorrectly) documented in our attempts at cleaning things
> up in this area. I confess that I have never been comfortable with the
> comment for test_and_set_bit() prior to my problematic patch:
> 
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
> 
> It's worth noting that with the spinlock-based implementation (i.e.
> prior to e986a0d6cb36) then we would have the same problem on
> architectures that implement spinlocks with acquire/release semantics;
> accesses from outside of the critical section can drift in and reorder
> with each other there, so the conversion looked legitimate to me in
> isolation and I vaguely remember going through callers looking for
> potential issues. Alas, I obviously missed this case.
> 

I just to want to mention that although spinlock-based atomic bitops
don't provide the full barrier in test_and_set_bit(), but they don't
have the problem spotted by Hector, because test_and_set_bit() and
clear_bit() sync with each other via locks:

	test_and_set_bit():
	  lock(..);
	  old = *p; // mask is already set by other test_and_set_bit()
	  *p = old | mask;
	  unlock(...);
				clear_bit():
				  lock(..);
				  *p ~= mask;
				  unlock(..);

so "having a full barrier before test_and_set_bit()" may not be the
exact thing we need here, as long as a test_and_set_bit() can sync with
a clear_bit() uncondiontally, then the world is safe. For example, we
can make test_and_set_bit() RELEASE, and clear_bit() ACQUIRE on ARM64:

	test_and_set_bit():
	  atomic_long_fetch_or_release(..); // pair with clear_bit()
	  				    // guarantee everything is
					    // observed.
	  			clear_bit():
				  atomic_long_fetch_andnot_acquire(..);
	  
, maybe that's somewhat cheaper than a full barrier implementation.

Thoughts? Just to find the exact ordering requirement for bitops.

Regards,
Boqun

> So it looks to me like we need to:
> 
>   1. Upgrade test_and_{set,clear}_bit() to have a full memory barrier
>      regardless of the value which is read from memory. The lock/unlock
>      flavours can remain as-is.
> 
>   2. Fix the documentation
> 
>   3. Figure out what to do about architectures building atomics out of
>      spinlocks (probably ok as lock+unlock == full barrier there?)
> 
>   4. Accept my sincerest apologies for the mess!
> 
> > IOW, the proper fix for this should, I think, look something like this
> > (whitespace mangled) thing:
> > 
> >    --- a/include/asm-generic/bitops/atomic.h
> >    +++ b/include/asm-generic/bitops/atomic.h
> >    @@ -39,9 +39,6 @@ arch_test_and_set_bit(
> >         unsigned long mask = BIT_MASK(nr);
> > 
> >         p += BIT_WORD(nr);
> >    -    if (READ_ONCE(*p) & mask)
> >    -            return 1;
> >    -
> >         old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
> >         return !!(old & mask);
> >     }
> >    @@ -53,9 +50,6 @@ arch_test_and_clear_bit
> >         unsigned long mask = BIT_MASK(nr);
> > 
> >         p += BIT_WORD(nr);
> >    -    if (!(READ_ONCE(*p) & mask))
> >    -            return 0;
> >    -
> >         old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
> >         return !!(old & mask);
> >     }
> > 
> > but the above is not just whitespace-damaged, it's entirely untested
> > and based purely on me looking at that code.
> 
> Yes, I think that's step 1, thanks! I'm a bit worried about the perf
> numbers on the other thread, but we can get to the bottom of that
> separately.
> 
> Will
