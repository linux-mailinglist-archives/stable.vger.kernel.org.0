Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56A81681B4
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 16:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgBUPdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 10:33:02 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:33660 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbgBUPdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 10:33:01 -0500
Received: by mail-lj1-f181.google.com with SMTP id y6so2647635lji.0
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 07:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tVFIILbLigXa2LaGau6WSUSinRQYYOxk7dDhxxCC9M4=;
        b=nSa7UJPITzxQgoaqt3ZmZekxwxB07aqoRFYAm7MsinYY5gSCTe7GtiH7vF5KF8zuVO
         2bp8KWiW2XpREjwCCssS1mopmzRFfvssXNkQff/SItRX+z00Q6UWL4ZASnZ81TP/LhDt
         APkOYB+3tewawTByabfpE9zoghB8+EcNg+45WtcFkoNlgPhwiPRJvLa3KxOQiBk286Ir
         HTE9tUy87Vy0NZXt6Urr0Y7tcLKky3ZrZzkU1Wc0KtbCm5+zJLeoDcoQbUjBa5FaYC/g
         AqZdITMqnNyLnBqvV8iaQG2MwCk1dmlscPuK0TIEdfis63ioJ+9opusphNh7RIIdcaK0
         R4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tVFIILbLigXa2LaGau6WSUSinRQYYOxk7dDhxxCC9M4=;
        b=Wdv9VyJwumqTqu7UUI3Vt5T1e8eAkB3q0NfeT2COwQtdhZFMxc4BJ98nWTgXPiSJPy
         susyMA1WWx6GOUrtW56/h08Acdwy2NzxKeJu4hLppa8+D/EpCdR13EIW5pUVuo3EOins
         BUEPnEZySX7Viuo9MT1sc+J2QuruwqiCt2MHhLu9eyNgbb2Hx9guet24EFiZav17lbcu
         vLgU+QkAw3onFroUxNqzXBGJngsZ4NxiwDyvI2i0VP3nyvNNwnoawGTh8cZyHk+eZrgM
         EVc/LFoWOrMdHC44dZJT6zCh9qPJlR1ba33qpY9quJCTclIn5D7IxRC27FVvVd2Osxsp
         /qaw==
X-Gm-Message-State: APjAAAWMHsqunqg/lVkqTE0veum0gH5A1noxFpFkJ8huxQH6bzjLG8FC
        D5t9zU2h2G8D1TzV96rvsVJFGRBMB+SCtQUNreUvAmRO
X-Google-Smtp-Source: APXvYqx/VyPaUurPNIviW5uMqcYgAE1ZWQK0EiPaviXmH2sf65VsY2i2alV7n3qhZ6YzCxX4r3N78IB3xDjH6z8BsRM=
X-Received: by 2002:a2e:8e70:: with SMTP id t16mr22600520ljk.73.1582299179419;
 Fri, 21 Feb 2020 07:32:59 -0800 (PST)
MIME-Version: 1.0
References: <adb8b3ba-16c4-49f9-0160-3522681b49f8@roeck-us.net>
In-Reply-To: <adb8b3ba-16c4-49f9-0160-3522681b49f8@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Feb 2020 21:02:47 +0530
Message-ID: <CA+G9fYtCZpVYmSDLO75UJZpF9oz=UVWeENz-6x9vj=urqt+0oQ@mail.gmail.com>
Subject: Re: Build failures in v4.9.y, v4.14.y stable queues
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 21 Feb 2020 at 20:03, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> arch/arm/boot/dts/sun8i-h3-orangepi-lite.dtb: ERROR (phandle_references): Reference to non-existent node or label "cpu0"
>
> Affects both v4.9.y (v4.9.214-119-gb651de82f0d1) and v4.14.y (v4.14.171-173-g611d08c2bab0).

We do see this build problems.

- Naresh
