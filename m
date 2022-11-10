Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10061624D74
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 23:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiKJWIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 17:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKJWIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 17:08:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F6E2A94F
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 14:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668118036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pkHFZ8A71PGLDYSbDeILz7gnWAG5cNe8osJEY2sw1oo=;
        b=RkPDbCDIgGFQcga5oWayTUjknIzkXHDLI0FMjgf7A4TRa2pWrtZCln2SF3EYMRCUfi1Mjs
        gT0/WhKBKmI/EFkX2LuMYKsdbe5KAZdugVBppd1ysgb8Qgke62L6vARMZ63RqqGlZrB+JE
        7LPayI2GlR7NTMJT63mwjjkeTuofv1g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-277-SaiWYo-ONkCeKDUEjDUSxA-1; Thu, 10 Nov 2022 17:07:15 -0500
X-MC-Unique: SaiWYo-ONkCeKDUEjDUSxA-1
Received: by mail-qv1-f72.google.com with SMTP id ng1-20020a0562143bc100b004bb706b3a27so2504690qvb.20
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 14:07:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkHFZ8A71PGLDYSbDeILz7gnWAG5cNe8osJEY2sw1oo=;
        b=s/EPpnlbTJnt1LeYuVUlzcQFwmtoDH/emJPWDMw3o5gaYkiMG0d71kWDLrieS/fOo7
         zaCsPKWDR+N5udd2C3aX1W66kfj+fDj9CPY/DiGwTPE1mwFco31irsGRx7EM/74v8egd
         j+SKVfhsR7wQqxPjxC/VryJy4ap8JYJ0jpy7fI10+G0nlG90DP84XuqHEEylOTcNGkrm
         JkuygOZ4HSnPqfdNSnj463dXhzb7xh6+1Yvel8KgKTKqUmFnnRAh/otUuXZe/+e7RSei
         yA2qFzIdyWYGeQwKD7xSfCCh3MKoJ2jWfBTJ7PeaGTwX4738Gv6fjhKnGNXziOe5r6AG
         Cp3Q==
X-Gm-Message-State: ACrzQf0axxWoDtu78qZVUh1H7/fdR0EB/WrmHOOD0LqJyTTNI0YS/vDT
        ixXUCHxYJjlyJFb0+VK1HnZ+7BZ3PHPPpDX2sO57wXNFsIuby3C9P0sWUXhPcxzrxMTFjC3mWnP
        jDFma+Qgh1P3zFIFV
X-Received: by 2002:a05:622a:a13:b0:3a5:7c31:2e3e with SMTP id bv19-20020a05622a0a1300b003a57c312e3emr1687902qtb.111.1668118034559;
        Thu, 10 Nov 2022 14:07:14 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4t4EgXmvKFwJ30gGMnTRs25++xa44a/3U/cSg3MHQzpqjLs+FQ2ezrzmzlOvCI1OHu38uacA==
X-Received: by 2002:a05:622a:a13:b0:3a5:7c31:2e3e with SMTP id bv19-20020a05622a0a1300b003a57c312e3emr1687885qtb.111.1668118034342;
        Thu, 10 Nov 2022 14:07:14 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id y8-20020a05620a44c800b006ee77f1ecc3sm358268qkp.31.2022.11.10.14.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 14:07:13 -0800 (PST)
Date:   Thu, 10 Nov 2022 17:07:12 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y212ENf87kLjiI6m@x1n>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
 <20221108011910.350887-2-mike.kravetz@oracle.com>
 <9BB0EA0C-6E7C-462B-8374-5BFEC34E8415@gmail.com>
 <Y21xlgG6sxP6q5K9@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y21xlgG6sxP6q5K9@monkey>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 01:48:06PM -0800, Mike Kravetz wrote:
> However, Peter seems to prefer just exposing the current zap_page_range_single.  
> The issue with exposing zap_page_range_single as it is today, is that we also
> need to expose 'struct zap_details' which currently is not visible outside
> mm/memory.c.

Ah I see, that's okay to me.  Thanks,

-- 
Peter Xu

