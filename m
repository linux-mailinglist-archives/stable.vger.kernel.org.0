Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BE819A1AF
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 00:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgCaWJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 18:09:43 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34371 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgCaWJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 18:09:42 -0400
Received: by mail-ot1-f68.google.com with SMTP id m2so9087107otr.1
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 15:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ifrIprtCmZCzS2rJSxbv6FFXsExlpwqRTV97NQIJ9rs=;
        b=IgFFgsAWYaFEytOk8+1XW190BObyf7+0lOQae8kvvO91eG2YNPGCGIYDcNIgf8OD5c
         bbzyop+Ku5KhHsy0IwV12gH+siQ4xtMhSnbz01VygvXCE/pZwMLp1dv8yTX3DpoRRrbj
         aq+PShu3V8Rf1ggxGBtgAgMCIC40cy4erilzdOe7u4t2pmkxnzt53kuE9t9Ookgayq6u
         zZflX3MboDDfQAo1FermwmveXvPRUp8rm1jAhl1zctqw6fw0Z+5+hYRcTlsJX39MZpBt
         iGZUuWVvdQrz6g3XworAKW8B9XJQaUMb7R9l9cd35cM/w/g0U4TWdzrFyrqGixkH1McU
         PSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ifrIprtCmZCzS2rJSxbv6FFXsExlpwqRTV97NQIJ9rs=;
        b=I+/tXm5wEQ7m5YLM7u5XlYpFO0DLJVOuuTEhzauzHhBShFntajgsdFi52rjIQnuOaF
         CJ4AeOtFdVjDCSmzPQWBQ89QGnUGODUjIBHOLsZSHS/eW+feEsZXza0sUwqKcOx3x8xn
         Xosx6VGvCZKHokerwRr0/OL8WEeMWkSsjHzzx/Tpyrb7mwy4pfNOEbCrJKpfOs9OceYj
         V1Q5rHNmd4vmm1hCGlsnWOx7bW5imYcz5C/oysRKiQ7+gBKe59UQTqC7e9kTVHSRtvjF
         CcyUTX2ygMESOZbMPQRvM3e0Q1h716sxYDxSt/muZhrKT4TKvht8P8dJNWFL5teaZE5w
         5Y+Q==
X-Gm-Message-State: ANhLgQ33XRyvIn7jCycAJc6/8uH2HR/MO9APtwpiMe5Lo8n0wVoCtkX4
        oKCycBM0n8ZvJjg0fa3wz5TYCQND/8HHA+EEnvqkoA==
X-Google-Smtp-Source: ADFU+vvQD06/XmjeJyI4FrtAXAGmuuiEX1yjtwfPNoFnp54Fkwnbl5A1nBoHeuT4QWFafHtq2rTg2jUtvFNiqwrNXOo=
X-Received: by 2002:a9d:1920:: with SMTP id j32mr13961381ota.221.1585692580240;
 Tue, 31 Mar 2020 15:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200311170120.12641-1-jeyu@kernel.org> <CANcMJZDhSUV8CU_ixOSxstVVBMW3rVrrQVYMmy1fz=OdhxA_GQ@mail.gmail.com>
 <CANcMJZD9Lz-J_idL5i225VR_3Mo6PcTRsYBBrGsMByX6W4jepQ@mail.gmail.com> <20200331095802.GA3026@linux-8ccs>
In-Reply-To: <20200331095802.GA3026@linux-8ccs>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 31 Mar 2020 15:09:27 -0700
Message-ID: <CALAqxLWZ8aET=gHpYUi_v0ez-gDT5nPEnAEb+2uxebFU8D9RXg@mail.gmail.com>
Subject: Re: [PATCH v2] modpost: move the namespace field in Module.symvers last
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 2:58 AM Jessica Yu <jeyu@kernel.org> wrote:
> +++ John Stultz [30/03/20 23:25 -0700]:
> >On Mon, Mar 30, 2020 at 10:49 PM John Stultz <john.stultz@linaro.org> wrote:
> >> The only difference I can find is that the Module.symvers in the
> >> external module project doesn't seem to have a tab at the end of each
> >> line (where as Module.symvers for the kernel - which doesn't seem to
> >> have any namespace names - does).
> >>
> >> Is there something I need to tweak on the external Kbuild to get
> >> Module.symvers to be generated properly (with the empty tab at the
> >> end) for this new change?
> >> Or does the parser need to be a bit more flexible?
> >>
> >
> >One extra clue on this: I noticed the external module Makefile had
> >KBUILD_EXTRA_SYMBOLS="$(EXTRA_SYMBOLS)"  in the $(MAKE) string, where
> >EXTRA_SYMBOLS pointed to some files that no longer exist.  I removed
> >the KBUILD_EXTRA_SYMBOLS= argument, and magically, the generated
> >Module.symvers now had tabs at the end of each line.
> >
> >I wonder if there some path in the KBUILD_EXTRA_SYMBOLS= handling that
> >isn't generating the output in the same way?
>
> I'm afraid we're going to need some specifics on reproducing this
> issue. Could you provide a reproducer or steps on how to reproduce? I
> have not been able to trigger this problem even with
> KBUILD_EXTRA_SYMBOLS pointing to an invalid path (I also tested with
> valid paths).
>
> I tested with a skeleton external module that exports two functions,
> one with a namespace and one without. I built this module against the
> latest v5.6 kernel. The generated Module.symvers was correct - the
> namespaced function had the namespace at the end and the other
> function without a namespace had a tab at the end.
>
> I also tested with two external modules, one with a symbol dependency
> on the other, so KBUILD_EXTRA_SYMBOLS usage is required here. The
> generated Module.symvers was also correct here.
>
> The only advice I can offer at this time is that all external modules
> must be built against the new kernel to generate a correctly formated
> Module.symvers file. If you have any KBUILD_EXTRA_SYMBOLS pointing to
> an outdated Module.symvers file for example, you will see the "FATAL:
> parse error in symbol dump file" error.

Well, my apologies.  :(  In the light of day, this isn't reproducing
anymore. I'm a bit at a loss as to why I was tripping over it so
regularly before, but I suspect something in the build is leaving a
stale Modules.symvers around from before this patch landed.

Terribly sorry for the noise.

thanks
-john
