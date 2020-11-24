Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956462C33C0
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 23:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388606AbgKXWRL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 24 Nov 2020 17:17:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:38293 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731238AbgKXWRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 17:17:10 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-175-Y51XK0xAPXSbNaFUnwjJqw-1; Tue, 24 Nov 2020 22:17:06 +0000
X-MC-Unique: Y51XK0xAPXSbNaFUnwjJqw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 24 Nov 2020 22:17:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 24 Nov 2020 22:17:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Artem Labazov' <123321artyom@gmail.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] exfat: Avoid allocating upcase table using kcalloc()
Thread-Topic: [PATCH] exfat: Avoid allocating upcase table using kcalloc()
Thread-Index: AQHWwprkdg3ghuo7zUO/MeBWMbuGy6nX2YQQ
Date:   Tue, 24 Nov 2020 22:17:06 +0000
Message-ID: <ebdf1f1769aa45cc8880155a4189f2a6@AcuMS.aculab.com>
References: <20201124194749.4041176-1-123321artyom@gmail.com>
In-Reply-To: <20201124194749.4041176-1-123321artyom@gmail.com>
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

From: Artem Labazov
> Sent: 24 November 2020 19:48
> 
> The table for Unicode upcase conversion requires an order-5 allocation,
> which may fail on a highly-fragmented system:

ISTM that is the wrong way to do the case conversion.
It is also why having to do it is bloody stupid.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

