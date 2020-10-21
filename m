Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C328A2954A4
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506544AbgJUWGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 18:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506461AbgJUWGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 18:06:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE53C0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 15:06:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 144so2310137pfb.4
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 15:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=IK+ZMP2az0RfPWcNkCMoV3EvgaO3Q2+DaxT88xfq70s=;
        b=BHInRJZgPQYw3GolT2+P917F3CtK3B8WgMft9Alp2/I+WOKq9JqCMQKJK3RU0DDC5O
         uNaO25XfQEfIKgjWpoDj7b4bKjpTZzqr8JT5Fy8/NTu1j610//2wrmIPrsuPjC/mNrpB
         McmoPnHMSK4nrvJQAFXU+LbLYUmj1DeEMUm+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=IK+ZMP2az0RfPWcNkCMoV3EvgaO3Q2+DaxT88xfq70s=;
        b=IRHVRz9qXpjyxan6+1gGnUmux6kzxj36SzgbRh1y2wlyTJm/EzNgav6rOnPwyZKuMo
         p2JZg+OCy24Pt6mExYwenxq/GguntahSTh7ewSfMhG6+PD9nIccJYCs5q83pYiem62fy
         yx1ei7k9oK84SzcrvCVK9bnc+wUSDPjSxndShLGTgHGkVN+MrXKDrvJ/kLAbdutNvqec
         13vQW40Qq6oxzpA+pg56ZGCQ47PKGlYvo6wpd9DOz/obtTrWG4qUdLW2qwqqaYo8ccG3
         CmWwwHOtau77FVNDWw4jq503dJ8bDWzksExx/VG+Tn+uPxkKONE7QczZoVMtvEH31d5+
         3dZw==
X-Gm-Message-State: AOAM5332NxQVvCxpZFKXyY8ntahhSvtf0I7fzTBSUrheYs2uu8EowuOT
        LroSdSxMAodGop+CKjkeM4gbMg==
X-Google-Smtp-Source: ABdhPJwfIN8B8/sBkUHsjFMnj0A33TfVS6lON7NRuGhEjueahqVrrlMGzM6dQm51TqTvvEkyU5p7OA==
X-Received: by 2002:a63:1e0b:: with SMTP id e11mr5003372pge.72.1603317997512;
        Wed, 21 Oct 2020 15:06:37 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id b142sm3293301pfb.186.2020.10.21.15.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 15:06:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201021211326.GA18548@willie-the-truck>
References: <20201020214544.3206838-1-swboyd@chromium.org> <20201020214544.3206838-2-swboyd@chromium.org> <20201021075722.GA17230@willie-the-truck> <160329383454.884498.3396883189907056188@swboyd.mtv.corp.google.com> <20201021154909.GD18071@willie-the-truck> <160329672229.884498.3370140649393072677@swboyd.mtv.corp.google.com> <20201021211326.GA18548@willie-the-truck>
Subject: Re: [PATCH 1/2] arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
To:     Will Deacon <will@kernel.org>
Date:   Wed, 21 Oct 2020 15:06:35 -0700
Message-ID: <160331799505.884498.376133101315233761@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Will Deacon (2020-10-21 14:13:26)
> On Wed, Oct 21, 2020 at 09:12:02AM -0700, Stephen Boyd wrote:
>=20
> > My read of the spec was that the intent is to remove the call at some
> > point and have the removal of the call mean that it isn't vulnerable.
>=20
> No, the CSV2 field in whichever ID register is for that. We check that in
> spectre_v2_get_cpu_hw_mitigation_state().

Alright, makes sense!

>=20
> > Because NOT_SUPPORTED per the spec means "not needed", "maybe needed",
> > or "firmware doesn't know". Aha maybe they wanted us to make the call on
> > each CPU (i.e. PE) and then if any of them return 0 we should consider
> > it vulnerable and if they return NOT_SUPPORTED we should keep calling
> > for each CPU until we are sure we don't see a 0 and only see a 1 or
> > NOT_SUPPORTED? Looks like a saturating value sort of thing, across CPUs
> > that we care/know about.
>=20
> The mitigation state is always per-cpu because of big/little systems, the=
re
> just isn't a short-cut for the firmware to say "all CPUs are unaffected"
> like there is for SMCCC_ARCH_WORKAROUND_2 with its "NOT_REQUIRED" return
> code.
>=20

Ok. Can/should kvm be emulating the CSV2 bit that the guest sees? Just
wondering why I'm falling into this (ghost) trap in the first place.
