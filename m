Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450D635AD26
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhDJMCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 08:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhDJMCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 08:02:10 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8102C061762;
        Sat, 10 Apr 2021 05:01:55 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id p23so5874931ljn.0;
        Sat, 10 Apr 2021 05:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ms7ohJBgjEkyiG1bcAusjToo4RkzhjMegDyZXWoaGwY=;
        b=Veie/yYBQO6Wa+Tc0Iiev/WPDpWA7ig8xWc629ssJ4VZykMzc4KZ3/UATQFYix8VLl
         Pya5fgUVRd+WleJx5sNVJlOPolEJiUwtyiKBvgrsooxRkjS/YDnLXvSZm7h0kuTxLJN6
         3tLn7U35mll5kncpgm5iYK3Aj8DO2lAb0XQ2MzbF9EeRoSyaUn+BoFv7dd0776260Onx
         6NLYau/aVuvfJAqXeyxVBz6rIqNVvcVHvbl1JwcI6TN3RUOxgMT4ju/Jfv7nj8xq+KkC
         A3NYwV2mr2pM1jo2tv8+iR+9hPsdHi4tHqDnkPp3NCr6EIuaAzs+3wc8kxHysoojlikD
         lQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ms7ohJBgjEkyiG1bcAusjToo4RkzhjMegDyZXWoaGwY=;
        b=cLKGZw0qb2EwvTa/340j5MVbbSs/QMYW58ZIMS6Z8hSJ+owNZbKq74Z44DlUGNSPZN
         dqU2N0b4LXgR5wUJnF77BgO5PWoLE2GArbtCK1pU4JV9zTs6Yc/gnAe2wq4pMcY+K9rS
         JBcM+YyEll6lVuCFn1wRJXDZtbpm09aRCFP5CJdw0t6lcWzyEh6EMROT1I8UcPZwy/Uk
         nGPFIPyWAyq3gJeuNloFtj8j2fcOjvj5mS2bwogKYnXBfkmOer2QK5UuTb7fCbmE3/Q6
         4lDb/zreE2EDywl5U9HYYQaLh6MdaZ/HC1hGZw1WOk1gyfJ1CUlMaHrCAOYk7wqj7Ejl
         cdWA==
X-Gm-Message-State: AOAM533r4kVjwCbClmMzw0MrpiLSmyfYa5M2anPIth4BEyc7bdWh+aD4
        RYheLSi3CV+n/rPwtt99paVmHW5/Z15KK9wyGBo=
X-Google-Smtp-Source: ABdhPJzgxeVMzthaKfVBOM8IDFrjuTtQKMq5CCZxguGilgOrJ43rG4Hf1l28Yl++gOSrmhbQQYDpeM5hL3QObjeGjWc=
X-Received: by 2002:a2e:87c6:: with SMTP id v6mr12155140ljj.490.1618056113408;
 Sat, 10 Apr 2021 05:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210410090919.3157-1-brgl@bgdev.pl> <YHFsp1Q0rcqQwz3t@kroah.com>
In-Reply-To: <YHFsp1Q0rcqQwz3t@kroah.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 10 Apr 2021 09:01:43 -0300
Message-ID: <CAOMZO5AnHUVC-ESGSjXtqsaB0-5HP9hKkA7o0_k2dkm9d-+vHw@mail.gmail.com>
Subject: Re: [PATCH stable] gpiolib: Read "gpio-line-names" from a firmware node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable <stable@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Roman Guskov <rguskov@dh-electronics.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sat, Apr 10, 2021 at 6:15 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> What is the git commit id of it in Linus's tree?

It is b41ba2ec54a70908067034f139aa23d0dd2985ce

Thanks
