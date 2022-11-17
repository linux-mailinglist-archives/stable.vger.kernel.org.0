Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103C962E4D5
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 19:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240031AbiKQSyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 13:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbiKQSyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 13:54:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED1385169
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 10:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668711239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pqDtOtNSwX0ZV2YnFqWo79lClAu9bDuVWAJZIEodJ7s=;
        b=HpsUOQEU44K0KINKcRGDgLeIzb4eCZQZGeFoHnZfIVw1nFfRduZb9f07JM+ke4lNXIlZIg
        Ukgs+ETqiO5xSd+czSX1rZFwrPoAJpCrRQU0NlZnZXR6f+CHlfHeHzwWSBm4Ydm/KRqd5x
        kHL+mRUIjF//wsE76j429+QwU70YEfA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-575-08J_pV8lNlWKOITTnTkznQ-1; Thu, 17 Nov 2022 13:53:54 -0500
X-MC-Unique: 08J_pV8lNlWKOITTnTkznQ-1
Received: by mail-qk1-f199.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso3211178qkp.21
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 10:53:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqDtOtNSwX0ZV2YnFqWo79lClAu9bDuVWAJZIEodJ7s=;
        b=EVnk0aHDuHYVWi22MiR9ptpo5LRF4VOMPFQJPIcd3Ig8BPsCNX6C6CMlqilh5FuNHZ
         /V1vNkui0bYSDLiEPxAilf6ss2RS2JFFxwvSzSYkiG0NFH5J+Q/9WfOaRc9sM8vRjdBJ
         iJXB4vMM4CEOxj7s/tVYPx8ku1nvxfAiDTO0nT0sUCkLv1gCLX+SdCxWaJoarL0TrvrT
         qemHBBxDOeEZlqM5fDTMV6RIONAqQOEjC+JAcx3CU5GMpcw4AUFuk8Vs8u+inq3tc1+u
         sQ9le7t6qGfM5a4j+tSMw/l5uld3GxNAcckVOgqKHp2ZnRVKI4bKQuy+kIgzkrl+gPXs
         JoFw==
X-Gm-Message-State: ANoB5pkaz0wUwLWium7V+JMeiaMJngbJbeYdtFo9HoXFout99BiBjF+g
        CpM+Nuq69OS+g65FQPg+hrpvO/oUyWGaTr47AOlCrRaFZ1N/XjPdTvlifj+HtD/nyLwFWtcvk7l
        zlPoPkllzHRcLBM9x
X-Received: by 2002:a05:622a:289:b0:343:6909:9204 with SMTP id z9-20020a05622a028900b0034369099204mr3581879qtw.347.1668711234079;
        Thu, 17 Nov 2022 10:53:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4pjBfmBUmb8xyyeg1C+sqT3nsADmA8FXGzdanQiaRc4baapIqKmPjicoswCyXlkvWC03dPvQ==
X-Received: by 2002:a05:622a:289:b0:343:6909:9204 with SMTP id z9-20020a05622a028900b0034369099204mr3581867qtw.347.1668711233802;
        Thu, 17 Nov 2022 10:53:53 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id d17-20020a05620a241100b006f87d28ea3asm974024qkn.54.2022.11.17.10.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:53:53 -0800 (PST)
Date:   Thu, 17 Nov 2022 13:53:52 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "David S . Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, r@hev.cc
Subject: Re: [PATCH 04/47] LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is
 set in {pmd,pte}_mkdirty()
Message-ID: <Y3aDQKwGDLXtWRJu@x1n>
References: <20221117042532.4064448-1-chenhuacai@loongson.cn>
 <Y3ZPRx/VUoVvujNa@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3ZPRx/VUoVvujNa@x1n>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 10:12:07AM -0500, Peter Xu wrote:
