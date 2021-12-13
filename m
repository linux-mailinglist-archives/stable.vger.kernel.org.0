Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74336473484
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbhLMS7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbhLMS7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:59:00 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DA4C061574;
        Mon, 13 Dec 2021 10:59:00 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id d10so40751009ybe.3;
        Mon, 13 Dec 2021 10:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqQC7tgPMbNXR/+JNvw896EE85G5XX2sbVCCzLSsfQ4=;
        b=LyLcrbv44h8PePiceZ/nDsApu2MVHNPwKg9S2QdPg0p2XM4XPyXHVHdyFiGR5Oltm6
         BHW3hWBwoB1sUksHzCz6uosCecnUrFPFxV8Sfym4bN84uHkuYzjPaW0Kqoa0e57Rbo0+
         K5cgzGWsAfVmmS2GhHS9n0DtUuGLoid7zj0Aibhp+oDNua82y5zG5HC2otaQjiq/XHCU
         OrImPA8Uoqht65JDTQj8R3YtGfULChMDHFIxrv+P19W5QTrr/83bKwjZsIY1JkXURnpX
         jPcJOkb/aVdDUwcGIhgwEaXcj+Fsi5HZ6rLhFdG80uFgl6IWxtemnim28PywspqHVWmY
         FKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqQC7tgPMbNXR/+JNvw896EE85G5XX2sbVCCzLSsfQ4=;
        b=D8aYOFEKjsNqv9pREHuXwt1VW6OY25/+WerYZPcoV3exF8hmAtfoHfMYXK2EK4AUs5
         CVYxay557bUMVA4UgRVewthYimTCeFYi59w7gajySJRMXmK0GPXqF0wywx/lONO7qCyp
         k6Fjw3RPwN2ZmTg2Mp1obwrK/ehXW7lxhQN7+kssZZ5rv8EVvqmtc7YlrviADHLdBYe/
         E6iEabYzVnAmnfB+n9MkV7lazpg6ktZUzZNeqNILmriLled510hjnBZsf4Lhlx5KAc4a
         BrOJH24Gs2foW1dOFXW1i1B6W+vWEF/j8SwNkgdSCcEDndIvki2byW632iWEzKEcmblo
         T8Jw==
X-Gm-Message-State: AOAM5316alofOwC+FlTxZTXoNtHRFMkuiKLuZbUIj4dH2vIWn3vRhALR
        c+gQZyVzJU0TT5Wu/x2byupt3CKKYzptajLu4Vo=
X-Google-Smtp-Source: ABdhPJxLF+T1Na0RFVC8OoLY9i6ikPWpX5kC9cOOlXjhXiKjEofITC6KbzD5umxoHToYB7r1XD1HdStFk+/KK223cE4=
X-Received: by 2002:a25:7316:: with SMTP id o22mr406530ybc.640.1639421939347;
 Mon, 13 Dec 2021 10:58:59 -0800 (PST)
MIME-Version: 1.0
References: <20211213092930.763200615@linuxfoundation.org> <CADVatmPsqW050=k07RDChjnf_F+MJfkLzHiRcdeoWQ7Mws_qMw@mail.gmail.com>
In-Reply-To: <CADVatmPsqW050=k07RDChjnf_F+MJfkLzHiRcdeoWQ7Mws_qMw@mail.gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 13 Dec 2021 18:58:23 +0000
Message-ID: <CADVatmMMe7NGpX9CcViLrhxP69gJ6m+9rViEVuh0E6j1QXGDVg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Mon, Dec 13, 2021 at 4:27 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> HI Greg,
>
> On Mon, Dec 13, 2021 at 9:51 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.221 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> > Anything received after that time might be too late.
>
> Just an initial report. mips allmodconfig is failing with the following error.

Ignore this please. I am not seeing the error on a clean build. Need
to check what went wrong with my build script.


-- 
Regards
Sudip
