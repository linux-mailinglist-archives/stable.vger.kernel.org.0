Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48665960B5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbiHPQ7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiHPQ7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:59:17 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53A87C1F4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:59:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id tl27so20088341ejc.1
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=PZiFKHAPInSqLmOQSyV+TmAHEnPDfiBJsJIlSVONBUo=;
        b=LRCjpJNqVhX8469WWIWi7kwgE6So402iY3NGTnuzSThPccWIrskygornwb3D41OzQ8
         AUJcD7neOIjJ1r8h+Jp8C9vYMNzRMuvxPNuRcwR+OxVlO2b01+dqO7h3GoedFTyK4/ix
         FxYRfhKhFY51NZt1Ph4W4hbaBuIKb82elRAmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=PZiFKHAPInSqLmOQSyV+TmAHEnPDfiBJsJIlSVONBUo=;
        b=GBt9nAAvlCXPDkBt2Nyuz2rTJHgYIudrWP8jEEGrFNvxT3h315QkEmq4KPxHezlYyy
         upOAAAJhM3E0Ca7L+5MwLF6sQyzvVPgXFAPCtr5pAG02IcGEq+PD0CEzxHEal5XIltjh
         MVknfQC0lgE7yP5X77Gzo+4/xRKTLyBkLj0CS6MJdkfOPKki5/0/SsBK88N68E3FbZhR
         U7rzRqvqH3J+G/SSd7fQwbvz5YqnKBy1xMF78E/emd3Pjgq5jaBM92ZlFA8Dw5zK5HQc
         zZsBpL0ouCc35d4qgUmmTzJwjMrpPThIZJCp/uIt2+0BVzTJl9Fqnawit4nwoxc4yQts
         S/ZQ==
X-Gm-Message-State: ACgBeo0lzbzSTxklrHJvSCSZQ/iqYylHBCU1mWpOB4SYOLQruCHVaLkd
        swXOi3PRZjt1mGbCbXZOcVe+IjyLx/VqhRYdnkw=
X-Google-Smtp-Source: AA6agR7Yqu2ckGtYGX+swloNzh3yGRGfTe/idV8UeyKinTffVZ41GGoEWKBwE0zQvXo6XNfm8kGo+A==
X-Received: by 2002:a17:907:7b83:b0:730:8649:9836 with SMTP id ne3-20020a1709077b8300b0073086499836mr14243565ejc.0.1660669153950;
        Tue, 16 Aug 2022 09:59:13 -0700 (PDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906301500b0071cef6c53aesm5515690ejz.0.2022.08.16.09.59.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 09:59:13 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id r83-20020a1c4456000000b003a5cb389944so5811477wma.4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:59:12 -0700 (PDT)
X-Received: by 2002:a05:600c:657:b0:3a5:e4e6:ee24 with SMTP id
 p23-20020a05600c065700b003a5e4e6ee24mr8635263wmm.68.1660669152579; Tue, 16
 Aug 2022 09:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <YvqaK3hxix9AaQBO@slm.duckdns.org> <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
 <20220816134156.GB11202@willie-the-truck> <YvuvxnfHIRUAuCrD@boqun-archlinux> <74559da4-5cd4-7cc4-0303-ab5f6a8b92ae@marcan.st>
In-Reply-To: <74559da4-5cd4-7cc4-0303-ab5f6a8b92ae@marcan.st>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 16 Aug 2022 09:58:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=whn=gkf8kOxVPPeTpcgsFk21P9sk4SZRQ26=Jhqo6ewRA@mail.gmail.com>
Message-ID: <CAHk-=whn=gkf8kOxVPPeTpcgsFk21P9sk4SZRQ26=Jhqo6ewRA@mail.gmail.com>
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
To:     Hector Martin <marcan@marcan.st>
Cc:     Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tejun Heo <tj@kernel.org>, peterz@infradead.org,
        jirislaby@kernel.org, maz@kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 9:22 AM Hector Martin <marcan@marcan.st> wrote:
>
> It's worth pointing out that the workqueue code does *not* pair
> test_and_set_bit() with clear_bit(). It does an atomic_long_set()
> instead

Yes. That code is much too subtle.

And yes, I think those barriers are

 (a) misleading

 (b) don't work with the "serialize bits using spinlock" model at all

It's a good example of "we need to really have a better model for this".

             Linus
