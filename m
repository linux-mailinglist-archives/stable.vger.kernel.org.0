Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A657564EEFF
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiLPQ0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiLPQZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:25:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA32E687
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671207884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XA1mi3/yvF2SMJgghhMSPk1ys5oNzMW3ysl1aCR5HSU=;
        b=f5Y3+KeTlw5bWIsAd/2jheHrZqsYHuwCxhJ/O/u+RYk2dCS/PH2vsrUuEVIZca8gatRqbD
        X4Yf6Td1MvwkYBvcdCkkTZTOwZkMu3+ajMKGU1HgBxUa7duSkcw5h9G/eGlRpm+DxQDlJ7
        S1pVh6L9QVOpyFM6kC97rZJ775chqpI=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-hdeP3VNkPFmsSyqCnMcBmA-1; Fri, 16 Dec 2022 11:24:42 -0500
X-MC-Unique: hdeP3VNkPFmsSyqCnMcBmA-1
Received: by mail-vk1-f198.google.com with SMTP id u16-20020a1f2e10000000b003bd15638f64so1088242vku.1
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:24:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XA1mi3/yvF2SMJgghhMSPk1ys5oNzMW3ysl1aCR5HSU=;
        b=kteF6BgHsZNblXirGxk+inQib+mw50t33sxf3GGaN73oh2RwvYuEoSdA1GSMuiIB3A
         4T+f61yhSFHmXQ8VdRv2CUTOogFejmuZA4F5IVuvdkq6nIAA/6PRONxdwf8u7N6abLb3
         jaRnDnL6qVe/D+eHhSRUj2yC9uSJ3LtF/5JCBVaGr0Vd0BWPYB3N6s90Z9aF4RShyCf1
         DEVQSPsv6TkIQpWlpFOsvRzDRO3GJKXCTjHQH6XqYIIzTPMjsqs5L9cIQEvlg1DrTWbh
         rqdZJBy3lWHH/1DMvxSq4Let+Xdg5ntlqmTmCTuwjAbzwWFfdhkkHNty6p0gQzaE1ww6
         LiHA==
X-Gm-Message-State: ANoB5pnGP3b3WYsVJYKu1Um3lszjEkp6NJ3R3TZQLIs3us+jB/Felgcp
        iDXWy0UC53bxX3DQnVn4t2OGRmoR/YSs1dIeQ8alO19oY7X0wofEIvJJYywpO32tycEGf3+jxxT
        dKEA/eq7qbCg1LrQM
X-Received: by 2002:a67:dd10:0:b0:3b3:6ddc:97f with SMTP id y16-20020a67dd10000000b003b36ddc097fmr15187487vsj.29.1671207882414;
        Fri, 16 Dec 2022 08:24:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6OJlfzNjkPvaVv4RHsPHN78/T6Vk/8cntq0gr0I50Jwzh7j9GHfeHPbvrFscG2qYOO36b7iQ==
X-Received: by 2002:a67:dd10:0:b0:3b3:6ddc:97f with SMTP id y16-20020a67dd10000000b003b36ddc097fmr15187469vsj.29.1671207882204;
        Fri, 16 Dec 2022 08:24:42 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-45-70-31-26-132.dsl.bell.ca. [70.31.26.132])
        by smtp.gmail.com with ESMTPSA id de26-20020a05620a371a00b006cfc01b4461sm1688741qkb.118.2022.12.16.08.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:24:41 -0800 (PST)
Date:   Fri, 16 Dec 2022 11:24:40 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/uffd: Fix pte marker when fork() without fork
 event
Message-ID: <Y5ybyFa5U9VzVcwg@x1n>
References: <20221214200453.1772655-1-peterx@redhat.com>
 <20221214200453.1772655-2-peterx@redhat.com>
 <618b69be-0e99-e35f-04b3-9c63d78ece50@redhat.com>
 <Y5yGp6ToQD+eYrv/@x1n>
 <8c36dd0a-90be-91bf-0ded-55b34ee0a770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c36dd0a-90be-91bf-0ded-55b34ee0a770@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 04:57:33PM +0100, David Hildenbrand wrote:
> I'm more concerned about backports, when one backports #1 but not #2. In
> theory, patch #2 fixes patch #1, because that introduced IMHO a real
> regression -- a possible memory corruption when discarding a hwpoison
> marker. Warnings are not nice but at least indicate that something needs a
> second look.

Note that backporting patch 1 only is exactly what I wanted to do here - it
means his/her tree should not have the swapin error pte markers at all.

The swapin error pte marker change only existed for a few days in Linus's
tree, so no one should be backporting patch 2.

Thanks,

-- 
Peter Xu

