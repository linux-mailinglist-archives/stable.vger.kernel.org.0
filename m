Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04723666D3
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 10:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhDUIOX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 21 Apr 2021 04:14:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:46516 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234464AbhDUIOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 04:14:17 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-146-0tFHdEHxM4aXflNbaT3tgQ-1; Wed, 21 Apr 2021 09:13:40 +0100
X-MC-Unique: 0tFHdEHxM4aXflNbaT3tgQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 21 Apr 2021 09:13:40 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Wed, 21 Apr 2021 09:13:40 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] scsi: BusLogic: Fix missing `pr_cont' use
Thread-Topic: [PATCH v2 1/5] scsi: BusLogic: Fix missing `pr_cont' use
Thread-Index: AQHXNg9Ed+BsTt2aWkawhrOt2gHa/qq+nqtA
Date:   Wed, 21 Apr 2021 08:13:40 +0000
Message-ID: <bcb0b8fa8e1f404989c9d6450be10074@AcuMS.aculab.com>
References: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk>
 <alpine.DEB.2.21.2104201940430.44318@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2104201940430.44318@angie.orcam.me.uk>
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

From: Maciej W. Rozycki
> Sent: 20 April 2021 19:02
> 
> Update BusLogic driver's messaging system to use `pr_cont' for
> continuation lines, bringing messy output:

If reasonably possible it is best to avoid use of pr_cont().

If there are concurrent writes from multiple cpu I believe
the writes still get separated.
(Something has to give...)

For instance I've seen concurrent 'oops' generate the list of
loaded modules one module per line with the two lists interleaved!

Quite often one of the %p[A-Z] modifiers can help.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

