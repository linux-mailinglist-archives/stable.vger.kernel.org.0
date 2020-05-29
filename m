Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0BA1E881C
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 21:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgE2Tqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 15:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgE2Tql (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 15:46:41 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB3DC08C5C8
        for <stable@vger.kernel.org>; Fri, 29 May 2020 12:46:40 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id e1so982182vkd.1
        for <stable@vger.kernel.org>; Fri, 29 May 2020 12:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4W5Sat/5R+Ack57F4Z6oQH+X3by1m0TX8wOY8Irmk0=;
        b=fU1bOuEt5ZzOPNFtsNlrTYxfPSrX/xHwM5J5MKGPDD6kgAzyoE6ZK5uDdK6EM1pkmb
         hRfASs8dsVBYo8LNKhDOUFKq3v+0ur6pZsEjP6dGBEEADcKT2QjKJ8Kr1pdyYWXrmxck
         r+P2wwlEVgG8xPVZY/Tnph8PuFxg8Ik4xRzJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4W5Sat/5R+Ack57F4Z6oQH+X3by1m0TX8wOY8Irmk0=;
        b=LkNFfBO3F0SGOA2lF67/47O6xPhIlRuDiF9YCAywYMzSYUMQP0CPbzrGt+oeN+TTos
         rGIo4ysykU+K1isLkqUZbBSTvStKDpnhuEw3lJCv1srUggsTTZq3nNneG+95R7q2F7kf
         c67wUrKvaebg6oV8qcTwNDopqGErU/o1Me6LTW96WspqwQ1nFx105aKDSA6FcCYuoQzG
         2Z+9gyraG7OZpJYBZaNupYPj5CtgzXI2hUDrLXFvodyki12FTE7mbf4IS+QCR7vtcEmZ
         B7s2fANAdV6XWHFbBfGTcXs04Dl0PpXC31AhYZrntfMQLJqdU2tDC1XJPhQ1423P8fTG
         E9HA==
X-Gm-Message-State: AOAM531pm8+2m0rVmL7+v5mRqDIr7gnWJ6hC1AHTatPozInUTrAhy/l0
        5AnSkWYMnFtN61JcOBDmHBiF73aImy4=
X-Google-Smtp-Source: ABdhPJwqsZRkQ1RZB1qTf1FgKRTB7GVClEIdjv4MTd5oTP7RiWiN+KhhYUzIpDQ/jLQgL9vvMXb7Tg==
X-Received: by 2002:a1f:26c4:: with SMTP id m187mr7128180vkm.45.1590781599368;
        Fri, 29 May 2020 12:46:39 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id i27sm889912uab.17.2020.05.29.12.46.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 12:46:38 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id 1so2176025vsl.9
        for <stable@vger.kernel.org>; Fri, 29 May 2020 12:46:38 -0700 (PDT)
X-Received: by 2002:a67:1703:: with SMTP id 3mr7608885vsx.169.1590781598116;
 Fri, 29 May 2020 12:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
 <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
 <0f6b1580-41d8-b7e7-206b-64cda87abfd5@synopsys.com> <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
 <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com>
 <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com>
 <CAJz5OpdMDumfdYC+aj0N20p4qVEkEkHhNY3uKest6RSpPtrDWQ@mail.gmail.com>
 <CAD=FV=XsLA3w2QPcNF3-mgZbZoGsz4kg_QvHcoZV=XTVDYhnSg@mail.gmail.com>
 <20200529190031.GA2271@rowland.harvard.edu> <CAD=FV=UUULUgw_fnpbv2b-m8=CrOJimOba+ewRJj_hMB7niK1A@mail.gmail.com>
 <52f936c5-7f3f-5da0-33b8-3e6d4a4008d1@synopsys.com> <CAJz5OpcP860ANLLZELB7GNSsGAY2SvataZVAMyQj_HG0udkOmg@mail.gmail.com>
In-Reply-To: <CAJz5OpcP860ANLLZELB7GNSsGAY2SvataZVAMyQj_HG0udkOmg@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 29 May 2020 12:46:26 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VuX6pAtU+3-uXAJ8sXecbuiRNDj6RP36Xkyp-_G85-VA@mail.gmail.com>
Message-ID: <CAD=FV=VuX6pAtU+3-uXAJ8sXecbuiRNDj6RP36Xkyp-_G85-VA@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Frank Mori Hess <fmh6jj@gmail.com>
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, May 29, 2020 at 12:45 PM Frank Mori Hess <fmh6jj@gmail.com> wrote:
>
> On Fri, May 29, 2020 at 3:33 PM Minas Harutyunyan
> <Minas.Harutyunyan@synopsys.com> wrote:
> > So, can we conclude on this solution?
> >
> > dwc2_disable_global_interrupts(hsotg);
> > synchronize_irq(hsotg->irq)
>
> That solution is fine with me.  Disabling the dwc2 interrupt sources
> in initialization before the handlers are registered is also worth
> doing, but it doesn't have to be in the same patch.

Sounds fine to me.

-Doug
