Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67F73D8B94
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 12:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhG1KRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 06:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhG1KRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 06:17:01 -0400
X-Greylist: delayed 546 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jul 2021 03:16:59 PDT
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC297C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 03:16:59 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4GZTqp0MR9zMqBHb;
        Wed, 28 Jul 2021 12:07:50 +0200 (CEST)
Received: from [127.0.0.1] (unknown [87.88.186.222])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4GZTqn3c2fzlmrs4;
        Wed, 28 Jul 2021 12:07:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=asdrip.fr;
        s=20210424; t=1627466869;
        bh=gGvxgUyldNbPfsnrB85WHEVk+2mcBxIQzIc0vKO1mjw=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=F4Z0fyhBM+akD0ETer1zkkOc5o20IHLhsE07BQRJeOZ4cyfK5I/o7Iw3szpIXQyNA
         wFExPDaA1CsEiNUfHpAhAncYkmCE6YXQdO7Rk7FdWhXNW9pGdjTu0CU3NszuoRiTQU
         kHj/EYG735s8z0ML/vqp28N18mGO+zU+XIcZNsQ8=
Date:   Wed, 28 Jul 2021 10:07:47 +0000 (UTC)
From:   Adrien Precigout <dev@asdrip.fr>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org
Message-ID: <5c29cf89-559e-4d49-a38c-4b87d033bb04@asdrip.fr>
In-Reply-To: <YQD51cSUOpDaD7Ad@kroah.com>
References: <fc66decb-ed13-45dd-bf82-91f0cc516a30@asdrip.fr> <YQD51cSUOpDaD7Ad@kroah.com>
Subject: Re: Tr: Unable to boot on multiple kernel with acpi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <5c29cf89-559e-4d49-a38c-4b87d033bb04@asdrip.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
Thank you for your answer!
Here is the error I got when sending my first message with html and plain i=
f you need it :).
This is the mail system at host=C2=A0lindbergh.monkeyblade.net.
I'm sorry to have to inform you that your message could notbe delivered to =
one or more recipients. It's attached below.
For further assistance, please send mail to postmaster.
If you do so, please include this problem report. You candelete your own te=
xt from the attached returned message.
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 The mail system
<stable@vger.kernel.org>: host=C2=A023.128.96.18[23.128.96.18] said: 550 5.=
7.1=C2=A0=C2=A0=C2=A0 Content-Policy reject msg: The message contains HTML =
subpart, therefore we=C2=A0=C2=A0=C2=A0 consider it SPAM or Outlook Virus.=
=C2=A0 TEXT/PLAIN is accepted.! BF:<U=C2=A0=C2=A0=C2=A0 0.500074>; S232140A=
bhG0VhZ (in reply to end of DATA command)
----------------------------------------
*Reporting-MTA*: dns;=C2=A0lindbergh.monkeyblade.net
*X-Postfix-Queue-ID*: 0C4B7C061757
*X-Postfix-Sender*: rfc822;=C2=A0dev@asdrip.fr
*Arrival-Date*: Tue, 27 Jul 2021 14:37:23 -0700 (PDT)
*Final-Recipient*: rfc822;=C2=A0stable@vger.kernel.org
*Original-Recipient*: rfc822;stable@vger.kernel.org
*Action*: failed
*Status*: 5.7.1
*Remote-MTA*: dns;=C2=A023.128.96.18
*Diagnostic-Code*: smtp; 550 5.7.1 Content-Policy reject msg: The message
contains HTML subpart, therefore we consider it SPAM or Outlook Virus.
TEXT/PLAIN is accepted.! BF:_; S232140AbhG0VhZ_

Jul 28, 2021 08:31:54 Greg KH <gregkh@linuxfoundation.org>:

> On Tue, Jul 27, 2021 at 09:48:55PM +0000, Adrien Precigout wrote:
>>=20
>> 27 juil. 2021 23:31:53 Adrien Precigout <dev@asdrip.fr>:
>>=20
>> Hi,
>>=20
>> On my acer swift 3 (SF314-51), I can't boot on my device since 4.19.198 =
(no issue with 4.19.197) without adding "acpi=3Doff" in the parameters. Sam=
e thing happens on 5.12.19 (didn't happened in 5.12.16), 5.13.4 and .5 and =
5.10.52.
>=20
> Odd, this list accepts html emails...
>=20
> Anyway, as I said on the stable list in response to this same request,
> it's a known issue with the acpi developers, please read the thread I
> pointed you at there and let the developers know it is affecting you.
>=20
> thanks,
>=20
> greg k-h
