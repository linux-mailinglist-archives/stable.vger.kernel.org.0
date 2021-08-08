Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B00C3E39E6
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhHHKpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 06:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhHHKpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 06:45:17 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB284C0613CF;
        Sun,  8 Aug 2021 03:44:57 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id v24-20020a0568300918b02904f3d10c9742so11186880ott.4;
        Sun, 08 Aug 2021 03:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9U9q0lZUKvbYE54RBYTDoIiNw159S6rYKfxs0QanQdA=;
        b=BCaXKSSv8FmRRSLzHzm5EhLBPmnNWT/0VRlgGcNrsJe2NF9ugmko/soup69ZBwzvRE
         3cUBeS6Ue/BzWCq+en/H7LbqhB8HaeqwdcbgtNLA2oHtdNuIxTt/1yy/OHPHkaOiEAEz
         ov0Pxq/QWWfQMkLvyL1avZ82+pYbZ9sg/JM6F3zNqUX+t9+XMedlCmIH7c2tPpljZaEk
         fx1NGv/vzANWdTIvlk6LrISKq6ojPebU/UvIRglJEqwnJiwN6ejk+EC3GMOHu5yBOehC
         vd+4dZPzYkn0oId536oKDEr8oRsMtnpyo14qISzrWZPFv2R8K39GZaWAg3FysPtNEOJs
         xKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9U9q0lZUKvbYE54RBYTDoIiNw159S6rYKfxs0QanQdA=;
        b=t84iXfYXmniz82fbNE31uJ+aNEJGKotkIp+qCDcpz0JNKa9TKDi+Dq5q+dpZDH/vZP
         wsVXVq+aojqJx+GP+/8fB+Rjd0UEuFRKACdwstDB6ZQuN047Ue0c3sHfSrfpzEFmZdOy
         FQVrswQdfi8hC9V83pT5x/F7sL3CycVICZXajPm/YcQNohhqaOZBFeF+iq/t0X5mI4Xp
         u1QlWdcbV9tgHAcmxPJOEAf6TlZxXvjOejB0r3GKqcqZu21C6C7MF2PmavCgoHGYnf0U
         VuppIGLQM5b9hf0qY7wQYQ9ccKGO4tGmOYuzJpwKVh3iRNClfEwL9nM48kc5Xmw2F8bP
         m/tQ==
X-Gm-Message-State: AOAM531gsDiBKwzD2qtele0lX06d/SYtmHquroDTBgGXz7FnQNYFQXMo
        i9BpPrLa8s9ddYjh0ia+/QVQIXhMPiQMmEXP4HI75ySjtuc=
X-Google-Smtp-Source: ABdhPJy2xl2rUBT0EBVx9mc8SQaSdTYDIZ5+UnBlv5OtJBtHIvX0gEjsxmHl0LTo4Zn1RVIxV19ZPvTTK+kGldTW/WU=
X-Received: by 2002:a9d:749a:: with SMTP id t26mr13870019otk.370.1628419496524;
 Sun, 08 Aug 2021 03:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com>
 <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org>
In-Reply-To: <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org>
From:   Mikael Pettersson <mikpelinux@gmail.com>
Date:   Sun, 8 Aug 2021 12:44:45 +0200
Message-ID: <CAM43=SNV4016i2ByssN9tvXDN6ZyQiYM218_NkrebyPA=p6Rcg@mail.gmail.com>
Subject: Re: [BISECTED][REGRESSION] 5.10.56 longterm kernel breakage on m68k/aranym
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-m68k@lists.linux-m68k.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 8, 2021 at 1:20 AM Finn Thain <fthain@linux-m68k.org> wrote:
>
> On Sat, 7 Aug 2021, Mikael Pettersson wrote:
>
> > I updated the 5.10 longterm kernel on one of my m68k/aranym VMs from
> > 5.10.47 to 5.10.56, and the new kernel failed to boot:
> >
> > ARAnyM 1.1.0
> > Using config file: 'aranym1.headless.config'
> > Could not open joystick 0
> > ARAnyM RTC Timer: /dev/rtc: Permission denied
> > ARAnyM LILO: Error loading ramdisk 'root.bin'
> > Blitter tried to read byte from register ff8a00 at 0077ee
> >
> > At this point it kept running, but produced no output to the console,
> > and would never get to the point of starting user-space. Attaching gdb
> > to aranym showed nothing interesting, i.e. it seemed to be executing
> > normally.
> >
> > A git bisect identified the following commit between 5.10.52 and
> > 5.10.53 as the culprit:
> > # first bad commit: [9e1cf2d1ed37c934c9935f2c0b2f8b15d9355654]
> > mm/userfaultfd: fix uffd-wp special cases for fork()
> >
>
> That commit appeared in mainline between v5.13 and v5.14-rc1. Is mainline
> also affected? e.g. v5.14-rc4.

5.14-rc4 boots fine. I suspect the commit has some dependency that
hasn't been backported to 5.10 stable.
