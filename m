Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52653E4A15
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 18:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbhHIQhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhHIQhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 12:37:16 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04507C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 09:36:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id t9so35201233lfc.6
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 09:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OXlEntOQ4sJUD3Y+k08wN+RcN/f3NBdEb9pRW4WUJbQ=;
        b=hxVvbbo3nbmOJFdkPaEEI6mLUpATRgeZCSnVhqH7oiFVZs2qqoaHFlauGBeZXsF8v7
         o6ZUyEJutJTb6QheIki2sHXfocFo5tnhOYu9UFiyjsmkvL2n/S90/dwLTbV3ZKKVWHry
         69rDSlaNaxGlOnzTSaIipjUdas1tUkBjqlEWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OXlEntOQ4sJUD3Y+k08wN+RcN/f3NBdEb9pRW4WUJbQ=;
        b=OhPW0Tg1B0sPBVzqmhXNn/MCKdtO0UwTu2R1ojwpuSxgQfOoI0l+/xSf/dpNIJmi0R
         xN6v2PZRGi+LsklJKszKK5FeiVLJVOMZPfqManRtVGEamp/nKHRsyXL/yQIl3nZAS2e4
         t+Q7vsfVQft/J5TvcppS2YDPVHEmdx2+59UvA5lN5PcrkTgGOugQuICvp/WlzA9E+xg9
         e4amnwvkKZp0F4xRiRPuPnVDbGSNGER/2WIAn/Hk7m7ZaKIybBlU+msdEz5lCDbiWmuP
         5bHMM5YkWhAsiDUfupJjOyhI7K2s4+VWoYonKkFA5IMXL8o2sSkkEHc2pP3hgPvoLmHz
         Hp/Q==
X-Gm-Message-State: AOAM5305reiICeFwST47RLvTRfCuWlrPnuzP11ozCAJS01TDOBHD6yvl
        CMcNAfnLzTvGuRoQFEODNqrUz433kFuxLBmL
X-Google-Smtp-Source: ABdhPJwHr3nYe+A/VI7PAreSZqnAgOCZ8FqcqB1/w0WjVBtMRbS0uu64NryqrzX+RDQKwGSVmBxp6Q==
X-Received: by 2002:ac2:4d55:: with SMTP id 21mr18732126lfp.458.1628527012578;
        Mon, 09 Aug 2021 09:36:52 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id g30sm1782983lfv.196.2021.08.09.09.36.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 09:36:52 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id a7so24450609ljq.11
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 09:36:52 -0700 (PDT)
X-Received: by 2002:a2e:84c7:: with SMTP id q7mr16019081ljh.61.1628527011843;
 Mon, 09 Aug 2021 09:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <162850274511123@kroah.com> <CAHk-=wg9Ar-XBVQ860-TLA-eo8N=UYO8DQ5Ye0rBBuiwzv_N_A@mail.gmail.com>
 <YRFXe06Eih48qlD7@kroah.com>
In-Reply-To: <YRFXe06Eih48qlD7@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 9 Aug 2021 09:36:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
Message-ID: <CAHk-=wh5E7qqooGiqHJ3U2=PBFPs1UKuXMcoNi+3mQ4wZDha7g@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] pipe: increase minimum default pipe size
 to 2 pages" failed to apply to 4.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Willy Tarreau <w@1wt.eu>, "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 9, 2021 at 9:27 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> But that commit showed up in 4.4.13 as fa6d0ba12a8e ("pipe: limit the
> per-user amount of pages allocated in pipes") which is why I asked about
> this.  The code didn't look similar at all, so I couldn't easily figure
> out the backport myself :(

Oh, I guess I have to actually download the stable tree. Normally I
only keep the main tree git around..

               Linus
