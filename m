Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD46658E96D
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 11:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiHJJSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 05:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiHJJSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 05:18:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 085C5AE20E
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660123100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0uiFPFiP6Hf6PNS9QuyB3HMvVy2bvN3qOXGUpbbFgOo=;
        b=FzplMLkCx8GQlrG+9Nv4wFSHS237nIIPjYwH2eutrQjt8A9P2Lb9ttd1xwUYnVtK2Mcx3A
        /hQ2OpA38lxuNpJPpf1lO2AOVdih1mpZtPIGU8nrVlFsLl6KxUa2Bnt7NasG/LA70SU2eX
        5nxRZa7v99GaGmeX1/FSeFTDWBbZrdo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-140-GB3FGhPYNpm63fD9rP0gWA-1; Wed, 10 Aug 2022 05:18:18 -0400
X-MC-Unique: GB3FGhPYNpm63fD9rP0gWA-1
Received: by mail-wm1-f69.google.com with SMTP id n1-20020a7bcbc1000000b003a4e8c818f5so365349wmi.6
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=0uiFPFiP6Hf6PNS9QuyB3HMvVy2bvN3qOXGUpbbFgOo=;
        b=q+S18EiKtmnKe6UiuHYK0W9utXNTC45uI81kNCfbRw84Nw4/G+C10bxQr+iW3oQYk+
         3NDIWDfdVT5oIq5App7I+MsmMSLYZRgdUfN2wicK9LLwcqlriT8V9leK+OJqXostX0gb
         5A/FVcddtKZ6b9eGUqSq2UNmYRkrNpHmSMIZ4qIqKkhTTr8fLwVYdZaH9mUvU2/CqLr7
         SouCucAYLUkoFoIcvs609lgHVBEnCIO54Y/FiWUXN4M/oW7xUNsoUJfS6/mJpRV/6nTv
         SZ2dWpwTi+PjI3fn0dkj1qwkDeIOZ0th2KWkIOKJUOf34eVM7EmtQP96QS86eLXPy0wZ
         O95Q==
X-Gm-Message-State: ACgBeo0hdkz3b3GIxTpd/HG6NTEUlC1jF+vkPVkLWjRgINT0Cpl27cnO
        nSqAl4wSq9poP76lujBaiHeyKK3PCnefuwdA2EKw95bgN9jWvdneORz4s05oi15+Rv9e+EMQ+Gy
        2+RCDf2PjD9tXzdOZ
X-Received: by 2002:a5d:61d0:0:b0:220:839f:dc95 with SMTP id q16-20020a5d61d0000000b00220839fdc95mr16183060wrv.241.1660123097766;
        Wed, 10 Aug 2022 02:18:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4w5nqH68Aak/Fd8pzrx9X+dRdxqFW9Ts+JdPHPB8s/CPVnYHbTHvx8DKBRDt9uCEvZ7YPAmQ==
X-Received: by 2002:a5d:61d0:0:b0:220:839f:dc95 with SMTP id q16-20020a5d61d0000000b00220839fdc95mr16183044wrv.241.1660123097498;
        Wed, 10 Aug 2022 02:18:17 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:1600:a3ce:b459:ef57:7b93? (p200300cbc7071600a3ceb459ef577b93.dip0.t-ipconnect.de. [2003:cb:c707:1600:a3ce:b459:ef57:7b93])
        by smtp.gmail.com with ESMTPSA id o36-20020a05600c512400b003a5317f07b4sm1727479wms.37.2022.08.10.02.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 02:18:17 -0700 (PDT)
Message-ID: <b314c287-5fc2-9f61-53f6-33282a2bed92@redhat.com>
Date:   Wed, 10 Aug 2022 11:18:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20220809205640.70916-1-david@redhat.com>
 <afab7f23d10145b590aef44b3242db64@AcuMS.aculab.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <afab7f23d10145b590aef44b3242db64@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.08.22 11:12, David Laight wrote:
> From: David Hildenbrand
>> Sent: 09 August 2022 21:57
> ...
> 
> These two functions seem to contain a lot of the same tests.

Yes, but after Linus and I discussed to not even reuse is_cow_mapping()
but instead to spell it out, I refrained from factoring common checks
out here to harm readability.

[...]

> 
> Perhaps only the initial call (common success path?) should
> be inlined?
> With the flags and vma tests being moved to an inline helper.

Do we really care enough to hurt readability? I mean, most things here
are simple bit checks, not expensive function calls.

inline is only a hint to the compiler after all. Please correct me if
I'm wrong.


Now, I don't have any strong opinion, but I do want to make progress for
this because -stable trees still need fixing and I'll be posting the
reproducer on Monday.


Thanks

-- 
Thanks,

David / dhildenb

