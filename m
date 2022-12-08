Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C80F6472C9
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiLHPWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 10:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiLHPWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 10:22:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E780871246
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 07:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670512883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1TCrGY30xtqKhvpkZ91gzI+bfZZQwx6XMMEYmjyVbA4=;
        b=Z06Z8BchhQpGHHHs3F4XeGqlHq/CHrPP2kVnvTxGR4U0ms18diAS1OwjV1eJNKqu+EM78c
        iSGB5qi6StHciNiBdp5S83otUAW3g4iS1FiCwDlrJz6xe4oS5ao40hl5IbUF80FGlRUxuT
        PlEMKbsoeVMxEWFvXMSdp/Kz6jBa5NA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-70-lJdnghseOj2gfVdCeNknvA-1; Thu, 08 Dec 2022 10:17:31 -0500
X-MC-Unique: lJdnghseOj2gfVdCeNknvA-1
Received: by mail-qt1-f200.google.com with SMTP id s14-20020a05622a1a8e00b00397eacd9c1aso1621844qtc.21
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 07:17:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1TCrGY30xtqKhvpkZ91gzI+bfZZQwx6XMMEYmjyVbA4=;
        b=OBir2PMzoynvFIn97WoppJpKptIs5/rCr+w+IqF9oRGQ/tU+MgdsNS+R04404mWNNA
         S2gsxdorTbp/hz+neZsrdPfe4r/imT2H1EKjPLCV6qO65vOOTLNdXLEOv5c97uJDghzO
         yZOgAQRBomBbR6nlCMv2v6Jcwq3aALBDPoXDlEPGKWFI4PN/RlVOMSy4taARJK85+low
         NJT5Pi02KQ7ZSvugQTRf6kFIvZ81uh7bTqWM9bJbNKLfDoGLTmucZG+b0090A6iXTFeI
         f+qpZ4lDln9ybnUMjPqAv/2tOQKejK0O2umcx3RW3AO84+ShRHVfrKWcTeoF0HagUdd4
         BgEw==
X-Gm-Message-State: ANoB5pl2RMKhh0Nh7FBZtWMZrJzv0oucfk/T5lFsjzA4NCWJ9OloO/GG
        U2Vt+l/J2a1JOVT8hH8GjScy/ramSivw0uiArsrYHZLaghlkE8Qnm58+Gg6o3ho2FbGd8sxHMOr
        hbwp27Por7DxElWm7
X-Received: by 2002:a05:622a:4a17:b0:3a5:3c5e:7b67 with SMTP id fv23-20020a05622a4a1700b003a53c5e7b67mr3659178qtb.37.1670512651094;
        Thu, 08 Dec 2022 07:17:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7xIQ66ISuHWGhfM3iVFJxH0myy6pVHyIzFHhJhtBI9sCg9WI0NXgOhibs7AlkbCRvBltMwCQ==
X-Received: by 2002:a05:622a:4a17:b0:3a5:3c5e:7b67 with SMTP id fv23-20020a05622a4a1700b003a53c5e7b67mr3659149qtb.37.1670512650788;
        Thu, 08 Dec 2022 07:17:30 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id c4-20020a05620a268400b006ec62032d3dsm19471430qkp.30.2022.12.08.07.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 07:17:29 -0800 (PST)
Date:   Thu, 8 Dec 2022 10:17:28 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
Message-ID: <Y5IACIN6b5UaYq42@x1n>
References: <20221202122748.113774-1-david@redhat.com>
 <Y4oo6cN1a4Yz5prh@x1n>
 <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
 <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com>
 <Y45duzmGGUT0+u8t@x1n>
 <92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com>
 <Y4+zw4JU7JMlDHbM@x1n>
 <5a626d30-ccc9-6be3-29f7-78f83afbe5c4@redhat.com>
 <Y5C4Zu9sDvZ7KiCk@x1n>
 <53e52007-e556-332d-ec4d-5fe48a90e9b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53e52007-e556-332d-ec4d-5fe48a90e9b0@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 09:10:41PM +0100, David Hildenbrand wrote:
