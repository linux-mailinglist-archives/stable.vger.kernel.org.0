Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C934CEE45
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 23:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiCFWyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 17:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiCFWyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 17:54:15 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D891593A4
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 14:53:22 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id x200so27583860ybe.6
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 14:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aOFdIQOlVmlBWlpoZ05a42UXG2GAYDcAvHWPoMhLF6Y=;
        b=i7WabAua26mjY3a5WtaA5VDmzDVUekD8MMdQcav1qF3C7Ud8MaRrKMp+DNjRmVJt2Y
         oNjOOx8IH9CYX/gfsTV1J+zYnxBnJ7Bb4FBwXB9IObmEcnLdVkuwau+Arl0OhbwBRfYd
         +a6Ui5hhMNmiUXspr5zeeWWrB8E+4lvNOzxlFj6CEqInhmGE6bx1fCYeakSj1qpHl8pq
         j0xt7Jkc+/8Jf/DQ9t8qPPwuP3c4Qsp5XxSJzsYR9j6Z5CtorVsDosI+2VtlfxuQKmdb
         D6eSDRfrWzNdsykTCJ326plBrUtGjsCGcmAJDc5DAOIZbDglg1i77iEusec47biVNQra
         Gtpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aOFdIQOlVmlBWlpoZ05a42UXG2GAYDcAvHWPoMhLF6Y=;
        b=dIpOfyQYqDvOIWDkjvmwHOmTsBVOMU+hdKynMmCCiQGm/xcLmoKHaCIDV7AB2VhNTt
         ZJ6r5wHlBdifsmkYuA5PEXp9yZ/ebY3dPJjxIPC7dKME4vMkyNnDoPCRi6nRCSi7FCFb
         14CChTOude5A+DA3N9OXZUrOOPjxVER79Skei23lPSg7pd7v6rdvJGf2/AzjDznOv1A1
         MoSllEYiOmnKggmAMjUtgBJub0sHh8on8D3VGekTRtjub8zwOuScar+Ish7RJQsw1k/v
         O7x3CWa+xuu0YJO2sDaZo5Dt4PiPaYNTQjyhB5IqP467ZA9MZfxjGHZ/+u3kvNeQLC26
         /gDA==
X-Gm-Message-State: AOAM532uON5OItEyHOi3kbW2qnB89C3hoDp9EFx0wXdkXlFr5XuflQZd
        N6JVgHh1awQnnszlOAaty881xGXoz/Y1JgH2+yVzNQ==
X-Google-Smtp-Source: ABdhPJwok5XfMECSCDQHY0u+nvF6M6DH/WYoxQ0OFIb6O9M6xkjjyTQDLgKGF5oVPxSwaaqjVAswicq60XpllwBnaN8=
X-Received: by 2002:a25:fe04:0:b0:628:af01:f734 with SMTP id
 k4-20020a25fe04000000b00628af01f734mr6163099ybe.441.1646607201347; Sun, 06
 Mar 2022 14:53:21 -0800 (PST)
MIME-Version: 1.0
References: <1646559441105125@kroah.com> <YiUssomamBu84L/v@sashalap> <YiUuo8o9+OKkNs1u@kroah.com>
In-Reply-To: <YiUuo8o9+OKkNs1u@kroah.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Sun, 6 Mar 2022 14:53:10 -0800
Message-ID: <CAJuCfpH+bSx7jtqfSwrZkKxFrp+b8sc5zRixrEFCKh_-xSnQkA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mm: prevent vm_area_struct::anon_name
 refcount saturation" failed to apply to 5.15-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <brauner@kernel.org>, caoxiaofeng@yulong.com,
        Colin Cross <ccross@google.com>,
        Chris Hyser <chris.hyser@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        David Hildenbrand <david@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        legion@kernel.org, Michal Hocko <mhocko@suse.com>,
        Peter Collingbourne <pcc@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 6, 2022 at 1:59 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Mar 06, 2022 at 04:50:42PM -0500, Sasha Levin wrote:
> > On Sun, Mar 06, 2022 at 10:37:21AM +0100, gregkh@linuxfoundation.org wrote:
> > >
> > > The patch below does not apply to the 5.15-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > ------------------ original commit in Linus's tree ------------------
> > >
> > > > From 96403e11283def1d1c465c8279514c9a504d8630 Mon Sep 17 00:00:00 2001
> > > From: Suren Baghdasaryan <surenb@google.com>
> > > Date: Fri, 4 Mar 2022 20:28:55 -0800
> > > Subject: [PATCH] mm: prevent vm_area_struct::anon_name refcount saturation
> > >
> > > A deep process chain with many vmas could grow really high.  With
> > > default sysctl_max_map_count (64k) and default pid_max (32k) the max
> > > number of vmas in the system is 2147450880 and the refcounter has
> > > headroom of 1073774592 before it reaches REFCOUNT_SATURATED
> > > (3221225472).
> > >
> > > Therefore it's unlikely that an anonymous name refcounter will overflow
> > > with these defaults.  Currently the max for pid_max is PID_MAX_LIMIT
> > > (4194304) and for sysctl_max_map_count it's INT_MAX (2147483647).  In
> > > this configuration anon_vma_name refcount overflow becomes theoretically
> > > possible (that still require heavy sharing of that anon_vma_name between
> > > processes).
> > >
> > > kref refcounting interface used in anon_vma_name structure will detect a
> > > counter overflow when it reaches REFCOUNT_SATURATED value but will only
> > > generate a warning and freeze the ref counter.  This would lead to the
> > > refcounted object never being freed.  A determined attacker could leak
> > > memory like that but it would be rather expensive and inefficient way to
> > > do so.
> > >
> > > To ensure anon_vma_name refcount does not overflow, stop anon_vma_name
> > > sharing when the refcount reaches REFCOUNT_MAX (2147483647), which still
> > > leaves INT_MAX/2 (1073741823) values before the counter reaches
> > > REFCOUNT_SATURATED.  This should provide enough headroom for raising the
> > > refcounts temporarily.
> >
> > I think that this patch depends on 78db3412833d ("mm: add anonymous vma
> > name refcounting") which we don't have in any of the stable trees. (is
> > this why it wasn't tagged for stable?).
>
> Suren said he would provide a backport on Monday, so let's see what he
> comes up with :)

Ah, right. We don't have anonymous vma name support in 5.16 or earlier
kernels, so this patch is indeed not needed there.

>
> thanks,
>
> greg k-h
