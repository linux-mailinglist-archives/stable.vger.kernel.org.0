Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82130316F6E
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 20:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhBJTAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 14:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbhBJTA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 14:00:26 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B68C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:59:46 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id v193so3202754oie.8
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H/NwjI0G4hJBKe8FbPn6CSlv+zT5kFR2e/T4DwZ4wp4=;
        b=ZunjwweaQ+zjq+0tfLhb1Q+XRFjvsTf3SKcpqyabsgHDZHwXbYbxizxbZlsm9jJlLA
         XEUw1WrwCV2Zwb7D77zLeSqNCf+uAHtW39aUuPk59pvd1euAtkeZZSjtMEb+BFszmsFy
         2DdSEKNegUQdqFuTKLLccLat/SxpHJcfNTi4Mf9QUOEDJqlbloQpkYtpNqR4FUigZ2Lb
         pcbJ90/hjWQc7UHKBC/nHpuJNsH6miI/XnEgaYDrxVEPxzBcnIpx5OFeZBEOEP1b+mfc
         wQmombM/5Fxvd0hLHhMNkJNG23wABtOYwMneDZCr5/k1wbZyY7sM5dzT4tRycFezvVoZ
         dpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H/NwjI0G4hJBKe8FbPn6CSlv+zT5kFR2e/T4DwZ4wp4=;
        b=TxbUJjqXlV1MiAOG1B0ykyEHI/74PXkmIFJIHn5y0ep8qn1+sHETuwC/wA7fw+QSbp
         EmYXTYWwSnKUXkUg9lPUgmluAlvYd2+LvcQuBcgAI26+/7az9KKUpxvUL9CXanxXcj1b
         7k5ZnvpEQHkQM+9e8yKeYmxwPb7CY8rvBO6cTFLxYZWTfUoKrxGHNaiN/6espuiwFmCF
         sKsKlmF6JwzrwphYaFiLm882QDFNVVyRo2TfvokwMEyTpzWokh9xpYoeZZuYbkPzMFVQ
         AEnLwnkm5wKXQKAFqIRIDIn0sPmvqhLWhiOGabKYmFGIUYrNzwNXAPVxNE63aMqhPfad
         fYVA==
X-Gm-Message-State: AOAM532B3BABsnu4MhrnQ2buFxfVeuJAUge5LAvPhzm7GabloHF87S7k
        jhb5RBQmdv+rIQW5a1p9LFD4+fl8XmehKA34UuH+lEjk5Y7kPvKP
X-Google-Smtp-Source: ABdhPJwIZdeQcKqiKfLeMioxEw9qtPS9hH4q+QDQJTxJfsv+waTtOUMUvVgp2imMyfjSsdQNq6QmWQMI4cQQ4d1U/UA=
X-Received: by 2002:aca:2217:: with SMTP id b23mr282434oic.13.1612983585955;
 Wed, 10 Feb 2021 10:59:45 -0800 (PST)
MIME-Version: 1.0
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com> <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
 <20210210131916.GC1903164@localhost>
In-Reply-To: <20210210131916.GC1903164@localhost>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Feb 2021 00:29:33 +0530
Message-ID: <CA+G9fYuQL9=gJJtWp7wHRzY1dc4q-Be4XjrZJUmYTJUbDEN=dA@mail.gmail.com>
Subject: Re: [4.14] Failing selftest timer/adjtick
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        linux-stable <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have tested adjtick on arm64 juno-r2 device and it got pass
and here is the test output on Linux version 4.14.221-rc1.

+ ./adjtick
Each iteration takes about 15 seconds
Estimating tick (act: 9000 usec, -100000 ppm): 9000 usec, -100000 ppm [OK]
Estimating tick (act: 9250 usec, -75000 ppm): 9250 usec, -75000 ppm [OK]
Estimating tick (act: 9500 usec, -50000 ppm): 9500 usec, -50000 ppm [OK]
Estimating tick (act: 9750 usec, -25000 ppm): 9750 usec, -25001 ppm [OK]
Estimating tick (act: 10000 usec, 0 ppm): 10000 usec, 0 ppm [OK]
Estimating tick (act: 10250 usec, 25000 ppm): 10249 usec, 24999 ppm [OK]
Estimating tick (act: 10500 usec, 50000 ppm): 10500 usec, 50000 ppm [OK]
Estimating tick (act: 10750 usec, 75000 ppm): 10750 usec, 75000 ppm [OK]
Pass 0 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
1..0

output link,
https://lkft.validation.linaro.org/scheduler/job/2254102#L1255

- Naresh