> Now, my 2 cents on the whole topic regarding "supported", "not supported"
> etc:
> 
> (1) If something is not supported we should bail out or at least warn
>     the user. I'm pretty sure there are other uffd-wp dummy users like
>     me. Skimming over the man userfaultfd page nothing in particular
>     regarding PROT_WRITE, mprotect(), ... maybe I looked at the wrong
>     page.
> (2) If something is easy to support, support it instead of having all
>     these surprises for users and having to document them and warn the
>     user. Makes all these discussions regarding what's supported, what's
>     a valid use case, etc ... much easier.
> (3) Inconsistency confuses users. If something used to work for anon,
>     in an ideal world, we make shmem behave in a similar, non-surprising
>     way.
> (4) There are much smarter people like me with much more advanced
>     magical hats. I'm pretty sure they will come up with use cases that
>     I am not even able to anticipate right now.
> (5) Users will make any imaginable mistake possible and point at the
>     doc, that nothing speaks against it and that the system didn't bail
>     out.
> 
> Again, just my 2 cents. Maybe the dos and don'ts of userfaultfd-wp are
> properly documented already and we just don't bail out.

I just don't know how to properly document it with all the information.  If
things missing we can always work on top, but again I hope we don't go too
far from what will become useful.

Note that I never said mprotect is not supported... AFAIR there is a use
case where one can (with non-cooperative mode) use uffd-wp to track a
process who does mprotect.  For anon uffd-wp it should work already, now
this also reminded me maybe yes with the vm_page_prot patch for shmem from
you it'll also work with shmem and it's still good to have that.  In that
case IIUC we'll just notify uffd-wp first then with SIGBUS.

Said that, it's still unclear how these things are used altogether in an
intended way.  Let me give some examples.

 - What if uffd-wp is registered with SIGBUS mode?  How it'll work with
   mprotect(RO) too which also use SIGBUS?

 - What if uffd-wp tracks a process that also use uffd-wp?  Now nest cannot
   work, but do we need to document it explicitly, or should we just
   implemented nesting of uffd-wp?

 - Even if uffd-wp seems to work well with mprotect(RO), what about all the
   rest modes combined?  Uffd has missing and minor mode, mprotect can do
   more than RO.  One thing we used to discuss but a slight different case:
   what happens if one registers with uffd missing and also mprotect(NONE)?
   When the page accessed IIUC we will notify SIGBUS first instead of uffd
   because IIRC we'll check vma flags earlier.  Is this the behavior we
   wanted?  What's the expected behavior?  This will also be a different
   order we notify comparing to the case of "uffd-wp with mprotect(RO)"
   because in that case we notify uffd-wp before SIGBUS.  Should we revert
   the order there just to align with everything?

Sorry to dump these examples.  What I wanted to say is to me there're just
so many things to consider and that's just a start.  I am not sure whether
it'll be even worth it to decide which should be the right order and make
everything very much defined, even if I still think 99% of the people will
not even care, when someone cares as a start from 1% then 0.99% of them
will find that they can actually do it cleaner with other approaches with
the same kernel facilities.

What about the last 0.01%?  They're the driven force to enhance the kernel,
that's always my understanding.  They'll either start to ask: "hey I have a
use case that want to use uffd with mprotect() in this way, and that cannot
be done by existing infras.  Would it make sense to allow it to happen?".
Or they come with patches.  That's how things evolve to me.

These may be seen as excuses of not having proper documentation, personally
sometimes it's not easy for me to draw the line myself on which should be
properly documented and which may not be needed.  What I worry is over
engineer and we spend time on things that may not as important or more
priority than something else.

Going back - the solo request I was asking to not use a mprotect example is
mprotect is really not the one that the majority should use for using
uffd-wp.  It's not easy to help people understand the problem at all.
That's all for that.

Thanks,

-- 
Peter Xu

