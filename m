Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC393331A6C
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 23:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCHWwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 17:52:10 -0500
Received: from rere.qmqm.pl ([91.227.64.183]:17108 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhCHWvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 17:51:41 -0500
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4DvYVc6zsYzBb;
        Mon,  8 Mar 2021 23:51:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1615243900; bh=H9wLxJ0Rkwg3daKNdIV/G5ZrNhIxhfAWBnvvXTOR7qM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ghzBgTL82zBvtP4DimcOOH2m4qMMrOFcP+e24A8EfW5o5EkYeuDfm1/QDmWe87Pq5
         IQxj3+RnvV/Tckhb9aYlhZqbhgvjLlJv47x3JrQJm6S/kBBRZm86CO2JV+Ie3gU73A
         UoeNGCBzwcCfDgUwQjfa7T92COvon7JLgF49fuyVnsnM0QOeU6JNJ4uDgOrWDl2wMm
         xshCcHXd03GGeHsS9ru9Mkld6NshR2JQLGwjROY23LDCY96ih9DWCdGuPqchheGpZv
         iCrHsxbDuAW3FoZF/nGJ6PiVLlClnmapce6Y5mgbW0xhGOITdx2uZYp+p+fln4dmqp
         XdbaA87XSw0XQ==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.4 at mail
Date:   Mon, 8 Mar 2021 23:51:33 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: stable: KASan for ARM
Message-ID: <20210308225133.GA19890@qmqm.qmqm.pl>
References: <20210307150040.GB28240@qmqm.qmqm.pl>
 <CACRpkdbiVPZLJ2d4th1auTN9CRHHh-N2eS+2TBiuuCaq_ZsuAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbiVPZLJ2d4th1auTN9CRHHh-N2eS+2TBiuuCaq_ZsuAA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 10:44:03AM +0100, Linus Walleij wrote:
> On Sun, Mar 7, 2021 at 4:00 PM Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> 
> > Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
> > are 7a1be318f579..421015713b30 if I understand correctly. They are
> > not normal stable material, but I think they will help tremendously in
> > discovering kernel bugs on 32-bit ARMs.
> 
> It's a development feature not supposed to be enabled in production/product
> kernels and following the stable kernel rules I don't see what this
> code would achieve in stable.
> 
> IMO it's a better idea to provide a branch with KASan for each stable branch
> that developers can pull in if they want to enable it and use it for testing.
> 
> Are you interested in setting up such branches for others to use?
> I think it would be helpful. Also the work shouldn't be very hard after bring-up
> and it ends when the last stable pre-v5.11 kernel is EOL:ed.

This is just a few patches, so I've posted the branch at my git repo.
Please clone after fetching stable/linux-5.10.x from kernel.org:

	git remote add rere git://rere.qmqm.pl/linux
	git fetch rere refs/heads/kasan-for-arm-510

Best Regards,
Micha³ Miros³aw
