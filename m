Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9EA42ECD
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 20:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfFLShE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 14:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbfFLShC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 14:37:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15FB20896;
        Wed, 12 Jun 2019 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560364622;
        bh=2tbqEGYQrwakdscjzkXtggwQKOtfP0w++2SzQAqYt9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bVQkB0VDn4eloOFiBO1kPYpFp0wMePuRXOjxTF2Fdf1xDscFXYCBF1obqkK6dMkvu
         JEgYnc8zBBxg1H3QXgvXsViQuA1+10qictnTmXguXXnMXI9M8aS9WRW7Hw/gkX1XE3
         n5NEhI4lrgtEHXoXX3FO6j9JiPlDceRmEiRjwG24=
Date:   Wed, 12 Jun 2019 20:36:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guilherme Piccoli <gpiccoli@canonical.com>
Cc:     stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        sashal@kernel.org
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Message-ID: <20190612183659.GA16699@kroah.com>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
 <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
 <20190612164958.GB31124@kroah.com>
 <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 03:07:11PM -0300, Guilherme Piccoli wrote:
> On Wed, Jun 12, 2019 at 1:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jun 12, 2019 at 01:37:24PM -0300, Guilherme G. Piccoli wrote:
> > > +Greg, Sasha
> >
> > Please resend them in a format that they can be applied in.
> >
> > Also, I need a TON of descriptions about why this differs from what is
> > in Linus's tree, as it is, what you have below does not show that at
> > all, they seem to be valud for 5.2-rc1.
> 
> Thanks Greg, I'll work on it. Can this "ton" of description be a cover-letter?

Nope, in the commit log itself as we need it in the tree if we apply it.

Remember, 99% of all patches that we take in the stable tree that are
NOT in Linus's tree end up having bugs.  Yours will, and we want lots of
documentation about exactly why we are thinking we are justified in
taking this patch :)

thanks,

greg k-h
