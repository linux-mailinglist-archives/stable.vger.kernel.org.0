Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFA644D6C5
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 13:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhKKMsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 07:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhKKMsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 07:48:52 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928C1C061766;
        Thu, 11 Nov 2021 04:46:03 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E0D6922236;
        Thu, 11 Nov 2021 13:46:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636634762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f+TAWD2aPFtiwm8hAkd9NRN9NVSO95emUnttm6E55YI=;
        b=AYomQ9LHYEjiziwIM+OKUWO9gPSTwzkjGV+HEnUiE72UDSOFhs6OIY/ezdg3J0/+vjVJ7L
        z8U97Qmb2v8iGPHOYrkNeq9s823AlbBVn6dxjoWLWEQKqvP5UEEjFhnvMiwpAgyJMOhwL6
        pvegdN/G8ELXjIahSDOl7iiH62Y6nOk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Nov 2021 13:46:01 +0100
From:   Michael Walle <michael@walle.cc>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org
Subject: Re: [PATCH] spi: fix use-after-free of the add_lock mutex
In-Reply-To: <YY0Oe9NjhfUvq0J+@sirena.org.uk>
References: <20211111083713.3335171-1-michael@walle.cc>
 <YY0Oe9NjhfUvq0J+@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <20cde88dd11fde7f6847506ffcaa67ed@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2021-11-11 13:37, schrieb Mark Brown:
> On Thu, Nov 11, 2021 at 09:37:13AM +0100, Michael Walle wrote:
> 
>> ---
>> changes since RFC:
>>  - fix call graph indendation in commit message
> 
> If you are sending a new version of something please flag that in the
> commit message, this helps both people and automated systems identify
> that this is a new version of the same thing.

Are RFC patches eligible to be picked up? I wasn't sure if I had to
resend it at all. But since there was a mistake in the commit message
anyway, I went ahead and the the first "real" version. How would
you flag that? Isn't changing the subject from "[PATCH RFC]" (ok it
was "RFC PATCH", my bad) to "[PATCH]" enough?

-michael
