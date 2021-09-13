Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A6340A135
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 01:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349264AbhIMXDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 19:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349027AbhIMXDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 19:03:11 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C0AC0613B2
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 16:00:38 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id k4so24398688lfj.7
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 16:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKl+vSgoVtwUpDwTiYFeDbvOkP5sbvNaiiVprss03Dw=;
        b=A1SYNoXPXp9aR+QbDKLZgTKR12NmkzDsOFeCyOq0tPMxICI8eICyWtmYqdV3M1oPuP
         9MBd9pl8eNdfQkXn+0HNWq9vz63p8ZK8e3uwgCGxvf635skYTr0/yvFcHK4U/9Wsbopw
         8ecObmvzNF+VlYoo92Jv4arrMr190jRmGZWA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKl+vSgoVtwUpDwTiYFeDbvOkP5sbvNaiiVprss03Dw=;
        b=hhKeqS9rA0Kxi38s1zQ12ZyYjgPpB/0Osq0TzgdqD6shKzde3AqqS9Wotxr/RTH/Lx
         daF6+QBsdVVDLyw32xzWmU05ax4Oh2drGU9PAgVenIodAET4YMvJPspnTvM4AAMyGruf
         G9L3lnB9s/bmIFHfE/AlmB/PMqWvn0lfVUPR7pyChMLkOtDiW9GKlZ3ujJlArBP0P6B4
         imfrUukeSd6t76ri6I+I9t0qzj66AsHFLJxfWaYryV9PMWXRTCljECabvk6oEkyDd3uE
         BJ0OYnKvExmkXsSzD9cx19mZ1ZFNgnRvHFKiW9hPTZynLsW5LeX9nWjyVqiUEF6CzWm7
         EORg==
X-Gm-Message-State: AOAM530qYCRnezUfORhRXXC5wM/e70MEjhdODMqVhNncfSvqDX+aMfo8
        5Xh7/++0qs8FI0vXeKfq6fpNAXI2pPoohhqUYBg=
X-Google-Smtp-Source: ABdhPJwSv25Q0RQZiMC2O2SrmTICUowQqm64dSqG0EnJxHmOMvERmSa/Tp9xkKA7l1OK9je1lK2RKQ==
X-Received: by 2002:a05:6512:3405:: with SMTP id i5mr10389001lfr.165.1631574036660;
        Mon, 13 Sep 2021 16:00:36 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id i18sm350051ljj.84.2021.09.13.16.00.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 16:00:35 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id l11so24432814lfe.1
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 16:00:35 -0700 (PDT)
X-Received: by 2002:a05:6512:3984:: with SMTP id j4mr963725lfu.280.1631574034860;
 Mon, 13 Sep 2021 16:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com> <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com>
 <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
 <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
 <CAKwvOdkf3B41RRe8FDkw1H-0hBt1_PhZtZxBZ5pj0pyh7vDLmA@mail.gmail.com>
 <CAHk-=wjP2ijctPt2Hw3DagSZ-KgdRsO6zWTTKQNnSk0MajtJgA@mail.gmail.com>
 <CAKwvOd=ZG8sf1ZOkuidX_49VGkQE+BJDa19_vR4gh2FNQ2F_9Q@mail.gmail.com>
 <CAKwvOdkz4e3HdNKFvOdDDWVijB7AKaeP14_vAEbxWXD1AviVhA@mail.gmail.com> <CAKwvOdmtX8Y8eWESYj4W-H-KF7cZx6w1NbSjoSPt5x5U9ezQUQ@mail.gmail.com>
In-Reply-To: <CAKwvOdmtX8Y8eWESYj4W-H-KF7cZx6w1NbSjoSPt5x5U9ezQUQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Sep 2021 16:00:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=whjhJgk7hD-ftUy-8+9cenhMDHqaNKXOyeNVoMxZRD-_A@mail.gmail.com>
Message-ID: <CAHk-=whjhJgk7hD-ftUy-8+9cenhMDHqaNKXOyeNVoMxZRD-_A@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Baokun Li <libaokun1@huawei.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 2:15 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Sorry wrong diff:

Well, this second diff was seriously whitespace-damaged and hard to
read, but while it seems to be the same number of lines, it sure looks
a lot more readable in this format.

Except I think that

                default: dividend / divisor);

should really have parentheses around both of those macro arguments.

That's a preexisting problem, but it should be fixed while at it.

I'm also not sure why that (again, preexisting) BUILD_BUG_ON_MSG()
only checks the size of the dividend, not the divisor. Very strange.
But probably not worth worrying about.

               Linus
