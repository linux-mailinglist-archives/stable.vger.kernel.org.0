Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8F61E88FE
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 22:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgE2Uhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 16:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgE2Uhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 16:37:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3ACC08C5C8;
        Fri, 29 May 2020 13:29:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j10so5331839wrw.8;
        Fri, 29 May 2020 13:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fB9V5yxTdl0Y/SF+tmGL/MfOvt9Ppi9fS3wB0UgNJoE=;
        b=rCQNkS8yjDJzrS7pJTvKxijntbCHM+wtCfEaW70MRgTQZcE93bQjqXxUAMMZQTQ4dF
         NJIVfw2kJXfifp2KRfeit0A/IkNuxYClReH9mDJJ9J2pWp9XRMHleFN7xDnQHC3PEaQa
         L82TA1QkWnjGpApa5UgMKwcB6wP4An8jw87+R5ySqS0FGhD7zqcajk7AM8mRA+YBh19t
         RchB++kI38hn9G1L9hqq1ogTRCN4HmmLpvQRyqhWwbDpQnv5YAY89Zh7vSYTLkWiSSr0
         REhO/TgnrMN4QCbbiYHHovvCsTXXmQm6W3In5vCJlOweP09O8Oxmvl4eJADUhyLdg8xI
         uwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fB9V5yxTdl0Y/SF+tmGL/MfOvt9Ppi9fS3wB0UgNJoE=;
        b=t2dxBHE4upIYKtEgBL5HuncOmFeaUM9eL5HIrkaU1h2d10tlhTqVxkJRrbMIYnR0Bx
         drhxOZU3TqbZqMS82Ndf9aNOhQEsQbqbuz2d1n64qQWXF62dLuu/aBWA8bXgLJ/GLTqK
         WGF+Cpho5WBH8WSVIyxOdmUpwzS5F4UPG2LCz4Z9tf3SSvPQinrMuKV7S1e1+UnWOC8G
         poJfPYP3OyrbxVY4A3raK2vIZ92GUss1qHsjwW0jN6BnuOIpck/MovDT5CZ/H4rFs+pe
         1D/JDZZSLtRZMPkqEFbzhoGGa9PtyaW5OIwVMIZJ6vDgU+NsaTeyLSHVxAGdpu369Hi3
         Ia+Q==
X-Gm-Message-State: AOAM5300cf0ba28lsTCgokr2q4YjEd1GJBX5AehSb2P12EG5sMf1cLuP
        4G5f9ylIxgg34nXj2iS5j4kOL2eL+72XtiCpDcY=
X-Google-Smtp-Source: ABdhPJwgvaCDlsEU6b6VHl1zt74QkOXIGbiWzt0svEVrnCthWkVj8mjupMJyZKpmiXt1gRk90beRtWHllU7oXod90Hk=
X-Received: by 2002:adf:ef47:: with SMTP id c7mr11084863wrp.57.1590784174030;
 Fri, 29 May 2020 13:29:34 -0700 (PDT)
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
 <CAD=FV=VuX6pAtU+3-uXAJ8sXecbuiRNDj6RP36Xkyp-_G85-VA@mail.gmail.com> <f68ce0c2-7014-64ff-73e3-94d93897e3b2@synopsys.com>
In-Reply-To: <f68ce0c2-7014-64ff-73e3-94d93897e3b2@synopsys.com>
From:   Frank Mori Hess <fmh6jj@gmail.com>
Date:   Fri, 29 May 2020 16:29:22 -0400
Message-ID: <CAJz5OpfBfFhDODB+kL+uAGVgtg6vMTS9NPuu78zV8kEpozR_dA@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc:     Doug Anderson <dianders@chromium.org>,
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

Hi Minas,

On Fri, May 29, 2020 at 3:50 PM Minas Harutyunyan
<Minas.Harutyunyan@synopsys.com> wrote:
>
> Can you test it on your setup and confirm (to keep "Tested-by: Frank.."
> tag).
>

I just tested the

dwc2_disable_global_interrupts(hsotg);
synchronize_irq(hsotg->irq);

version of dwc2 shutdown, and booting a new kernel with kexec worked
fine for me.

-- 
Frank
