Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D02C8EC9
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgK3UNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 15:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgK3UNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 15:13:37 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3240AC0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 12:12:51 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id l1so7116935pld.5
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 12:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xdK8+qkc2rtuVSy5z4KzKkg6o06W3+GbexGx9SBitVM=;
        b=wK3ShHoBqxgZvGL9tz2LsiHza2V8Qq+i1MrEAA82aXcHCURZHT48vMhRLfCutCkbbR
         tAGnm1mcR0StRiQCdYH9CLtC9NeL81DgDQyBCIoS5Hzm5YBTPEqXF34iGGbE2z91z/7E
         myw7BuRoKXDtncCCJqTZDw8Y4Y2rucIu5M2Km60H8Mzrq34xnoCKSZ6IAfYoTudcV+N6
         CNX5glIymgl1eVnYSHqP8oldWqjXhIqds4IN5qgRNysQkRpvd8qqBG0z7M0BOxfTUFj8
         b1LCYg1p4TftgKSKQMB2nE0H5NXPcorXOww8cIFLpg2R5uaO72Te+WHM9hd+JctzpyaI
         /IDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xdK8+qkc2rtuVSy5z4KzKkg6o06W3+GbexGx9SBitVM=;
        b=KitGRRJ7mk0F6Lk+6Y2EBinawkpXqW/fIFXshEj9HOePnbFFG9Sp1riSNUWNzH/swG
         TCwngO+DJSxkkc2lE2UpxwQl1XYZ8+mZiM3MHg0mSHrTI9vAZQH8F7mgzXpWJG+hVByx
         pH85S+ZlynwYHVuZ3XldxgElasP2/zUn0M3SQ4gdjUo2o2vcRqZiLyF27BQxclv6DIsa
         fJA/GrfoJOq4Aaf3fwIhLCL1sB/usH+rxf9HKlYISYrByMz0Bd5E2JrYvkjWSxBblILR
         w0w+x3Dj51ZrLOGA3QzTqxXJZIj/dGOhkbO3RGYyzmZlTRPc1Vr5CnQnlyt33JGxdqzt
         F86g==
X-Gm-Message-State: AOAM531pMPCO6X00DfoLmtlSd3UnKSDVnmLpQMYl3l1V/PSvBJj5Rvw2
        032oqwO3t8EbO+n+ElLbkd7FtiLxYJYsv1l72uO1AL1rN+v0yA==
X-Google-Smtp-Source: ABdhPJy2yJpznno2UNGOaFhGigmzH2+/QnBPutAyxmqWdT9JN+hxh1ZKo5pJKmX/+BSK3ZR5qbTSWgDkYkoKYx+uAHY=
X-Received: by 2002:a17:90a:dc16:: with SMTP id i22mr654696pjv.32.1606767170547;
 Mon, 30 Nov 2020 12:12:50 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYt0qHxUty2qt7_9_YTOZamdtknhddbsi5gc3PDy0PvZ5A@mail.gmail.com>
 <X79NpRIqAHEp2Lym@kroah.com>
In-Reply-To: <X79NpRIqAHEp2Lym@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 30 Nov 2020 12:12:39 -0800
Message-ID: <CAKwvOdmfEY6fnNFUUzLvN9bKyeTt7OMc-Uvx=YqTuMR2BuD5XA@mail.gmail.com>
Subject: Re: [stable 4.9] PANIC: double fault, error_code: 0x0 - clang boot
 failed on x86_64
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        x86@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 10:38 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Is the mainline 4.9 tree supposed to work with clang?  I didn't think
> that upstream effort started until 4.19 or so.

(For historical records, separate from the initial bug report that
started this thread)

I consider 785f11aa595b ("kbuild: Add better clang cross build
support") to be the starting point of a renewed effort to upstream
clang support. 785f11aa595b landed in v4.12-rc1.  I think most patches
landed between there and 4.15 (would have been my guess).  From there,
support was backported to 4.14, 4.9, and 4.4 for x86_64 and aarch64.
We still have CI coverage of those branches+arches with Clang today.
Pixel 2 shipped with 4.4+clang, Pixel 3 and 3a with 4.9+clang, Pixel 4
and 4a with 4.14+clang.  CrOS has also shipped clang built kernels
since 4.4+.
-- 
Thanks,
~Nick Desaulniers
