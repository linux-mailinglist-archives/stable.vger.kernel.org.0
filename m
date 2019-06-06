Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377C937510
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfFFNYC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 6 Jun 2019 09:24:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:30548 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726877AbfFFNYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 09:24:02 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-26-kobq2hx2OiCkRXv6U5Q6Sg-1; Thu, 06 Jun 2019 14:23:57 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu,
 6 Jun 2019 14:23:56 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 6 Jun 2019 14:23:56 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Oleg Nesterov' <oleg@redhat.com>
CC:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        "Linux List Kernel Mailing" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>, Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCH -mm 0/1] signal: simplify
 set_user_sigmask/restore_user_sigmask
Thread-Topic: [PATCH -mm 0/1] signal: simplify
 set_user_sigmask/restore_user_sigmask
Thread-Index: AQHVG8OiWeMKMn2zNEeA0y96arbBsKaOUFtAgAAW0gCAABcWoIAAA6aAgAAcBEA=
Date:   Thu, 6 Jun 2019 13:23:56 +0000
Message-ID: <3070fdaff85d4961a7ad9a3a0da0a4ee@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
 <20190605155801.GA25165@redhat.com>
 <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
 <1285a2e60e3748d8825b9b0e3500cd28@AcuMS.aculab.com>
 <20190606110522.GA4691@redhat.com>
 <6e3eeb101a30431eb111ad739ab5d2b0@AcuMS.aculab.com>
 <20190606124103.GB4691@redhat.com>
In-Reply-To: <20190606124103.GB4691@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: kobq2hx2OiCkRXv6U5Q6Sg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov
> Sent: 06 June 2019 13:41
> On 06/06, David Laight wrote:
> >
> > Some of this code is hard to grep through :-)
> 
> I'd suggest to simply read the kernel code once and memorise it, after
> that you will not need to use grep.

Unfortunately all the available buffer space is full of the SYSV and NetBSD
kernels, there isn't any room for the Linux one :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

