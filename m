Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DF56273A8
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 00:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiKMX53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Nov 2022 18:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKMX53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Nov 2022 18:57:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79372D2CD
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 15:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668383794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EZbvZ1avvMufEpFcdH/nIpwHKdM0wHX6sD3CBlfSiEs=;
        b=Iq/QnngSGIGZkxR0hVbMJ+16SSb60g8qz04QJqNIqTtQ96gh5PATwaIGZbBCkFlG3mJDZE
        IFBLk30vyF+vVKCWQjmGnkfGoA6YT/EmQvUI9xdp/Lp2JldiuH1tieJ7x1B+FJzd3+E+jA
        gIArL72CGse5CKXyoihfGEaA3V5dbho=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-417-Bgcm5O3NO1uAfYqrSE8dhw-1; Sun, 13 Nov 2022 18:56:33 -0500
X-MC-Unique: Bgcm5O3NO1uAfYqrSE8dhw-1
Received: by mail-qt1-f200.google.com with SMTP id c19-20020a05622a059300b003a51d69906eso7107605qtb.1
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 15:56:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZbvZ1avvMufEpFcdH/nIpwHKdM0wHX6sD3CBlfSiEs=;
        b=oCIImXShORC9NYq03Q7l3blKyRy0YLtLmPFhpC74u0n+LGQRwozmEaqK4IFVQDwocq
         HvknBOjlptQF4zKBijdoF+4A1zOQz7v6xlySdr7QCY//sU13cN/EvP6XGhh98FlVoRT0
         xCI20ynvqxhADAwjfzSPfu8TMwJtRcZChWA7ygA1bPP101FbcoHoW6sh7ZYdjuBDZ1SK
         6Cf9JLQEVNeaGThraxLyY2GOpkkDOf/MBzF8yn7A3EARAgZz4QD6a7gcA9kargrNMOXM
         NV16+m1uK6VAufbM6l92hrBPhneHx4818uSHrNdtGasuUodpP7gae/fwilGdtthfO2M5
         Sfvw==
X-Gm-Message-State: ANoB5pmkWrvxhnEwUjBEanNvxvb0F1PtTXJYBNUQ9EQCKX3Qs2VbN/8r
        F9Xm/J018Pwr3F2rZk1DGRwszdJ7ZKS5zaQMrmRrPVXq8xr0cfUeOJnIhJJlwjQeue0hdLDLwEl
        gB0RPpvXFSj5hS4zN
X-Received: by 2002:ae9:c10c:0:b0:6fa:3cb1:da73 with SMTP id z12-20020ae9c10c000000b006fa3cb1da73mr9400845qki.175.1668383792778;
        Sun, 13 Nov 2022 15:56:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6EsFagGxYt6hjzxI1lLzrGvIO37GXjcoHtfxyk0egSnoJxB+naPS2mbwEdZSVGxZw83Gaq9A==
X-Received: by 2002:ae9:c10c:0:b0:6fa:3cb1:da73 with SMTP id z12-20020ae9c10c000000b006fa3cb1da73mr9400831qki.175.1668383792546;
        Sun, 13 Nov 2022 15:56:32 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id b18-20020ac87552000000b003a5d7b54894sm2781261qtr.31.2022.11.13.15.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 15:56:31 -0800 (PST)
Date:   Sun, 13 Nov 2022 18:56:30 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-ID: <Y3GELocAJ+p+gKpc@x1n>
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <87tu36icej.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87tu36icej.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 11, 2022 at 10:42:13AM +1100, Alistair Popple wrote:
> Hi Peter, for the patch feel free to add:
> 
> Reviewed-by: Alistair Popple <apopple@nvidia.com>

Will do, thanks.

> 
> I did wonder if this should be backported further for migrate_vma as
> well given that a migration failure there might lead a shmem read-only
> PTE to become read-write. I couldn't think of an obvious reason why that
> would cause an actual problem though.
> 
> I think folio_mkclean() will wrprotect the pte for writeback to swap,
> but it holds the page lock which prevents migrate_vma installing
> migration entries in the first place.
> 
> I suppose there is a small window there because migrate_vma will unlock
> the page before removing the migration entries. So to be safe we could
> consider going back to 8763cb45ab96 ("mm/migrate: new memory migration
> helper for use with device memory") but I doubt in practice it's a real
> problem.

IIRC migrate_vma API only supports anonymous memory, then it's not
affected by this issue?

One thing reminded me is I thought mprotect could be affected but I think
it's actually not, because mprotect is vma-based, and that should always be
fine with current mk_pte().  I'll remove the paragraph on mprotect in the
commit message; that could be slightly misleading.

-- 
Peter Xu

