Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B692C3420E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFDIn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:43:29 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:34377 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfFDIn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:43:29 -0400
Received: by mail-yb1-f182.google.com with SMTP id x32so5114872ybh.1
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 01:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PB0gAszORonitjvvcJKyso6qc1wh2BUdVPJWAoTFWaM=;
        b=NVOdwreD+78sHCrliiuSaBS1y9gylsENnUDZf2DCXTAYPxQfwz1R3V3OK0EMce4oka
         mao1ymZWbA0c3q9YUTGO+IIk4hcgR9z/Xg1MY2TbvZhheOVC0dWCuPQK1ckfPqp892ZL
         TwkeTq1a6+jHf8ngc0Ow7BT/1Innbgz8xZVGTbCZWQSO64vCjLBA/MnOt5OJXDPgCueA
         VwN2BSWNSuDY6knTLl2ffY5t7mZPJdUlYOsRuqkZAZm4SPw4yoKBcjB+e7iXU/LsuzXb
         WsdW5sGhmS6ktbGnEaLaJlN6gz5bIc7H1JiPr8GXigh5N0THIFOAqsFcNA0+6/rb+LLX
         b4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PB0gAszORonitjvvcJKyso6qc1wh2BUdVPJWAoTFWaM=;
        b=D3GcwUHbLlFv9omUCDn6lK/kRLJJNNEi8KR1/TzAie3F3DfDZGQoxgAvEzFEsNrcEc
         XcdeL2TvQe6q/+44AYug+R6IrQeUvIqbf2+mdCdPk0ZTB9W/ir6qo4qkv9QUXb47qfOx
         pkrFX3bq1zjApZoqjYaMhgJx2LrGLjXBH2RB5Dcb3bDQbjTqcPHyF6I8bGQjVJ8XX86d
         NRGIgZmeFsOefq7oOwhZzBhTqxZ9nV466DztCjm3gVL6T/Z9cDrpy9rNem1FJ9OAbTT5
         tatRnqtD1n9ypwVZSqF5XN/dc58MBkgopyybC9hAGqJr9Pbyoronyz0g0yHv/1Q85pX+
         Ot4g==
X-Gm-Message-State: APjAAAU+gkZBDvxy+hJRHwaKxVlZaT0I9bThA6Kb8fy53MLjmLSEZVUH
        bTLMp/HXAeqFz5ZTeaV9WgtdHB6wK5aBdPsEb7o5Mg==
X-Google-Smtp-Source: APXvYqwaezv4Wfr8YFvfO2BqqQC+BWwaLjpe5HHiDUgRjcB2WKV/N6+NMeH1xYhnpaXqSZTnIVV8PdqDfHsilNChaOw=
X-Received: by 2002:a25:c74d:: with SMTP id w74mr550895ybe.61.1559637808490;
 Tue, 04 Jun 2019 01:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190603173114.GA126543@google.com> <20190604075235.GD6840@kroah.com>
In-Reply-To: <20190604075235.GD6840@kroah.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 4 Jun 2019 01:43:17 -0700
Message-ID: <CABXOdTcgyQ2XrCAurq-pne95mdeh5B36yidGTFfc6r_wu5kJsQ@mail.gmail.com>
Subject: Re: 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()")
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Zubin Mithra <zsm@chromium.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>, blackgod016574@gmail.com,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 12:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 03, 2019 at 10:31:15AM -0700, Zubin Mithra wrote:
> > Hello,
> >
> > CVE-2019-12378 was fixed in the upstream linux kernel with the following commit.
> > * 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()")
>
> A CVE was created for that tiny thing?
>
> Hah, no, I think I'll refuse to apply it just for the very point of it.

We don't create CVEs, but we do have to get CVE fixes applied to our
branches. We don't try to police the creation of CVEs, and we don't
try to double-guess them since that would be futile (who guarantees
that our double-guessing matches yours ?). We do have a policy to not
apply CVEs directly but ask for stable tree merges instead to avoid
deviation, and we (more specifically, Zubin) spend a lot of time
validating the fixes before sending a request. I just made that
official policy, but a policy is not cast in stone. We will stop doing
that if we get this kind of response. If that is what you want, let me
know.

Zubin, maybe hold back with -stable backport requests for the time
being, and just apply missing patches directly to our branches. Sorry
for the trouble.

> That's something that can not be triggered by normal operations, right?
> It's a bugfix-for-the-theoritical from what I can see...
>
> > Could the patch be applied to v4.19.y, v4.14.y, v4.9.y and v4.4.y?
>
> Why are you ignoring 5.1?
>
Probably because no one is perfect.

Thanks,
Guenter

> thanks,
>
> greg k-h
