Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D650D42670
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 14:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409153AbfFLMsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 08:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404447AbfFLMsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C059208C2;
        Wed, 12 Jun 2019 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560343716;
        bh=T7e+N0eXDbEngt69yByxL9+F/rITTlRQEha/KbhDUzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rnKLtEAxRvOXqVMO6zK2mIXacAPITo3KQhYEuhfGoWoMVunscMyXuGd7Nq5OXjggV
         qBDRLNsev8IXy5q5A8Y7w8nTpJ1jCG3zSLPTeoslA8Uq0m8ajpYWmQ4wtt5/Qbeftm
         d+TSHxnSvWhHAl4yYzos/HgVfRh+Hwgm3mg+5Zb8=
Date:   Wed, 12 Jun 2019 14:48:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guilherme Piccoli <gpiccoli@canonical.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Message-ID: <20190612124834.GA27918@kroah.com>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
 <CAHD1Q_wraiFkLP72pFfGhON+KZe7yo3ktXvsAA40QVcXvzviSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHD1Q_wraiFkLP72pFfGhON+KZe7yo3ktXvsAA40QVcXvzviSA@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 09:40:17AM -0300, Guilherme Piccoli wrote:
> Hi Greg and Sasha, is there any news about these patches?

What patches?

> Just checked the stable branches 5.1.y and 5.0.y, they seem not merged.

Are they merged in Linus's tree?  What are the git commit ids?

I have no record of these patches in my queue at the moment, sorry.  If
these were a backport, please resend them in the proper format.

thanks,

greg k-h
