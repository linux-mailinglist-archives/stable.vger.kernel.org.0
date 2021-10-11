Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F28429758
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 21:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhJKTNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 15:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbhJKTNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 15:13:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576B5C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:11:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so70877459edj.1
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HLnB0UKJBywsOE8RYieHcM9J99STUr3x8CGLTaGZ7rg=;
        b=IbSzotG/gn+bOgJdVHqaoqeGcTECqlVlr8e4zZIiIerhvDXx07DhhDVP0kuBYtb5+b
         pPN5SMAhRMuJPhNqO7xqyu3qAxkL4JPb4iHrnpcsYsdQCl8U5cm2YR5UQSy+ibh0UrRI
         CjBTye/93zB5t2AFWScnyeaR3Sp2MrQI3yTVx8CDI66GmyXYeL8yRBPNREY13v9aBv8G
         LGn8wFb4iF/8ylqnQY1b+1sGTdqBqhEdcnwtqUTxoD2gMY/qcEN87IFjDmuGqUp1dIfm
         /A5+g6LV00pnIGVOv0SOV2XFuvd7xmm+XpzY6fWt0yd9CUh7m+fEZG/JKU5ZWaunD0ih
         pYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HLnB0UKJBywsOE8RYieHcM9J99STUr3x8CGLTaGZ7rg=;
        b=VF53ARY/6de5pnGzF9yxZAXNshqpvP3XNo/TEMaTQX6C7ro+X59yfZlwXhgXEJE+cL
         C7gTQD8B5ujrwz957DxrDDreVohcVUX65lADFBzKoxi36bfyYSca8UObBbr6OR73ZSQg
         HyTY5om2O0azHKIMEJUQpaJIpKvTwa54fpyor1ZbuIl+dYkHvHFW6niSDix9ERnRD+5A
         KVPw3U9ylS3B9+5q+GrJvew9Bx7BU73hC0jCaElSUN1FpfauX0+Evg6Ypc3AY2c4wF3D
         37+aik7yRIN1sKcyYljjix2kTwHHi1ZsdyklTjoLl19KHcUSig1xIfmTSBPSD4d4Bh7D
         bOtA==
X-Gm-Message-State: AOAM532dhxekkUjLP5jflA48JNeE2dG9WtbJ8CctRg/jLcjWumzdmCc7
        mXN9Qo9fMU7xt23XsbYTJVjKJ1EXL6SpJAt7JW7vZA==
X-Google-Smtp-Source: ABdhPJxif7+cQPoBU/ej9FKwJOZfnKScrvx+4/O3wCZshSb3yKi50AMF5pZDKCV3lgUGxkg4ROGmFKDOLuDEyU4og6c=
X-Received: by 2002:a05:6402:5255:: with SMTP id t21mr42165596edd.103.1633979476782;
 Mon, 11 Oct 2021 12:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134517.833565002@linuxfoundation.org> <CA+G9fYutz0ZgJ=rrg8=Fd7vh9c7G-SJfF2YoH5wZyGzUHu4Dqw@mail.gmail.com>
In-Reply-To: <CA+G9fYutz0ZgJ=rrg8=Fd7vh9c7G-SJfF2YoH5wZyGzUHu4Dqw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Oct 2021 00:41:05 +0530
Message-ID: <CA+G9fYsLnz89gHYWkJMgevCrUC3DbMS48TrY4CXge1y24f-iHg@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

The reported crash on the arm x15 is an intermittent problem.
Which is also noticed on Linux next and mainline.

We are investigating this problem.

This reported crash is not specific to this rc review.

- Naresh
