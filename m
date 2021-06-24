Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE03B2873
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 09:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhFXHXi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 24 Jun 2021 03:23:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:50239 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231438AbhFXHXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 03:23:37 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-5-gGbqqVa_MamySoR60Cs1mA-1; Thu, 24 Jun 2021 08:21:16 +0100
X-MC-Unique: gGbqqVa_MamySoR60Cs1mA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Jun
 2021 08:21:15 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Thu, 24 Jun 2021 08:21:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>
CC:     'Guillaume Tucker' <guillaume.tucker@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Thread-Topic: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Thread-Index: AQHXaCznpjkpNTpwjEW+kA8o/GdKZashmKhggAAdGgCAABKuUIAAWbwAgACepjA=
Date:   Thu, 24 Jun 2021 07:21:15 +0000
Message-ID: <a05d4cd3366e4047ba42663738e12198@AcuMS.aculab.com>
References: <20210619025834.2505201-1-keescook@chromium.org>
 <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
 <42f26361db6f481e980ac349bf0079ef@AcuMS.aculab.com>
 <202106230917.FE2F587@keescook>
 <76a575d1364a47458d27c76c65b673b6@AcuMS.aculab.com>
 <202106231231.9B858B95A@keescook>
In-Reply-To: <202106231231.9B858B95A@keescook>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook
> Sent: 23 June 2021 23:47
> 
> On Wed, Jun 23, 2021 at 04:27:47PM +0000, David Laight wrote:
...
> > You can probably even do:
> >
> > echo "$test" | /bin/sh -c cat >$TRIGGER || true
> >
> > (moving the redirect to the outer shell).
> 
> Actually, it looks like the "write" is already happening in the exec'd
> process, so this can just be:
> 
> echo "$test" | cat >$TRIGGER || true
> 
> But it still can't be:
> 
> echo "$test" >$TRIGGER
> 
> which is what I had over-engineered a solution to. :)

That one fails because echo is the shell builtin.
But:
	/bin/echo "$test" >$TRIGGER
should be fine.

Quite where the original came from I not sure I want to find out.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

