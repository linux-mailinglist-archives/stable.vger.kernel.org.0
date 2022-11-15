Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2444862A106
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiKOSEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiKOSEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:04:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA2B305
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668535428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZPGmCDP4PdFjMklWOBrmsqQLminbKqT3dINkdp9yW4=;
        b=fZ+rWeSsnKXg293z9HL6yOmD7UDK9J5zQrYxWyZnh99EV/ASOnJhTN5gEz/n1rpNRm9vdd
        Fotc7xVsMKHM2DR05YWA+e+pdgRGpyd8nNv1CH2Hkq0Vq62DW9VwagKGf/iDH5Eqw44DkJ
        3L2ZaLM9cP1fzSvFsAyJGkDMVrpPt5o=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-414-TXLt2igfNvi3J7kSDEFh0g-1; Tue, 15 Nov 2022 13:03:47 -0500
X-MC-Unique: TXLt2igfNvi3J7kSDEFh0g-1
Received: by mail-qv1-f69.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso11285985qvb.23
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:03:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZPGmCDP4PdFjMklWOBrmsqQLminbKqT3dINkdp9yW4=;
        b=sVCHDzUuP8bhxwe9UpR5EaZDE8VuxtaiI/FRE/6Yq0BWwYMW1V8+DoRuHgBXnlsYsq
         LH5w/uoTFxygzddxrgtk+ZikdcVJTpcFGB9psCvHvTbDUVmBcHMZkWAFJ+9/Au7VDwti
         KsQj1Zz+4y2FoiQQFmOp1INpdzgwHvos0Ac9iM5yzeoYE+GWgos4E5gEzX2d2yYsrBXl
         VTHvozqQn1WHN5LjJ4PIXs5rU0gqtK34mwAHYr3Gvbkhl1oDjOLvGBbzpR9wA0Z0ZKug
         2tdKsPG9b26gMXyJvlLOlYtCvE8KQWA9TIAWGDXgizBgJvefPCseH7yDqlo+TDT/Zldu
         fRow==
X-Gm-Message-State: ANoB5pn34OWFNYRcyzGtx5de6Pi/cMGQVjdnF21lBvEeGtCwN8btj0xv
        pRBOA7NUs5IwpuVUi3hCJfeds66wtlBbm7GxypCWGXBkFlDPozYAEQVOPRHMznt5+qy03gM1Pdu
        mPpUOqbbUQaalDiJt
X-Received: by 2002:a0c:fb4f:0:b0:4bb:746b:b643 with SMTP id b15-20020a0cfb4f000000b004bb746bb643mr17508981qvq.19.1668535426683;
        Tue, 15 Nov 2022 10:03:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6mtOCzP7fiXUrDhLbvxXOqillzwqzhWEmXWxlkkc1Rq2ucanEsEPbR5tAtX2D+jVp+DisnVg==
X-Received: by 2002:a0c:fb4f:0:b0:4bb:746b:b643 with SMTP id b15-20020a0cfb4f000000b004bb746bb643mr17508949qvq.19.1668535426426;
        Tue, 15 Nov 2022 10:03:46 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id e8-20020ac86708000000b003431446588fsm7455092qtp.5.2022.11.15.10.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 10:03:46 -0800 (PST)
Date:   Tue, 15 Nov 2022 13:03:44 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-ID: <Y3PUgOUYx6ECN405@x1n>
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <9af36be3-313b-e39c-85bb-bf30011bccb8@redhat.com>
 <Y3KgYeMTdTM0FN5W@x1n>
 <ec8b3c86-d3b2-f898-7297-c20a58ae2ac1@redhat.com>
 <Y3O5bCXSbvKJrjRL@x1n>
 <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 06:22:03PM +0100, David Hildenbrand wrote:
> That's precisely what I had in mind recently, and I am happy to hear that
> you have similar idea:
> 
> https://lkml.kernel.org/r/20221108174652.198904-6-david@redhat.com
> 
> "
> Note that we don't optimize for the actual migration case:
> (1) When migration succeeds the new PTE will not be writable because the
>     source PTE was not writable (protnone); in the future we
>     might just optimize that case similarly by reusing
>     can_change_pte_writable()/can_change_pmd_writable() when removing
>     migration PTEs.
> "

I see, sorry I haven't yet read it, but sounds doable indeed.

> 
> Currently, "readable_migration_entry" is even wrong: it might be PROT_NONE
> and not even readable.

Do you mean mprotect(PROT_NONE)?

If we read the "read migration entry" as "migration entry with no write
bit", it seems still fine, and code-wise after pte recovered it should
still be PROT_NONE iiuc because mk_pte() will just make a pte without
e.g. _PRESENT bit set on x86 while it'll have the _PROT_NONE bit.

May not keep true for numa balancing though: when migration happens after a
numa hint applied to a pte, it seems to me it's prone to lose the hint
after migration completes (assuming this migration is not the numa
balancing operation itself caused by a page access).  Doesn't sound like a
severe issue though even if I didn't miss something, since if the page got
moved around the original hint may need to reconsider anyway.

-- 
Peter Xu

