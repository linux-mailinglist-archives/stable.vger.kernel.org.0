Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2654110FF71
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 14:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfLCN5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 08:57:52 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40370 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfLCN5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 08:57:50 -0500
Received: by mail-lf1-f67.google.com with SMTP id y5so3043093lfy.7;
        Tue, 03 Dec 2019 05:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=457uQsQCEeipbE026J3TMXLMXjOh2/mmGjFgvd7Sd+o=;
        b=tnzJk+3mUizoPk4RfBgou4GWvd36Hh/RKV790xeBl7a+AAjnBtfxaY25sShf7gDZKp
         GbpRBFKzvBPkP75kwGcc2G3RK7cZz6+kQoV0/Vbcq3V6frMT0pnRibY1rO2d2EK2hiPi
         LaoYKhN4fm8r7y7JI1jIbEY5KulspE/BCRv8wfQ9080biht9r49bGv6o2s5weXnXPYpC
         Q8r8Wj9k+G76PebZxfjgeuLsCI4e7cP6wXuQlpTf4QW6keMj6J7i5+93WwNYwXQcWZIf
         JxPnoCShp3oFhYGwdBgPH1gnuIKef6cWs8SpIFezVYodQKAvcFMqs8ZyvZkLdzvkjOjv
         0MWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=457uQsQCEeipbE026J3TMXLMXjOh2/mmGjFgvd7Sd+o=;
        b=sxVC+oPvNEk5TwcxC/mlxvR3Iue89kDcnlSCjlqRwDgZM6EYdLq6mEwoSegqAQ7Drm
         sYjhvfodYWB6/agfJ4zG9HgKYIayqWHkN8RiED5mamm/5bG/kiojq/LAg4AixAbY18Kg
         PFA+PU8dvXNAxacWMk9SocVUoiFbThncwtey6XE2YLkbWbqrKqQdzpTZ8QHlFKifW4tx
         ypqL6qOLHs1/htsIVWG0kGdfKJ3cVOt/6XQdWfASMS7jNqBOy453pKz4Iwd6p9CbhQTw
         xiB0rkf3pZQbLh9cMvQqegHMR7eEe77J1BG+asGyf7jz+X5CUltJPg73DcBbQFybeUHU
         XP3w==
X-Gm-Message-State: APjAAAW/MMYLuFm5z1qI6RRJT9MqfSxycdh28+HKnmhW7hsEFiPf/8z8
        WmmWBosOZtj/E19xV44l02DpXPeem3E16Q==
X-Google-Smtp-Source: APXvYqxw8XOaL3u2qdZCCVSO4jETWPu7X7sPsMzRhrrtauCwWK0NkF5C85ZNR+0T4mrLm61YPnGIQA==
X-Received: by 2002:a19:4208:: with SMTP id p8mr2727863lfa.160.1575381467739;
        Tue, 03 Dec 2019 05:57:47 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id k25sm1395858lji.42.2019.12.03.05.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 05:57:46 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Fix logical condition
In-Reply-To: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com>
References: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com>
Date:   Tue, 03 Dec 2019 15:58:40 +0200
Message-ID: <87v9qx8q9b.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Tejas Joglekar <Tejas.Joglekar@synopsys.com> writes:
> This patch corrects the condition to kick the transfer without
> giving back the requests when either request has remaining data
> or when there are pending SGs. The && check was introduced during
> spliting up the dwc3_gadget_ep_cleanup_completed_requests() function.
>
> Fixes: f38e35dd84e2 ("usb: dwc3: gadget: split dwc3_gadget_ep_cleanup_com=
pleted_requests()")
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Tejas Joglekar <joglekar@synopsys.com>

Indeed this is a very important fix :-)

I'll queue it up.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl3mahAACgkQzL64meEa
mQZ6MA/9FICkpzkRGI+2/xLfielv9YLpsi2JLS5GfntpPEGIk3V7cLo5L1tkOWzv
6aR4Qx4P3iG83+MYwdEFq/EJRXzc2C6iiM909lT2XgvvpUdn+tzKYXAF4mHjRrqA
OKzHcguRI11Ob6wAXj090s5MV1hdW+pSdR86AFfr7/pniJ6W86kvWbb/zJJOOxU6
wJHCClU4BJ5xoIdD/C0E9SVM1uAFFoH5+Z3TG5uCSgx/PrfskYDFKL58Z69A1w7u
6KLuU9atapFxFGg6Ha6RjHOD0QX8Zu0PZbufTQmyEd0Sck3l85cvYoIcdTlYTnoB
7BS3P/b5JYHEZL6r1mRUEYHEz94hPoUrC504yYEYN3dw4cASEqbL1093zbZeM/wU
B/PMR93B80Qp/QcLGF7wHAhLLFRygTnRSYGuSrNNbzVKzaqkvBzLcdTUvH60DU+V
2HOK5f8u74LEDisNf3QKnisFmhSuibmz4oDSDLrJXeX003duZUBjqPLw0BnPJp9m
k/duBlV4l/3t+olZdd7aYrH3ChcYL+oJZoYgFXIfwGSc4bHYRb96pZVd22Nulvgk
V0P8TJITGwDB7kPTXsrUZVia2RiAF2lNjdDBUeVjemBaTv5E6LpWVNyIk+owZlO5
uqO0FJC5tvxcXSFcBAIHU4z9WMJrV5iUJ368AA1kU5wltg6fbsA=
=1MLv
-----END PGP SIGNATURE-----
--=-=-=--
