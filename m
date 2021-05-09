Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E433777A8
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEIQ4I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 9 May 2021 12:56:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:42655 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhEIQ4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 12:56:08 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-198-FopczfqiPWaL-OVgYN3BgQ-1; Sun, 09 May 2021 17:54:54 +0100
X-MC-Unique: FopczfqiPWaL-OVgYN3BgQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Sun, 9 May 2021 17:54:52 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Sun, 9 May 2021 17:54:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Russell King - ARM Linux admin' <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH] arm: Enlarge IO_SPACE_LIMIT needed for some SoC
Thread-Topic: [RESEND PATCH] arm: Enlarge IO_SPACE_LIMIT needed for some SoC
Thread-Index: AQHXRNSfOfqwrTJOkUK/ibckCmgRtKrbXBSg
Date:   Sun, 9 May 2021 16:54:51 +0000
Message-ID: <4f6e5115e00e4df2a84a57ed0359e907@AcuMS.aculab.com>
References: <20210508175537.202-1-ansuelsmth@gmail.com>
 <20210508185043.GF1336@shell.armlinux.org.uk>
 <YJcV6I6yYt5zIsXQ@Ansuel-xps.localdomain>
 <20210509130956.GI1336@shell.armlinux.org.uk>
In-Reply-To: <20210509130956.GI1336@shell.armlinux.org.uk>
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

...
> Well, an obvious question would be: do you really need that much IO
> space? PCs have got away with 64K of IO space without having a problem
> for years, so 64K per bus should be fine. If you have 3 buses, that
> should be 3 * 64K or 192K.

Not only that, but most modern PCI (even) cards don't require IO space.
Or does this include memory space - which can be much bigger.

I have cut one of our FPGA PCIe slaves down from two 8MB BARs to
two 1MB ones, with the extra small BARs (eg for MSI-X) the bridge
would have allocated 32MB, now 4MB.
Fortunately that card only needs to work on x86-64.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

