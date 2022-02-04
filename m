Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022524A9E55
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377168AbiBDRvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377047AbiBDRvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:51:11 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5779CC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 09:51:11 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id n10so14609157edv.2
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 09:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o4hiJqR1yEZtQsqmzLlZSfYU8B7IPxJQai2V7jYSZc4=;
        b=RcFLddjHA0EwraDsXQJEq58cJTr2gUXIr9LfLuW9F/h0ucvYyxLmquBUMGKrYcyOpg
         NgOZnAMU8LjKRuXzparft+8yKW1fLvguR3OCDmH/Axos054DyKeWO1ZHsTYpT3+ztQzS
         AnA0982jKYnR0SSr8xJr9VFHphFQNA+Ixj/mU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o4hiJqR1yEZtQsqmzLlZSfYU8B7IPxJQai2V7jYSZc4=;
        b=2SxFq2RGWCpnQJqcI/MAjveQ4Ehgu5MKiAYYCwKZ8TlTWjErMAvE/lc4XXgUebaAOt
         1+grw+/isUVzFIUBpVuXv86qRhdJw5HnwO/KbfwzuJBCzVXnbrLgJoENwupaIPjpX0QK
         QVGfzbnHbMjZ1MLx407rNuilCAlJnyoszx886iNuHw/SABrAWlitkbyGUMXcujurwNq+
         qZB1If1VNAm17h2f6pS0Zz3N+gCDx3e+g+0SFoQbe39+5bINzIANQAjEfeolKH5AIyDj
         Y2JmjQzMgqCZ2XuGmY882hZhXVVMDAdCpZLMDqLkeBLxWXXjpLqo0rQKznP8FLkMykV1
         jvyw==
X-Gm-Message-State: AOAM533lFcaCPCidPd3T/kaEis4YE7Q1IaypzFeSP4WNvg4TcaZ+altF
        DGpS3g8dAGf2GyaZnCSWuOX5F9+mcleHEa9y
X-Google-Smtp-Source: ABdhPJywYCnIjujSCGwcm/VRd4wmbDrXpy03AvZckLeMB4pfkcZHQF1SssunO8atNi7VhchAfNVr8Q==
X-Received: by 2002:a05:6402:35d0:: with SMTP id z16mr245034edc.149.1643997069749;
        Fri, 04 Feb 2022 09:51:09 -0800 (PST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id bx18sm1080723edb.93.2022.02.04.09.51.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 09:51:08 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id r17so3674736wrr.6
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 09:51:08 -0800 (PST)
X-Received: by 2002:adf:f90c:: with SMTP id b12mr7765wrr.97.1643997067773;
 Fri, 04 Feb 2022 09:51:07 -0800 (PST)
MIME-Version: 1.0
References: <20220130130651.712293-1-asmadeus@codewreck.org> <Yf0Fh7xIgJuoxuSB@codewreck.org>
In-Reply-To: <Yf0Fh7xIgJuoxuSB@codewreck.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 4 Feb 2022 09:50:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgeEada1nT7yqc4SBKr9q9WeuBxDyJGZ9ebjP631ry81A@mail.gmail.com>
Message-ID: <CAHk-=wgeEada1nT7yqc4SBKr9q9WeuBxDyJGZ9ebjP631ry81A@mail.gmail.com>
Subject: Re: [GIT PULL] 9p for 5.17-rc3
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 4, 2022 at 2:53 AM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> I rarely send fixes out small things before rc1, for single patches do
> you have a preference between a pull request or just resending the patch
> again with you added to recipients after reviews?

Generally, pull requests are what I prefer, partly for the workflow,
partly for the signed tags, and partly because then the patch also
gets that same base commit that you tested on.

That said, despite all those reasons, it's a _very_ weak preference
when we're talking a single individual patch.

So if it's easier for you to just send a change as a patch, I still
very much apply individual patches too.

             Linus
