Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C73881456
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 10:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfHEIfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 04:35:53 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45797 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfHEIfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 04:35:53 -0400
Received: by mail-oi1-f194.google.com with SMTP id m206so61464672oib.12
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 01:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YvenGluDW+CRQxA9W16JUsv5O7GSdzEd3sfteBA8Wr0=;
        b=zUgfF5EiUfAXqO6GdFJCqTmsT+W1uHlln/PLA03pUZFNjItrYqiyOfSXxxQ1c9rTP+
         OB2mnGCSgyv4xWpnQ3AAz5O5Fc809+BE1ksYWgGxIROzIei9Rt8qOKTksutQWNhdteHH
         h4EkDvZaIMghHcY6UBnmdUv2ZCeU+C2mwUOXozIeKa0UYhNK8QOxP1+DiTC1IddIM7IS
         oaJMVEa7iBS5KAvLIDevmkUbzd/UPkH7I/icpuuY8a875xFQqigfnO7ScQosZo0/o9jF
         EQgpG55slJr7d8bhGo+g3AxhL0SeC7SwMyqdWx9dmOVNPFXdYk/WPPBBUHVoShAIO5zl
         wylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YvenGluDW+CRQxA9W16JUsv5O7GSdzEd3sfteBA8Wr0=;
        b=tiSoRvSMz5x72Mo2PvoPc7oilu6NTQseSVuMpLWra+Gnlwqf31SxJIAgXo9uRNwRZk
         4jLvt3fqv1K7dfUlZRIi1gEEvLfz+mPYtT+dJLZsjehlIKJdyZhMqLtQKpntiWidun9r
         CH3NYNIyl00kRmFgeukybbKJg6+hwOPq+g/w/ZjbgM2+eG3e6+aSZbccX2NoDnlS+Nb0
         WCh19qQpWsrTWQJzGMKIXBwE6LlhlJmKm7Faj+GmKm7u1G5xEVlsc6mq2p+ExQhd43dr
         BYZbx4A67PiyPkCVb1JAPvLiiuCOuo0jVKYxkigvEb9CCjXZMcb0bQbJC8Lh0wMlo5Ui
         l1Ig==
X-Gm-Message-State: APjAAAVpt7bKWwOYo/YJB+RyO4mRvRvWl7zH41w9kr/DMD1epj7uPiHW
        w/7Jlu6Zow1SkFXvyIAa73XylNYY5RPjW0j2lNABgxIc
X-Google-Smtp-Source: APXvYqycx2y9AbPf8hskWcFGHI21Aaue5Vvx3NwqCaAvCRBtMlzBtQi0Hzhp5MT0Flod+gHRpI07lU5B8peY6tnOVNY=
X-Received: by 2002:aca:450:: with SMTP id 77mr10721170oie.114.1564994152061;
 Mon, 05 Aug 2019 01:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <1564982748230183@kroah.com> <20190805103242.4816abcc@endymion>
In-Reply-To: <20190805103242.4816abcc@endymion>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Mon, 5 Aug 2019 10:35:41 +0200
Message-ID: <CAMpxmJUfPKwmhBD_cNHUA9m_AZ3a0ekX+6oeptU6z6COGBwV4w@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] eeprom: at24: make spd world-readable
 again" failed to apply to 4.19-stable tree
To:     Jean Delvare <jdelvare@suse.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pon., 5 sie 2019 o 10:32 Jean Delvare <jdelvare@suse.de> napisa=C5=82(a):
>
> Hi Greg,
>
> On Mon, 05 Aug 2019 07:25:48 +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
>
> Technically it applies. Just it doesn't build ;-)
>
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
>
> The backport is trivial, I'll take care of it, thanks.
>
> --
> Jean Delvare
> SUSE L3 Support

Hi Jean,

I already sent backports for v4.9, v4.14 and v4.19 earlier today.

Bart
