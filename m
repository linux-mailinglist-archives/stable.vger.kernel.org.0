Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109392927AE
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgJSMxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 08:53:18 -0400
Received: from mail-41103.protonmail.ch ([185.70.41.103]:59427 "EHLO
        mail-41103.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgJSMxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 08:53:18 -0400
Received: from mail-02.mail-europe.com (mail-02.mail-europe.com [51.89.119.103])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-41103.protonmail.ch (Postfix) with ESMTPS id 8EDAC2003B44
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 12:53:15 +0000 (UTC)
Authentication-Results: mail-41103.protonmail.ch;
        dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="dY0ATRRK"
Date:   Mon, 19 Oct 2020 12:53:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1603111991;
        bh=+RaXHwwamZ1EOj3yremEf8kauSUCk1hTCgWdKFgnrBk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=dY0ATRRKV5WTsvbLCvupPYhnTUzcr8bkyvm+nPA4qqtiL+IpUwrfsZGdNRwe2boE4
         Qelc3Q6lD2XT5WQfXCkO3zKagV65PlFdh8AnK6TQmY7V+Jchci3H8Mfah4Ozq1Ioji
         VFQwsamdpvRW5+0JTPGytYlPQ0UaKmKHYkXtYGlY=
To:     Coiby Xu <coiby.xu@gmail.com>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH v2] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Message-ID: <eA5pt2nxH5jB_qgxYEAHbUxK5Rxww6DE2IpvFKGrvMyZvM2nZbqil2egzmycszz06jij2B69JG-dqNQ5XLuufMzUm10bxLJ2xHoj9UEY5jk=@protonmail.com>
In-Reply-To: <20201019005412.rifxrvpdxu574jag@Rk>
References: <20201016131335.8121-1-coiby.xu@gmail.com> <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com> <20201017004556.kuoxzmbvef4yr3kg@Rk> <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com> <20201017140541.fggujaz2klpv3cd5@Rk> <fRxQJHWq9ZL950ZPGFFm_LfSlMjsjrpG7Y63gd7V7iV647KR8WIfZ4-ljLeo0n4X3Gpu1KIEsMVLxQnzAtJdUdMydi_b0-vjIVb304Da1bQ=@protonmail.com> <20201019005412.rifxrvpdxu574jag@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> [...]
> You have been directly contributing to this patch because several
> improvements of next version are from you. I experienced a similar
> situation when submitting patches for QEMU. The only difference is
> that the feedbacks on the QEMU patches were also given in the format
> of patch. Or do you think a reviewed-by tag from you after you think
> the next version is of production quality is a better way to credit
> you?

Thanks, but there is no need for any tag from me. I am no maintainer/review=
er of/for
the affected subsystem.

> [...]


Regards,
Barnab=C3=A1s P=C5=91cze
