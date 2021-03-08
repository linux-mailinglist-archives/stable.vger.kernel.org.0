Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC4D330A72
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 10:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCHJoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 04:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCHJoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 04:44:16 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5482AC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 01:44:16 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id h4so15265956ljl.0
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 01:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UZpDZTZ9LwFhrdqLMbbTpbZEBRZHEcS27kE7/ZCdADQ=;
        b=Rhe29c2EgYCjaQ2/EWqiBZ7l00OqwQ3GMHh/as6c6qULYxIA5+XrYNEYyZ4n7glZDi
         X4jVwodZS40v2zkclMG0b5CyFkLU7oG6tOIdyKOpnfNkvtOrXSMHRTKxxDayhzApDBfF
         aRloeyRPlZSMXdyURFCunmzmkLjLMT0gRC9f8KGO6BnAoIjh/2AFOObOfqYOlSU7sQCf
         UGrm/rRGVA1Ut+QFG1QibPBnlUNJv8iv1BSA7V0kOTCnkLrxDngasM2vOR+ey/3ChL7A
         PJDOLK8ALrvKR3NcCQHTjOY79vLyFIC3jqDbGwxpLYWZ+dcaw3Kst7QLmHy04tYv5+1I
         w76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UZpDZTZ9LwFhrdqLMbbTpbZEBRZHEcS27kE7/ZCdADQ=;
        b=t6EFF6bSx02x18Z4vtio+Bx8PfSvsD4wEWd8VgOk4Ng7E9TXBSrpySKKULWbuYsRLb
         WdmwlDPGQFL17p9IRO60QcGWYlo8D7FF+Kzs+4nDy+oEx7KLwVAwBalBF8eLi9ifp9e2
         z98AoiCYdoggDTwEG/VyyM1LSIdjpG7x/PYUEBiG86sQ1XJ38VF3GwsC0VoushOh63k7
         RDFv4Fz7RMkWW9U11dEKSZcB7S6YclzTw6wCVRiUexE9qGvXFsXUNLxI0TEZW8yV4l0u
         /Dwguqao7HJTIxwjmPzhGpVddGySUuE9HWShjt5O7YfMuTb8EbD7rGjNufkUuTFJPZe6
         0YWA==
X-Gm-Message-State: AOAM531+PjdfxrJmrGQEwZqKyKz5Z61Pl6hIklD3St1iGY2ubVdTATDt
        /oU6NwdOTY8cSZvUVu7VHTUKwNVaFZqKg+H1m+KAa2juxRN+sg==
X-Google-Smtp-Source: ABdhPJycuOfbMcCcEQGHcSnGo2Pp31obSbB9piVR1k32R11C70Eu+4pUVg0GNEFA2BqmdTZELs744k26GM33BepFgG8=
X-Received: by 2002:a2e:7001:: with SMTP id l1mr13347781ljc.200.1615196654150;
 Mon, 08 Mar 2021 01:44:14 -0800 (PST)
MIME-Version: 1.0
References: <20210307150040.GB28240@qmqm.qmqm.pl>
In-Reply-To: <20210307150040.GB28240@qmqm.qmqm.pl>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 8 Mar 2021 10:44:03 +0100
Message-ID: <CACRpkdbiVPZLJ2d4th1auTN9CRHHh-N2eS+2TBiuuCaq_ZsuAA@mail.gmail.com>
Subject: Re: stable: KASan for ARM
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 7, 2021 at 4:00 PM Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.q=
mqm.pl> wrote:

> Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
> are 7a1be318f579..421015713b30 if I understand correctly. They are
> not normal stable material, but I think they will help tremendously in
> discovering kernel bugs on 32-bit ARMs.

It's a development feature not supposed to be enabled in production/product
kernels and following the stable kernel rules I don't see what this
code would achieve in stable.

IMO it's a better idea to provide a branch with KASan for each stable branc=
h
that developers can pull in if they want to enable it and use it for testin=
g.

Are you interested in setting up such branches for others to use?
I think it would be helpful. Also the work shouldn't be very hard after bri=
ng-up
and it ends when the last stable pre-v5.11 kernel is EOL:ed.

Yours,
Linus Walleij
