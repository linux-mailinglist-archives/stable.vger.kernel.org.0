Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75ECF6B6182
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 23:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCKWiS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 11 Mar 2023 17:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCKWiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 17:38:17 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073CF113D6
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 14:38:15 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-275-Rt4IcH8OMWatABEZxiBpHg-1; Sat, 11 Mar 2023 22:38:12 +0000
X-MC-Unique: Rt4IcH8OMWatABEZxiBpHg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Sat, 11 Mar
 2023 22:38:10 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Sat, 11 Mar 2023 22:38:10 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sasha Levin' <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
CC:     Eric Biggers <ebiggers@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: AUTOSEL process
Thread-Topic: AUTOSEL process
Thread-Index: AQHZVCKmzM8JBhrR3EiolnpkbZYpuq72Kyfw
Date:   Sat, 11 Mar 2023 22:38:10 +0000
Message-ID: <9ff6fe2c13434512b034823112843d4f@AcuMS.aculab.com>
References: <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain> <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain> <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain> <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz> <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org> <ZAyK0KM6JmVOvQWy@sashalap>
In-Reply-To: <ZAyK0KM6JmVOvQWy@sashalap>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

...
> I suppose that if I had a way to know if a certain a commit is part of a
> series, I could either take all of it or none of it, but I don't think I
> have a way of doing that by looking at a commit in Linus' tree
> (suggestions welcome, I'm happy to implement them).

Could something in git (eg when patches get applied) add dependencies
between the patches in a series.
While that won't force the entire series be added, it would ensure
that all earlier patches are added.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

