Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E488593148
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiHOPHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiHOPHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:07:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E7E711A04
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660576067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tw1noeklhKvo4eFPa0CcJ3FiBdmqu8Dq+RMX4xesWq0=;
        b=NDDSKWtUrtvu5/vrQLduXV/oXmCly41KHOvCXX1S7xViV7XaIXhxDxZ3ymQUXZyn9Zb9ie
        NbbnGSfWavNFO0cJ+jyvuRsJKpO68fesK1PGSOX6LP5oHXIWmjMwgz3DNz4pT9ENDLVALL
        k1Oo40Syz+DTksN7TgMrvlYlA3cz2u8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-Xur5im-SOhalY4X_70kQMw-1; Mon, 15 Aug 2022 11:07:45 -0400
X-MC-Unique: Xur5im-SOhalY4X_70kQMw-1
Received: by mail-ej1-f72.google.com with SMTP id sa33-20020a1709076d2100b0073101bdd612so1132820ejc.14
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Tw1noeklhKvo4eFPa0CcJ3FiBdmqu8Dq+RMX4xesWq0=;
        b=Lj1VsCyT/3UB1oZ63oyCjDVuDKLy3oLKNRm05qZpl68I+StJzePrCaFr5or/XSKM9Q
         lYWeF895q9DBNl2suRqkXcSMFmUwbkV+txPQ2jq66J7MZyfarNUdaVxQE+rXGNQgEiyI
         c/ucz++7zbZCvJwyCkZRfTJkAY1wrGsBTegv8hhYJpavr7EVt7fc9cOAsjgeF8elQ1v2
         ZVWeZ2W2d7s48dK72qigNqY+rRf4hYGAk6KW56UGpv4Mx9X7KcCN6agQ1cXGF+Q0sLQS
         YFOPei4Vii3mHtzeA/Dj05ndWC+QtJdr3m72ThL3GqHDwjnJAns7Z9R0ZJKzrUClpNUP
         HppQ==
X-Gm-Message-State: ACgBeo1qKqgVF8khMakMCeacDYb3XydhMSB7gEozaF5FQSV93NrhTVkq
        6ChX08UVTykeZDy9xgLaLGmLrMx2jRDxw0vzXdXu2+GIGM95Q+Ah9OvcdpIgxpkxrvvpXSQ7k/v
        +6YcpaDr4kzU4OAi/8eyexx8Kek4Fd1iU
X-Received: by 2002:a17:906:11d:b0:712:abf:3210 with SMTP id 29-20020a170906011d00b007120abf3210mr10788095eje.292.1660576064354;
        Mon, 15 Aug 2022 08:07:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7tSkwByq5xF+yQbvSmrIHPWHYtArmthzfrZzL3s9Mg7AqC/e7mdYkOfmwqETCp2bEDphqRJ1HIZBm4X4cThrU=
X-Received: by 2002:a17:906:11d:b0:712:abf:3210 with SMTP id
 29-20020a170906011d00b007120abf3210mr10788077eje.292.1660576064081; Mon, 15
 Aug 2022 08:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220811103435.188481-1-david@redhat.com> <20220811103435.188481-3-david@redhat.com>
 <YvVRfSYsPOraTo6o@monkey> <20220815153549.0288a9c6@thinkpad>
In-Reply-To: <20220815153549.0288a9c6@thinkpad>
From:   David Hildenbrand <david@redhat.com>
Date:   Mon, 15 Aug 2022 17:07:32 +0200
Message-ID: <CADFyXm7-0zXDG+ZHjft95aAAiSZh_RyAqgJw1nGsALwEL1XKiw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared mappings
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 3:36 PM Gerald Schaefer
<gerald.schaefer@linux.ibm.com> wrote:
>
> On Thu, 11 Aug 2022 11:59:09 -0700
> Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> > On 08/11/22 12:34, David Hildenbrand wrote:
> > > If we ever get a write-fault on a write-protected page in a shared mapping,
> > > we'd be in trouble (again). Instead, we can simply map the page writable.
> > >
> > <snip>
> > >
> > > Reason is that uffd-wp doesn't clear the uffd-wp PTE bit when
> > > unregistering and consequently keeps the PTE writeprotected. Reason for
> > > this is to avoid the additional overhead when unregistering. Note
> > > that this is the case also for !hugetlb and that we will end up with
> > > writable PTEs that still have the uffd-wp PTE bit set once we return
> > > from hugetlb_wp(). I'm not touching the uffd-wp PTE bit for now, because it
> > > seems to be a generic thing -- wp_page_reuse() also doesn't clear it.
> > >
> > > VM_MAYSHARE handling in hugetlb_fault() for FAULT_FLAG_WRITE
> > > indicates that MAP_SHARED handling was at least envisioned, but could never
> > > have worked as expected.
> > >
> > > While at it, make sure that we never end up in hugetlb_wp() on write
> > > faults without VM_WRITE, because we don't support maybe_mkwrite()
> > > semantics as commonly used in the !hugetlb case -- for example, in
> > > wp_page_reuse().
> >
> > Nit,
> > to me 'make sure that we never end up in hugetlb_wp()' implies that
> > we would check for condition in callers as opposed to first thing in
> > hugetlb_wp().  However, I am OK with description as it.
>

Hi Gerald,

> Is that new WARN_ON_ONCE() in hugetlb_wp() meant to indicate a real bug?

Most probably, unless I am missing something important.

Something triggers FAULT_FLAG_WRITE on a VMA without VM_WRITE and
hugetlb_wp() would map the pte writable.
Consequently, we'd have a writable pte inside a VMA that does not have
write permissions, which is dubious. My check prevents that and bails
out.

Ordinary (!hugetlb) faults have maybe_mkwrite() (e.g., for FOLL_FORCE
or breaking COW) semantics such that we won't be mapping PTEs writable
if the VMA does not have write permissions.

I suspect that either

a) Some write fault misses a protection check and ends up triggering a
FAULT_FLAG_WRITE where we should actually fail early.

b) The write fault is valid and some VMA misses proper flags (VM_WRITE).

c) The write fault is valid (e.g., for breaking COW or FOLL_FORCE) and
we'd actually want maybe_mkwrite semantics.

> It is triggered by libhugetlbfs testcase "HUGETLB_ELFMAP=R linkhuge_rw"
> (at least on s390), and crashes our CI, because it runs with panic_on_warn
> enabled.
>
> Not sure if this means that we have bug elsewhere, allowing us to
> get to the WARN in hugetlb_wp().

That's what I suspect. Do you have a backtrace?

Note that I'm on vacation this week and might not reply as fast as usual.

