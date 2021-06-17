Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1923AAF41
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 11:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFQJEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 05:04:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231352AbhFQJEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 05:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623920546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uLAb2LWOWOji+4QIg5CxEI4uB4pyxF2B9IUfZkfCsDc=;
        b=WUOF5pg+5SPDFFP14f2cpbDIZSlsWJGMJ+uafFi9DgEDL17hmI9YFwoLzz0Ga1Rd9TRWEx
        hCU7NpzpSywWDtJ8DLOpnAzuP6MoCzz7wI+lIxFBoWKSIptmTXAeWAJxKAQW0U/t5XPu3O
        BR2RLrMsWlutkH1sq2SHvHhRMcl1sk4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-70B3GBR6OMmSMh7ol99PWA-1; Thu, 17 Jun 2021 05:02:24 -0400
X-MC-Unique: 70B3GBR6OMmSMh7ol99PWA-1
Received: by mail-ed1-f70.google.com with SMTP id u26-20020a05640207dab02903935beb5c71so1150564edy.3
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 02:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uLAb2LWOWOji+4QIg5CxEI4uB4pyxF2B9IUfZkfCsDc=;
        b=SzRtCuFyMCQZrQ2tr2uUFid/2dwZyxOCCH3ts2dhbcnDrraxQRoNv9qpVM9IVuZx2t
         21kWjhMis7szNHjh6p8sNBBJIGAjozKuTTm0J1qLXchq1yQAIipox1rDzUCXc+L+ys3D
         c6P+f7tn73Km3xIHqeLQh5wOYPDBijNDEVZ1GYHtMGXMy3R9oWV7YUS6U24KotVFAJRb
         5Aoy/sUtF0EuXOxZ+L63gWBIAIrNlQ0fkWmvI+cDC+ZMepmafqMXwE/XMJ7GgX4I96Kr
         rPs2Y3HzLRGGsmp3FEw0jB5VifoM44QKBT0jkU3fqYEzrAqQ/GE4iKEPj+wIWcvDfOPP
         kGbA==
X-Gm-Message-State: AOAM530MPYm24emUuNVggnPpFwr8BMKoiGDtg/MnnNsN2AASjw/16TLf
        8s1SGQvXBq/I9P1AxkueYX8zdAyV9Z9ne95EqqDrngYFRjSyxCuhxbazLfm2/dcAJHb/Rqyq4Gn
        7H3K8GAUilWyVg+r1
X-Received: by 2002:a17:906:3402:: with SMTP id c2mr4129523ejb.213.1623920543649;
        Thu, 17 Jun 2021 02:02:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzogSU+ufXCMZzwMM0twjtu/A99aCzJYDHKy42Qiq22+cRh/KkDm9wZRCIVPMGJ4b/rkw+22Q==
X-Received: by 2002:a17:906:3402:: with SMTP id c2mr4129502ejb.213.1623920543441;
        Thu, 17 Jun 2021 02:02:23 -0700 (PDT)
Received: from krava ([83.240.60.126])
        by smtp.gmail.com with ESMTPSA id t15sm3412610ejf.119.2021.06.17.02.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 02:02:23 -0700 (PDT)
Date:   Thu, 17 Jun 2021 11:02:21 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Mark Wielaard <mark@klomp.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Frank Eigler <fche@redhat.com>
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
Message-ID: <YMsPnaV798ICuMbv@krava>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
 <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com>
 <YMopCb5CqOYsl6HR@krava>
 <YMp68Dlqwu+wuHV9@wildebeest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMp68Dlqwu+wuHV9@wildebeest.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 17, 2021 at 12:28:00AM +0200, Mark Wielaard wrote:
> Hoi,
> 
> On Wed, Jun 16, 2021 at 06:38:33PM +0200, Jiri Olsa wrote:
> > > > diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> > > > index d636643ddd35..f32c059fbfb4 100644
> > > > --- a/tools/bpf/resolve_btfids/main.c
> > > > +++ b/tools/bpf/resolve_btfids/main.c
> > > > @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
> > > >   	if (sets_patch(obj))
> > > >   		return -1;
> > > > +	/* Set type to ensure endian translation occurs. */
> > > > +	obj->efile.idlist->d_type = ELF_T_WORD;
> > > 
> > > The change makes sense to me as .BTF_ids contains just a list of
> > > u32's.
> > > 
> > > Jiri, could you double check on this?
> > 
> > the comment in ELF_T_WORD declaration suggests the size depends on
> > elf's class?
> > 
> >   ELF_T_WORD,                   /* Elf32_Word, Elf64_Word, ... */
> > 
> > data in .BTF_ids section are allways u32
> > 
> > I have no idea how is this handled in libelf (perhaps it's ok),
> > but just that comment above suggests it could be also 64 bits,
> > cc-ing Frank and Mark for more insight
> 
> It is correct to use ELF_T_WORD, which means a 32bit unsigned word.
> 
> The comment is meant to explain that, but is really confusing if you
> don't know that Elf32_Word and Elf64_Word are the same thing (a 32bit
> unsigned word). This comes from being "too consistent" in defining all
> data types for both 32bit and 64bit ELF, even if those types are the
> same in both formats...
> 
> Only Elf32_Addr/Elf64_Addr and Elf32_Off/Elf64_Off are different
> sizes. But Elf32/Elf_64_Half (16 bit), Elf32/Elf64_Word (32 bit),
> Elf32/Elf64_Xword (64 bit) and their Sword/Sxword (signed) variants
> are all identical data types in both the Elf32 and Elf64 formats.
> 
> I don't really know why. It seems the original ELF spec was 32bit only
> and when introducing the ELF64 format "they" simply duplicated all
> data types whether or not those data type were actually different
> between the 32 and 64 bit format.

nice, thanks for details

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka

