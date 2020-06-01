Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3951EAFC3
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgFATpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 15:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgFATpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 15:45:40 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3198BC061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 12:45:40 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m18so9674371ljo.5
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 12:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=090F/pVAsEFUivGLT4RTfEhIq5Rj4DAQd754LIIQ1fc=;
        b=i8jf8VpvJ+M7BOTwHCBaQ1nlsPHVs3kmLaC/LCaFdFWgGcOPa6+CNtz2i8s/IWgaCa
         sXQdcJ7LWtRk6tR6yY6f+Q4h+8ZGC+V6pMj3WQyqpS1m3b5OwE8e4FI2pmV19Vc3ayN/
         zlImGfpYc1dzEa/TuavzNmcjNl+ar6KNxPGCAT5KJa25TGXxJ6ouwjjzSPqNwHvUcKnS
         mSgmfTRl+9GEBK7PSAF0z5KvCnzXzSU9Uae69pcZj3J5of0wB2z25zxApmSZsK/TXqAR
         CzmqszQ8T6KT+b9NQZL36lkao1OzEo98YVSpKFJX3gZrEvc8jda5DeSSPb3TUH0UsLGt
         QcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=090F/pVAsEFUivGLT4RTfEhIq5Rj4DAQd754LIIQ1fc=;
        b=Z327xqInv7coMD7wAj55peqD4gEu+sIsUKol3JtzTOqhtt3MqyHrNKV9E52UpXXKkO
         1+q8V2J7vgZr8VNKs+riPNLRj28mwTPBLGPVpAainPf5eof1g/Z0Wi7+JWe6n+2latIv
         f4vGc0IIVDOpOoKe2C7k3EZYa5EfrMeh4/23GruqsxZbyAClC0gBEkeFt5EW042qvmdC
         2YTs7k8wUVLPvaehRNMdNH8fqgvOUYGe25b6rBgNSVm9GbduOLpY0O5Nuli2h6eDwOKO
         wRkxwzvSdfpiaIzCCpdMNkJle1vQHMv2EXxzrxSIjZTdSzdeSaOl7q3flZIR6F8BNoKF
         b6Wg==
X-Gm-Message-State: AOAM531VscSX0eMc/YlhVx7Ew+gnj3BTd+lE8XufxNpxIwB4sFvjm84s
        ln9bkQ7Z8dtqmGVWuj/6E1BPuB7xZe3DqFGbZb1klw==
X-Google-Smtp-Source: ABdhPJzBi2hqC7d5tmBYMjZRZkLdIbLG6EemuwQJMMOfje8D3a2Wl0l3LV005ZSFRaZ0Nl48DmTUTDXl6CDQxlkh820=
X-Received: by 2002:a2e:9684:: with SMTP id q4mr11571338lji.431.1591040738539;
 Mon, 01 Jun 2020 12:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com> <20200601170751.GO1551@shell.armlinux.org.uk>
 <CA+G9fYsHPjXW5BWbAgURhxnrSHamGPMAGtpjikbkUd79_ojFbw@mail.gmail.com> <20200601182922.GQ1551@shell.armlinux.org.uk>
In-Reply-To: <20200601182922.GQ1551@shell.armlinux.org.uk>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jun 2020 01:15:26 +0530
Message-ID: <CA+G9fYvNxYTgO=vtFWnDibMQiSW1+mX8t=Kr73oqNH5wF8wK-A@mail.gmail.com>
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Jun 2020 at 23:59, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jun 01, 2020 at 11:01:19PM +0530, Naresh Kamboju wrote:
> > On Mon, 1 Jun 2020 at 22:37, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > > It looks like Naresh's toolchain doesn't like the new format
> > > instructions.  Which toolchain (and versions of the individual
> > > tools) are you (Naresh) using?
> >
> >   toolchain version is gcc-9
>
> gcc 9 is just one part of the toolchain - that's the compiler, and
> actually irrelevent for the errors being reported.
>
> It's binutils, specifically the assembler that is choking, so that's
> the version we really need.  Something like:
>
>   arm-linux-gnueabihf-as --version

GNU assembler (GNU Binutils for Debian) 2.34

- Naresh
