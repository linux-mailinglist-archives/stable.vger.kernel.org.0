Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF29EBDE
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 22:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfD2Ux3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 16:53:29 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:51018 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbfD2Ux3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 16:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1556571206; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eci7PqqUZRtWPK2vm2tYC0lnabTJ5/V4H+ljsaB1HN4=;
        b=qrj1euXE69KAV7OvTpHY0Gwmm6g23q0zwuWjKQ57NVf0+g+JzUoPk8EhRsDEuIOgJ3prSm
        IRs5JdQNpKe16tM8k5AeSFOiiYNcciEFhRi2FBygv/zgBi4r3Mt0gSqsbjWiTC5Qhe0xm9
        guoDFvCUG9DuFK6G2PQ5JZG9nlaCJoQ=
Date:   Mon, 29 Apr 2019 22:53:11 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] clk: ingenic/jz4725b: Fix parent of pixel clock
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <1556571191.1721.0@crapouillou.net>
In-Reply-To: <155562472561.15276.17918796624287416345@swboyd.mtv.corp.google.com>
References: <20190417112420.3034-1-paul@crapouillou.net>
        <155562472561.15276.17918796624287416345@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stephen,

Le jeu. 18 avril 2019 =E0 23:58, Stephen Boyd <sboyd@kernel.org> a=20
=E9crit :
> Quoting Paul Cercueil (2019-04-17 04:24:20)
>>  The pixel clock is directly connected to the output of the PLL, and=20
>> not
>>  to the /2 divider.
>>=20
>>  Cc: stable@vger.kernel.org
>>  Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  ---
>=20
> Applied to clk-next

Could you drop this patch?

It turns out it is wrong and the pixel clock is really connected to the=20
"pll half"
clock. The real bug was elsewhere: the "pll half" clock does not report=20
the correct
rate. I will send a patch for this one later.

Thanks,
-Paul

=

