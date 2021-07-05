Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC78E3BB78B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGEHOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEHOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 03:14:07 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11659C061760
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 00:11:30 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 11so19785185oid.3
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 00:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cZxArIjNZiHAGrhe17Yt+MUgYkYYP6oVJyNePuaLvQo=;
        b=jt+4gUW9plZiaS9YkEY8ki1HyDF9NdX/e/lcWCxHXtVTkxPsdM/atRLxcFXqW9EKoQ
         Yk+8PFQjcYz6Gh7CdGvunOQmap638MzLaAlLksr++j9bHRlLbL8wV5nO8nX1EWcFpoQt
         sbhgTYq57PEOz8AZOImm/t05oInCAxLY6CmCGLfkAt3POBqiwYogq3YKLydmmNEbdjCO
         CP3Y5Q8/vG+jn1uGyJDr1OUJZ0HnyhP1yka5f3m+DaUCZuRmchZwBw1HtSM8PLqvYlGE
         lyPVZfHn1/aqNmhTBnX7KhboGSZBOlkeQR126yinmckoYg/AQm+OmDXVrqaz5R6vWJQu
         libg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cZxArIjNZiHAGrhe17Yt+MUgYkYYP6oVJyNePuaLvQo=;
        b=QQFmocrgxcq76tc9mZcrl+C2HszdAdpaLXeAFB8+PysimHXu/KXYmqE25Qsr6LgST3
         c3xL6/hAazH5TrwtZSZPrpw5y/QHzVoSOc4qRbHZbLr+n9xY+Pw+juX6YtwhOo3r7zKp
         fQzIsWDeN436KJM0JhfSeYDQ74nXLiFVP2nOPh9CmiYdyQgIbX1PIY22PQwiqZKjCjcF
         muZU7OD/joho+uVv3H3mod9Bsoa+lBTY5RoOBDE980gio8zMcB/XdpEspWgeWKPgu+6t
         1EeeuDqSG4zkve20cF+123p+tb+c3VWQXuspBtHMV5Jr+w0YoQUUr6677wHyfV70HfCE
         7gRw==
X-Gm-Message-State: AOAM530lRThMigzNyOQHw4act5aXMnUE6p0747k+4EneOCL/GgaOKRvL
        z0UWX/6yrUVdYN4uvuwFPxOjmjmwOqrbEP9IL5Cz/Q==
X-Google-Smtp-Source: ABdhPJwxa4HxU03oGoZBalOKZcT2rSN8GgCgw22jAVdG6FeLKxYuzpzdZSzAMBm9hF/iaaAMYRfNBM3gbYi48NnAF8c=
X-Received: by 2002:a05:6808:158b:: with SMTP id t11mr9184452oiw.8.1625469089197;
 Mon, 05 Jul 2021 00:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210628142607.32218-1-sashal@kernel.org> <20210628142607.32218-50-sashal@kernel.org>
 <20210703152144.GB3004@amd>
In-Reply-To: <20210703152144.GB3004@amd>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 5 Jul 2021 08:10:47 +0100
Message-ID: <CA+EHjTzO5Tsns4c6-7qXsyRtyGRwf4Yf_rBAPaVF303R1ih3EA@mail.gmail.com>
Subject: Re: [PATCH 5.10 049/101] KVM: selftests: Fix kvm_check_cap() assertion
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 Hi Pavel,

On Sat, Jul 3, 2021 at 4:21 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > From: Fuad Tabba <tabba@google.com>
> >
> > [ Upstream commit d8ac05ea13d789d5491a5920d70a05659015441d ]
> >
> > KVM_CHECK_EXTENSION ioctl can return any negative value on error,
> > and not necessarily -1. Change the assertion to reflect that.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> This is userland code, right?
>
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -55,7 +55,7 @@ int kvm_check_cap(long cap)
> >               exit(KSFT_SKIP);
> >
> >       ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
> > -     TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
> > +     TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
> >               "  rc: %i errno: %i", ret, errno);

There's at least one case that I am aware of that potentially would
return a value other than -1 on error, which is a check for
KVM_CAP_MSI_DEVID (-EINVAL, -22):

https://elixir.bootlin.com/linux/latest/source/arch/arm64/kvm/arm.c#L229

Also, considering that this is test code, it might be good to have the
check be as strict as possible.

Cheers,
/fuad

> And syscalls return -1 on error in userland, not anything else. So
> this should not be needed.
>
> Best regards,
>                                                                 Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
