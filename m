Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237B314CD07
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 16:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgA2POM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 Jan 2020 10:14:12 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20788 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgA2POM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 10:14:12 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-88-Q3tD76DDPH-PeBm5aDekKg-1; Wed, 29 Jan 2020 15:14:06 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 29 Jan 2020 15:14:05 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 29 Jan 2020 15:14:05 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Hans de Goede' <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Srikanth Krishnakar" <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: RE: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Thread-Topic: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Thread-Index: AQHV1rBGPy/8IrcoPUazhYLIIVdqQagBv6/g
Date:   Wed, 29 Jan 2020 15:14:05 +0000
Message-ID: <bfaf3336a54b4f70bb4e12f1936c20c9@AcuMS.aculab.com>
References: <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
 <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
 <87sgjz434v.fsf@nanos.tec.linutronix.de>
 <20200129130350.GD32742@smile.fi.intel.com>
 <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com>
 <20200129141444.GE32742@smile.fi.intel.com>
 <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com>
In-Reply-To: <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Q3tD76DDPH-PeBm5aDekKg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede
> Sent: 29 January 2020 14:28
...
> > Btw, why we are mentioning 20 / 6 and 28 / 6 when arithmetically
> > it's the same as 10 / 3 and 14 / 3?
> 
> I copied the BYT values from Thomas' email and I guess he did not
> get around to simplifying them, I'll use the simplified versions
> for my patch.

If those multiplier/divider values came from either official docs or
hardware registers I'd not simplify them.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

