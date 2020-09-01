Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8BB258763
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 07:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgIAFZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 01:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgIAFZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 01:25:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5F0C061290
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 22:25:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leviathan.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <s.trumtrar@pengutronix.de>)
        id 1kCynE-00014i-4C; Tue, 01 Sep 2020 07:25:16 +0200
References: <20200831104912.28974-1-s.trumtrar@pengutronix.de>
 <0632255f-448b-029d-9154-939fa45ee7ae@kernel.org>
User-agent: mu4e 1.4.12; emacs 28.0.50
From:   Steffen Trumtrar <s.trumtrar@pengutronix.de>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: socfpga: arria10: fix timer3 address
In-reply-to: <0632255f-448b-029d-9154-939fa45ee7ae@kernel.org>
Date:   Tue, 01 Sep 2020 07:25:13 +0200
Message-ID: <87v9gy83wm.fsf@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: s.trumtrar@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Dinh,

Dinh Nguyen <dinguyen@kernel.org> writes:

> Thanks for the patch Steffen, but I have already submitted a 
> patch to
> fix this.
>
> The patch is in linux-next and staged for an rc in v5.9.
>

perfect. Didn't see it yesterday, probably didn't look hard 
enough.


BR,
Steffen

--
Pengutronix e.K.                | Dipl.-Inform. Steffen Trumtrar |
Steuerwalder Str. 21            | https://www.pengutronix.de/    |
31137 Hildesheim, Germany       | Phone: +49-5121-206917-0       |
Amtsgericht Hildesheim, HRA 2686| Fax:   +49-5121-206917-5555    |
