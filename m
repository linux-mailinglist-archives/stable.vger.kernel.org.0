Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACA41F9AFA
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgFOOx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbgFOOx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:53:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396D9C061A0E;
        Mon, 15 Jun 2020 07:53:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a13so15564707ilh.3;
        Mon, 15 Jun 2020 07:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PzLODeo5kCBuBydptAl9EG85c2S9uCUTIghPM7WGHrI=;
        b=Ld/kDXe/GpaOFiwtcPx04ygASOETtYrA2o7jL1tqRZmD02Rszwfk78yBwHIGyPftAF
         /x1LkdoGCVJ2a2iks3DpaKuST/3QYPihF9qGtNyeZEH7qg/4UnGrpYSnEqbu3gn6YfBh
         EPCxfWT1NPwQk3GVQTgOeCwLFHb0X9709E4gfvAVcUy4UzZl0RfAdi/9xNXPLnMmYWaJ
         uGfmwYGmpvTF7tgJTaixqi63agth6chOM+RG2WvwfW7GYVtFkUPkQ/xgKrZrl8mwcelk
         ZI/hqvWInRrgIVhAXP/x9wn9jNvkSyoEg0eGpt8QGtAemevfP0uCqKG/i/bWeKH/JhXe
         Ubcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PzLODeo5kCBuBydptAl9EG85c2S9uCUTIghPM7WGHrI=;
        b=en2AA18ZFN01v1G7hEaulFVS8vsSipCmkFxigeEPahYdAbav/qXQPbC5fjlS/8s/Bw
         gXYexFhD5VMnQEywZi6WgwK7hai1xleufrw3VtboZPTAh0KKHawcTmDe4ivpL1o8gDfj
         XrtsscEiJ3p55sgFLYFfd5M3yiljsvsBbTf+SGkNIJSUQ8xwduLJgAmJC9+HpwJSBQim
         ESMNsKxQNj9pbtGdYrzoufJJdU4EIbHR5zDg7Nao0S98ZVfaKoQsiOJ5K1Sqorp0hg2x
         g12Rsk4u20zHYmiZBWXA639SQGyLzoNPNw5Uvo9POawvlvT3WdShzqjdZgu38pwcNR/F
         rgTg==
X-Gm-Message-State: AOAM531ZBOtuCzZh2Gx4gqRE4WYPth36MsNl8WxMCqXreACZOsYb/XBH
        cMXr7ogbnSQgyPR1+PumaOriUykMud465nEjqola2Ejh
X-Google-Smtp-Source: ABdhPJzHYsDv+aGOgSm4eVW9wFZEo9ZhievD2Gjn5An/GBjaq0kMq0f58qU903Mcxewu90XlQPTNbnHCmjRFI21BRqc=
X-Received: by 2002:a92:77c1:: with SMTP id s184mr27102625ilc.196.1592232836396;
 Mon, 15 Jun 2020 07:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200615131934.12440-1-aford173@gmail.com> <CAOMZO5Bw5qSDirAKBTRcu4_nDafDcfDGpuNRDyuLZs9Zc=HsQA@mail.gmail.com>
In-Reply-To: <CAOMZO5Bw5qSDirAKBTRcu4_nDafDcfDGpuNRDyuLZs9Zc=HsQA@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 15 Jun 2020 09:53:45 -0500
Message-ID: <CAHCN7x+=xjFTy6J4Ej61U2jXTez2rLrt=KtEOzbvV7Tzq6XoPQ@mail.gmail.com>
Subject: Re: [PATCH] drm/panel-simple: fix connector type for LogicPD Type28 Display
To:     Fabio Estevam <festevam@gmail.com>
Cc:     DRI mailing list <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Adam Ford-BE <aford@beaconembedded.com>,
        stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 9:46 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> On Mon, Jun 15, 2020 at 10:19 AM Adam Ford <aford173@gmail.com> wrote:
> >
> > The LogicPD Type28 display used by several Logic PD products has not
> > worked since v5.5.
>
> Maybe you could tell which commit exactly and then put a Fixes tag?

I honestly don't know.  I reached out to the omap mailing list,
because I noted this issue. Tomi V from TI responded with a link that
he posted which fixes this for another display.

https://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg312208.html

I tested that patch and it worked for a different LCD, so I did the
same thing to the Logic PD Type 28 display as well.

My patch and commit message were modeled after his, and his commit
CC's stable with a note about being required for v5.5+

I added him to the CC list, so maybe he knows which hash needs to be
referenced from a fixes tag.  I was hoping to not have to go back and
bisect if it's not required, but I will if necessary.


adam
