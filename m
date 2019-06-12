Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4402F42F4B
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfFLSsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 14:48:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55273 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfFLSsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 14:48:38 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hb8IW-0008J5-QO
        for stable@vger.kernel.org; Wed, 12 Jun 2019 18:48:36 +0000
Received: by mail-wr1-f69.google.com with SMTP id k3so7706346wrq.22
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 11:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/sqcpVKxZj4PB2u1+J3qG3Iq9vFtOeiH35zGJmow4g=;
        b=fmBXfUrfh5uJLKMfUClLZ57rCVOb8Fv23vuy1m8cxtEfdvUOTDG/5GeS8Vd6/HzhU1
         kpZ5+uzv2KiB1WtS1ReEc24EK/u6jbFr8xFZxjnU0Rd3grxTQnXGSpay4GavtJjnilir
         DBZ+YO2vO42wgkX0HXsyxUsTn92hRNxuZxNOqqgTJKO10J1mwmd7DhiRWrlc0f8XswB4
         f56ditSQ1obBLRBJyJj31d2FR0jOK+Ee+nwtU3UJwk4W7RegJeLRchMvhuva5dFbl8io
         iTKP29qm0wRmxpxGHlY9u0Ktx0R46IJmQUgwAoAkgq8XaL0CvMm3K/MO85ETlxnkluIa
         l+xA==
X-Gm-Message-State: APjAAAW6kitx42WDi0vhq6OInubylY6El1yZiIBHytf503p+BIRoucuD
        ssJFJEdW9l7kteJT4Fh9xysgnBalvTXvRmmKb262K8kZxNooC6E/aKTk22wDziYjkPtcHZDRfQ5
        HDWSWAIjJ15FdgwdyRlPtDUsKRBCRq2WMf6OloSa+nXdlcwBVkw==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr414110wmj.155.1560365316506;
        Wed, 12 Jun 2019 11:48:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx6phQL1bo7mvDjvbreNkFlAF5JIygP0kbJi5i6SVxhCaUFSkGll1cKNcDFnl9xf3OlftrPj+7NtBdxiMP+r4g=
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr414095wmj.155.1560365316327;
 Wed, 12 Jun 2019 11:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com> <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
 <20190612164958.GB31124@kroah.com> <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
 <20190612184322.GF1513@sasha-vm>
In-Reply-To: <20190612184322.GF1513@sasha-vm>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Wed, 12 Jun 2019 15:48:00 -0300
Message-ID: <CAHD1Q_w76cZy9_6vTXuK-OOc-BgxXrjp_dfgox-+tZq=gA0Hnw@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

OK perfect, thank you both!

On Wed, Jun 12, 2019 at 3:43 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, Jun 12, 2019 at 03:07:11PM -0300, Guilherme Piccoli wrote:
> >On Wed, Jun 12, 2019 at 1:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >>
> >> On Wed, Jun 12, 2019 at 01:37:24PM -0300, Guilherme G. Piccoli wrote:
> >> > +Greg, Sasha
> >>
> >> Please resend them in a format that they can be applied in.
> >>
> >> Also, I need a TON of descriptions about why this differs from what is
> >> in Linus's tree, as it is, what you have below does not show that at
> >> all, they seem to be valud for 5.2-rc1.
> >
> >Thanks Greg, I'll work on it. Can this "ton" of description be a cover-letter?
>
> Please just add it to the commit message. We might need to refer to it
> in the future and cover letter will just get lost.
>
> --
> Thanks,
> Sasha
