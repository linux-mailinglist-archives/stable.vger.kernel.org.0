Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDB35A152F
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 17:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiHYPFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 11:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240942AbiHYPFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 11:05:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FEFB56EF
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 08:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661439905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iygQAkAgz4JDbn3KVJAwromqSNqOkmZrJ35R+TSCGBw=;
        b=WbSg80lyvUQyENVdiNOFKKUNKeYOjb0cQAJn7tdJYmuQwBr4HYb7HCokp59/SE1IBBP4eH
        8cjpOEWd6amp0/cVC3DySSecEallveOSCz9A9dwz4XGBkui0ufuIKD562xAdywxDuTppQE
        d1EXedFasT5ttOZrLykSAwZ8MhEc2aY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-397-e3X3tSciOmObGorCXAK3Pg-1; Thu, 25 Aug 2022 11:05:03 -0400
X-MC-Unique: e3X3tSciOmObGorCXAK3Pg-1
Received: by mail-qk1-f197.google.com with SMTP id f1-20020a05620a280100b006bc4966f463so6325912qkp.4
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 08:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=iygQAkAgz4JDbn3KVJAwromqSNqOkmZrJ35R+TSCGBw=;
        b=r+1quCfbPz6OYBLkxrRYBfJ88sGhrTQYmVoPbzhiHdzO0W2Kelh0HP/tnaF658KZ/y
         FJ04E12mnj7qht5mkr0SgNNMS98a0sSDosFgAdPTNiJ6el0/a6UsJcwg2EbnjQiMp4W9
         hXghu7pIsf/0NZQsgMWKIDV3+gKBdh5sHEUnIQa6GLZYYDtDVo9nXs1i3dXAa5733gUg
         NRRhlEnfh084jZPRulRGo1QIJlvarDnCChBlK/1RJXBEVXJtu/zEwsmLUBKvHpGdgTeb
         LnJbQIG0Hk0L6RuLEVMy3JhSvZasai5eFmNmqrfK9EdBCqdY0rnwv+lPtVcnsrCN7NGa
         0Jvw==
X-Gm-Message-State: ACgBeo2qtEt8Z4HovtXAoHNqnnjJjD6PC+xvPlfnLXV6+askKypMBlsy
        fW2fVSPr4EL61ZoMquSpxfRFywUQf8/oJfZM6Qf1W8N2PprvWNdkZtxStB994FX2/U5VFnOudim
        U1v9G27XagjAgs20U
X-Received: by 2002:a05:622a:20e:b0:343:7345:36cc with SMTP id b14-20020a05622a020e00b00343734536ccmr3971329qtx.669.1661439903403;
        Thu, 25 Aug 2022 08:05:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5H6vUeaILfaettSLPx9OGO+p9IBfx7a4trs9PcWFxW10+WU/QvLs3nwiKRw0dOgxGyx6Uy1A==
X-Received: by 2002:a05:622a:20e:b0:343:7345:36cc with SMTP id b14-20020a05622a020e00b00343734536ccmr3971288qtx.669.1661439903064;
        Thu, 25 Aug 2022 08:05:03 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id bm25-20020a05620a199900b006b949afa980sm17692978qkb.56.2022.08.25.08.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:05:01 -0700 (PDT)
Date:   Thu, 25 Aug 2022 11:04:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     "Huang, Ying" <ying.huang@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <YwePm5lMSU2tsW6f@xz-m1.local>
References: <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Yv5QXkS4Bm9pTBeG@xz-m1.local>
 <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <87czcqiecd.fsf@nvdebian.thelocal>
 <YwaJSBnp2eyMlkjw@xz-m1.local>
 <YwaOpj54/qUb5fXa@xz-m1.local>
 <87o7w9f7dp.fsf@nvdebian.thelocal>
 <87k06xf70l.fsf@nvdebian.thelocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87k06xf70l.fsf@nvdebian.thelocal>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 11:24:03AM +1000, Alistair Popple wrote:
> By the way it's still an optimisation because in most cases we can avoid
> calling try_to_migrate() and walking the rmap altogether if we install
> the migration entries here. But I agree the comment is misleading.

There's one follow up question I forgot to ask on the trylock thing.  I
figured maybe I should ask out loud since we're at it.

Since migrate_vma_setup() always only use trylock (even if before dropping
the prepare() code), does it mean that it can randomly fail?

I looked at some of the callers, it seems not all of them are ready to
handle that (__kvmppc_svm_page_out() or svm_migrate_vma_to_vram()).  Is it
safe?  Do the callers need to always properly handle that (unless the
migration is only a best-effort, but it seems not always the case).

Besides, since I read the old code of prepare(), I saw this comment:

-		if (!(migrate->src[i] & MIGRATE_PFN_LOCKED)) {
-			/*
-			 * Because we are migrating several pages there can be
-			 * a deadlock between 2 concurrent migration where each
-			 * are waiting on each other page lock.
-			 *
-			 * Make migrate_vma() a best effort thing and backoff
-			 * for any page we can not lock right away.
-			 */
-			if (!trylock_page(page)) {
-				migrate->src[i] = 0;
-				migrate->cpages--;
-				put_page(page);
-				continue;
-			}
-			remap = false;
-			migrate->src[i] |= MIGRATE_PFN_LOCKED;
-		}

I'm a bit curious whether that deadlock mentioned in the comment is
observed in reality?

If the page was scanned in the same address space, logically the lock order
should be guaranteed (if both page A&B, both threads should lock in order).
I think the order can be changed if explicitly did so (e.g. fork() plus
mremap() for anonymous here) but I just want to make sure I get the whole
point of it.

Thanks,

-- 
Peter Xu

