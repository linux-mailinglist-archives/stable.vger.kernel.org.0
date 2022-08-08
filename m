Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7CD58CBDD
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbiHHQKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 12:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243876AbiHHQKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 12:10:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 097D926E2
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659975007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k2rVxCQ9cERJ9mXQXAN4OFCiUy0IwjBElfQJb084200=;
        b=gIRvVmFUqMn4qjjeB1KIItfSGTqGU6XpId1sIIeqNcCh9OIMq7fsePZ2uM2Q/xB43VwTJt
        HMZAGAzYkEJaORFdznC7Oy01rNUHscFpR41xwMdS1vPD1sWqU+f8g+UgpqkvWdIOiZ3p5N
        4XPq9VIFC7Le2WmQ0ENDrGCgVTi4DSM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-aR2PpyCvO0uCFDci_l_6bQ-1; Mon, 08 Aug 2022 12:10:06 -0400
X-MC-Unique: aR2PpyCvO0uCFDci_l_6bQ-1
Received: by mail-io1-f69.google.com with SMTP id i3-20020a5d8403000000b0067bd73cc9eeso4744415ion.19
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 09:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=k2rVxCQ9cERJ9mXQXAN4OFCiUy0IwjBElfQJb084200=;
        b=pG6cSDWMvRfb89F7q9b9F7U+GygZSK4BtTRgRFV6sqhnO25u1EJuEtxJZQAYtP2qWi
         7pMm3xyHUU8c9S7q8v9tXnXFl3geJ7AYPjkY2hUhvBnEEOcatpdy3e56Av7G0COkNv+b
         qWxM/t7GCi3eYw8Ti4Dg3DbLmNQxWh1gVgQVGiWIQ3xrl4g1Ff+Cp1lNvF6ljFIi5XIV
         ycsdliZriAfk3rWcmXSZvpALQX66497SSTkVjr8MT5yTIQoqOGbWhF9LBulgyZmCm1Vp
         L3gD2T5LX4efsVQ0zYCLvAxusUQd+35/zcUsskTdtLz0VjZKVolOgwwDmG1Clcuxw6Dy
         Zh6A==
X-Gm-Message-State: ACgBeo3V6twbZu6dyWa05Gn4skAF+4yme3fEME9lHerLXUZ87iDKhU0p
        E4iZ3KZsbJoEjiNBJGQ4SyVCsrNz/L8xOx5yicwFjdeSGwn7YH18tCay/jwkmhHepMJF8QVaiD5
        YuZavMQ9zR3F9uth+
X-Received: by 2002:a05:6e02:1c8d:b0:2df:72a9:ffcc with SMTP id w13-20020a056e021c8d00b002df72a9ffccmr8511703ill.189.1659975005376;
        Mon, 08 Aug 2022 09:10:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7M1kTZV0NW8ZsPJx7vif6CuH8zsDVFp6bLmx9V6FX7OFY7lFm4pqiWPcbvha02rSsJfqTNtg==
X-Received: by 2002:a05:6e02:1c8d:b0:2df:72a9:ffcc with SMTP id w13-20020a056e021c8d00b002df72a9ffccmr8511686ill.189.1659975005142;
        Mon, 08 Aug 2022 09:10:05 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id n16-20020a056602341000b00684f4b808ffsm13634ioz.39.2022.08.08.09.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 09:10:04 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:10:02 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Message-ID: <YvE1WsGKkGjyx1FU@xz-m1.local>
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com>
 <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey>
 <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey>
 <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
 <Yu2CI4wGLHCjMSWm@monkey>
 <Yu2kK6s8m8NLDjuV@xz-m1.local>
 <Yu2o5DUncFywbPFS@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yu2o5DUncFywbPFS@monkey>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 05, 2022 at 04:33:56PM -0700, Mike Kravetz wrote:
> It looks like vma_soft_dirty_enabled is recent and not in any stable
> trees (or even 5.19).
> 
> Yes, I did start working on hugetlb softdirty support in the past.
> https://lore.kernel.org/lkml/20210211000322.159437-1-mike.kravetz@oracle.com/
> 
> Unfortunately, it got preempted by other things.  I will try to move it up
> the priority list.

Thanks, Mike.

It'll also makes sense to forbid it if it may take time to finish, so we
don't need to push ourselves.

-- 
Peter Xu

