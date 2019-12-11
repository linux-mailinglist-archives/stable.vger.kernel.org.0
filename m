Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC1C11AEA7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfLKPEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:04:52 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:22157 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729228AbfLKPEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 10:04:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576076690;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=CjfY3IHAv53gW+pu2/nTNB7jUxk4umIqwnPnMai+4YA=;
        b=ir/gietSPfZbsoiAxxwUqi7eKLZPSn8mCDw5sIAt++kRQRpSQUdMwD9scnb43HZNRl
        Zp8/+qySBI3doV+pbynaxZrKXzBIKfCAUS4fYCUmdJT27UdDeQGfOdRn4mqPa2H6svP4
        1YJ3kA9095HxMxht7hp6wAMIqcbHPGIZsDjXp/tr6At3IqWRlxvcj9LjTMNdoPKk7iys
        dhX9jluzgUJLoEvXXWknoDHtSHwUMcEoJeEg7fM7JXbulmjzuq+0sK90j0hzqQ2C84dz
        sidZKGnQAtERBrn6MB8YIrL1Qj7MJnuulZMC7OJFszbmlSVkd0L2Kejf5fswY9XLA4kJ
        S9vA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrvwDOutHk="
X-RZG-CLASS-ID: mo00
Received: from mbp-13-nikolaus.fritz.box
        by smtp.strato.de (RZmta 46.0.4 DYNA|AUTH)
        with ESMTPSA id Q0b574vBBF4n0Bi
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Wed, 11 Dec 2019 16:04:49 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: WTF: patch "[PATCH] net: wireless: ti: wl1251 add device tree support" was seriously submitted to be applied to the 5.4-stable tree?
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20191211142448.GA605616@kroah.com>
Date:   Wed, 11 Dec 2019 16:04:49 +0100
Cc:     kvalo@codeaurora.org, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5722399B-A4BF-4E91-8507-78EC8E11FDE9@goldelico.com>
References: <1576073193178125@kroah.com> <8B77E722-80C2-4607-8519-AC36CC42519C@goldelico.com> <20191211142448.GA605616@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 11.12.2019 um 15:24 schrieb Greg KH <gregkh@linuxfoundation.org>:
>=20
> On Wed, Dec 11, 2019 at 03:19:19PM +0100, H. Nikolaus Schaller wrote:
>> Hi Greg,
>> I have checked with Documentation/process/stable-kernel-rules.rst but =
not found out
>> what is failing.
>>=20
>> Basically this belongs to a series to fix a bug
>>=20
>> 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting =
DMA channel")
>>=20
>> that exists since v4.7 and has been hidden by patches which came into =
the kernel over
>> the time.
>=20
> I do not understand at all.
>=20
> What does tagging all of these random wifi driver commits with cc:
> stable have to do with an old mmc commit from 4.7-rc1?

Here is also the cover letter for the series when they were originally =
submitted to fix linux-next:

https://lore.kernel.org/patchwork/cover/1142016/

Unfortunately that gets lost by the transition to stable.

BR,
Nikolaus Schaller

