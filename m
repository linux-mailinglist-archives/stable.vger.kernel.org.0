Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EB737F3E6
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 10:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhEMIMM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 13 May 2021 04:12:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:36763 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231485AbhEMIML (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 04:12:11 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-38-wSN3IdVMP8OQ2JQTBB0LqA-1; Thu, 13 May 2021 09:10:56 +0100
X-MC-Unique: wSN3IdVMP8OQ2JQTBB0LqA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 13 May 2021 09:10:55 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Thu, 13 May 2021 09:10:55 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Maximilian Luz' <luzmaximilian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Topic: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Index: AQHXR3+B5Hf0DG1T80+Lb/Y+9zG7TarhDftg
Date:   Thu, 13 May 2021 08:10:54 +0000
Message-ID: <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
In-Reply-To: <20210512210459.1983026-1-luzmaximilian@gmail.com>
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

From: Maximilian Luz
> Sent: 12 May 2021 22:05
> 
> The legacy PIC on the AMD variant of the Microsoft Surface Laptop 4 has
> some problems on boot. For some reason it consistently does not respond
> on the first try, requiring a couple more tries before it finally
> responds.

That seems very strange, something else must be going on that causes the grief.
The 8259 will be built into to the one of the cpu support chips.
I can't imagine that requires anything special.

It's not as though you have a real 8259 - which even a 286 can
break the inter-cycle recovery on (with the circuit from the
application note).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

