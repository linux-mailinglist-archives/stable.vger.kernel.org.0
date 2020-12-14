Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5792D9542
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 10:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgLNJ2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 04:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391739AbgLNJ2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 04:28:21 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C89C0613D3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 01:27:40 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id m12so28430203lfo.7
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 01:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mlnOgRlYfdWWAtF0jT9VPpITSWK8EzRly1RHNCoFmLA=;
        b=xr6HjhuGFyztbp4aNTyix9tdk+oG9PipBRVB5d1A9QYCuxTk5o8ERogp6kz9yPpsi8
         YbC8XV+qRfA0o7FFGZgtsBUWYBuTQn6U0MWTZWNKK9U211wBbXgLzPIaNPVgS3DlziX1
         7hYtnbfOlpkQmQbKfJXAZGTixMaMAD1htXm7z/4HEmErgO0dTe0Qro86Vmzr/DF+uE+e
         DNUCMqMQxNik8oltpgib0H1gb3pwpP2vxc5Nu4O+6cPj5zcREApt++HW4JDG7Nr/0blT
         MwGCQyUw2E6TtSJ1IoeRuwEkmobduSOksXdPhzaykVgeWO8ez3Xf5TPDYo5U9u/Ah74l
         U7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mlnOgRlYfdWWAtF0jT9VPpITSWK8EzRly1RHNCoFmLA=;
        b=E619LHDdugDlPfabkJVFy5PYDscuW162/lsBzBlegPCv6gilFQGCNwdb2hEldoA62g
         Ic5WdtdAmkjAxrSjhEh9DfVTOh91irglqElhjfiVt4J/1BXODQs8fQK/Jpoat5yjeFW/
         s8GADoXZQl/Igp4CLcRYUT6NeHMN1PLDb1NWs2b27bpr+MQyDTIH3NkaCAovvp1NZwJB
         ppc3YYUUW4qp0ytqN9binc4uAm87Kz2bWmZ65c7LXdKlrRkW2PQiv77VHGdyQDqiul/s
         GH1e3ELPicBTdIQMVe5QG8g08m1v0maw6Ccx/Wmi+9TwvcX/Qf5Ahk6TSjuPXIoIm7MK
         cSBw==
X-Gm-Message-State: AOAM532wqFhAG4VDMktlIjaXOCVeD1UHZd2hcmVzNaL85MGNoQ2zzpCt
        tjwT2oAyojCGB4yVWEpBGi+9A5vhpC1FXLNgmvlEIw==
X-Google-Smtp-Source: ABdhPJzGfF/vu7nSSKr0Z061mb6vkrp+fqfxWfVG1o+XueFjyYMpJ9Qse/CDkKG2bP6HvYJNDDf/q/VcH1TqwB7Wg4c=
X-Received: by 2002:a19:6557:: with SMTP id c23mr8730637lfj.157.1607938059529;
 Mon, 14 Dec 2020 01:27:39 -0800 (PST)
MIME-Version: 1.0
References: <20201213225517.3838501-1-linus.walleij@linaro.org> <cc06e06b-ff24-68a2-f5f3-c8533118a34d@redhat.com>
In-Reply-To: <cc06e06b-ff24-68a2-f5f3-c8533118a34d@redhat.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 14 Dec 2020 10:27:28 +0100
Message-ID: <CACRpkdZp+gnJAo02OJkiN_KUX3bOPc2vzQGWHLZF2hQHvuQQkw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: ux500: Reserve memory carveouts
To:     David Hildenbrand <david@redhat.com>
Cc:     arm-soc <arm@kernel.org>, SoC Team <soc@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pavel Procopiuc <pavel.procopiuc@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>, wi nk <wink@technolu.st>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 10:21 AM David Hildenbrand <david@redhat.com> wrote:

> > ARM SoC folks: please apply this directly for fixes.
>
> Can we come up with a Fixes: tag or has this been broken forever?
> (assuming modern boot loaders)

It's been broken forever :/

> > David: just FYI if you run into more of these type of
> > regressions. Actually the patch is unintentionally good
> > at smoking out other bugs :D
>
> Thanks for CCing - I'm adding some people that ran into similar issues,
> but not sure if the other bugreports are related (or have similar root
> causes).

Yeah we first were convinced there was something wrong with
the patch you made but I read it over and over again and there
is nothing wrong with it at all. It just alters the behaviour pattern of
memory management in some apparently drastic ways.

After a lot of silent crashes I finally got an external abort with
a reasonable backtrace showing the PTE pointing to this
modem memory and then we figured it out.

Yours,
Linus Walleij
