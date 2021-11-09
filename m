Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F43444AF44
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbhKIORk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 09:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbhKIORk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 09:17:40 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C79C061766
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 06:14:54 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j21so77035472edt.11
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 06:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35Sg/kjjFoX51dQQ64PItZWdmNgeLJSxHQmhQKr8pEo=;
        b=Yr2rb5Lzb2GOeBqUovyq2W5e/t5FUdpxiO9nNTMxUtJopCqkMdoKTk8ldtWq2htk9y
         ldwSTcGN6Snh/+A82H4zx1lDxDoRwjaM4shnBkU4TEiFbYJ+4KmAOC+uXjCdjRuN9kiP
         M+AK04QZlCWOcmVN79IH6viA2/UJbtlR8rVcDxEchb/spSxP/bpdU7ojHD4/UGJe83BV
         B436MFMoRMng3VXrBLqhqPoOVuFkUeQDZurbNiqg2ZteS4YkTVRjkGcNqxYtuuODYfKi
         5z1SwbP1FskerG6QymdzUga4sxKJpy+7ILe9GH7IsVv7K7tKeP8smdB6CRquaXC7WkBp
         L71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35Sg/kjjFoX51dQQ64PItZWdmNgeLJSxHQmhQKr8pEo=;
        b=sJ3jW9hAGzUBzWpS8cqi0BArY3gFCErZWpLAyBtjQPBay+s3vLpWwhz3ZC6th5PyKE
         KdZHNEOHp/caWZmNYGWkdcdw6hZcq3cPBzRcbewTZCHcr3XBDf5XaDkqklOpUmMi0JU9
         IC4rfMG0xgZx9ENK/5mm/cgrsJLwmLAWNIvGlJulpsYtB61pV1ifTttNZfn3TtROZBfk
         FH5Z0wZ6NxGDFsKxvQnqFTbIoZtaFrXhcU2gW43HN1AIj4i5aLaE+tqzt4XHnHlA83nt
         9gBWd0N5ketRlRWzZlkto3Rj84jIDjhsQCY/tkbKLF/bot159/1duCn1ocMaHAJEo4QR
         0VYQ==
X-Gm-Message-State: AOAM530YeA2HBO8x3R5s7X+Bta0ks1d3dY8mc5gbr6X8HVtcMtRAoccg
        qFVYuNX0msDCg9o9CLaARasdhDw1YLA3Zj+uA0y8kQ==
X-Google-Smtp-Source: ABdhPJy2jhGZSZW0YwIHsaG+Un9wKKPJzRkMy/xStg9kqI8zo4/hHzHqDfg0VQi6xjn1mLHYGfvVJu+WpjJRPyCZvSE=
X-Received: by 2002:a50:e184:: with SMTP id k4mr10632554edl.217.1636467292402;
 Tue, 09 Nov 2021 06:14:52 -0800 (PST)
MIME-Version: 1.0
References: <CADyq12yY25-LS8cV5LY-C=6_0HLPVZbSJCKtCDJm+wyHQSeVTg@mail.gmail.com>
 <cb682c8a-255e-28e5-d4e0-0981c2ab6ffd@intel.com> <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
 <CADyq12y0o=Y1MOMe7pCghy2ZEV2Y0Dd7jm5e=3o2N4-i088MWw@mail.gmail.com>
 <472b8dbf-2c55-98c9-39ad-2db32a649a20@intel.com> <CADyq12whSxPdJhf4qg_w-7YXgEKWx4SDHByNBNZbfWDOeEY-8w@mail.gmail.com>
In-Reply-To: <CADyq12whSxPdJhf4qg_w-7YXgEKWx4SDHByNBNZbfWDOeEY-8w@mail.gmail.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Tue, 9 Nov 2021 09:14:16 -0500
Message-ID: <CADyq12yrcJkxALo4muEnR3Nm2yyZAvtabN3RY4fm1DSqtNTF0A@mail.gmail.com>
Subject: Re: XSAVE / RDPKRU on Intel 11th Gen Core CPUs
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 9, 2021 at 8:43 AM Brian Geffon <bgeffon@google.com> wrote:

> What's interesting is that writing to init_pkru fails with -EINVAL for me,
> and I've traced it down to get_xsave_addr() returning NULL on the following
> check:
>
>   /*
>   * This assumes the last 'xsave*' instruction to
>   * have requested that 'xfeature_nr' be saved.
>   * If it did not, we might be seeing and old value
>   * of the field in the buffer.
>   *
>   * This can happen because the last 'xsave' did not
>   * request that this feature be saved (unlikely)
>   * or because the "init optimization" caused it
>   * to not be saved.
>   */
>   if (!(xsave->header.xfeatures & BIT_ULL(xfeature_nr)))
>      return NULL;
>

Sorry, I should have probably also shared the value of xfeatures at
this point is 0x3: which appears to be: (X86_FEATURE_FPU |
X86_FEATURE_XMM)

Brian
