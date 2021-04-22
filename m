Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1EA368118
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 15:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhDVNDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 09:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbhDVNDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 09:03:52 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4005DC06174A
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 06:03:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id p6so38050826wrn.9
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 06:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZHLzNOHj90q7Oj3aQnNhu92h15Ny9i/xNLc3zPdfQ4g=;
        b=WpphpWM7d4l8VUDnKXFsMAY2uU4Ft2tRsNLcpI2xJpUu4g0bNIaUUKE0gGVDhLiX/g
         OjnVmquOzil9wscCXKdb84emGCUDQkMe4RFl4hJh8KN5Wd87NYtHx57Sv7BqWckv6n5b
         mVKgWt6qQdgryA8hdzD2XfYDmSwjXZKn5xTSogNopKH/q3ToOfYDhJw1XORyZm3uCz19
         LImQkK/2tVquZeYhYYgKPruClmVOtjO6X9iyj5D3O7rCfKE3B5QJfT3WgAaiUusI+dvP
         QA4JMoLeJWEErqUPzSDb5DHeWxwyXkFsBjyqfLJOX31XqB42pSNoVWxe8TRRr0KNpNzp
         Htbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZHLzNOHj90q7Oj3aQnNhu92h15Ny9i/xNLc3zPdfQ4g=;
        b=Vq9CpTgFcLju0K6KeHqYquoLCqBgogLf/co/HlT8ybkI13xJLP50SK993Y+gQRcwVf
         FB6Zdoetul33d1Z0Dr+w0T5XbzXjXR8wItmwL1+7yPd+9snXUzZDFEJX6B/OYmxRo+V4
         hLXqe0wXHd6bO7iHI2puToGp7Rk64KM6Hjxq4LHhpONHrHfZ1CXm5Psh2Va2Lh6GpP8t
         2+90IpgVqGnN2OuXbyH0NyVVV/LA6Mfr6Xlpak8u5OWQSkIlxkE3BsEcIBHS1q0oF/yf
         8r87Eq5BX7mIxQe9nKScQyCKK47jj3mU0ujqseqiWKx8PUbLvRUz22cRRL7zcvBewGcm
         xEXg==
X-Gm-Message-State: AOAM531v+m9UsY0EFtXj4xLLBuHOrs49F/BAT4xUkdLE24tnsz1ZS0i1
        hDZ1lj1gvAtgiupXBRV6EkNjzQ==
X-Google-Smtp-Source: ABdhPJzhRXkQSnlUedDmqIlV0CkRTeBNaGDZqXpCq7gzsxQIKyjCm9svb44UVutt3ylPh+tyhXcIWw==
X-Received: by 2002:a5d:47ce:: with SMTP id o14mr4045996wrc.236.1619096595880;
        Thu, 22 Apr 2021 06:03:15 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id n18sm3369617wrw.11.2021.04.22.06.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 06:03:15 -0700 (PDT)
Date:   Thu, 22 Apr 2021 13:03:12 +0000
From:   Quentin Perret <qperret@google.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
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
Message-ID: <YIF0EIXylUJzIsTS@google.com>
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
 <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
 <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
 <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
 <YH/ixPnHMxNo08mJ@google.com>
 <cc8f96a4-6c85-b869-d3cf-5dc543982054@gmail.com>
 <498b8759-1a70-d80f-3a4d-39042b4f608e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498b8759-1a70-d80f-3a4d-39042b4f608e@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 21 Apr 2021 at 08:17:28 (-0700), Florian Fainelli wrote:
> 5.10.31 works correctly and shows the following for my platform:
> 
> 40000000-fdffefff : System RAM
>   40200000-40eaffff : Kernel code
>   40eb0000-4237ffff : reserved
>   42380000-425affff : Kernel data
>   45000000-450fffff : reserved
>   47000000-4704ffff : reserved
>   4761e000-47624fff : reserved
>   f8c00000-fdbfffff : reserved
> fdfff000-ffffffff : reserved
> 100000000-13fffffff : System RAM
>   13b000000-13effffff : reserved
>   13f114000-13f173fff : reserved
>   13f174000-13f774fff : reserved
>   13f775000-13f7e8fff : reserved
>   13f7eb000-13f7ecfff : reserved
>   13f7ed000-13f7effff : reserved
>   13f7f0000-13fffffff : reserved

OK, so if we're confident this works from 5.10 onwards, I would suggest
to follow Ard's original suggestion to revert this patch from older
LTSes as we're clearly missing something there.

Thanks,
Quentin
