Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE21510EEF0
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 19:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfLBSKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 13:10:51 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42043 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfLBSKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 13:10:51 -0500
Received: by mail-pf1-f194.google.com with SMTP id l22so31082pff.9
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 10:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IiS0hrDFK/c7wtXhXJeLnNmpvEmWHGEj6jDtdt+gE6g=;
        b=r3Daf3YyB9O/Cu8KJOhSWnU0t/f6Msn68Q2tAoTwZIaOwFTvoAtMZmILbPFAQWjsGC
         jPWAi+WWYSYl8Yuuk5KkStUdpI+K026HUpdiYti8IwfOle7GMHT+/I4zRIKUrFlxHThL
         RK0Y0MKSPKIxFjNlOk86Nm4b6S5AXlj8Fh34HEbN70kgrS84DUiX3tNIn0VDLrh2M7qB
         V58zk4rn8jJZO2Or2hSMRH5oryg47j2WCJXcQjLRDcFzjXA0MuLqQdkxrBCUG3uCaQsM
         tbtxonb8/0ATb0ia18IaUngO93lovyoHS6fILzINmCI7plDEnb731WEBbWOvAEydp2Lc
         DwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IiS0hrDFK/c7wtXhXJeLnNmpvEmWHGEj6jDtdt+gE6g=;
        b=iTyrPPNLgtfB1QWgxCKF5shdOyjV9aOJGm4H2DN3CX6WOul3z+vFVUz1rNWJovW83U
         fYtrRrWLAbz9uFW3IzemEaIYqqtnMeVu1dEbtZhMmk3OwcQgX5GVlBY7ZopEW3TFSrsZ
         lfxlxwLcqzzlVgkedqyJ7nH1o4wHxf9AL8mwITolQwg3F6f+LY10AaF5d7mEboRNLjow
         uIrQPJjixhmwZqdoaX/St1n2SnqJx/+mHQJmk2xrqsn9a9ef3hkKA1LDrOwkXQK2+GRk
         VbQ6sb67o9AyuQQ7xXt3qBeA4vUINWS2PlFJZoQnqZbXCouO5BSpMWhJhAeWIiaVth/G
         cw4g==
X-Gm-Message-State: APjAAAWIxmOJs9Ua+XMySnyYi2OUL1MY/7agCbGBZOZnpCXozQgUwygQ
        Umvwr58PcYZjQzOKUVuSgJUr5FUKunRBkE6WxBZm//Ar70Qw4Q==
X-Google-Smtp-Source: APXvYqzG8dZiWgCWIUALW7gIzJV7e/muFf+E2p3Dl1KN7+czq69cuZQcyn8S2C8BEbRtpekuJwxXGjrnjGq+t8dA+ro=
X-Received: by 2002:a65:590f:: with SMTP id f15mr292264pgu.381.1575310250051;
 Mon, 02 Dec 2019 10:10:50 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOd=eubuZH-tVY_KX2pjp4rnTzLBkk9iPfaHkRDqg2zaBKA@mail.gmail.com>
 <20191127065339.GE1711684@kroah.com>
In-Reply-To: <20191127065339.GE1711684@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 2 Dec 2019 10:10:39 -0800
Message-ID: <CAKwvOdkiWq06vCARkqp6EOsDSR2avXzQ7L+-d9jGN0--xnbCBQ@mail.gmail.com>
Subject: Re: please apply mbox files for CONFIG_UNWINDER_FRAME_POINTER clang support
To:     Greg KH <greg@kroah.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Huckleberry <nhuck15@gmail.com>,
        =?UTF-8?B?TWlsZXMgQ2hlbiAo6Zmz5rCR5qi6KQ==?= 
        <miles.chen@mediatek.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tri Vo <trong@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Stefan Agner <stefan@agner.ch>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 10:53 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Nov 26, 2019 at 03:12:43PM -0800, Nick Desaulniers wrote:
> > Greg, Sasha,
> >
> > Please apply the following mbox files to 5.3, 4.19, and 4.14
> > respectively.  They enable CONFIG_UNWINDER_FRAME_POINTER support for
> > 32b ARM kernels when compiled with Clang.
> >
> > This is upstream commit 6dc5fd93b2f1ef75d5e50fced8cb193811f25f22.
> >
> > It's a clean cherry-pick to 5.3.
> > A slight nudge was needed for 4.19 and 4.14 since the config name was
> > changed in upstream commit f9b58e8c7d03.
> > A further nudge was needed for 4.14 since a4353898980c and
> > 469cb7376c06 don't exist there.
> >
> > We're looking to use these in Android. Trusting the better judgement
> > of the stable maintainers, we're happy to carry these in the Android
> > common kernel trees, alternatively, but I think these are pretty low
> > risk to take.
>
> It's a new feature, so no, I can't take this for the stable trees,
> sorry.  Feel free to carry them in the android trees.

Done
4.14: https://android-review.googlesource.com/c/kernel/common/+/1179084
4.19: https://android-review.googlesource.com/c/kernel/common/+/1179202

-- 
Thanks,
~Nick Desaulniers
