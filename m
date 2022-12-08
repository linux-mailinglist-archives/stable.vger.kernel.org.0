Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7D06476FC
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 21:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiLHUHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 15:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLHUHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 15:07:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B1A70BBD
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 12:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670529970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aO91Cy3aiM72NJuvUVHnXgYZwK+vF7vmwZ76fFMKBJA=;
        b=gCBTfLlX31rA/NtiEO56Qal7vxnQN1ERYUvm9rrbOYLYL2WEOxneiWMPCUN8y+VZFbVsU4
        XtcAi6nJNzRGQjd4SpfCrH1tkCj8lihzlKGNWxjoJc5LK86jo7B7/ahk2Q0qp97/v1xWvH
        rVsyS64IH2WbJ+HUXt9EBz8YyZi3Ed0=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-297-hrmnxB0aPBeizVwS4ouJRw-1; Thu, 08 Dec 2022 15:06:08 -0500
X-MC-Unique: hrmnxB0aPBeizVwS4ouJRw-1
Received: by mail-yb1-f199.google.com with SMTP id i7-20020a056902068700b006f848e998b5so2638591ybt.10
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 12:06:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aO91Cy3aiM72NJuvUVHnXgYZwK+vF7vmwZ76fFMKBJA=;
        b=2IkAA5OQ+3r+Q6H9JJ9nGW5YEgGhCgbYERxOeCPC5wgBMtBaqxF5gc0pGB7J5yTHxi
         5W35VAtjRgYKn4UoD+6tKCyWARBkE14OKeAYNPhAFshrI7Np6CLpoCaZHe5Qvi5Vh4mD
         Ed8Ec+oStnTiIWLpGHdurJhtvre+aVNslxO810DF0UJYNvnUY5x/WLU1/4/THcIO9JA2
         Ky9+3vYmSfd/xVo86p7GgOss1xUQ8bAglf1OCxLvjruyWm2Sie/wBvV0KrZV+6zgNyjb
         BcJkMpAOUvHOq/qG/kfWrgMk16cCwME/O/V8syT2qzVZZpHuXzBUyJE2kZDqOdUt0WU7
         mU9w==
X-Gm-Message-State: ANoB5pnRrIO4RmHdK3paNJssDYpwhr88ZSyya/HABl3OBxbActSidlFo
        YG+UnJ/rfUWZXOx0iGy/pd7D2woB63UV2wLD4WG7g5g8htHJtmk4WjrQJhRXldrZHnk3k/XMcqJ
        qMIQiay3guMYSmv+h
X-Received: by 2002:a25:2314:0:b0:714:e101:8548 with SMTP id j20-20020a252314000000b00714e1018548mr1353386ybj.58.1670529968073;
        Thu, 08 Dec 2022 12:06:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6rgZb0VkMbKMAwlRjV5wDNe3+42qmtQQXCtPakXyJ8UHqzCz/Y5cKAOu9FJotIYvo1ZV0gPA==
X-Received: by 2002:a25:2314:0:b0:714:e101:8548 with SMTP id j20-20020a252314000000b00714e1018548mr1353366ybj.58.1670529967829;
        Thu, 08 Dec 2022 12:06:07 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id q13-20020a05620a0d8d00b006fab416015csm20082249qkl.25.2022.12.08.12.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 12:06:07 -0800 (PST)
Date:   Thu, 8 Dec 2022 15:06:06 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v1] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
Message-ID: <Y5JDrkBGEyZviXz9@x1n>
References: <20221208114137.35035-1-david@redhat.com>
 <Y5IQzJkBSYwPOtiP@x1n>
 <b9162f04-7d8e-1ada-f428-85fd84327d1c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b9162f04-7d8e-1ada-f428-85fd84327d1c@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 05:44:35PM +0100, David Hildenbrand wrote:
> I'll wait for some more (+retest) before I resend tomorrow.

One more thing just to double check:

It's 6a56ccbcf6c6 ("mm/autonuma: use can_change_(pte|pmd)_writable() to
replace savedwrite", 2022-11-30) that just started to break uffd-wp on
numa, am I right?

With the old code, pte_modify() will persist uffd-wp bit, afaict, and we
used to do savedwrite for numa hints.  That all look correct to me until
the savedwrite removal patchset with/without vm_page_prot changes.

If that's the case, we'd better also mention that in the commit message and
has another Fixes: for that one to be clear.

-- 
Peter Xu

