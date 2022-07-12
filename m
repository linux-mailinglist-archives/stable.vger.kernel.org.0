Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721A1571B33
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 15:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiGLN1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 09:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiGLN1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 09:27:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EECD0904DB
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657632461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DC68EZcp8HbHnL+RJJnc8fD/j/Lhx9vJKALlsi90sNc=;
        b=JN03ZOgGpmaBCqYAjrO1tBPM3ggTslg/tZ39iUJ/Q4QXPjZ6LrwMh5yb09Veez4pH8u+Jj
        YVE+Ht9d8DyfZn0EUBuyJuiZ0NzyiZ5kd3d8Yj6ac6iwknzSOMNPb+DSdS2HP05Glb1fqN
        ozbo1Fwu7ufijhZUmcgskyaH+Wbr6sw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-Isb4rd2YP6ay0mD6vdk4pQ-1; Tue, 12 Jul 2022 09:27:40 -0400
X-MC-Unique: Isb4rd2YP6ay0mD6vdk4pQ-1
Received: by mail-qk1-f199.google.com with SMTP id o13-20020a05620a2a0d00b006b46c5414b0so7862767qkp.23
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DC68EZcp8HbHnL+RJJnc8fD/j/Lhx9vJKALlsi90sNc=;
        b=NG+0w6CPIGqyLM7C4MEbuqAEmwpdCBRNYJAkXIa7ED/AmmtVDaGmC/GYIcuaQE5hkS
         +/JdQXHQaJsdBcJb0xPoR5poYda0QFSvM4Jy7xFbumGyp0e191MlWaCN8utqWjycOLXt
         FNgbhZSSmjU3TbIapFxspA3PYoFDdDtOI2SgmZEE7+bMbpxBBG3KJCiSVyd7dIdjGYhJ
         jXhZ9epXQ+gc1WxvzxDobm2Y9H71jujAmConvjep8U7EqTfT/Oj5yoi7ctiwZZDbQ8nS
         aJvBM1dS59zOTor2KQAR8djcJ3/qYJb27pDvfosiE/asMgLVGy3SpPSzMJDR5uxAya6Q
         CO8g==
X-Gm-Message-State: AJIora9ok1+X4xstO+Yjl6PYp/9s+ZUlWM5Y52ZSRxDBWpdTCcNRgmfk
        tLdUsQF7OwGPIj8UqxegwhM0wQE5MMgzQKi51fBNdcOiUJsSJ1vIpSU2ROas1hxSuFuq0vCbTCC
        BhLaRKs8NsJkyvTnm
X-Received: by 2002:a05:6214:c8a:b0:473:26f:59e0 with SMTP id r10-20020a0562140c8a00b00473026f59e0mr17562252qvr.63.1657632459749;
        Tue, 12 Jul 2022 06:27:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vwHUvgExMAHhJ8Gd2okDEZPQ1R189/OcIsXzRgysYWzxhAs75REVpZWXe77Sgmk3CxU4XqpQ==
X-Received: by 2002:a05:6214:c8a:b0:473:26f:59e0 with SMTP id r10-20020a0562140c8a00b00473026f59e0mr17562224qvr.63.1657632459456;
        Tue, 12 Jul 2022 06:27:39 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id s12-20020a05620a29cc00b006b28349678dsm10208701qkp.80.2022.07.12.06.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:27:37 -0700 (PDT)
Date:   Tue, 12 Jul 2022 09:27:36 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Nadav Amit <namit@vmware.com>,
        James Houghton <jthoughton@google.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: provide properly masked address for
 huge-pages
Message-ID: <Ys12yG6XKCCTI3LH@xz-m1.local>
References: <20220711165906.2682-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220711165906.2682-1-namit@vmware.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 09:59:06AM -0700, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Commit 824ddc601adc ("userfaultfd: provide unmasked address on
> page-fault") was introduced to fix an old bug, in which the offset in
> the address of a page-fault was masked. Concerns were raised - although
> were never backed by actual code - that some userspace code might break
> because the bug has been around for quite a while. To address these
> concerns a new flag was introduced, and only when this flag is set by
> the user, userfaultfd provides the exact address of the page-fault.
> 
> The commit however had a bug, and if the flag is unset, the offset was
> always masked based on a base-page granularity. Yet, for huge-pages, the
> behavior prior to the commit was that the address is masked to the
> huge-page granulrity.
> 
> While there are no reports on real breakage, fix this issue. If the flag
> is unset, use the address with the masking that was done before.
> 
> Fixes: 824ddc601adc ("userfaultfd: provide unmasked address on page-fault")
> Reported-by: James Houghton <jthoughton@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

