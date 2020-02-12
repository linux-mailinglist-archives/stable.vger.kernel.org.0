Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693EB15A06D
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 06:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgBLFRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 00:17:15 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:36837 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgBLFRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 00:17:15 -0500
Received: by mail-oi1-f175.google.com with SMTP id c16so887400oic.3
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 21:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lambdal-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=swj2e1unZxLTr+eU0S7w12ZleMVKRnLyFuIP1piSS8I=;
        b=Eu8Jwz8tweAfLxp6xoPZfgE9THQgs4DJNn7wnaYMtugxlu505ZfPJ3pz5VMg5qLKaC
         9VeRCjshOY23jCKCcAd+eVEMBFdCVVCfJEmdbxn9ikrdk+tRHGj5JEv8mukh9AOy3kCp
         zDNwamsReN9LG+oaaVEwr/h2rM8GqQC0KfKTU2iO0k/DOcZRgYFTGMDiHZ9hQI5r5GsI
         Rj+n8dblIV8XAZBFZw5mgLsBtek/krVVXSjP7izhE9NxwxxIS1YK8MZScVNtmxEjjySn
         n799xyRJ5Xo+iOY1CFhbyAqnoZGSyBeB3/wmy80wwFvp+53uv+7+YvNrF1mRL0Uvi7it
         u2Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=swj2e1unZxLTr+eU0S7w12ZleMVKRnLyFuIP1piSS8I=;
        b=rmWcz7jcdt1dmCx/Ovn4Z592mHT096jkcFa17yUTbPJ+hQs0aGzoIfVnVibpSGwG3u
         Z2Fjjl8lhBHRovPhEZuKsc9xmsJAsOx4ott9Eenm3pY0J/QZox96JZoWneypGvTBY1ym
         RRB0WHDJlp6GU3A4HgdvkumAneU5Ezzd4mOp3j+dVEzCqfktDRf2XmBdEuTz6HjGnrXp
         URU1byAdK9cxS/ijXj8ddmzbJqs6Hkcbp7Jfup/2dsBp19d2DMnxIA9q8sU9N+FsPXmK
         pEK5rL+SF6Q6l52z3yyHweDy125Ue87mJc6fuStK7bF3IAAw/jBkRx3BbL9oN2i+qFQs
         pbkA==
X-Gm-Message-State: APjAAAU5HsGPRtmC/T/iLDPX/KEZaPmmK23V4HYBMfA65KRQOtkaC0ne
        80FbwJrvZWISibJ8lPX/JGFPC6GgT2E=
X-Google-Smtp-Source: APXvYqxi/NgsDLYK2/SMRqF+1b27DULShmfgn7/RR1WgMr8iPTvE+CAhzeOFNJhfEIIyYQGOxJfGQg==
X-Received: by 2002:aca:530e:: with SMTP id h14mr5027806oib.105.1581484633975;
        Tue, 11 Feb 2020 21:17:13 -0800 (PST)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id f37sm2005124otb.33.2020.02.11.21.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 21:17:13 -0800 (PST)
Received: by mail-ot1-f44.google.com with SMTP id 59so678889otp.12;
        Tue, 11 Feb 2020 21:17:13 -0800 (PST)
X-Received: by 2002:a9d:7a56:: with SMTP id z22mr7525771otm.201.1581484633007;
 Tue, 11 Feb 2020 21:17:13 -0800 (PST)
MIME-Version: 1.0
From:   Steven Clarkson <sc@lambdal.com>
Date:   Tue, 11 Feb 2020 21:17:02 -0800
X-Gmail-Original-Message-ID: <CAHKq8taawUbZWubQ8qzy05+qUKuCAYGy7kEZ-PkgPeFhode5gg@mail.gmail.com>
Message-ID: <CAHKq8taawUbZWubQ8qzy05+qUKuCAYGy7kEZ-PkgPeFhode5gg@mail.gmail.com>
Subject: Request to cherry pick 2b73ea379624 into 5.4.x and 5.5.x
To:     stable@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

Commit 2b73ea379624 ("x86/boot: Handle malformed SRAT tables during
early ACPI parsing") fixes a boot hang on some ASUS motherboards with
an older BIOS. Could you pull this into 5.4.x and 5.5.x? Should cherry
pick cleanly into both.

Thanks

Steve