> Hi, Huacai,
> 
> On Thu, Nov 17, 2022 at 12:25:32PM +0800, Huacai Chen wrote:
> > Now {pmd,pte}_mkdirty() set _PAGE_DIRTY bit unconditionally, this causes
> > random segmentation fault after commit 0ccf7f168e17bb7e ("mm/thp: carry
> > over dirty bit when thp splits on pmd").
> > 
> > The reason is: when fork(), parent process use pmd_wrprotect() to clear
> > huge page's _PAGE_WRITE and _PAGE_DIRTY (for COW);
> 
> Is it safe to drop dirty bit when wr-protect?  It means the mm can reclaim
> the page directly assuming the page contains rubbish.
> 
> Consider after fork() and memory pressure kicks the kswapd, I don't see
> anything stops the kswapd from recycling the pages and lose the data in
> both processes.

Feel free to ignore this question..  I think I got an answer from Hev (and
I then got a follow up question):

https://lore.kernel.org/all/Y3Z9Zf0jARMOkFBq@x1n/

> 
> > then pte_mkdirty() set
> > _PAGE_DIRTY as well as _PAGE_MODIFIED while splitting dirty huge pages;
> > once _PAGE_DIRTY is set, there will be no tlb modify exception so the COW
> > machanism fails; and at last memory corruption occurred between parent
> > and child processes.
> > 
> > So, we should set _PAGE_DIRTY only when _PAGE_WRITE is set in {pmd,pte}_
> > mkdirty().
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> > Note: CC sparc maillist because they have similar issues.
> 
> I also had a look on sparc64, it seems to not do the same as loongarch
> here (not removing dirty in wr-protect):
> 
> static inline pmd_t pmd_wrprotect(pmd_t pmd)
> {
> 	pte_t pte = __pte(pmd_val(pmd));
> 
> 	pte = pte_wrprotect(pte);
> 
> 	return __pmd(pte_val(pte));
> }
> 
> static inline pte_t pte_wrprotect(pte_t pte)
> {
> 	unsigned long val = pte_val(pte), tmp;
> 
> 	__asm__ __volatile__(
> 	"\n661:	andn		%0, %3, %0\n"
> 	"	nop\n"
> 	"\n662:	nop\n"
> 	"	nop\n"
> 	"	.section	.sun4v_2insn_patch, \"ax\"\n"
> 	"	.word		661b\n"
> 	"	sethi		%%uhi(%4), %1\n"
> 	"	sllx		%1, 32, %1\n"
> 	"	.word		662b\n"
> 	"	or		%1, %%lo(%4), %1\n"
> 	"	andn		%0, %1, %0\n"
> 	"	.previous\n"
> 	: "=r" (val), "=r" (tmp)
> 	: "0" (val), "i" (_PAGE_WRITE_4U | _PAGE_W_4U),
> 	  "i" (_PAGE_WRITE_4V | _PAGE_W_4V));
> 
> 	return __pte(val);
> }

(Same here; I just overlooked what does _PAGE_W_4U meant..)

> 
> >  
> >  arch/loongarch/include/asm/pgtable.h | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
> > index 946704bee599..debbe116f105 100644
> > --- a/arch/loongarch/include/asm/pgtable.h
> > +++ b/arch/loongarch/include/asm/pgtable.h
> > @@ -349,7 +349,9 @@ static inline pte_t pte_mkclean(pte_t pte)
> >  
> >  static inline pte_t pte_mkdirty(pte_t pte)
> >  {
> > -	pte_val(pte) |= (_PAGE_DIRTY | _PAGE_MODIFIED);
> > +	pte_val(pte) |= _PAGE_MODIFIED;
> > +	if (pte_val(pte) & _PAGE_WRITE)
> > +		pte_val(pte) |= _PAGE_DIRTY;
> 
> I'm not sure whether mm has rule to always set write bit then set dirty
> bit, need to be careful here because the outcome may differ when use:
> 
>   pte_mkdirty(pte_mkwrite(pte))
>   (expected)
> 
> VS:
> 
>   pte_mkwrite(pte_mkdirty(pte))
>   (dirty not set)
> 
> I had a feeling I miss some arch-specific details here on why loongarch
> needs such implementation, but I can't quickly tell.

After a closer look I think it's fine for loongarch as pte_mkwrite will
also set the dirty bit unconditionally, so at least the two ways will still
generate the same pte (DIRTY+MODIFIED+WRITE).

But this whole thing is still confusing to me.  It'll still be great if
anyone can help explain why the _DIRTY cannot be set only in pte_mkwrite()
if that's the solo place in charge of "whether the pte is writable".

The other follow up question is: how do we mark "this pte contains valid
data" (the common definition of "dirty bit"), while "this pte is not
writable" on loongarch?

It can happen when we're installing a page with non-zero data meanwhile
wr-protected.  That's actually a valid case for userfaultfd wr-protect mode
where user specified UFFDIO_COPY ioctl with flag UFFDIO_COPY_MODE_WP, where
we'll install a non-zero page from user buffer but don't grant write bit.

From code-wise, I think it can be done currently with this on loongarch:

  pte_wrprotect(pte_mkwrite(pte_mkdirty(pte)))

Where pte_wrprotect(pte_mkwrite(pte)) is not a no-op but applying MODIFIED.

While on many other archs it'll be as simple as:

  pte_mkdirty(pte)

But that's really error-prone and not obvious.

Copying Hev too.

Thanks,

-- 
Peter Xu

