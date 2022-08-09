Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DDF58E0D4
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344458AbiHIUPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343999AbiHIUPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:15:11 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D518126AF1
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:15:09 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z2so16570022edc.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=X1/mYkVHU3QQELeXoM1reH5RSgIloRBIOFMBth8wCSU=;
        b=FGG/j0qA+lcc5NIm9Yr1RfxyjspKe0bRMPQntKiDcsr1oym/+xnHixwfrbQ28m7YGu
         g/N5WLzKwxa4WMJlknvz7Yf00cZu5FrHuLCG6il2QAFzWtyDTqzgTjgpynexBGJCyuhp
         tdJUKIRlyrFII/hnW7p3KEJ2rfU9KhujBiUdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=X1/mYkVHU3QQELeXoM1reH5RSgIloRBIOFMBth8wCSU=;
        b=WxGpHNF7PAfpsTyPmZOblTNWTHNCcttxRkqGh0pDgOmMUvwNqiYpGfaSP1vQtCKBZZ
         L2+S74T9ro1lpKBRQn7fW4FmedAqQfGuzguiunb509fBZpmfLvOVV1sfcsgeViVDYJeg
         onkyXiUOpdvBslikFNJG1MWV0fF2t5tC5Nzg7awFQdbRAR8R/yHNc/9MqvAwVkABxhXT
         ftagQzEpN/pk5gt8F9viadQzqQSXTeo905yEsoLsGFTR/cSviUs1tzT93HRhtTbguf84
         ajjwcnwGFA+UYnnUJY3xQi03Xd5BItMW+ANoDHeSQMVocJ7r7WufRkFqLBtwsX60tllb
         zTXg==
X-Gm-Message-State: ACgBeo1HKFDhy2+Xg9TsTO5zne5v6lsr7OoPsCSQEL8zJkiwqYr77AJp
        hUwkhc080Tv3nss5UwryFQdXCDZzDBgnIK2mKaI=
X-Google-Smtp-Source: AA6agR5yaj1Zj37E/OunNUMJ4A+ocno2TgI6F11yiKv3U7JqIjT/j87fj3lE0x1nNALUEj5coxefPg==
X-Received: by 2002:aa7:ce88:0:b0:442:30f5:433f with SMTP id y8-20020aa7ce88000000b0044230f5433fmr2153250edv.317.1660076107980;
        Tue, 09 Aug 2022 13:15:07 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id bx7-20020a0564020b4700b0043577da51f1sm6452299edb.81.2022.08.09.13.15.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:15:06 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id j15so15532629wrr.2
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:15:06 -0700 (PDT)
X-Received: by 2002:a5d:638b:0:b0:220:6e1a:8794 with SMTP id
 p11-20020a5d638b000000b002206e1a8794mr15513397wru.193.1660076105927; Tue, 09
 Aug 2022 13:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com> <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
 <91e18a2f-c93d-00b8-7c1b-6d8493c3b2d5@redhat.com>
In-Reply-To: <91e18a2f-c93d-00b8-7c1b-6d8493c3b2d5@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 13:14:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
Message-ID: <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 9, 2022 at 1:07 PM David Hildenbrand <david@redhat.com> wrote:
>
> >         /* But FOLL_FORCE has no effect on shared mappings */
> >         if (vma->vm_flags & MAP_SHARED)
> >                 return false;
>
> I'd actually rather check for MAP_MAYSHARE here, which is even stronger.
> Thoughts?

Hmm. Adding the test for both is basically free (all those vm_flags
checks end up being a bit mask and compare), so no objections.

For some reason I though VM_SHARED and VM_MAYSHARE end up always being
the same bits, and it was a mistake to make them two bits in the first
place (unlike the read/write/exec bits that can are about mprotect),

But as there are two bits, I'm sure somebody ends up touching one and
not the other.

So yeah, I don't see any downside to just checking both bits.

[ That said, is_cow_mapping() only checks VM_SHARED, so if they are
ever different, that's a potential source of confusion ]

               Linus
