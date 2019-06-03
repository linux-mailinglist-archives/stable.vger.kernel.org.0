Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5234F32E6C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 13:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfFCLQx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 3 Jun 2019 07:16:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52582 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728147AbfFCLQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 07:16:53 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-108-o7jhmQwnN0qxpv2KrDfHtw-1; Mon, 03 Jun 2019 12:16:50 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 3 Jun 2019 12:16:49 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 3 Jun 2019 12:16:49 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Masahiro Yamada' <yamada.masahiro@socionext.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
CC:     Vineet Gupta <vgupta@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] kbuild: use more portable 'command -v' for
 cc-cross-prefix
Thread-Topic: [PATCH] kbuild: use more portable 'command -v' for
 cc-cross-prefix
Thread-Index: AQHVGfoc7Nk6FX5Ty02s910sxgLWxaaJxwdw
Date:   Mon, 3 Jun 2019 11:16:49 +0000
Message-ID: <3dcacca3f71c46cc98fa64b13a405b59@AcuMS.aculab.com>
References: <20190603104902.23799-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190603104902.23799-1-yamada.masahiro@socionext.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: o7jhmQwnN0qxpv2KrDfHtw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada
> Sent: 03 June 2019 11:49
> 
> To print the pathname that will be used by shell in the current
> environment, 'command -v' is a standardized way. [1]
> 
> 'which' is also often used in scripting, but it is not portable.

All uses of 'which' should be expunged.
It is a bourne shell script that is trying to emulate a csh builtin.
It is doomed to fail in corner cases.
ISTR it has serious problems with shell functions and aliases.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

