Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C647105732
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 17:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUQiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 11:38:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40309 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUQiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 11:38:51 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A2ED22601;
        Thu, 21 Nov 2019 11:38:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 21 Nov 2019 11:38:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=g
        2JxlAyiwCkIGvutlrAE+5G2mjmK69r1uQOZ0m09+Jc=; b=cyPrfF6Ojf2aZcRjC
        XQSbFyGzVZGnamBjX17FaE6ZKxEGIW07hnUb6rKjfXdPlCsnUMDuWQBn2pnyAdlX
        LdPL+CyJxQHJsWzs0hz9nTqw22DfH3anTOwIbvVpwCZEDNI6ViYe+aSjVzszho8Z
        6dR0L7RNmZhgcmLTQSlcoH3M6P3dkgNbuVcfya2MgIrhoNeWQuXMvPYkXC/bIxSf
        iNCEZNl9nqzGKR471n4ddzKgVTxnFlHVWAItH9L1mPpBgMFDDaPPO3735KQFU+ry
        bjeJtZce3sg3IaOcccClHvimvq08frUF1XlHsnJ15B6XGAP4U/kLxAkRVrWBYPi4
        77j3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=g2JxlAyiwCkIGvutlrAE+5G2mjmK69r1uQOZ0m09+
        Jc=; b=ZgMaKYIMYKEDgaFMXN8v9ZlYMZmccGXSvUKMtam22hPJzLz1QP34eTdzB
        GctqRVmtlRZCu5jjZC4a9hQHnDUzY/td3HWnz4Ztx5srCPkM1k/qx9E2hbaHZDRx
        EhsWR/UysZSzsI78vurUQQKtW/0spqU48LdBsMUFfMKzJ+ehtX5y6bBxtTI5iPT7
        TjPvEy9sD32/Wx4CnPhx8GpuuXBW9tuQvjMM2QJhfHN4FjKv+rEEJSux015eFyu5
        VdxHfeQtetn/ofJGoyf4Ka0FiRPFHtovSCzu2cBMfyfekVYZCQ2/zRV24nW8dRvG
        cxQI+QBY5ojBLfzUujd4s8ok5n5dw==
X-ME-Sender: <xms:mr3WXYwZaZHcdPo5rA6glNw8EeRaxjuwMHVuVPL6YCKcTONXdNC2vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjfgesth
    ekredttderjeenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecukfhppedvudejrdeikedrgeelrdejvdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mr3WXTRp8q5J8eF56ovareO6MjzfcXIUmQdhddsreCx2O1BcQRbsNw>
    <xmx:mr3WXfWQlcm7V6QH9w8Fp8fz-mTRi8tYPvPC2bi_J6eRhIdb7XR2vA>
    <xmx:mr3WXVbk5iVBrIvbgDL1bLysDxcVLBFdB0bo1B4H13BVLIT_mmAXsA>
    <xmx:mr3WXTTQm5eh5ETJ_FRpgae-hdNPql2MsdVrAzf-kDDS-sasPqfStw>
Received: from localhost (unknown [217.68.49.72])
        by mail.messagingengine.com (Postfix) with ESMTPA id 826A53060065;
        Thu, 21 Nov 2019 11:38:49 -0500 (EST)
Date:   Thu, 21 Nov 2019 17:38:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Yama Modo <zero19850401@gmail.com>
Cc:     linus.walleij@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4] gpio: make the gpiochip a real device
Message-ID: <20191121163846.GC651886@kroah.com>
References: <CACgcjHEHxzBkiE6hH3OEUw6V+PZHX7MAKht61OZPbAyAVRDQiQ@mail.gmail.com>
 <20191121115442.GA428835@kroah.com>
 <CACgcjHGKksiBq8ZWR4UbJ+4=P0+dMv=hdudA6Qq5N965Bi_8Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACgcjHGKksiBq8ZWR4UbJ+4=P0+dMv=hdudA6Qq5N965Bi_8Qw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 10:08:03PM +0800, Yama Modo wrote:
> Hi Greg ,
> 
> Thanks for your response!
> 
> > Greg KH <greg@kroah.com>於 2019年11月21日 週四，下午7:54寫道：
> 
> > On Thu, Nov 21, 2019 at 07:47:37PM +0800, Yama Modo wrote:
> > >> Dear Linus Walleij,
> > >>
> > >> I want to backport commit ff2b13592299 "gpio: make the gpiochip a real
> > >> device" to linux 4.4.y. Could you please review the following patch? I
> > >> will improve this later if something need to take care. Thanks!
> >
> > >> Why do you want to do that?  What does it "fix" and who needs it for the
> > old 4.4.y kernel tree?
> >
> 
> Sorry I should take care about that patch must fix the issue directly and
> then it can be backported to stable kernel. We use Linux 4.4.y-cip for our
> MOXA products, such as UC8410A, for a super long term kernel, and it’s
> based on Linux 4.4.y.

If your device works properly on 4.9 or newer, you really really really
should use that instead.  That way you always have support, and proper
fixes, unlike what will, and is already, happening with 4.4.y.

> We suffer a kernel panic issue because of of_node inconsistency and
> gpio-reserved-ranges with no gpio device, and we find mainline、4.9.y、4.14.y
> and 4.19.y have no this gpio problem, and there are have gpio device.

Great, why not use 4.19.y?  That was said to be the next "super long
term kernel", right?

> Many gpio patches are based on gpio device. If we want to backport these
> gpio patches to Linux 4.4.y-cip, it will suffer more problems than having
> gpio device’s kernels. Besides, in house patches in Linux 4.4.y-cip are
> harder to upstream mainline because subsystem of Linux 4.4.y-cip is far
> from mainline’s.

I have no idea what is in the -cip 4.4.y tree.  You are on your own
there.  And honestly, I think the model of what they are trying to do
there is totally wrong and will fail horribly :(

Use 4.19.y.  Or even better yet, 5.4.y  Your device is "alive", keep it
alive by giving it the latest kernel updates so that you know it is in
good health.  To rely on an old kernel like that, you can not guarantee
how alive it will be.

good luck!

greg k-h
