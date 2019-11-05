Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04462EFF9D
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 15:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbfKEOXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 09:23:39 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:49583 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389083AbfKEOXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 09:23:38 -0500
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mj8iJ-1hxtan37R7-00f9Ij; Tue, 05 Nov 2019 15:23:36 +0100
Received: by mail-qk1-f170.google.com with SMTP id h15so11531680qka.13;
        Tue, 05 Nov 2019 06:23:36 -0800 (PST)
X-Gm-Message-State: APjAAAVlMfeuJT7rM+C/sroAovXLCi1GZcDkVuDDZwQUVENLWPutJqCP
        npS776GVNjjF7+F/LjxKY20czgP5tkbnzrAVDVI=
X-Google-Smtp-Source: APXvYqxEJlpoNZwMPLpzsXqtyuzA7jOFNpOCO6jYdbmb8Rt9qzUV9PB1GkNKVDNJDtW7nTqNAE7nVJYyIwLqAnfMeaY=
X-Received: by 2002:a37:4f13:: with SMTP id d19mr7205469qkb.138.1572963815449;
 Tue, 05 Nov 2019 06:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
In-Reply-To: <20191031113608.20713-1-christian.brauner@ubuntu.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 5 Nov 2019 15:23:19 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2P0djkhfHhQUGdO3YX7QGtLeF2OH1HaJmbmRq5Nuojbg@mail.gmail.com>
Message-ID: <CAK8P3a2P0djkhfHhQUGdO3YX7QGtLeF2OH1HaJmbmRq5Nuojbg@mail.gmail.com>
Subject: Re: [PATCH] clone3: validate stack arguments
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:g9UvdAFkc5K5I1WUz3TIItfnCw2AoYB7lvNx6PYbY2iTTZkZBuV
 1T7QX9Skaji8HOzG6B7oI/t8iwBJdguhPv+e44QUBvV9T+P/RTh7gqvoR44j29THV/jswrA
 fpiuKzqM7ga+3+/dQVv3Cx3ADfxY70sJmqgE6Mrc3bLpeZJAS+JxJx+BbQkAhZpd8UvSDyi
 oZ/0oeJrAiKrU5ZTYGhJA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5JY4BvQQdNI=:MuZI6gc0XPZdqM1HqDwBh1
 u0UgyA7sT+aegKhB7KPWR7ohGn/3nu3xLEG1jaj9XeHSyMjKH4tntDL0YGpwKh+aEn36jjWoQ
 QH3ok9yLl+Z9uzG6DBLbdwXOXKB2i2y9vAtEyiaK3Qm4DR58vPtAO6jdSNcUD+UgEnvLHPrm5
 B+UUtbM6rx/08GFsyMsG03qdnMteLatFdX06hSriygEiN/J6aMlnEGIGErrJr8L4wsNQw1gup
 a8AtGWcxY/Tvu2hQ20n6JrpKwlpC1OU2VGaHezL1BSt+TyChSe6p7+LYMOvSW36ythyBuq+oz
 ABW/P+Wxjw0eiS0vQxJ61IKNL13kzyDAztMQFa6J8EuyosGfeFfpQkw7f4JzG6gHDaVcySuhJ
 o0JpDtJelNviB5raADwGCL+/CfkTCxfq6SfAHd8k2M9gwAUdhbC2a4wZX3Py7bcV1/gTH0QKp
 3jN0Mr22gAYLDY3nAOVyeVu8e7CYvzVJpX2VghN6kqvt2LhaqMmAXmKOUpRh3Wbn66sK6PGwF
 1sYQ8lw/3d77PGBwKu+wGtnUlLZ3kEgv8C8DUnpeW8yWWtY+nYXM4KHq23B0dULgBr2wUt4Nw
 urjfHfu2CIRi3XEXaKyebuelQgWIgxLvHqPLKiKHIBhQwzWHM5dnK4ZwT4n0ppV4/sVKnWmFU
 SRnVxlJuPv5JpXXVfVB/tG0M8NRQvoCVqf5W8FqLDSbCuqoQJtKOW1Dqxc4io1Bi2rP+Lz12l
 zcIfq7Jk7fv2MTgWWSumoxR9G7upXwkQlBP1Ei7RGeLirmpyhKnczDvVEN0ALdbwTpBTrQvHK
 HGSrWt5tMxCU+67V3YTynAvQCPcqUCL/8e1jHb21yJrYr7Vymn50VbK1AzuiD4nDNjDovO99P
 B+nb043KbWyQOUxGRw7w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 12:36 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Validate the stack arguments and setup the stack depening on whether or not
> it is growing down or up.
>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
