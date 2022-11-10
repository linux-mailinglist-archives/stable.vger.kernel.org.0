Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC8B624D7B
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 23:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiKJWJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 17:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiKJWJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 17:09:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA03822B1E
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 14:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668118124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=od/5bKmrXfsFZtwHFrDmanan/mLVNdHteQQ7qlODf90=;
        b=ULXZUTQ+K20SKBGWSP/OgwcmZSlI9Spj6lGAYR7dDxQi0o3thxTjsDD9a6rHyBiL9ojiLf
        8hTOLceg2e72SideOXuVZGTIilHC0jnHQGBy6bv0zBPSbPWMcjKIc4HcZMY0PymDQ8oG7b
        AtXM2qaheWTy6maHs0Nc86SGMKAw4I4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-mla_tozQPbWxO9CE1b52uA-1; Thu, 10 Nov 2022 17:08:42 -0500
X-MC-Unique: mla_tozQPbWxO9CE1b52uA-1
Received: by mail-qv1-f70.google.com with SMTP id mh13-20020a056214564d00b004c60dd95880so1421628qvb.6
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 14:08:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=od/5bKmrXfsFZtwHFrDmanan/mLVNdHteQQ7qlODf90=;
        b=L+6yGE3EbmRVB5MLCkqnUBCD8xGK/VdoAzwtNIytOf/7pRXPVpZxQQzI19h+lJUFK2
         z3q3Lo687shs0pyRaZeCcGPQtAe1ZP/kXIZO8cMMj5rSBzaErKLFfeSxBmsQrMyG3LB2
         QfEGT+9p6p1aucWYUmNqQ7q0/NSW8WO1McvsAFiYcdD/FCIHQDiTnHI5mRDnMoYxWFt9
         RmzHjtedMTAfqwoVEHTTU6mLsT0dv/R9j2I80vIMjMiu8RIvsnq6mV/93z6lXvmzfQU+
         m6MkNT9YUiu9EicfPgxrkJcLyuF4gF1DiSfCS1MeuKY+sHvNeho7YyRvZAeJIHkKXl2T
         AyZQ==
X-Gm-Message-State: ACrzQf0kzNlcnlWz75JvuNVEa3fnn6d351nkChz+oAhcwhoNuYgYtUyZ
        nCQRtUHTlDDyGzNSKlSN6sOFar7g2CTVAuYar10btEyPXsbJZzoNc6MBm5y2w3n+X3buKuX7Ni1
        3f7Q5wjWUO2ZgCVl6
X-Received: by 2002:a05:620a:3cd:b0:6f8:4c19:8072 with SMTP id r13-20020a05620a03cd00b006f84c198072mr2070493qkm.601.1668118122359;
        Thu, 10 Nov 2022 14:08:42 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4c4f8EvRXK3VQAzgH4BUiGTn4Ttp5tjSkonjNIRZhtgCjwSke5s0WOfITMemRYOiXmztDuqA==
X-Received: by 2002:a05:620a:3cd:b0:6f8:4c19:8072 with SMTP id r13-20020a05620a03cd00b006f84c198072mr2070481qkm.601.1668118122138;
        Thu, 10 Nov 2022 14:08:42 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id i5-20020a05620a404500b006fb11eee465sm342085qko.64.2022.11.10.14.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 14:08:41 -0800 (PST)
Date:   Thu, 10 Nov 2022 17:08:40 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ives van Hoorne <ives@codesandbox.io>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-ID: <Y212aAxqCtFszhTq@x1n>
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <CADnc5G2-7B7qyPitDY33Wb0D5a=pq-1PC=gp0f9peTtVnOvzjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADnc5G2-7B7qyPitDY33Wb0D5a=pq-1PC=gp0f9peTtVnOvzjw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 01:53:25PM -0800, Ives van Hoorne wrote:
> I verified these latest changes with my initial test case, and can confirm
> that I haven't been able to reproduce the problem anymore! Usually, I would
> be able to reproduce the error after ~1-5 runs, given that I would fill the
> page cache before the run, now I have been running the same test case for
> 50+ times, and I haven't seen the error anymore.
> 
> Thanks again Peter for taking the time to find the issue and coming up with
> a fix!

Thanks for the quick feedback, Ives!

-- 
Peter Xu

