Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4DF4BAF5A
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 02:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiBRB7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 20:59:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiBRB7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 20:59:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E0BEF94D0
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 17:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645149536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QE7RF7q2CobUX4IFI+57/lGPYQfU48wtPZuoNRlavuQ=;
        b=S0OzyKEJPRNDYkJno6TJvMGbjtQg+kaIWUOFmBeN/BpAdDdn1PdL3XjU0FHXXBglxaOE8f
        g7Dm+SSu+dEOJ0Sjbl4ad48WXMoPgJBHftWOCQrPu9mBuDYnwjT3ocLbWTuohXPmVJO/VJ
        qeLSdp+Jv3Jd2snlqm3gHLv1B/MUXLc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-bBEsBlhVOVe7owmVSZB-7A-1; Thu, 17 Feb 2022 20:58:55 -0500
X-MC-Unique: bBEsBlhVOVe7owmVSZB-7A-1
Received: by mail-pl1-f198.google.com with SMTP id c22-20020a170902849600b0014eff3fd4bcso2844026plo.7
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 17:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QE7RF7q2CobUX4IFI+57/lGPYQfU48wtPZuoNRlavuQ=;
        b=QmwEakh0WWEwjmv3X++sDy36r9Iq101E9fOlVuHIDi2SmX36wtHHi6Rre4KCArQ49w
         h4eyv/yDwGoNB6rc8EWrGlA8egDFR1yFvYAgY83WfeCKe31bIgKkWhiyRQTuZ9Hva1Pr
         NuMd7jXnMemztQqEFtlKy3CxU3NcIU3KNRr5CP4s8/1fLFrSvxaCHK/TBKfMMp4+3VmR
         2GekQWCRsgR5a6zlXs7SKAvDqmWBszj2AzulPbCqtPI5u3r4Gczmw+OAHXvUjy7eAkNz
         +sJ4SIkB8ivrFp2MUGiTwIddlR6giEp00BXCxnhbgHDM6XspVFE3nrhPrpUq2/wIZXK7
         Qvng==
X-Gm-Message-State: AOAM532WltBXMDW3uhxnR7zt32rvRwAh8xFDVKF9Y+lITRO3LV1UI+6D
        +Rpp3nlm7LdhMJ7uFaJkCaJbZvGCdrK8JH7KqI8Wro0k78Vx7AuAr1rkMlIj2s1D+N8vW06Fa26
        Kkqt5Tr2sviZsHeow
X-Received: by 2002:a17:90a:c292:b0:1b8:d40c:9292 with SMTP id f18-20020a17090ac29200b001b8d40c9292mr6000170pjt.139.1645149534398;
        Thu, 17 Feb 2022 17:58:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxeJOFDT/yHds7fZ6sSawpHZg5BF2GsuU/gtrCjzQTB2OjN6ABNZJVU5nNeaAO4TkJYyBqRNg==
X-Received: by 2002:a17:90a:c292:b0:1b8:d40c:9292 with SMTP id f18-20020a17090ac29200b001b8d40c9292mr6000148pjt.139.1645149534070;
        Thu, 17 Feb 2022 17:58:54 -0800 (PST)
Received: from xz-m1.local ([94.177.118.47])
        by smtp.gmail.com with ESMTPSA id c68sm9017323pga.1.2022.02.17.17.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 17:58:53 -0800 (PST)
Date:   Fri, 18 Feb 2022 09:58:48 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Nadav Amit <namit@vmware.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Message-ID: <Yg79WMuYLS1sxASL@xz-m1.local>
References: <20220217211602.2769-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220217211602.2769-1-namit@vmware.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Nadav,

On Thu, Feb 17, 2022 at 09:16:02PM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> When a PTE is set by UFFD operations such as UFFDIO_COPY, the PTE is
> currently only marked as write-protected if the VMA has VM_WRITE flag
> set. This seems incorrect or at least would be unexpected by the users.
> 
> Consider the following sequence of operations that are being performed
> on a certain page:
> 
> 	mprotect(PROT_READ)
> 	UFFDIO_COPY(UFFDIO_COPY_MODE_WP)
> 	mprotect(PROT_READ|PROT_WRITE)

No objection to the patch, however I'm wondering why this is a valid use
case because mprotect seems to be conflict with uffd, because AFAICT
mprotect(PROT_READ|PROT_WRITE) can already grant write bit.

In change_pte_range():

        if (dirty_accountable && pte_dirty(ptent) &&
                        (pte_soft_dirty(ptent) ||
                                !(vma->vm_flags & VM_SOFTDIRTY))) {
                ptent = pte_mkwrite(ptent);
        }

PS: I always think here the VM_SOFTDIRTY check is wrong, IMHO it should be:

        if (dirty_accountable && pte_dirty(ptent) &&
                        (pte_soft_dirty(ptent) ||
                        (vma->vm_flags & VM_SOFTDIRTY))) {
                ptent = pte_mkwrite(ptent);
        }

Because when VM_SOFTDIRTY is cleared it means soft dirty enabled.  I wanted
to post a patch but I never yet.

Could I ask why you need mprotect() with uffd?

Thanks,

-- 
Peter Xu

