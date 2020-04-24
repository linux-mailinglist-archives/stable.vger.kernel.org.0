Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111341B7130
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDXJuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:50:16 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40595 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgDXJuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 05:50:15 -0400
Received: by mail-io1-f67.google.com with SMTP id p10so9713709ioh.7
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 02:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6dHUDskGTlpWCtHIuIBU/ej74enmuqs9QrIOjUxDxTw=;
        b=bZfSi8G/Ds+jCGwev9qoBlCfi3N1YDRdEr+MwJ9SB2ssavdc3IxAQSba4vHuU7HPOP
         bZfPFWhwVvmlAzRIaWNvdw+SEW+0MPkjmK+m95IW3A/XS5uMuEH5/+jX192nJQXiILEg
         XgZ9CaZ9pv1KmY/rGpW2ADU+xw3JT2nBew9JjJO9r6RH6nWgBUCG7o0vkIYHJpoTyw53
         C+R7tEUdGXu1ULoqoa2lgVbK+fgh2weEyUw9gsIJWjUBd9b8SP0QSVhZEEBDtcv/XVdz
         fEo8AnHNiVxGMvGeNay8w0BtxlQ4oxs83fGNzXuTqnK6t4rZKlVgyc7JTR0mcrfwRtNu
         avyA==
X-Gm-Message-State: AGi0PuYwg5w5sn9npAzq/jF68esh74yFz33LZS9uOisgyWpJ/Exf8Ikf
        MU/rkeVLgmBkmGNRRBnweKJBK6cuL8f1yYVy19I=
X-Google-Smtp-Source: APiQypLo8lbC1Ovo4n92FN/j46YMwq/dyCmxWua4lxqlPJfsenvQiuY5gG/RchGdG0F7d3aJexBikTqnhB//ZAoT9/Q=
X-Received: by 2002:a6b:7317:: with SMTP id e23mr7827695ioh.72.1587721813333;
 Fri, 24 Apr 2020 02:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <1585635488-17507-1-git-send-email-chenhc@lemote.com> <20200331145325.f6j2jjczlz33xuyi@sirius.home.kraxel.org>
In-Reply-To: <20200331145325.f6j2jjczlz33xuyi@sirius.home.kraxel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 24 Apr 2020 17:57:37 +0800
Message-ID: <CAAhV-H6vpKk=MD3PX8r6ByT7u4fhwfUcBX6c8FGVA-D0yqm28g@mail.gmail.com>
Subject: Re: [PATCH Resend] drm/qxl: Use correct notify port address when
 creating cursor ring
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Dave Airlie <airlied@redhat.com>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,  Gerd

On Tue, Mar 31, 2020 at 10:53 PM Gerd Hoffmann <kraxel@redhat.com> wrote:
>
> On Tue, Mar 31, 2020 at 02:18:08PM +0800, Huacai Chen wrote:
> > The command ring and cursor ring use different notify port addresses
> > definition: QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR. However, in
> > qxl_device_init() we use QXL_IO_NOTIFY_CMD to create both command ring
> > and cursor ring. This doesn't cause any problems now, because QEMU's
> > behaviors on QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR are the same.
> > However, QEMU's behavior may be change in future, so let's fix it.
> >
> > P.S.: In the X.org QXL driver, the notify port address of cursor ring
> >       is correct.
> >
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
>
> Pushed to drm-misc-next.
It seems that this patch hasn't appear in upstream.

>
> thanks,
>   Gerd
>
Thanks,
Huacai
