Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A63295070
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502849AbgJUQMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502848AbgJUQMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 12:12:05 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11347C0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 09:12:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so1734424pfn.12
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 09:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=pjUFlnUt0sVqVNyXUeX+2nYGGLuzFr1RFnAsc9/hEZc=;
        b=JCger6du92m4uwhDkZiF26D9g8XCS3IORIK1mOhO1qFNmYhHtF/mFbu6yQx24U7B2z
         FzYMJ03BMOmbBWbWA2VbdvUVXqQJXNn1nzcKmD0NoRL8k/0iL7k7toPtuTTYLOOCH6pt
         cIUfsq6GHJPz94pdNX9yQU2rrmUpxApasi2uw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=pjUFlnUt0sVqVNyXUeX+2nYGGLuzFr1RFnAsc9/hEZc=;
        b=uJdMstmuN0AHlobXivsnGTnCfncBaQghb/0BCU4hASszCJqyvz/pEST9ik+kfj1sXw
         CcnlKcfN/FtEKYUAi0xi+WrJ3eCRRgscsx6AckG8N9ncVMBIoTQNC5eM7oKgfrZyN7og
         KInPayvvuk3iNvLzmJl97sWHNQP3bdyfyKsf1o2AChB0pnny8aIRkOA3BqyjyqMfBfhk
         6VBIWlRdLuMVtJDBWxhbnD3RLKwB+CmnqURfK9QA29ECfU/flBZ3tEdn+m8XkXGy8fxc
         RxRdoHCwDL5EiJYWtNK90uh1GfJ2wXpjkb7N7QW/zpivyvKwd8nDmgpV6ldp7v4jRXHO
         K3rg==
X-Gm-Message-State: AOAM533Wjbi9GonGVapESOalOEiDFfMvYK7c9bFof0YqPFhzHBfE62/a
        qYNrnwplgMicpA0uLPuOSskd2yavFZGtNA==
X-Google-Smtp-Source: ABdhPJy2tdWNalf6KEessz3fjq5gBCehPaa8JHjz83PsXY3krrxY+BLqr8tr8gywsLgOTQFh/BGoWg==
X-Received: by 2002:a62:8c55:0:b029:152:b326:9558 with SMTP id m82-20020a628c550000b0290152b3269558mr4171999pfd.72.1603296724583;
        Wed, 21 Oct 2020 09:12:04 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id g15sm2881355pgi.89.2020.10.21.09.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 09:12:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201021154909.GD18071@willie-the-truck>
References: <20201020214544.3206838-1-swboyd@chromium.org> <20201020214544.3206838-2-swboyd@chromium.org> <20201021075722.GA17230@willie-the-truck> <160329383454.884498.3396883189907056188@swboyd.mtv.corp.google.com> <20201021154909.GD18071@willie-the-truck>
Subject: Re: [PATCH 1/2] arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
To:     Will Deacon <will@kernel.org>
Date:   Wed, 21 Oct 2020 09:12:02 -0700
Message-ID: <160329672229.884498.3370140649393072677@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Will Deacon (2020-10-21 08:49:09)
> On Wed, Oct 21, 2020 at 08:23:54AM -0700, Stephen Boyd wrote:
> >=20
> > If I'm reading the TF-A code correctly it looks like this will return
> > SMC_UNK if the platform decides that "This flag can be set to 0 by the
> > platform if none of the PEs in the system need the workaround." Where
> > the flag is WORKAROUND_CVE_2017_5715 and the call handler returns 1 if
> > the errata doesn't apply but the config is enabled, 0 if the errata
> > applies and the config is enabled, or SMC_UNK (I guess this is
> > NOT_SUPPORTED?) if the config is disabled[2].
> >=20
> > So TF-A could disable this config and then the kernel would think it is
> > vulnerable when it actually isn't? The spec is a pile of ectoplasma
> > here.
>=20
> Yes, but there's not a lot we can do in that case as we rely on the
> firmware to tell us whether or not we're affected. We do have the
> "safelist" as a last resort, but that's about it.

There are quite a few platforms that set this config to 0. Should they
be setting it to 1?

 tf-a $ git grep WORKAROUND_CVE_2017_5715 -- **/platform.mk | wc -l
 17

This looks like a disconnect between kernel and TF-A but I'm not aware
of all the details here.

>=20
> >=20
> > Does the kernel implement a workaround in the case that no guest PE is
> > affected? If so then returning 1 sounds OK to me, but otherwise
> > NOT_SUPPORTED should work per the spec.
>=20
> I don't follow you here. The spec says that "SMCCC_RET_NOT_SUPPORTED" is
> valid return code in the case that "The system contains at least 1 PE
> affected by CVE-2017-5715 that has no firmware mitigation available."
> and do the guest would end up in the "vulnerable" state.
>=20

Returning 1 says "SMCCC_ARCH_WORKAROUND_1 can be invoked safely on all
PEs in the system" so I am not sure that invoking it is from a guest is
safe on systems that don't require the workaround? If it is always safe
to invoke the call from guest to host then returning 1 should be fine
here.

My read of the spec was that the intent is to remove the call at some
point and have the removal of the call mean that it isn't vulnerable.
Because NOT_SUPPORTED per the spec means "not needed", "maybe needed",
or "firmware doesn't know". Aha maybe they wanted us to make the call on
each CPU (i.e. PE) and then if any of them return 0 we should consider
it vulnerable and if they return NOT_SUPPORTED we should keep calling
for each CPU until we are sure we don't see a 0 and only see a 1 or
NOT_SUPPORTED? Looks like a saturating value sort of thing, across CPUs
that we care/know about.
