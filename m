Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFCD4734A5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbhLMTGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbhLMTGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:06:04 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BBDC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:06:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l25so55824652eda.11
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aeg0qZoqwBz2YeITn5N/MdhGJK25+H4D5wmM2wOoIDQ=;
        b=eq/NYPxr+/3OXWhGOjuz7PoDcEoOxFDTk8/gC8xQriKEUka73c3Egjtm++qkWh/blv
         /tuskbqyiivPHlT0BQLVcts8BsayE5ce7IDChuYdfquWaAdh1WSt38alodQHeG4+xIUp
         w1A63XOlsc2pCYT1nXFNPllugkOK3vHyTecLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aeg0qZoqwBz2YeITn5N/MdhGJK25+H4D5wmM2wOoIDQ=;
        b=gxEIwguzHGgHw24O0dt7NuvMmh1RfhlKQD/r4Ru8zn3fv6Iene/+fsbQ66oDZ86I/7
         rscU3h4rlpIvOk3EpVpKHCZnsspOsa5QuGaN6Ow0VDZmcpx5xlJnHd6Xp9kfzbkd6lhd
         kHpKN6fPhl0ssyyLSmD6KRrQGJ6ECqqgoarL3UT4YTkmVKMB+miDPrVc951Rvxs+7818
         n2IKM3rTfErZyxSwU8/5Fc/93yUQ1n7b/nLdtP3l2CutcuvMMP/WpuysNGZ5ClSB0HGf
         lR68FfcbXzRlpCg3zzan93AeRNMi/0SND46anFKT9VgNoforRPJY+K3o6E2VHr+p/rpV
         ZEbw==
X-Gm-Message-State: AOAM532mrd1yh84Tq3LdLUpJPVvZ26sSQFiEQPGerxjRG0e67SAjJ8n5
        Ly+j8PY5952iv7uRh2ueN6Pu8OtbPCWme5dk
X-Google-Smtp-Source: ABdhPJwqVdHaXS6VirEWzK97+Rxe30VjqvcPfggs8ZW+mnx3yGcxGgeQXvu9NBaHU2TO8gxG/WcWjQ==
X-Received: by 2002:a17:906:8145:: with SMTP id z5mr206102ejw.519.1639422361464;
        Mon, 13 Dec 2021 11:06:01 -0800 (PST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id 12sm451223ejh.173.2021.12.13.11.05.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 11:06:00 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id k9so10957503wrd.2
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:05:59 -0800 (PST)
X-Received: by 2002:adf:8b0e:: with SMTP id n14mr365289wra.281.1639422359361;
 Mon, 13 Dec 2021 11:05:59 -0800 (PST)
MIME-Version: 1.0
References: <20211213092930.763200615@linuxfoundation.org> <CADVatmPsqW050=k07RDChjnf_F+MJfkLzHiRcdeoWQ7Mws_qMw@mail.gmail.com>
 <CADVatmMMe7NGpX9CcViLrhxP69gJ6m+9rViEVuh0E6j1QXGDVg@mail.gmail.com>
In-Reply-To: <CADVatmMMe7NGpX9CcViLrhxP69gJ6m+9rViEVuh0E6j1QXGDVg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Dec 2021 11:05:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh14HQZHWr=aNjpKrq-dP51iA6YbL3LmZGEVsOkWL-9XA@mail.gmail.com>
Message-ID: <CAHk-=wh14HQZHWr=aNjpKrq-dP51iA6YbL3LmZGEVsOkWL-9XA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59 AM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> >
> > Just an initial report. mips allmodconfig is failing with the following error.
>
> Ignore this please. I am not seeing the error on a clean build. Need
> to check what went wrong with my build script.

The gcc plugin builds often fail if there's been a gcc version update,
and you need to blow the old plugins away.

We do not have the full dependencies for system tools, and that might
happen with other incompatible system updates too.

But practically speaking, the gcc plugins are the only thing in the
kernel build that regularly cause problems.

             Linus
