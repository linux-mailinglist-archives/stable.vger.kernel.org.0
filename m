Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B80205B25
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 20:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbgFWSwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 14:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733138AbgFWSwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 14:52:30 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF19C061755
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 11:52:29 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id n5so17742352otj.1
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 11:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o0ZyZBP3R+xTsYbXudhPpeqGQTx9+AtNXicoVw+deco=;
        b=gdKqYos2nRamqmG/sd35v1EqNpbtG3PgDZ2E/tKpeKaJVjd4jrL/oqg/dsC2xdGuAe
         Qkmdffu9YfXVdVYSddOShypUzRWjTKVlWLxPdP9yqsTz7molW/pzEeuAUYju9xxAAcgq
         K9PUEARzddqf1oxlK1zqzhgkwo5t3CaCemnRymg8KwkEqU7p7N3RD7ihuegY7ql0WoV3
         wjKEEeyegTPJ83s8obqhz7P1ZUyNxmBRgaipBT18usGwYxJmZsAdpWUD/5X6ZIeQl2Hj
         08RzZPNIT6yNJJQoLxFURJfHOBxXMLf5g6IcnutbZvEmXa7QXH5+blWDmvXQB3xaOTrw
         xWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o0ZyZBP3R+xTsYbXudhPpeqGQTx9+AtNXicoVw+deco=;
        b=bKgM1mcHvUa+gZFUy2GiTee02eYzkEi0phboDYCjHgwiNdr+tXwetEMNO2jMBVT6yN
         x4Bs9306MMKYb11N8cwMhDCZfKUv+lwfZ/jWhZzpWoNhJtDFL8UNlXhs6RrfW8iUdB0W
         Q2Vz3z3mpxI0/nG7WJHk6r7dt8AVmDr4C3CnVcHiaOChtn4PqV6UZ6ccOvGGapeMqx3B
         fHqNR2FZWwG84+puzd8uothZy0sDBTDbvR8wEHGqLYTc4LYeckP9peiUzo/ARThEiVMj
         iHW745fLBZi88f9HRXUa2fma/lL4cCaPdlrsceieI9zhkka7UIpWLLQ8Xtg3NX/orusX
         3ErQ==
X-Gm-Message-State: AOAM533KWuIp/Pow1hGpbzhwAJsmYjKxXyW5C8Ooxs5gSR43dLBWKixp
        CPV0HkrdwwYj9oGc+scRflmhF+JaPU1kFY0rfJU7XpEYNTRz7Q==
X-Google-Smtp-Source: ABdhPJzp+aM0LlFXFQjN4tMW0nFimdEGTUlw1nniLZRr8VJRCoJV2HqfPjDySP2P6IFuViQjezhymY70H2D/O0Ud/6Y=
X-Received: by 2002:a05:6830:210d:: with SMTP id i13mr18314198otc.252.1592938348318;
 Tue, 23 Jun 2020 11:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <1592937087-8885-1-git-send-email-tharvey@gateworks.com> <CAOMZO5CbLvf_iV5K1zXZdYqgpBqrOZmTGR=NYyL+j73ojTGOnw@mail.gmail.com>
In-Reply-To: <CAOMZO5CbLvf_iV5K1zXZdYqgpBqrOZmTGR=NYyL+j73ojTGOnw@mail.gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 23 Jun 2020 11:52:16 -0700
Message-ID: <CAJ+vNU19ebj3xpOKxeHMzdMQjVdZoJCTFJ5DSYat7U4tpZTWvQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] ARM: dts: imx6qdl-gw551x: fix audio SSI
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 11:41 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> Hi Tim,
>
> On Tue, Jun 23, 2020 at 3:31 PM Tim Harvey <tharvey@gateworks.com> wrote:
> >
> > The audio codec on the GW551x routes to ssi1
> >
> > Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>
> Shouldn't this have a Fixes tag, so that it could be backported to
> older stable kernels?

Fabio,

Yes, it likely should as it fixes audio capture from 3117e851cef1b4e1.
I didn't think it would apply cleanly to stable but it looks like it
does.

I cc'd stable@vger.kernel.org. Should I submit a new revision with the
following?

Cc: stable@vger.kernel.org
Fixes: 3117e851cef1b4e1 ("ARM: dts: imx: Add TDA19971 HDMI Receiver to GW551x")

Thanks,

Tim
