Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3572C40173C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbhIFHlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 03:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbhIFHlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 03:41:51 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362B7C061757
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 00:40:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z19so8259125edi.9
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 00:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FL5J+gSNutoi0Pq/uomWnaoEPs1pB+cuD1QhhYtiTCo=;
        b=BG31e0qN4YISK1734gaiUTzWuVQOxF5cY/Wv4j0DbwFi9buxEzwWmCZ62kai33yfcZ
         E4PJsIJoFA3pfY4uposkraXEdA/Uk1diAJ/Pvlh24laol7+KPKzUjs0fHYIzpAWVV8Pp
         bzg+GPgmw+7loyzxQJZdbjPg5er8OgWv1jwVnL/MiiMC9g7UxZFqmYK5DiaHKqgDK/dW
         /dUh7iyoyiWWaMRNsCttNyyu/qwG/h+zfCgi4IcNLKkymhyKKRXebhMfMWYfzANSz+RG
         sBj74gAZvN32nFNbO4Msgrqy1+RxXh3Eusg6IdZmSEZ3rs/LMPGE+QiE3zwaZZCqgbxS
         VIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FL5J+gSNutoi0Pq/uomWnaoEPs1pB+cuD1QhhYtiTCo=;
        b=hkMfLIYysbW9CLBalytMgki+4H0ZkT3sdvjX3vKI4C7msLMgYpcqowuy56MGuwJQbh
         4wdCdxL1VdVnRn8Hvg1KDMXzStDssS2YhgdaMb1zk7pWGysPtl6xkh8oyPCVej7ET6uC
         oF4SPz0BriN3GbMjWAY+HRIFxjLFyo9SVTwLOm7RzyMvgA6w6ASrM+RFV1UwzzuWKoTm
         unnS/SRLhl77M544mkWJiQQ4/l9DSlDPF6fSyosaxjvtFsWH2fYK8HLfVN0NFPKBDZ+x
         NucO7w/2JMZqg7BVZOGC4BMpNmZ8hYl4ILFoauxGuxmqM7nMPoAqgggPUufxUB4PRoj2
         Xa/w==
X-Gm-Message-State: AOAM530saZZ7koOdUfa1SCERj6ntJs1MUh66DbWdXNHKuBk2MKlMJ0oc
        rp4+ECsbAE09nsIw5hM6MZgqeXI4j0uec5K0EXqVcQ==
X-Google-Smtp-Source: ABdhPJzF3d2u9FRcwDxgjT1qXwQsqXXf5z4QJF8uF9GyuCXwuaj7A4o1Ez5DJPmr6NQb7X9uY3XLVp7XDxFPNewNiqw=
X-Received: by 2002:aa7:dc50:: with SMTP id g16mr11971779edu.182.1630914045592;
 Mon, 06 Sep 2021 00:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvMaHgSied79QBs3D=eDVETGH=3gxA8owCSRj313yEhVg@mail.gmail.com>
 <YTTbD+BKRpd0g4hq@kroah.com>
In-Reply-To: <YTTbD+BKRpd0g4hq@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 6 Sep 2021 13:10:34 +0530
Message-ID: <CA+G9fYs-K2f+eZW55u5uh1gQedTQpm=TGDNk7K1uOk8AeDNUQA@mail.gmail.com>
Subject: Re: kernel/kexec_file.o: failed: Cannot find symbol for section 10: .text.unlikely.
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 5 Sept 2021 at 20:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Sep 05, 2021 at 07:28:35PM +0530, Naresh Kamboju wrote:
> > Following build errors noticed while building stable rc Linux 5.13.14
> > with gcc-11 for powerpc architecture.

<trim>
> Is this a regression?  Has this compiler ever been able to build this
> arch like this?

Yes. It is a regression with gcc-11.

stable rc Linux 5.13.14 with gcc-11 - powerpc - FAILED
stable rc Linux 5.13.14 with gcc-10 - powerpc - PASSED

- Naresh
