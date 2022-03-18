Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765954DDD1B
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 16:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbiCRPjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 11:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237890AbiCRPjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 11:39:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD39B182;
        Fri, 18 Mar 2022 08:37:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g19so9735749pfc.9;
        Fri, 18 Mar 2022 08:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nw1gVfsrX5TVqVbU6JW2Pvb7rhoK13gC1EWpvY8GUzk=;
        b=V9GZdjqUjhPWfzDhRwgSYuMGZqkZwUCDIu8Ly/vG0H6HALjQdpgWnhe1AkH/Hckq9t
         EF3KVAcYrtH7o9jmUy46lFZiMW4KCWlE1zvbQQSAqOIjwVDgSJ8O2xgyHstQgMtN6Bpx
         NiDgDYNnEBMOU8pGHkKT800OVIJ/BqXjQ5J0heIlD9LMQxXooyIZD+RD61JtSMBK5lkr
         k7MbbskS7Uzxf9h/ACQ+sox3k135Sx8nz51lJ/msgxSUL4VYsyU4orAI3h5YUiIoWyEd
         5EXGB32lRPALEhQyGkHDfBfNWOeks4Lk7EKi4Fl84VuIPgvf2sA0Twmyq2lL0lYAug9j
         gFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=nw1gVfsrX5TVqVbU6JW2Pvb7rhoK13gC1EWpvY8GUzk=;
        b=ek6lz/8Vx7cCjJMtwHPQlD8c/y8lT9W46Uh0plcHJSK6rZyqtN9REV/VB5iJon0QQv
         OPn3VCT0qSLSKBMFNm/oH5IWpVTuLCHC7nCugAdbXd19V+oy//IJgpk/iZFnOd+bV9dt
         jEkWae5xJ8tmirerKdTdnco9VPXBzNSXWjC8mmSTg+A67dkoq+mECPQVz/BLkQFpa/JI
         /rHJdJzAfHlUss3UBP7H6qiqekqrs+28M22LrOF7/4+WYdAi4i/5nvE47AOCSEJ5f80Y
         UE1hkwJHOLofbd/VGhcw0eXD8p7txmkNPSDRn+ZfY45rqmIkK/aGe6l/A3S0NlIsi3LG
         rLAA==
X-Gm-Message-State: AOAM531cmBCunandLvCyi+iQrJYenMG1ZHC3rYHLOfyXHyOQElle96lD
        uJ0EBUp3VLd06CIzKfqJ6tEOceyexS8=
X-Google-Smtp-Source: ABdhPJwDUIHB6+NZdEJ+cPQLFdeJ68gW2iHEfXUiokmdBbTLYgDb67L2UC9qU0S/dsTC83peA/21Ng==
X-Received: by 2002:a63:ef41:0:b0:381:7f41:64d8 with SMTP id c1-20020a63ef41000000b003817f4164d8mr8322625pgk.312.1647617873029;
        Fri, 18 Mar 2022 08:37:53 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:bd26:cec:b459:db6e])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm10528428pfl.135.2022.03.18.08.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 08:37:52 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 18 Mar 2022 08:37:50 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edgar Arriaga =?iso-8859-1?Q?Garc=EDa?= 
        <edgararriaga@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <YjSnTu9QZiiZQE7A@google.com>
References: <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
 <YjFAzuLKWw5eadtf@google.com>
 <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
 <20220316142906.e41e39d2315e35ef43f4aad6@linux-foundation.org>
 <YjNhvhb7l2i9WTfF@google.com>
 <CAJuCfpGBJev_h92S0xLEQXghGQzNPCsqWTunpVPJQX4WWPjGzw@mail.gmail.com>
 <B49F17E4-8D3D-45FB-97E9-E0F906C88564@gmail.com>
 <74852e90-003b-84b8-9836-72258e3c5057@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74852e90-003b-84b8-9836-72258e3c5057@quicinc.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 07:35:41PM +0530, Charan Teja Kalla wrote:
> Thank you for valuable inputs.
> 
> On 3/18/2022 2:08 AM, Nadav Amit wrote:
> >>>>>> IMO, it's worth to note in man page.
> >>>>>>
> >>>>> Or the current patch for just ENOMEM is sufficient here and we just have
> >>>>> to update the man page?
> >>>> I think the "On success, process_madvise() returns the number of bytes
> >>>> advised" behaviour sounds useful.  But madvise() doesn't do that.
> >>>>
> >>>> RETURN VALUE
> >>>>       On  success, madvise() returns zero.  On error, it returns -1 and errno
> >>>>       is set to indicate the error.
> >>>>
> >>>> So why is it desirable in the case of process_madvise()?
> >>> Since process_madvise deal with multiple ranges and could fail at one of
> >>> them in the middle or pocessing, people could decide where the call
> >>> failed and then make a strategy whether they will abort at the point or
> >>> continue to hint next addresses. Here, problem of the strategy is API
> >>> doesn't return any error vaule if it has processed any bytes so they
> >>> would have limitation to decide a policy. That's the limitation for
> >>> every vector IO syscalls, unfortunately.
> >>>
> >>>>
> >>>>
> >>>> And why was process_madvise() designed this way?   Or was it
> >>>> always simply an error in the manpage?
> >> Taking a closer look, indeed manpage seems to be wrong.
> >> https://elixir.bootlin.com/linux/v5.17-rc8/source/mm/madvise.c#L1154
> >> indicates that in the presence of unmapped holes madvise will skip
> >> them but will return ENOMEM and that's what process_madvise is
> >> ultimately returning in this case. So, the manpage claim of "This
> >> return value may be less than the total number of requested bytes, if
> >> an error occurred after some iovec elements were already processed."
> >> does not reflect the reality in our case because the return value will
> >> be -ENOMEM. After the desired behavior is finalized I'll modify the
> >> manpage accordingly.
> > Since process_madvise() might be used in sort of non-cooperative mode,
> > I think that the caller cannot guarantee that it knows exactly the
> > memory layout of the process whose memory it madvise’s. I know that
> > MADV_DONTNEED for instance is not supported (at least today) by
> > process_madvise(), but if it were, the caller may want which exact
> > memory was madvise'd even if the target process ran some other
> > memory layout changing syscalls (e.g., munmap()).
> > 
> > IOW, skipping holes and just returning the total number of madvise’d
> > bytes might not be enough.
> 
> Then does the advised bytes range by default including holes is a
> correct design?
> Say the [start, len) range passed in the iovec by the user contains the
> layout like, vma1 -- hole-- vma2 -- hole -- vma3.
> 
> Under ideal case, where all vma's are eligible for advise, the total
> bytes processed returning should be vma3->end - vma1->start. This is
> success case.
> 
>  Now, say that vma1 is succeeded but vma2(say VM_LOCKED) is failed at
> advise. In such case processed bytes will be
> vma2->start-vma1->start(still consider hole as bytes processed), so that
> user may restart/skip at vma2, then continue. This return type will be
> partially processed bytes.
> 
> If the system doesn't found any VMA in the passed range by user, it
> returns ENOMEM as not a single advisable vma is found in the range.

As I mentioned in other reply, let's do not make any exception(i.e.,
skipping hole) for vectored memory syscall but exact processed bytes
on the exact ranges.
