Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AE4257DF9
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgHaPvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgHaPvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 11:51:01 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA05C061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 08:51:01 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id e14so3463586vsa.9
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 08:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ImpEO43/fyN0zbW5WmDfvqnd0799BAvzu/fNwpLdLN8=;
        b=yqLy1Alx3+cYR31mM5QOu8+fEshyzBt76sqjdGvsSdQ0ff7c9puXthP/ntURCgmqEs
         8Ee7Sl8XKdhxpieo5uh4xU/leu3T818wSPp0PMkvTWqL9xxjgge7uMSRS5FDIDFC732d
         8xL1KrcBT3XGf1H6D5rHxo3c34WgV+jlHbAkPb6/8AuYh/CDzbZIfTjUa/yLDk++qbM1
         oNHhnAdb296hdV+Zb7sfVdWvZj/AVEaYLH0hrLD8F/X7ZORyCkvrSfTQqYEDh3lvpCN/
         o16ICyS/nSIHl7zjivvbqzcGWzXIhLtHFWNZV4b6M8e3yqJ+LOIvXBX7sJ/k6mEWT0f8
         XSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ImpEO43/fyN0zbW5WmDfvqnd0799BAvzu/fNwpLdLN8=;
        b=evymRfAhlFDr9TDSTu+ORopmaY/MZBZTzMpvoudkLucH9ZBi++URiQWonbdmvbS6VG
         7hqAQ8DweBCHPD7HqK31Itmo+TiJ38ZuGVi+Xwi6v5EsLxd4ZVWKlOlHaZiL2I08eshQ
         xbyffLQpR+sNc+dDUpgjTH2kVMz+88QZJr9aQMWOJg5akn4dhRA7XmWFH3v6egsJVlhH
         4z8PSK9Amw7ApJgac38aDxAb8Q+KNYmwu688aiHhdfiJEnlTHFdCdDkny7Q4wo6H0elQ
         IekeQwJzbvXD5i/ZC+cOQB3NKgZ1F2ct/lT2w1jR12JaO16CFutBYHlFXyYFbp+/+9DA
         joDg==
X-Gm-Message-State: AOAM533oVakvY32D7r13Ny5pSHoMwJ7Gm96joZS8kFSxlFqGIFUaG3gF
        9jZDxolppIZT/FJyi1DKmFdE9EJBnlK3+kGx9fTEuQ==
X-Google-Smtp-Source: ABdhPJxfwfIk/M0HyJJp/48xzPBt0cyTh/q10X/vvB/PitLco7t8Mhj2cWSJsxGBXPxgYB4BKSfuDPaKvQtt81JTiLI=
X-Received: by 2002:a67:e3cc:: with SMTP id k12mr1600122vsm.173.1598889060780;
 Mon, 31 Aug 2020 08:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvsNkxvs7hdCB3LC9W+rP8hBa3F1fG3951S+xHfiOJwNA@mail.gmail.com>
In-Reply-To: <CA+G9fYvsNkxvs7hdCB3LC9W+rP8hBa3F1fG3951S+xHfiOJwNA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 31 Aug 2020 21:20:49 +0530
Message-ID: <CA+G9fYturdDvr_p-o6XfGzthh=e5Tc7591JZAz_Jwvf9_cJqdg@mail.gmail.com>
Subject: Re: perf: tools/include/linux/kernel.h:53:17: error: comparison of
 distinct pointer types lacks a cast [-Werror]
To:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Cc:     linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Aug 2020 at 21:20, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Building stable-rc 5.4 with gcc 7.3.0 perf build failed for x86_64
> and arm64 architectures.
>
> In file included from btf_dump.c:16:0:
> btf_dump.c: In function 'btf_align_of':
> perf/1.0-r9/perf-1.0/tools/include/linux/kernel.h:53:17: error:
> comparison of distinct pointer types lacks a cast [-Werror]
>   (void) (&_min1 == &_min2);  \
>                  ^
> btf_dump.c:770:10: note: in expansion of macro 'min'
>    return min(sizeof(void *), t->size);
>           ^~~
> cc1: all warnings being treated as errors
>
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/263/consoleText
>
> - Naresh
