Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E5C4B581D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 18:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356921AbiBNRKX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 14 Feb 2022 12:10:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348389AbiBNRKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 12:10:21 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C39A3652C3
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 09:10:11 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-59-4uBsnFPgM72Ml12czhVz_g-1; Mon, 14 Feb 2022 17:10:09 +0000
X-MC-Unique: 4uBsnFPgM72Ml12czhVz_g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Mon, 14 Feb 2022 17:10:06 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Mon, 14 Feb 2022 17:10:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@infradead.org>,
        Arnd Bergmann <arnd@kernel.org>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "dalias@libc.org" <dalias@libc.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "guoren@kernel.org" <guoren@kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "bcain@codeaurora.org" <bcain@codeaurora.org>,
        "deller@gmx.de" <deller@gmx.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-m68k@lists.linux-m68k.org" <linux-m68k@lists.linux-m68k.org>,
        "openrisc@lists.librecores.org" <openrisc@lists.librecores.org>,
        "green.hu@gmail.com" <green.hu@gmail.com>,
        "shorne@gmail.com" <shorne@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "nickhu@andestech.com" <nickhu@andestech.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dinguyen@kernel.org" <dinguyen@kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "richard@nod.at" <richard@nod.at>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 03/14] nds32: fix access_ok() checks in get/put_user
Thread-Topic: [PATCH 03/14] nds32: fix access_ok() checks in get/put_user
Thread-Index: AQHYIcSLBVNsuZIR/kWyaxa2mA9Gq6yTRsYw
Date:   Mon, 14 Feb 2022 17:10:05 +0000
Message-ID: <8a6e309687d647e3aef8a88bdb0922af@AcuMS.aculab.com>
References: <20220214163452.1568807-1-arnd@kernel.org>
 <20220214163452.1568807-4-arnd@kernel.org> <YgqK1ihlJvRFHJ9h@infradead.org>
In-Reply-To: <YgqK1ihlJvRFHJ9h@infradead.org>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig
> Sent: 14 February 2022 17:01
> 
> On Mon, Feb 14, 2022 at 05:34:41PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The get_user()/put_user() functions are meant to check for
> > access_ok(), while the __get_user()/__put_user() functions
> > don't.
> >
> > This broke in 4.19 for nds32, when it gained an extraneous
> > check in __get_user(), but lost the check it needs in
> > __put_user().
> 
> Can we follow the lead of MIPS (which this was originally copied
> from I think) and kill the pointless __get/put_user_check wrapper
> that just obsfucate the code?

Is it possible to make all these architectures fall back to
a common definition somewhere?

Maybe they need to define ACCESS_OK_USER_LIMIT - which can be
different from TASK_SIZE.

There'll be a few special cases, but most architectures have
kernel addresses above userspace ones.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

