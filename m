Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C204A418860
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 13:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhIZLlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 07:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230200AbhIZLlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 07:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A32361038;
        Sun, 26 Sep 2021 11:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632656376;
        bh=yXCtLx7Fu34z0Ajr2RdaJF2XJr65hF634x6wb/qoKH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ELdMAutrwqX0USx69XeLJYFnNqyCITvjXYHKLR74jE8ULOlUUcC2zHQHsUDz3ZMue
         klWgGgrtdxh5n8hGaChka8cUrAENAovp/Dxwr7ajiXAvgqj8OI0FpIZOCyq8Kz9+ky
         5Z1hCthcrXEaaUuKr4fUdXCs7Ap8d5Rb41wNVjqk=
Date:   Sun, 26 Sep 2021 13:39:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: glibc VETO for kernel version SUBLEVEL >= 255
Message-ID: <YVBb9ZoDGgV4cbXb@kroah.com>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com>
 <YVAhOlTsb0NK0BVi@kroah.com>
 <YVArDZSq9oaTFakz@eldamar.lan>
 <YVA9l9svFyDgLPJy@kroah.com>
 <xxvm9EznCQoQ_-YYhxhEknGTxHEnVW584ypJShT__L09eV-JOfFtr-K4M33xRa3VTL5tNgOGvJSUqWthW-El4IwTi6Vt4B_XZA-xMB6vOEY=@protonmail.com>
 <YVBYfQY94j7K39qc@kroah.com>
 <gjSfoj7RAJMOeVL1pzzsZl5SjMGR_BXqigZqgkJe4G_8PPfm3EhxRlrRi-I7-Z0guYL0DAFOWeSWmrt_R8RcgzNq6Bcnk7BlQ9g3_G9aT2w=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gjSfoj7RAJMOeVL1pzzsZl5SjMGR_BXqigZqgkJe4G_8PPfm3EhxRlrRi-I7-Z0guYL0DAFOWeSWmrt_R8RcgzNq6Bcnk7BlQ9g3_G9aT2w=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 26, 2021 at 11:31:20AM +0000, Jari Ruusu wrote:
> On Sunday, September 26th, 2021 at 14:24, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > Why use an older kernel tree on this device? Rasbian seems to be on
> > 4.19.y at the least right now, is there something in those older kernel
> > trees that you need?
> 
> Due to circumstances, I need "smallest possible" kernel with all extra
> stripped out. 4.9.y kernels are smaller than newer ones.

Smaller by how much, and what portion grew?  Are we building things into
the kernel that previously was able to be compiled out?  Or is there
something new added after 4.9 that adds a huge memory increase?

Figuring that out would be good as you only have 1 more year for 4.9.y
to be alive, that's not going to last for forever...

thanks,

greg k-h
