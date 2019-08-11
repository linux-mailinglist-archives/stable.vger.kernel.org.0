Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6F891C6
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 15:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfHKNMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 09:12:53 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40880 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfHKNMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 09:12:53 -0400
Received: by mail-lf1-f68.google.com with SMTP id b17so72571549lff.7;
        Sun, 11 Aug 2019 06:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMKiwn+LopYZfx+swOzbhUCh782S/3ZSXMB0o7HZBQI=;
        b=OmPxjkou+UfWkb7ONLmGZRygvLUkAxw0oB7nz51nV2H9LkGP5ZsGw8u2XrcvVJvc08
         X9t65J2x0TiWxP8vuXket1hhudk6E/m1klN677+ugyGKIY0y5+saA/qf9x2sXeF/jYPj
         1MBltklI+Mek2itg31mFK1DXx20E0TVSKxdyVe5+AXfQgBGf4P7X5GAJc+ZI8m/91Egx
         9MLbsJjnYoolUgVhnotAOxnZja82QrdrY8wUAE1ZFguuzhyB+RC9bHDzi4G6oL5xGaBx
         mPm1/xRgKPs9wDHnD+aab/WJYmpzq6b5IUwSXKeYqaQaeVbMEBkyvCSiPE9NpafX0Dse
         9Gjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMKiwn+LopYZfx+swOzbhUCh782S/3ZSXMB0o7HZBQI=;
        b=QiOT4lonDmixm39NNdH/Sua+FE2JXOCDO1kk9QG3rZJHMbY1FXzJX+w/mRzmV56gFu
         amLUkHAvYE+lktpkDz939M4GX0VasNNXoH+Khgbi8QSMUKfm38gv85weba6fvlXkqjbi
         vTikFIJp/kvUb4YhmoFjxJO7oNKdz4gYsdAECsIzQQZHSrBv7gxkoE5HQj6B+basSvYg
         BW1H05IOXwtWSVGQbFSQblPQvYuf8gjSKztU4nZyoIaJPiyZUbJHfk5zwApP2pz2PdKV
         kYWTjQ/U90a3GYLX0LYZ8V5dTfeLDvL5AQ0qFQ3TIEOfl+8KVFNnlWw6Z7lYxtkbtsdN
         HW8g==
X-Gm-Message-State: APjAAAXEIlz5+3Kok8qHA/LdORllGZhfzH1TA0Jasi2Vu80nwC1XR2mh
        g5BhfSbCqLARUz3a3BYEqmNM4V53ssgt1+h8vGe82l7D
X-Google-Smtp-Source: APXvYqx6ffj+7tDrhRn0wQehL4p4O21GD2nTpaNqWwxRrICL+UNYZIQJs0tCruTdGr0bQMqnYlj1hk3w6tWqEAp18/o=
X-Received: by 2002:ac2:5ec3:: with SMTP id d3mr17208280lfq.44.1565529170986;
 Sun, 11 Aug 2019 06:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190810154300.25950-1-festevam@gmail.com>
In-Reply-To: <20190810154300.25950-1-festevam@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sun, 11 Aug 2019 10:13:21 -0300
Message-ID: <CAOMZO5DRUP5=LRHzqqX5x2uCvhzUt1aBSC4ODA5g2as8XYhuWQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: rave-sp: Bump command timeout to 5 seconds
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lee,

On Sat, Aug 10, 2019 at 12:42 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> From: Andrey Smirnov <andrew.smirnov@gmail.com>
>
> Command to erase application firmware on RAVE SP takes longer than one
> second (it takes ~3s). Bump command timeout duration to 5 seconds in
> order to avoid bogus timeouts.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 538ee27290fa ("mfd: Add driver for RAVE Supervisory Processor")
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Please put this series on hold for now. We still have some things to address.

Thanks
