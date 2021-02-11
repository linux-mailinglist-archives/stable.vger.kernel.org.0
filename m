Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B3231921D
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhBKSVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhBKSS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 13:18:57 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83E0C061756
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 10:18:14 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o24so6656618wmh.5
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 10:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iQmHsNuspPNJzcfS9pT/2W+5PmGpXr1wvhVP/5EDOrk=;
        b=UXd/00usCnlyJAALdY7zGKZ4gli/9TRYwCWbEnr8M2KfgV4Yjombq3t2hCR4MWOES+
         n8/bObILcwfMydkz9+hH3dYx4eeMah66ogH/ktOrR3F5PF4Rf/OIru3ubxTObzZFsm+X
         7/ZhHaO1n0mMwh+S3p9qaqo1ZLGecfreNOdFsmjylDuHQRoxp62lj6h9q5VdREka2ONj
         5/qQ2KcRJMok93F3QIyovhBK6mw4OL6UjwXqe7ZHUyB0ymUGLUHBX0zVY9d6HXG9pw3P
         +PIfr2R/KR+DcZEpC/NevrLM/IsVX2SV/JiiR6Hip/ZXgGxQui+4uN7/bQQk2b/nXmbs
         RPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQmHsNuspPNJzcfS9pT/2W+5PmGpXr1wvhVP/5EDOrk=;
        b=POMsueR4yC7UFo76Atxfly2EfsBHT5TUESKpW6YEx9LCq8bgN2fOLsxzeaiuwGLPG9
         HI9BlY4o85YifoNzsSqmvJL+dh2zSfi2Au2vuLx7za6gJDTz5eZkQgb8DIedpTGA8RxM
         KUEoNedUDpAwGaFJyquJWkVdTUAvTCskhEWx4+apciEk5G1HS/5utM9AOWrihs7yX0v3
         pwxBhdv8eesXSEqULfCoVL6oF42cFf2HVyij4nKPVtKzE6havzbVAkEVPC7wvTNgqq73
         Vi5/3U8v56gNiiUaZnwZZFywVyWTti6KFYkM0BjS+CaLxPj4KmGb1cm/xUmL95hv01Kd
         RXrQ==
X-Gm-Message-State: AOAM533wTF5/7520jvYo2slnr3llyUKrJ64p+rf2EzzjaPBggIPl8e+4
        L2lAEEm0TCk7q6fqrv4pq5JAUE+mkJycnslR2zjZtnfvEwg=
X-Google-Smtp-Source: ABdhPJyFvwicgw0zi29LTidbtn1k/0roebAs2vFw6CP06nO4nbRPtBV+NDJAqgIF7McgrrYVa3YDsXUwiW0+0YycOUs=
X-Received: by 2002:a1c:e043:: with SMTP id x64mr6009715wmg.75.1613067493709;
 Thu, 11 Feb 2021 10:18:13 -0800 (PST)
MIME-Version: 1.0
References: <CAEvUa7mYi9J6qUbnUJi9=_+AXeXOopYJkZb+Z4CD9enGEQaFBQ@mail.gmail.com>
 <YCI39srMrc8dmL+p@kroah.com>
In-Reply-To: <YCI39srMrc8dmL+p@kroah.com>
From:   David Michael <fedora.dm0@gmail.com>
Date:   Thu, 11 Feb 2021 13:18:02 -0500
Message-ID: <CAEvUa7nBGwManydNPKFqVXQUugsDzx19nPv4Y2BaxrEqe6jFww@mail.gmail.com>
Subject: Re: Reporting stable build failure from commit bca9ca
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 9, 2021 at 2:21 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Feb 08, 2021 at 04:14:44PM -0500, David Michael wrote:
> > Commit bca9ca[0] causes a build failure while building for a G4 system
> > since 5.10.8:
> >
> > arch/powerpc/kernel/head_book3s_32.S: Assembler messages:
> > arch/powerpc/kernel/head_book3s_32.S:296: Error: attempt to move .org backwards
> > make[2]: *** [scripts/Makefile.build:360:
> > arch/powerpc/kernel/head_book3s_32.o] Error 1
> >
> > Reverting the commit allows it to build.  I've uploaded the config[1],
> > but let me know if you need other information.
>
> Do you also have the same build failure in Linus's tree with this commit
> in it?  And why not cc: the authors of the offending patch?

No, 5.11-rc7 builds correctly with the same
https://dpaste.com/7SZMWCU89.txt olddefconfiged.  I've CCed the commit
authors.

Thanks.

David
