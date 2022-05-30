Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F5053758D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiE3Hhx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 May 2022 03:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiE3Hhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:37:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 449A4712FC
        for <stable@vger.kernel.org>; Mon, 30 May 2022 00:37:23 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-1-58zlEE0YN66WK_EGsQ6QUA-1; Mon, 30 May 2022 08:37:20 +0100
X-MC-Unique: 58zlEE0YN66WK_EGsQ6QUA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 30 May 2022 08:37:18 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 30 May 2022 08:37:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Biggers' <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        gaochao <gaochao49@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH crypto v2] crypto: blake2s - remove shash module
Thread-Topic: [PATCH crypto v2] crypto: blake2s - remove shash module
Thread-Index: AQHYcrcaP7gQRKQBI0K/b88268hXeq03CmUA
Date:   Mon, 30 May 2022 07:37:18 +0000
Message-ID: <7719057c0de047ebacea46ab9588da44@AcuMS.aculab.com>
References: <YpCGQvpirQWaAiRF@zx2c4.com>
 <20220527081106.63227-1-Jason@zx2c4.com> <YpGeIT1KHv9QwF4X@sol.localdomain>
 <YpHx7arH4lLaZuhm@zx2c4.com> <YpJZqJd9j1gEOdTe@sol.localdomain>
In-Reply-To: <YpJZqJd9j1gEOdTe@sol.localdomain>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers
> Sent: 28 May 2022 18:20
> 
> On Sat, May 28, 2022 at 11:57:01AM +0200, Jason A. Donenfeld wrote:
> > > Also, the wrong value is being passed for the 'inc' argument.
> >
> > Are you sure? Not sure I'm seeing what you are on first glance.
> 
> Yes, 'inc' is the increment amount per block.  It needs to always be
> BLAKE2S_BLOCK_SIZE unless a partial block is being processed.

IIRC it isn't used for partial blocks.
Which rather begs the question as to why it is a parameter at all.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

