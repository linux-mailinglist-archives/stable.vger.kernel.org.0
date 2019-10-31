Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 171DAEAF13
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 12:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfJaLlL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 31 Oct 2019 07:41:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48739 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726711AbfJaLlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 07:41:11 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-109-GB0xbnyiMwuYT7SsYZLvhA-2; Thu, 31 Oct 2019 11:41:06 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 31 Oct 2019 11:41:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 31 Oct 2019 11:41:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christian Brauner' <christian.brauner@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>
CC:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        "Jann Horn" <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] clone3: validate stack arguments
Thread-Topic: [PATCH] clone3: validate stack arguments
Thread-Index: AQHVj99vS5K32QXnq0iIRbo0zlqhOad0n6Aw
Date:   Thu, 31 Oct 2019 11:41:06 +0000
Message-ID: <c600032527d24cf2a7dfd8a81467fd6f@AcuMS.aculab.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
In-Reply-To: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: GB0xbnyiMwuYT7SsYZLvhA-2
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner
> Sent: 31 October 2019 11:36
...
> /* Intentional user visible API change */
> clone3() was released with 5.3. Currently, it is not documented and very
> unclear to userspace how the stack and stack_size argument have to be
> passed. After talking to glibc folks we concluded that trying to change
> clone3() to setup the stack instead of requiring userspace to do this is
> the right course of action.

What happens if someone 'accidentally' runs a program compiled for
the new API on a system running the existing 5.3 kernel?

While it won't work, it needs to die reasonably gracefully.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

