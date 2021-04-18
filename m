Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7AD363627
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 16:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhDROsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 10:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhDROr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 10:47:59 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489ABC06174A;
        Sun, 18 Apr 2021 07:47:31 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id o13-20020a9d404d0000b029028e0a0ae6b4so11153812oti.10;
        Sun, 18 Apr 2021 07:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ywAWzjBuB7SBRfV7jQ7uOvrJs1PtdRwoYc2ALtF/tEI=;
        b=UM1ikJYhkwyxWdPDiE5uRnL8MvTn/DeFnBb3Vf2+xpF6dyfClbc5pu0n9lwiyjHJuM
         sDIpBZHb4eD2bNUrBaeF2WYXKuNp7b2+YGYF3x+6BOCEBO9r9bns8i07oO2rRsDhpT4z
         QaLaPWXyCjieB71NF9Qetaeqz3pq4X9JFTh2+ZCvP6ycx67rc09gDR5GAApCiCfEiuM1
         tlAr6OVjFiVazvuHb/6DynDdsvLvF1HisQeySkgyEXUb+y+QFi6DqeO3WpU0W1JVNkjh
         PxxfAw6cCKeMmypV6O7b1a/buaME37u0IBCgpHpHgzY3yDTuw1bOA6qTITku1Z1P4pdw
         qvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ywAWzjBuB7SBRfV7jQ7uOvrJs1PtdRwoYc2ALtF/tEI=;
        b=a9iOO8ZN72fIozYvm/tZB54oKmHOcnGvdA5MD/55ot1adHveBTRcGRorSZbN7Hj5Zq
         97JTNTcJGl+EJ1FRhIDfL6AVhlbDsLMaPEjutaFgapkzGxCxzvJ5kX0vP0P2k37VWMLx
         OWp8feggk/3tOvv4NTL0RxJLhyfTkFkdGuXF3BKd6hqQlZiDHoBhGoBcgA9sarKA2Zz6
         FVWzdOeyYO3BrciOTP76S47Zj2LP7f+PJvLsPBgc09GCq08IgM4BYCsiecsT/8O/+Xn6
         nv/be+Tf1kqMfFbsij7yMKunppxVW9+MSldhdzV8PQuodloydTiVg3KhL/owCzY8OGbm
         LHdw==
X-Gm-Message-State: AOAM53059PNNhPM1mkfP8E52Ka1vKUFYNktG2F6Wl33Muxys4s/f+EF+
        NMXwVqd7KdtbauLZVy+EPuj9g8OSuBRh3rGzoVerROX5c9PDpw==
X-Google-Smtp-Source: ABdhPJwCyg6Wj/fAOO+ha5il4h8JeU1mA2fe92BODRlrnLGytb8jgnzO3ElI0IsC/X8N6Q8fj07SOH/ZPxBhBl2w7bM=
X-Received: by 2002:a05:6830:1411:: with SMTP id v17mr11719713otp.87.1618757250650;
 Sun, 18 Apr 2021 07:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <1618749928154136@kroah.com>
In-Reply-To: <1618749928154136@kroah.com>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Sun, 18 Apr 2021 10:47:04 -0400
Message-ID: <CAPFHKzdKcVDDERr8pmd=65Tf=tWNh_bKar9OLQd0oS2YBVu80Q@mail.gmail.com>
Subject: Re: Patch "net: Make tcp_allowed_congestion_control readonly in
 non-init netns" has been added to the 5.10-stable tree
To:     gregkh@linuxfoundation.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 18, 2021 at 8:46 AM <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     net: Make tcp_allowed_congestion_control readonly in non-init netns
>
> to the 5.10-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      net-make-tcp_allowed_congestion_control-readonly-in-non-init-netns.patch
> and it can be found in the queue-5.10 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
> From 97684f0970f6e112926de631fdd98d9693c7e5c1 Mon Sep 17 00:00:00 2001
> From: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> Date: Tue, 13 Apr 2021 03:08:48 -0400
> Subject: net: Make tcp_allowed_congestion_control readonly in non-init netns
>
> From: Jonathon Reinhart <jonathon.reinhart@gmail.com>
>
> commit 97684f0970f6e112926de631fdd98d9693c7e5c1 upstream.

Hi Greg,

Thanks for picking this into the stable trees.

There's an earlier, somewhat related fix, which is only on net-next:

2671fa4dc010 ("netfilter: conntrack: Make global sysctls readonly in
non-init netns")

That probably could have been on "net", but it followed this other
commit which was not strictly a bug-fix. It's additional logic to
detect bugs like the former:

31c4d2f160eb ("net: Ensure net namespace isolation of sysctls")

Here's the series on Patchwork:
https://patchwork.kernel.org/project/netdevbpf/cover/20210412042453.32168-1-Jonathon.Reinhart@gmail.com/

I'm not yet sure where the threshold is for inclusion into "net" or
"stable". Could you please take a look and see if the first (or both)
of these should be included into the stable trees? If so, please feel
free to pick them yourself, or let me know which patches I should send
to "stable".

Thanks!
Jonathon Reinhart
