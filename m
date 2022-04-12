Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C74D4FE423
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 16:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356710AbiDLOuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355739AbiDLOuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 10:50:22 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 7E7A15C86A;
        Tue, 12 Apr 2022 07:48:02 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 12 Apr 2022 22:47:46
 +0800 (GMT+08:00)
X-Originating-IP: [60.186.191.15]
Date:   Tue, 12 Apr 2022 22:47:46 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Alan Stern" <stern@rowland.harvard.edu>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        mdharm-usb@one-eyed-alien.net, stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: storage: karma: fix rio_karma_init return
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YlWK7BxeO45UP4ee@rowland.harvard.edu>
References: <20220411060246.9887-1-linma@zju.edu.cn>
 <YlWK7BxeO45UP4ee@rowland.harvard.edu>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4ee24cb8.ae97.1801e3eb074.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cS_KCgDnaRATkVVipYAiAQ--.42269W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwMSElNG3GUAbgAAsC
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gQWxhbiwKCkplc3VzIENocmlzdCwgSSBwcm9taXNlZCBuZXh0IHRpbWUgSSB3aWxsIHVz
ZSBncmFtbWFyIHRvb2xzIHRvIGF2b2lkIHdhc3RlIG1haW50YWluZXIncyB0aW1lIGZvciB0aGUg
dHlwbyBsaWtlIHRoaXMuCgo+IHMvU2ltbGFybGx5L1NpbWlsYXJseS8KPiAKCgo+IAo+IEF0IHRo
aXMgcG9pbnQgKGp1c3QgYWZ0ZXIgdGhlICItLS0iIGxpbmUpIHlvdSBzaG91bGQgaGF2ZSBhIGRl
c2NyaXB0aW9uIAo+IG9mIGhvdyB0aGlzIHBhdGNoIHZlcnNpb24gZGlmZmVycyBmcm9tIHRoZSBw
cmV2aW91cyB2ZXJzaW9uLiAgT3RoZXJ3aXNlIAo+IHdlIGRvbid0IGtub3cgd2hhdCBoYXMgY2hh
bmdlZCBhbmQgd2hhdCB0byBsb29rIGZvci4KCkdvdGNoYSwgdGhlIG5ldyB2ZXJzaW9uIGF0IGh0
dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXVzYiZtPTE2NDk3NzQ2MjYzMjU0NSZ3PTIKClRoYW5r
cyBhZ2FpbiBmb3IgdGhlIHBhdGllbnQgYW5kIHVzZWZ1bCByZXBseS4gOikKClJlZ2FyZHMKTGlu
IE1hCg==
