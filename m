Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8903DE1C9
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 23:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhHBVor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 17:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhHBVoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 17:44:46 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59A5C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 14:44:36 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id a7so25683035ljq.11
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 14:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1Zn1dHNcAo55UWjf9UAwAe/+iNEFF6IvInOoH/fLVM=;
        b=sVhHg/iqD7K59RQFudyF+04kzy5TJm6/fmvMslbAoRf0FYWSPyPqCTkLndbPkMwjUM
         EQkOYp+m8CnGKTBvOnM8J2q8B0AJhMvPoH5kNqcIqwEx+RWQ4Hw5nvp1gAUnhAevt+x3
         Rdh0NQsuNBQcV7gF8C+MV61Q3mx7FP2ygQ4RE2Pa5JLUPi1qxOovnQ3FA1bhZqrQ1Fyx
         Y9GeKz3Hw9ZAql7uiJD6EyNoHBuTVW6wKQ1ePOieF8QUjx+Ajfw8Cl4pq+BsrrzI3bsN
         K6IaM0SjsGT+GMmsVjNse/vpLB0jQAQy5F0ywvxxzmEDGnS5TtDggZsEXyR2TNouR3wM
         huSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1Zn1dHNcAo55UWjf9UAwAe/+iNEFF6IvInOoH/fLVM=;
        b=BQ+bT7fPgHcndQLtD9MWm0DvSBIlAPdR6dKeW1jdDuKhL8puMpi8m1UVjSHNbu7o2S
         yqDUUYG04Cnzki5SMqagUh+H+fZJ1UfsEPw5Z45mN9+qWOv2SK/gDts+mThZqU4EzDz1
         JsgyejjWXYLzcOHoP1fh4F9Fw6dQaUyIIODjdbFsPFfO0deW764njygFuA/WZbNLG9d+
         B7lHNRE7QFvllLg/2dNKhU+3xO0vkKezmlakwGnBHH/Y3FH08BFQDCAfP9t6CAwucG4f
         qos/P4rYQgOgtirdRj8K0NaG0hx2XRES1s13oGG+HYaIU71hnH0EgnVBDYH0X4hkDYxB
         oYPg==
X-Gm-Message-State: AOAM530uPUZW9phBQ/SAHolfC+OFkcyqaizb1j5Q/AcyPv7MC9YsCaeP
        6cEA2SqWIRCMdwRgvH0Ao0hUgXDvxrXJQP8SN3oIqQ==
X-Google-Smtp-Source: ABdhPJwCTBp6qWzbw/PA8xgViv+BlPnAGGyU0ftiBpG3bke6G2EQEqhwmMYZXlxtBDipMh9fzzt6s9nJ8XUFEmlF6eo=
X-Received: by 2002:a2e:888f:: with SMTP id k15mr12570930lji.326.1627940675101;
 Mon, 02 Aug 2021 14:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <1406720038.945.1627915387982@localhost> <a41ca429-9480-9ecf-242b-5e68fade3c10@kernel.org>
 <YQhGFU85Q4k1dKfe@sashalap>
In-Reply-To: <YQhGFU85Q4k1dKfe@sashalap>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 2 Aug 2021 23:44:24 +0200
Message-ID: <CACRpkdahn4C-JEPD8VHWA7BgX9=tZ8UVB67w-B-wGZioTaBv_Q@mail.gmail.com>
Subject: Re: [CI-NOTIFY]: TCWG Bisect tcwg_kernel/llvm-release-arm-stable-allyesconfig
 - Build # 4 - Successful!
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linaro-toolchain@lists.linaro.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@linaro.org>, ci_notify@linaro.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 2, 2021 at 9:23 PM Sasha Levin <sashal@kernel.org> wrote:
> On Mon, Aug 02, 2021 at 10:28:02AM -0700, Nathan Chancellor wrote:
> >On 8/2/2021 7:43 AM, ci_notify@linaro.org wrote:

> >Greg and Sasha,
> >
> >Please cherry pick upstream commit 7e2bb83c617f ("power: supply:
> >ab8500: Call battery population once") to resolve this build error on
> >5.13.
>
> Queued up, thanks!

Thanks for pinpointing this patch Nathan!

Yours,
Linus Walleij
