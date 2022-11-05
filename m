Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA18D61DD1C
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 19:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiKESKN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 5 Nov 2022 14:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKESKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 14:10:12 -0400
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B22D11F;
        Sat,  5 Nov 2022 11:10:11 -0700 (PDT)
Received: by mail-qk1-f179.google.com with SMTP id v8so5101792qkg.12;
        Sat, 05 Nov 2022 11:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=slKF0rJ0Rir2ceC3QpwgE09jNGnnMT8HqJLhQZweuOI=;
        b=5rZMoWHn1/8Dd/kRnWrDkF968aOk1iYrhfTZjG7l7t0rkF6HxXyW1Z1rgA2CIepdfP
         JNbwJmeAdjcNYbFBhn5b8U5qQxzxVV5lo6h3H8vrGW+5VhwZA+72kVWkLc4/f2NbDgCK
         dcaTMISgd5U4hkZleI9HJfdtcYHZMa3l4LAfBQMcwmD+TaNpe/AusJC2A/pXT8gGAERU
         HeebD+izdr8OIQY51u6n5SdZ0jbusNAWsjSt1o/6v3bxS357IRFNQyTcJp8uQcPsMEtq
         b2L3keSl3FVXqBC5P1w8YPo2+oreDcFD0rqaBn5jBtTR6XPIMfHzkPY5M8qGLMa08NUw
         CXPA==
X-Gm-Message-State: ACrzQf1sTPCLfNl7EjxqzhGKnQojyoN3Ze071EWqlhLA4grBpNFcVlT1
        ADnuQBtaLF7W3Jp/z0YQetwfVNn9H3LOaKg1nE7cU5UJ
X-Google-Smtp-Source: AMsMyM6BpBjF6/vW3DJWYsm3B9od11m82oLF5euQ2Yv/K8jVFRoDkiJsT6XrOY8b3dsijMxeNhvQ5mPjrlJA6Kf1p9Q=
X-Received: by 2002:a05:620a:1476:b0:6fa:4c67:83ec with SMTP id
 j22-20020a05620a147600b006fa4c6783ecmr18552724qkl.23.1667671776746; Sat, 05
 Nov 2022 11:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20221101022840.1351163-1-tgsp002@gmail.com> <20221101022840.1351163-2-tgsp002@gmail.com>
 <CAJZ5v0iPFPbbconOoQ7x_4X5yJ31pP7aduLqG4dq6KgAsprKbA@mail.gmail.com> <fe95b054-e720-ebbf-ba03-4ea6662974ad@gmail.com>
In-Reply-To: <fe95b054-e720-ebbf-ba03-4ea6662974ad@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Sat, 5 Nov 2022 19:09:22 +0100
Message-ID: <CAJZ5v0hYc8sowEPaCKUG6yDkza6ax3d2iDeeSO8OQjot4OhLEQ@mail.gmail.com>
Subject: Re: [PATCH -next 1/2] PM: hibernate: fix spelling mistake for annotation
To:     TGSP <tgsp002@gmail.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, xiongxin@kylinos.cn,
        len.brown@intel.com, pavel@ucw.cz, huanglei@kylinos.cn,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 4, 2022 at 8:31 AM TGSP <tgsp002@gmail.com> wrote:
>
> 在 2022/11/4 00:25, Rafael J. Wysocki 写道:
> > On Tue, Nov 1, 2022 at 3:28 AM TGSP <tgsp002@gmail.com> wrote:
> >>
> >> From: xiongxin <xiongxin@kylinos.cn>
> >>
> >> The actual calculation formula in the code below is:
> >>
> >> max_size = (count - (size + PAGES_FOR_IO)) / 2
> >>              - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
> >>
> >> But function comments are written differently, the comment is wrong?
> >
> > It is, and it is more serious than just a spelling mistake.
> >
> >> By the way, what exactly do the "/ 2" and "2 *" mean?
> >
> > Every page in the image is a copy of an existing allocated page, so
> > room needs to be made for the two, except for the "IO pages" and
> > metadata pages that are not copied.  Hence, the division by 2.
> >
> > Now, the "reserved_size" pages will be allocated right before creating
> > the image and there will be a copy of each of them in the image, so
> > there needs to be room for twice as many.
>
> According to your interpretation, the formula should be：
> max_size = (count - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
>                 - (size + PAGES_FOR_IO)) / 2
>
> Am I right?

No, you aren't.

The formula is fine.  I've attempted to explain it to you, but perhaps
it's not been clear enough, sorry about that.
