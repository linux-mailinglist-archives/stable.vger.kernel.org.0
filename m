Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52DD19B482
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbgDARHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 13:07:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42185 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbgDARHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 13:07:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id q19so216590ljp.9
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 10:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aRrcqK5cfaNO7OpHqvvvRe3Ztegq+35dbp3U2NLv1c0=;
        b=G9FMkwedR3xk+FnQzgPlV2dbisol5n80kNiGY5ot7hx3A6H4kpC93ptTcVIYdDw16C
         kX1A3/EauPB/cc1mAo+0tIJH71iQ5jnG+59+9pInTUw4F+JLBhBqW+igtJzqgr5eY4/o
         15FFI6ROfbv8hGMmdpInKNl5WV+UZ2ozcWH8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aRrcqK5cfaNO7OpHqvvvRe3Ztegq+35dbp3U2NLv1c0=;
        b=JNQNuYAp0Jkn1J+XxqgJr7Qhxztb041NKUTuoIuq4YqwP9B2FuTIw6Dy1kHX0gF08h
         95kDHvYjiAaL86OaYUeKiG2Pk1Te43uJgF3JkKLlIFceQlBDkeCauBfIhNO8po9VIpkG
         ZG43l5MRLptdqcrSNZwwptAjAF281HB3m1ZWe7rZaUjIWdDXAt1LnJM1sswDe6Yge6WS
         7qjLassJrdLY+39F3VGBun1jK7Wu+v4LTr8O6OYf90bH0IrgNU5ss+v/HJru5/aVTC7j
         j0gzcbvSRwI+yxUt7AiA5T08LbEdEMUACSWt4xQac4d6N/u3IM4JxVpb15GzUGTjlRQB
         lDvA==
X-Gm-Message-State: AGi0Pub+TPf15PvIi6ZHqo9tyf3tj65X6LXuHDZLa9Wzs8BsD38ZfUVC
        m7KZ5VnaAhpzwT/dL+zYNosn9iXeK4U=
X-Google-Smtp-Source: APiQypLThzX+JTCo7yecMXNVR645Ly+3N6i4yM05aMyfmtYhhWuQ0kATne4FFqBC3g9MZxk3a0ZcAw==
X-Received: by 2002:a2e:904b:: with SMTP id n11mr13321843ljg.171.1585760824887;
        Wed, 01 Apr 2020 10:07:04 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id a26sm1518829ljn.22.2020.04.01.10.07.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 10:07:04 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id n17so229527lji.8
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 10:07:03 -0700 (PDT)
X-Received: by 2002:a2e:7c1a:: with SMTP id x26mr12738802ljc.209.1585760823439;
 Wed, 01 Apr 2020 10:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200401161413.974936041@linuxfoundation.org>
In-Reply-To: <20200401161413.974936041@linuxfoundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Apr 2020 10:06:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVBvO1b5UzfcHm6y4KLHOp3huFfGMdW21F6g25oUePLw@mail.gmail.com>
Message-ID: <CAHk-=wiVBvO1b5UzfcHm6y4KLHOp3huFfGMdW21F6g25oUePLw@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/10] 5.6.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 1, 2020 at 9:19 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.2 release.

Good. You made 5.6.1 so quickly that I didn't have time to react and
say that it makes little sense without the 802.11 fix, but you're
obviously making 5.6.2 quickly, so..

That was just horrible timing. David's email to say "holup" came in
literally _one_ minute after I had sent the 5.6 announcement: my
timestamps for that unfortunate thing is "3:51 PM" for my 5.6
announcement, and the email where David says "Meanwhile, we have a
wireless regression, and I'll get the fix for that to you by the end
of today" has a timestamp of "3:52 PM"

(Ok, so me actually tagging the tree and pushing it out happened about
half an hour earlier, so it's not like it was quite that close, but I
found the timing of the almost-crossed emails to be funny/sad).

                       Linus
