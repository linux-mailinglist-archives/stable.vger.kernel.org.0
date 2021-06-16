Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123D03A9BD3
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 15:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhFPNWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 09:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbhFPNWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 09:22:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CDFC061574;
        Wed, 16 Jun 2021 06:20:06 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id my49so3858873ejc.7;
        Wed, 16 Jun 2021 06:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9xU6WRg5z0sUzGECNos7mIypHHvCktW/w5KjCa93jY=;
        b=StsJr0hl0cK0uQCN42SYJrcFPIdnL5hJLfW1GDm7ObHbKDHX1i6+plBTcNFiU/IZnH
         pJaDsmVOLy3osQ0Kp/rEnE54a6PZt2wnvfsFffFRdXx3sjrEmKdLVKxzLxHoMLadgUxp
         ZVsS3xhURVfNLSD4iPx7EF+yPVahr+C3cMHCB2YrRaIAOrnSSFREexJa856/e0nvuNB2
         Hi+qPEvPDjQ59a/kqeXk4rgy1B5iB68tKCuNE5AoBQQ/dTNWBUeQOzuYpYiF8Egqmq6d
         Rm2c8kfH0EncrLVGby+qD1+hqkMSZ5O0WFUXDslga4qARER3Rxi/567AC7GAqhrx8qzn
         MDaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9xU6WRg5z0sUzGECNos7mIypHHvCktW/w5KjCa93jY=;
        b=o4/GkFFDl6SRswskPL0IIZXGOaImOvu0Mmg3Yv3i6tBW6OidrNFpiCh11em3geYDd/
         +ge5nZGH5wt7IP2D6JYjwYS05dkn5dmVt+CKQd8wF1R1yEsfzGu0JBuZLDuFuJ4X3Vu0
         CHQM3KNKBprl6YhbwftCAU2ODGEG6U1zDBjcdoygopk7+a3avXiUPWOwbyWBheD6Gwq9
         MkDjFF9lXT4HeC8MoIryqzo4pSHLnTMe9BFfSAy4gaU+S+f/PRYpnz8hgF+E5T54FuKD
         FFmYHUF+U1XyiMmW4Xwm1figeUawENBDG5r1ndvEIKkkv7SBFYkbnPbmwYKY6dfW/rtk
         gG8g==
X-Gm-Message-State: AOAM531LMOIKflqPpleLZ5i+rmF1SU24n7jQ4DkEv5S1mx2Kmvk9BgEb
        UJ8gm33XoGEifs49Q00CrGG0d5JiceYtDE/FZIw=
X-Google-Smtp-Source: ABdhPJyFEKtCneHl93v+sbrDC4AyudkYfTDVIu+e/Og+r4lR5oeGhEwo+e8fBFJqr93vnGWzszgMiKmN4mzqAjxaGag=
X-Received: by 2002:a17:906:7b4f:: with SMTP id n15mr5198906ejo.220.1623849604734;
 Wed, 16 Jun 2021 06:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org> <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com> <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
 <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
In-Reply-To: <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Wed, 16 Jun 2021 16:19:54 +0300
Message-ID: <CANEQ_++RSG=cOa-hWcHefqVa5_=FRo+PdwuJbE2A-NHA_RNXXQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID generation
To:     David Laight <David.Laight@aculab.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 1:19 PM David Laight <David.Laight@aculab.com> wrote:

>
> Can someone explain why this is a good idea for a 'normal' system?
>

This patch mitigates some techniques that leak internal state due to
table hash collisions.

> Why should my desktop system 'waste' 2MB of memory on a massive
> hash table that I don't need.

In the patch's defense, it only consumes 2MB when the physical RAM is >= 16GB.

> It might be needed by systems than handle massive numbers
> of concurrent connections - but that isn't 'most systems'.
>
> Surely it would be better to detect when the number of entries
> is comparable to the table size and then resize the table.

Security-wise, this approach is not effective. The table size was
increased to reduce the likelihood of hash collisions. These start
happening when you have ~N^(1/2) elements (for table size N), so
you'll need to resize pretty quickly anyway.
