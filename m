Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C3C12E417
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 09:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgABI6O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 2 Jan 2020 03:58:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39954 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727835AbgABI6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 03:58:14 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-62-0-8UGkBPNxus61PG9BdnHA-1; Thu, 02 Jan 2020 08:58:10 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 2 Jan 2020 08:58:09 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 2 Jan 2020 08:58:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Aleksa Sarai' <cyphar@cyphar.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>,
        "dev@opencontainers.org" <dev@opencontainers.org>,
        "Linux Containers" <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Thread-Topic: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Thread-Index: AQHVvuu3ha8TNgK7w0ufQ/mBgQviWKfXFrEg
Date:   Thu, 2 Jan 2020 08:58:09 +0000
Message-ID: <e1066da936244de99e7ee827695d6583@AcuMS.aculab.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <CAHk-=whxNw7hYT6bJn9mVrB_a=7Y-irmpaPsp1R4xbHHkicv7g@mail.gmail.com>
 <20191230083224.sbk2jspqmup43obs@yavin.dot.cyphar.com>
In-Reply-To: <20191230083224.sbk2jspqmup43obs@yavin.dot.cyphar.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 0-8UGkBPNxus61PG9BdnHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksa Sarai
> Sent: 30 December 2019 08:32
...
> I'm not sure I agree -- as I mentioned in my other mail, re-opening
> through /proc/self/fd/$n works *very* well and has for a long time (in
> fact, both LXC and runc depend on this working).

I thought it was marginally broken because it is followed as a symlink?
On, for example, NetBSD /proc/<n>/fd/<n> is a real reference to the
filesystem inode and can be used to link the file back into the filesystem
if all the directory entries have been removed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

