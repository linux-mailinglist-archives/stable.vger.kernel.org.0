Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C011DAB94
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 09:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgETHHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 03:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgETHHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 03:07:51 -0400
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [IPv6:2001:470:1f0b:3b7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6542CC061A0E;
        Wed, 20 May 2020 00:07:48 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 2F849543; Wed, 20 May 2020 09:07:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1589958463;
        bh=UuLjB4lUIXEJCTsjz0Aui6c45k/IBmfcpv9LSaqLVhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iMRJmr2GHbRzqTq+5jQISZdb5afOot71nAXDKe+7yovTew6TrwuNjUJ1Yx9n4wv6U
         pzD0vC0taVcmzPkEMZup/pgH0TgQnPgF6OEl8sL2QKJKT2anoPA6c3p02qJ/Q8+r7u
         u6TUmWcy5h5HEkc/N7zW31HIlA0YiI91GvgfItXquE/+LDa36uAckZUImTumpXpsxe
         cQZ2j+CLBzdJrVatqN6gc5ZhgEpdGJkNbW88sVpsTq+YaoDbNISmHsqySlZPrxc9X9
         02CM6JP0vJNLb2Zv4FCTcZt3wRLaN1kF+ABSmK/PJ50LxELaagaTn4Ps86l8pWshu9
         nWCajQF7IZpaMkegv6O1UHtFWeL2kBDob6qxKTCQSsuqUSIh9Jb71+KbCSHkbrRykT
         nuPOmuc9QGGmIg1FDvDu7zAgbn5nwN69gBV/XDnEXQFW/sHWRKNCdpmkMa9AY0YUwh
         SnegZSfj1ySzGoTNy8Zx/StQntry5/gOtfhyAjy0H44UuUxp/c5qTbw5oeCdby0uBW
         xHcFUHeZ3bgDLiz//PjwHt56Y61g6OQmzSEiU7/paFGudGdYaQiUzd/c4px3mK+TDE
         Ui7aPOqxpTSk3XIyR0nfwv4KuhB/D30pwMyjZYO2M/r+zPW4ujYWb/QeXADmVenQFz
         jJA1cESmmngnhnirBa1WVwnc=
Date:   Wed, 20 May 2020 09:07:43 +0200
From:   Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] s390/sclp_vt220: Fix console name to match device
Message-ID: <20200520070743.GO4974@valentin-vidic.from.hr>
References: <20200519181654.16765-1-vvidic@valentin-vidic.from.hr>
 <65218cdb-d03f-29a8-1e78-42ff2d4f958d@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65218cdb-d03f-29a8-1e78-42ff2d4f958d@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 07:25:06AM +0200, Christian Borntraeger wrote:
> This is not as simple. ttyS1 is the the console name and ttysclp0 is the tty name.
> This has mostly historic reasons and it obviously causes problems.
> But there is  documentation out that that actually describes the use of 
> console=ttyS1 console=ttyS0.
> to have console output on both sclp consoles and there are probably scripts
> using ttyS1.
> 
> I am wondering. The tty for ttyS0 is named sclp_line0. Does this work in LPAR?

I ran into this problem with qemu-system-s390x, so not sure about LPAR.
Would changing the tty name also cause problems?

-- 
Valentin
