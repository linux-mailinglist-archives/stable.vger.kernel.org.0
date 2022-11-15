Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B162F62A123
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiKOSM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiKOSMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:12:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540F620181
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668535882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1eer18dOX5R+bHPKMAIktRCptAEoDyYz4Wl1rWvmd9Y=;
        b=TTW20/nk/gWZ2kIPE2LrxWTH4lObSSZ9RuTBEE0gwFNMRKhXkakyL+Wk2FDfsRPBxL9zCL
        oURBjA7HE31Hvqz3PeuuxouebP4gbVDYVfqNpukQMGtUlXo5kWARvmOTHHTkPe59dDLqk6
        7sbnKZv06F+VvIbaHsqglfqei8xXCr0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-554-rwcdKSoMNwClENgZ5vhIUg-1; Tue, 15 Nov 2022 13:11:13 -0500
X-MC-Unique: rwcdKSoMNwClENgZ5vhIUg-1
Received: by mail-qt1-f197.google.com with SMTP id ay12-20020a05622a228c00b003a52bd33749so10710528qtb.8
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:11:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1eer18dOX5R+bHPKMAIktRCptAEoDyYz4Wl1rWvmd9Y=;
        b=N+GWLip/X6d0bt0V29mxEmz6g2Wz/OotZ6b9ALPbPu1roMm2ot3HBSy/tuWa1vOn3C
         nS/UedbCFVnsa7MH6fdSFh5bAkTZGwnlfAAE0pbblTgGaMiO9DclV79n8CAXQYhAWR4n
         fXwv+jMO2HB+nHMxKHgFuEs9/MVcbQTqM1jum97MG78PQe8cvXjUm2Vwm9UuB186Hh5g
         43QBj3wmVT9uzDxlpBcdxHOtrjo2X3mX2QLfCuKI2oWoo3WY4XrjwpfM51HHRg35gWLS
         mDR6025d0OcFTUDUGXUNFTpB72ArzHe8bIU4hqt3PP66v8UDi3hfOeuQtNTypq0jKDZR
         A/0w==
X-Gm-Message-State: ANoB5pnvA+SkxYEc4k5/pBx4IC92QU6Gs2MhGzY7wzLQGnNZCYLHqK0X
        Owuq1bSZmwWLq4xZo1Cf91R9HPH6lm3lQ+VQrWJYdfkf7PJ2GSiSoqB1TcZwD7729SXxE6OqFEr
        H+FWhNv2RjdsM7ODF
X-Received: by 2002:a05:620a:cca:b0:6fa:2a50:f884 with SMTP id b10-20020a05620a0cca00b006fa2a50f884mr16066923qkj.741.1668535873167;
        Tue, 15 Nov 2022 10:11:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6XBKkpt/Bs7c0cNYLkP4Cbh98dkNqTGjUQOJIIGYCpdr6clNBw82n+v7GW7OGh9k0xZvIOow==
X-Received: by 2002:a05:620a:cca:b0:6fa:2a50:f884 with SMTP id b10-20020a05620a0cca00b006fa2a50f884mr16066903qkj.741.1668535872949;
        Tue, 15 Nov 2022 10:11:12 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id e7-20020ac84b47000000b0039953dcc480sm7473363qts.88.2022.11.15.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 10:11:12 -0800 (PST)
Date:   Tue, 15 Nov 2022 13:11:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-ID: <Y3PWP9RPjg5FObMN@x1n>
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <9af36be3-313b-e39c-85bb-bf30011bccb8@redhat.com>
 <Y3KgYeMTdTM0FN5W@x1n>
 <ec8b3c86-d3b2-f898-7297-c20a58ae2ac1@redhat.com>
 <Y3O5bCXSbvKJrjRL@x1n>
 <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com>
 <2ed12722-2359-cb07-53e7-566d959d311e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ed12722-2359-cb07-53e7-566d959d311e@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 06:54:09PM +0100, David Hildenbrand wrote:
> No it isn't natural. But sneaking such a change into your fix seems wrong.
> Touching !uffd-wp code should be separate, if we want to do this at all (as
> we discussed, maybe the better/cleaner approach is to eliminate writable
> migration entries if possible).

If you see I made the subject as mm/migrate, because I took it as a
migration change, not uffd-wp specific.  I also added the Fixes to the uffd
patch because afaict that's the only thing that it affects, but I can't
tell either.

As I said, I'm trying to follow the rule where we have read entry I want to
make sure write bit removed.

I hope we have this patch land soon, because it affects users.  I'm not
against further rework on migration entries as I replied in the other
email, but for this patch I keep the same thoughts as when I posted.

Thanks,

-- 
Peter Xu

