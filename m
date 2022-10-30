Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F986126C4
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 02:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiJ3Ayu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 20:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ3Ayu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 20:54:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD2FF02D;
        Sat, 29 Oct 2022 17:54:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m2so7638598pjr.3;
        Sat, 29 Oct 2022 17:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=77q2Cu689tqGNFEGpDkfXqQD5HzMzl1ec5TJSSyQvvA=;
        b=EraN1j/tCpQDZrJ6/ChafeAePu1N6xwqHXnZgFGM2HTEcIYNsfqapOIp9JhcE6f2MJ
         fwQ8agRAzxeFH4TVG9SmI6vdBwOxt5w2zQOv+rsPY8aSdVl9EZVB/cDI8dUNO5i7/x9Y
         3uA46NZDyAheIe66Z1sHl9VpS6CGbAZqyWo+eZXtcD/mU8L1LDy6fmXgWW8n3cghu/42
         AB6kHTo9MNr/ftT8kwMwm4iKNGnvwzspTd+3RoF7WGydt2++63Z64GvHrIZLgiHUBMWa
         Rw2xo4PXQUsHAEf6y8yjgsm6++4OHrAIT/gwr7WzQRTXOBGOantv8cf04VGJAIo8Kccc
         8HRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=77q2Cu689tqGNFEGpDkfXqQD5HzMzl1ec5TJSSyQvvA=;
        b=MnQs/TcoVelGZSgIYmQwZnkUxWIps251q+ORQcJo+iMGWGJMYr+5H01WHxzH//nRcA
         DY0wlKOrs7PC9+P/lVcpgmeue1vSTl2wJ83ReUY2gXkN9JERi8NG3VZEh+jwUSNCChyK
         EBR0qJZ7lTQOaHSL7NLTTrVBEai+VJj9kmp0qUNZXZ4A+PL3WoXg+xPRrRrxHw7f7BDz
         iTMQ2Eb9t7d+5GTJtAelE67pBSHOmBgfFsyUYdW7siV/tocNJAWZvoGOzVNBSFiBkIt9
         E+uTlNl9Ns8FpPNM0rvHiVFjmQeWjDRcjhws2y9Y7En55x7CeVhzQZCLUG2lTue2kKze
         KHlA==
X-Gm-Message-State: ACrzQf1A3iJMe2g24+B3lEZV8Uy8qIB1YrIYgt0e+UTmRF0uHnhWRm2Y
        MuZmIRs6lvt2u8FTrtK0QbY=
X-Google-Smtp-Source: AMsMyM6gu09eo3bvtudODSKlspE707KvxJBRdAPtM3xEOdPcKEWu5D0PrHM4NTTxtQHInt1uCrtMgQ==
X-Received: by 2002:a17:902:bcc4:b0:181:899a:ac9c with SMTP id o4-20020a170902bcc400b00181899aac9cmr6914467pls.124.1667091287610;
        Sat, 29 Oct 2022 17:54:47 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 6-20020a631446000000b0046f7e1ca434sm1594012pgu.0.2022.10.29.17.54.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Oct 2022 17:54:46 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <Y13CO8iIGfDnV24u@monkey>
Date:   Sat, 29 Oct 2022 17:54:44 -0700
Cc:     Peter Xu <peterx@redhat.com>, Linux-MM <linux-mm@kvack.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <7048D2B5-5FA5-4F72-8FDC-A02411CFD71D@gmail.com>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n> <Y1nImUVseAOpXwPv@monkey> <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey> <Y1v/x5RRpRjU4b/W@x1n> <Y1xGzR/nHQTJxTCj@monkey>
 <Y1xjyLWNCK7p0XSv@x1n> <Y13CO8iIGfDnV24u@monkey>
To:     Mike Kravetz <mike.kravetz@oracle.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Oct 29, 2022, at 5:15 PM, Mike Kravetz <mike.kravetz@oracle.com> =
wrote:

> zap_page_range is a bit confusing.  It appears that the passed range =
can
> span multiple vmas.  Otherwise, there would be no do while loop.  Yet, =
there
> is only one mmu_notifier_range_init call specifying the passed vma.
>=20
> It appears all callers pass a range entirely within a single vma.
>=20
> The modifications above would work for a range within a single vma.  =
However,
> things would be more complicated if the range can indeed span multiple =
vmas.
> For multiple vmas, we would need to check the first and last vmas for
> pmd sharing.
>=20
> Anyone know more about this seeming confusing behavior?  Perhaps, =
range
> spanning multiple vmas was left over earlier code?

I don=E2=80=99t have personal knowledge, but I noticed that it does not =
make much
sense, at least for MADV_DONTNEED. I tried to batch the TLB flushes =
across
VMAs for madvise=E2=80=99s. [1]

Need to get to it sometime.

[1] =
https://lore.kernel.org/lkml/20210926161259.238054-7-namit@vmware.com/

