Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDFA1AC193
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636051AbgDPMnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 08:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636031AbgDPMn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 08:43:26 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D2C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 05:43:26 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id 74so2728797uau.11
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 05:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZVkid3rc7AY2BIf9FYom5hI2rVbFTpZlNbuUZSVZDyQ=;
        b=oKC0QH/HjzeNF3lks1y8T1tZUUwktzx0rNXxQC4SCHfedKCeRlh/jv9VlXz2emL9Pn
         uGDjNzsAVOJwV8csdTtXsh1X8/IN9V4kry7izMP0fQc3AeIIlvD+8JbUPeb9hR3mjMFF
         d6yWqvNTV+0hREgUAL2AcKw6+7lWTReKrNMDo8n04TiNgQVS/Zd0WWfnk86xNibL4Sag
         wewUswxgyZzJ0IGIsDzsos9+LOxZGNLtjFfs5bNLPU7Y5ATKPcy6yc1iyJrb/VFrK3bH
         /JWuEcfS8LLyx5EOrZejOCAoZo6o/hzsGM7s6HnbOQ6t+XT6tqm71IciVkQRuhuv4IsW
         +fPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZVkid3rc7AY2BIf9FYom5hI2rVbFTpZlNbuUZSVZDyQ=;
        b=HFziZxmvgLTzVdie5py6IlaDIL3hG/gKdYBVZ6DSmpzMjLMoU32sr4Mux0QNUjIz6p
         kvqU537lHg1vD8O4aKRQL1VvlzTEE/IgeRaD1OjJBJ5oGQd8PUnMjnc1L1MVKprS57mI
         1xavOaCqobAyl7/V1pZb2Uys+EE08WK8HXxLRJE4Pc9Q5q1uyrLS1QVtGCbHMgsfHlrp
         RymGQW7jxZNPjz02QSSogfIgKpZkjsXRha/jYrKS5wap8udAH7EeObOLOQx2sFk8Lxg7
         cOLau8UM7QsfG3beqAZc3YWv5QtYwsdIWYjhJNfFF7wZq1tewVaFFIGzkFYV03DmOn47
         weVg==
X-Gm-Message-State: AGi0PuYW+97GJgOLxmGp0ar2tljUsuN1HFhuC3JgjXGXdQkfeMlqxz9b
        JuoGfwakH5B9NbiKWmX9ZhAn/dq2RrOY5xbOtF5NZQ==
X-Google-Smtp-Source: APiQypLIXpu92oqp/+MREyPuryALkW1kQv+A77t3wqtIRB2llSM8a0j58dfqRQ4dX6EbqxiUElS+1Qcy+yrw+5GSISA=
X-Received: by 2002:ab0:4890:: with SMTP id x16mr3308764uac.107.1587041005980;
 Thu, 16 Apr 2020 05:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <1586948807146181@kroah.com>
In-Reply-To: <1586948807146181@kroah.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 16 Apr 2020 15:43:16 +0300
Message-ID: <CAOtvUMfUiizr6gnj4Uynr9+1aRhYZEMmh4_CrE3i+TGQQ3M38g@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] crypto: ccree - protect against empty or
 NULL scatterlists" failed to apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 2:06 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From ce0fc6db38decf0d2919bfe783de6d6b76e421a9 Mon Sep 17 00:00:00 2001
> From: Gilad Ben-Yossef <gilad@benyossef.com>
> Date: Wed, 29 Jan 2020 16:37:54 +0200
> Subject: [PATCH] crypto: ccree - protect against empty or NULL scatterlists
>

Thank you Greg.

Taking these additional commits will resolve the conflict and produce
correct behaviour:

b7ec8530687a ("crypto: ccree - use std api when possible")
c776f7d37b6b ("crypto: ccree - make AEAD sgl iterator well behaved")
05c292afb0c0 ("crypto: ccree - zap entire sg on aead request unmap")

Cheers,
Gilad
