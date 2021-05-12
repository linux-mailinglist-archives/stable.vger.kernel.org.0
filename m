Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA2037BC96
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhELMfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhELMfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:35:30 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E98C06174A
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:34:21 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso576181wmh.4
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L3AMrfm7KzdYjAx0MG/kXRzLEqn5TfDInWeiOnoS8A0=;
        b=wGwwVglhSHA1nu0sddt1O78EWcwn6fB5M95MBU2mYu8yxjZWRmVl4Xk2W/HBVliIQ+
         VqbqZ4D3hgvRwEI1eQ0SgoEs1oOuTGok3UPrOy9fE4HVc/V0LQd182Ehxjlb7M/vBxJZ
         1RejYqLqgKbdZ0/pTt6wEMHd7BbvNQfmn8aBdO+FGkEvHNyA9co4wkELQmNPARhE1beW
         7DK+sIGytXjOYdOJ7HhZNAMAAGxlGbDm3fMt3ulRHEjA9g6MXUa/2FfQ2FELIpeebL8E
         ythDkvX3BJoH9pQYp67RthOVD/w/EfKqEQnDXyxRkx3Brks5/3IgR1ibdRT56edbosyD
         Ukpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L3AMrfm7KzdYjAx0MG/kXRzLEqn5TfDInWeiOnoS8A0=;
        b=iNVoAjWLWq3cCByhNMb+oZeG7HtcbuLUIsTY/U43gsiEY0VYI86f6mdAMEbWIFOZQv
         JuFmnIuGGF3Wv2ouKTLa2MNsmUhyoFHLZaZ9wpVGp8Mf8ZgaVtNTok6a5mf+zj8hGa2W
         U9DgRINXBCDHR+L09G8/DK59PKOY6NH/pQh9GiNyAeU7BbU9/h6AIw87xXLvtPQG9E5C
         thyVDban3G6NHlxgfxzzobayVlCyF8gMww5Ld+WK+XeM750ghysQpIDwA+9lnuFN59US
         Mf1kjPij4vBqyGjgrRsuvXCN5Jc2NyQXbvIEXy2ijNrSMbNrQqFSu72uXDuRu5Xnwyt7
         hyAQ==
X-Gm-Message-State: AOAM532ZprYiZNHZNsS4gHFHEt3UQ/FllwCVxLVhUOPKvob9PXmd8H+L
        RrZBHf/xYOrojFIMU68cmEBTXg==
X-Google-Smtp-Source: ABdhPJxaogDe/xKEAVJSwlt6+D1vz2gSm4YwiHq4FwR/U+34LWOpQZ6ZvVIPkXLGy3PggDAnBF3Vyw==
X-Received: by 2002:a7b:cbc2:: with SMTP id n2mr38803203wmi.69.1620822860514;
        Wed, 12 May 2021 05:34:20 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id j10sm30643193wrt.32.2021.05.12.05.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:34:20 -0700 (PDT)
Date:   Wed, 12 May 2021 12:34:17 +0000
From:   Quentin Perret <qperret@google.com>
To:     Alexandre TORGUE <alexandre.torgue@foss.st.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Android Kernel Team <kernel-team@android.com>,
        Architecture Mailman List <boot-architecture@lists.linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
Message-ID: <YJvLSbGh0YPRo0S2@google.com>
References: <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
 <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
 <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
 <YH/ixPnHMxNo08mJ@google.com>
 <cc8f96a4-6c85-b869-d3cf-5dc543982054@gmail.com>
 <YIFzMkW+tXonTf0K@google.com>
 <ad90b2bb-0fab-9f06-28dd-038e8005490b@foss.st.com>
 <YJkGSb72aKg6ScGo@google.com>
 <e1da4a98-7521-518f-f85a-51e9c58b1fc3@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1da4a98-7521-518f-f85a-51e9c58b1fc3@foss.st.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 12 May 2021 at 12:55:53 (+0200), Alexandre TORGUE wrote:
> We saw that patches [1] and [2] cause issue on stable version (at least for
> 5.4). As you said issue can be seen with above device tree and check in
> /proc/iomem than gpu_reserved region is taken by the kernel as "System RAM".
> 
> On v5.10 stream there are no issues seen taking patches [1]&[2] and the
> reason is linked to patches [3]&[4] which have been introduced in v5.10.0.
> Reverting them give me the same behavior than on stable version.

Thanks for confirming. Given that the patches were not really fixes, I
think reverting is still the best option. I've sent reverts to -stable
for 5.4 and prior:

https://lore.kernel.org/stable/20210512122853.3243417-1-qperret@google.com/

Cheers,
Quentin
