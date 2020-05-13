Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0396D1D0C8B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgEMJnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgEMJnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:43:16 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ECAC061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:43:14 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u6so16998164ljl.6
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G9Pk3eW2eYSDlwb5QSUTyqMvq5AZJge7nVN7SY7K6mI=;
        b=vRRf1MgJ4N3erimr/iWvvwja+9091TJcpxCoJyXGuANZKOZr9rqyoxkYuyvD2/vWKM
         yuDzojazEgbZHk41kcloQAhbDWeF2wWjD0HPxoaiJyq3jXzpPK2UKD9T/gdbEwJkht/k
         8JQBv+vEEH2Gdghagsh6+ZkTKDmXrga6K2OTcek5mKTeJABw8heIhCSVtgln6GUpAY2W
         r6DWhc0kSlCR/6MYzJoFIrB7ygADHEuvgph+HwxzXYmUDsLo+ugPFYAnoYs5UWnXDt6g
         roRLJUkKRHzJIL5XEzamUCdiglvHK446AKPzkuQMa3kkXbr/v3cXxDJnc9ld+rq531qX
         rngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G9Pk3eW2eYSDlwb5QSUTyqMvq5AZJge7nVN7SY7K6mI=;
        b=jndqDfVa+aHis7ncehA5uM+CEX54Wy/6mkTDQS0Ea+SmrlxwEI3I8R0XYTFOGEnFxe
         xX/UtzF2yVoxMO27is3kPM99SzJc82cV3MbdB22Addps6Yn2YxTvZUgMOel3UmM4zP7/
         +XOqkdtaeFbXygPgoavZG/4C6l96v6CcrZZbHnmcZuu5WkscqsWhh009DQbspL46fUpX
         A9A3Sffy72JCOn+HnqpsQTULDqVo0PavvFegEX2WIomPGI2ROzUTLftIo98tmk2Tucly
         GTKLMueIwDd+PEXR08jI9t4WxNb628W41C+tCAcVe9Qu/7phOkLBV0KKvlotybE9zukp
         L21A==
X-Gm-Message-State: AOAM530tmth/pur/PahM5aURdAYpNJmv5HtLJgVMBpyaEO9FX0Fsxec4
        nzm2bZfEVzYQCqSrayv0Xb93fPkpjDQ/ilA/+3mmnQ==
X-Google-Smtp-Source: ABdhPJzAjoBqtm6Jcn0Mp4RUQZzfZn0efCuJqZvHqaAQOPEkMh3CRYVmFZ1H6Ckc5eGxB0N0tV9OQ4c9onlB/koX93g=
X-Received: by 2002:a2e:b6cf:: with SMTP id m15mr16014719ljo.168.1589362993241;
 Wed, 13 May 2020 02:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <CACRpkdb3WrEp1uvzMUGebtdXYPv5sMNF_gd5_zcB+=n3P48GQg@mail.gmail.com>
 <20200512210820.GA29995@sasha-vm>
In-Reply-To: <20200512210820.GA29995@sasha-vm>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 13 May 2020 11:43:02 +0200
Message-ID: <CACRpkdauUXj-iQULpBvVkiKj+M+EJprHF0Ms9cdX3=6YdFF+nQ@mail.gmail.com>
Subject: Re: Please apply Revert "serial/8250: Add support for NI-Serial
 PXI/PXIe+485 devices
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 11:08 PM Sasha Levin <sashal@kernel.org> wrote:
> On Tue, May 12, 2020 at 10:03:30PM +0200, Linus Walleij wrote:
> >Hi Stable folks,
> >
> >please apply commit
> >27ed14d0ecb38516b6f3c6fdcd62c25c9454f979
> >Revert "serial/8250: Add support for NI-Serial PXI/PXIe+485 devices"
> >also to the stable tree.
> >
> >My Fedora cannot switch baudrate or write to my serial port and
> >that makes me so sad.
> >
> >I have this problem with kernel v5.6.11.
>
> Hey Linus,
>
> Are you sure about the commit? 27ed14d0ecb3 ("Revert "serial/8250: Add
> support for NI-Serial PXI/PXIe+485 devices"") was merged upstream in
> v5.5.

Sorry I got the wrong one, I need to do some more bisecting
and find the real problem... :/

Yours,
Linus Walleij
