Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB56B0DBE
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 16:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjCHPzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 10:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjCHPyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 10:54:44 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFC291B7C
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 07:54:06 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-72-mj1XC4KrMCG4ZP0_bw2c9w-1; Wed, 08 Mar 2023 15:53:59 +0000
X-MC-Unique: mj1XC4KrMCG4ZP0_bw2c9w-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Wed, 8 Mar
 2023 15:53:57 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Wed, 8 Mar 2023 15:53:57 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'psmith@gnu.org'" <psmith@gnu.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "bug-make@gnu.org" <bug-make@gnu.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: No progress output when make 4.4.1 builds Linux 4.19 and earlier
Thread-Topic: No progress output when make 4.4.1 builds Linux 4.19 and earlier
Thread-Index: AQHZUcY8m3WvjvFA30iYgh0GUAxHw67xCC6A
Date:   Wed, 8 Mar 2023 15:53:57 +0000
Message-ID: <72676b579d6f48288044a512fd51d0af@AcuMS.aculab.com>
References: <ZAgnmbYtGa80L731@sol.localdomain> <ZAgogdFlu69QlYwu@kroah.com>
         <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
 <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
In-Reply-To: <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
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
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Li4uDQo+IERvZXMgYW55b25lIGtub3cgd2h5IHRoaXMgY29tbWl0IGlzIHVzaW5nIGEgbWFrZSB2
ZXJzaW9uIGNvbXBhcmlzb24/DQo+IFRoYXQgc2VlbXMgdG90YWxseSB1bm5lY2Vzc2FyeSB0byBt
ZTsgYW0gSSBmb3JnZXR0aW5nIHNvbWV0aGluZz8gIEFzDQo+IGZhciBhcyBJIHJlbWVtYmVyLA0K
PiANCj4gICAgIHNpbGVuY2UgOj0gJChmaW5kc3RyaW5nIHMsJChmaXJzdHdvcmQgLSQoTUFLRUZM
QUdTKSkpDQoNCkFkZGluZyBhICQoZmlsdGVyLW91dCAtLSUsLi4uKSBzaG91bGQgaGVscCB3aXRo
IG9sZCBtYWtlczoNClByb2JhYmx5Og0KDQoJc2lsZW5jZSA6PSAkKGZpbmRzdHJpbmcgcywkKGZp
cnN0d29yZCAkKGZpbHRlci1vdXQgLS0lLCQoTUFLRUZMQUdTKSkpKQ0KDQogICAgRGF2aWQNCg0K
LQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0s
IE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdh
bGVzKQ0K

