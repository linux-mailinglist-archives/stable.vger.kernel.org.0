Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B576C3CEA
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 22:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCUVmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 17:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCUVmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 17:42:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC292006B
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 14:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679434918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eO1WQnfoG/w/cSj2CfnriSK9imFQpojF1RgSiHWE/RM=;
        b=FAZsJy7SCZYyW0z9mqG52l+IKtRaB79oWaKjlqvlJiMRpXlGUfxFURze5ptoB5Y0+4r0vP
        ZJsrecQ+XwCcACWCx6e6SuvdMAUjMwpVYK98ldyKynQ/P/U0+m369VCDnZ8W11P6AG7mRS
        5/iBfzliilTd5V/LKKwVOPbJThum/UE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-Y6307RxoN3WBl3lBy-A92A-1; Tue, 21 Mar 2023 17:41:56 -0400
X-MC-Unique: Y6307RxoN3WBl3lBy-A92A-1
Received: by mail-qt1-f197.google.com with SMTP id f2-20020ac87f02000000b003dd98d8bea0so6155612qtk.6
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 14:41:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679434916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eO1WQnfoG/w/cSj2CfnriSK9imFQpojF1RgSiHWE/RM=;
        b=Njw34Dekz+JC7evFd2R/ta8eYidZFt12EkjwAhQ6/mH3VC5C7A8MZviYktzgaaYjLt
         SwRXPD0uGIc3hROWpNY5lAMxsmgBp4vhZBGzefQCeb3AuscIYywpgWNXqAmp20I1MUTP
         Teid5ieuvLWfQFrxDhkCwifqysjP/uDN2BUMCt2eQGefsqIqGUIGeNA/oNgeigTli5bP
         boTT782DhCDQ4jGV/rcCeslpqLKEeMISuGwfjSdk9mAunqmapxt6wUaEj+/fxpS/nJup
         +TeVSTXSlYa8jlflecfuJaH8zA7cjnILdmtJkD1cOkueRGyVg+lkjqgcOTiZtXozSFRL
         ZzpQ==
X-Gm-Message-State: AO0yUKWtpP0xnLnnnhwz36gdZ635d1zD3VMpYhIX+Oanf8Xt2CPkEh22
        MvbElarBjBIl39PItFcUC3HWSQKklNZNzLLv69+/NtCnDotcG5dbDVnr+ZL6pnZNCr8AB+oYH6c
        dA9J6IirSWc8sUtiE
X-Received: by 2002:a05:622a:1a86:b0:3e3:7e6b:50ce with SMTP id s6-20020a05622a1a8600b003e37e6b50cemr7071749qtc.4.1679434916338;
        Tue, 21 Mar 2023 14:41:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set/FfoX5c7VWU9K3jawrQuSLuzVqT6mE6nk6j1okuCz1TJRQKy9DJBmpGALs3rdztZmrd62Ggg==
X-Received: by 2002:a05:622a:1a86:b0:3e3:7e6b:50ce with SMTP id s6-20020a05622a1a8600b003e37e6b50cemr7071715qtc.4.1679434916056;
        Tue, 21 Mar 2023 14:41:56 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id c9-20020ac853c9000000b003e37dac7eb5sm2720074qtq.87.2023.03.21.14.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:41:55 -0700 (PDT)
Date:   Tue, 21 Mar 2023 17:41:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
Message-ID: <ZBokogPMNsz+1Rsb@x1n>
References: <20230321191840.1897940-1-peterx@redhat.com>
 <20230321205719.GA6030@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230321205719.GA6030@monkey>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 01:57:19PM -0700, Mike Kravetz wrote:
> > This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> > writable even with uffd-wp bit set.  It only happens with all these
> > conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
> > was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
>                ^^^^
> Nit, but is the word "then" intended to be there?  Almost makes it sound as
> if wr-protected was a result of the previous 3 conditions being met.

Not intended..  Since this is not fixup-able, I'll reword here when I'll
need to repost.

[...]

> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

Thanks!

-- 
Peter Xu

