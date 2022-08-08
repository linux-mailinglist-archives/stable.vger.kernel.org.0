Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DC758CE8D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 21:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiHHT20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 15:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244395AbiHHT2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 15:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18B0C1A38F
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 12:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659986887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FKLyUQGyxiB0I8xVy9lbNQivmteb6Wpnt1Hf2TvWtBo=;
        b=UnFUxJY6/quB6xRwOWmJTyeDpl+B0sAbyyMQPrJJYTVWrF0BwAoDQ7JhsD1MTKuZpddh5a
        iy70gQAN9CSPgYTa830jvmDXyMpBNU+a3MxyEoEMXENM8OknusPml3Zg90vAK/n+qU0iPh
        1p62Rq0T5NBzQoBAstp8UpeRcZyoGcE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-JiR57kY6O0emekumXPkOpg-1; Mon, 08 Aug 2022 15:28:06 -0400
X-MC-Unique: JiR57kY6O0emekumXPkOpg-1
Received: by mail-il1-f197.google.com with SMTP id n13-20020a056e02140d00b002dfa5464967so5794739ilo.19
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 12:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=FKLyUQGyxiB0I8xVy9lbNQivmteb6Wpnt1Hf2TvWtBo=;
        b=3odYJwOuMV4Ugdi7jqjKI/cfHwWrDYWz1fyjfinMgphGhvDnBCq+vIExdyZIm4zwL2
         oJoisloSBnNGlJ4lsAKceIBV3uZT1F8pvUU1yjBv5yoMLVGc0H0/Us6aWrSkxrUS9Jr2
         kc4MA9RvkJE2tJhddbzbvPXxCQuMcIdra7T4Pu2/n+ffAcgcvN+90Z8ApSlnkwm/28U3
         ThwaHzxNI7rBQvoSkEtHvwLfBZNPVzEO/6W830dbV7cZCYaqe1axxxKTuoxDGHxAU2GH
         aYIeC3bAZWmUZRoQIqCAw2xoIyVheImgHmAkcbSJZuH5HeaxXWUYH7CuP6oreOM7s6Vg
         y2yA==
X-Gm-Message-State: ACgBeo2WOYgnzTydGohek3uYRGuppSq5GEg5EwpuH8DFKOZbn0h2fONh
        VDtqzNc+pdXNQ0h1FrfYPY5gWUMGq/gfh18mf2W/ehh97HNGXmj+3G6rvJbzzGFAuICRRgVlYZ+
        T6LfvLzMGnQFO0RBx
X-Received: by 2002:a05:6602:1493:b0:67c:498f:6297 with SMTP id a19-20020a056602149300b0067c498f6297mr8018123iow.19.1659986886048;
        Mon, 08 Aug 2022 12:28:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6cjNWPmiHP9dSCLeVdoD8+pkHqAUBj7IxWRFHwftxGib/s/HCg7uOu95cJaOUnPFCTBHJyZA==
X-Received: by 2002:a05:6602:1493:b0:67c:498f:6297 with SMTP id a19-20020a056602149300b0067c498f6297mr8018116iow.19.1659986885839;
        Mon, 08 Aug 2022 12:28:05 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id q21-20020a02a315000000b0034272baf43esm5445764jai.168.2022.08.08.12.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 12:28:05 -0700 (PDT)
Date:   Mon, 8 Aug 2022 15:28:03 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Message-ID: <YvFjww9AX/BuHdSn@xz-m1.local>
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com>
 <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey>
 <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey>
 <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
 <Yu2CI4wGLHCjMSWm@monkey>
 <Yu2kK6s8m8NLDjuV@xz-m1.local>
 <36bcc1f5-40e9-2d2b-3e94-18994bf62ca4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <36bcc1f5-40e9-2d2b-3e94-18994bf62ca4@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 06:36:58PM +0200, David Hildenbrand wrote:
> Well, because the write-fault handler as is cannot deal with
> write-faults in shared mappings. It cannot possibly work or ever have
> worked.

Trivially - maybe drop the word "require" in "Hugetlb does not
require/support writenotify"?

-- 
Peter Xu

