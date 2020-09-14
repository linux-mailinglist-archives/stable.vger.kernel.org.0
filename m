Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D84C2684AD
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 08:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgINGSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 02:18:49 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:4650 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbgINGSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 02:18:48 -0400
X-UUID: 5de75fe1365e422fa86cc95bc383e785-20200914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=FgYGajFnr48178YWlLNBCrvjxfgu8FSyvJO866EVJIo=;
        b=ej2v/DB2B/D9UhzwXru0U1Y702h6SfGBRQ7CArp8gQkYi+N91eXG2i60uToa9o4b87b22RCWuR9x9opkcmEkRGe3qHnOjHyIHZIhTjjIHD75p3HczxgP2lCzNNwO2LoopytwYf1FTn8GbPqhAn9RfOj28fTOjKYCkgf2f9IehWw=;
X-UUID: 5de75fe1365e422fa86cc95bc383e785-20200914
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 654306854; Mon, 14 Sep 2020 14:18:38 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31N2.mediatek.inc
 (172.27.4.87) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Sep
 2020 14:18:37 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Sep 2020 14:18:36 +0800
Message-ID: <1600064195.29909.13.camel@mhfsdcap03>
Subject: Re: [PATCH] usb: gadget: bcm63xx_udc: fix up the error of
 undeclared usb_debug_root
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Felipe Balbi <balbi@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Date:   Mon, 14 Sep 2020 14:16:35 +0800
In-Reply-To: <20200914061210.GA788192@kroah.com>
References: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
         <20200914061210.GA788192@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 4EF90E5793C0723BBF8B3E7E35116F0E7C228F9523B03CB81A31635FD5023F032000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTE0IGF0IDA4OjEyICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IE9uIE1vbiwgU2VwIDE0LCAyMDIwIGF0IDAxOjM4OjUwUE0gKzA4MDAsIENodW5mZW5n
IFl1biB3cm90ZToNCj4gPiBGaXggdXAgdGhlIGJ1aWxkIGVycm9yIGNhdXNlZCBieSB1bmRlY2xh
cmVkIHVzYl9kZWJ1Z19yb290DQo+ID4gDQo+ID4gQ2M6IHN0YWJsZSA8c3RhYmxlQHZnZXIua2Vy
bmVsLm9yZz4NCj4gPiBGaXhlczogYTY2YWRhNGYyNDFjKCJ1c2I6IGdhZGdldDogYmNtNjN4eF91
ZGM6IGNyZWF0ZSBkZWJ1Z2ZzIGRpcmVjdG9yeSB1bmRlciB1c2Igcm9vdCIpDQo+IA0KPiBOaXQs
IHlvdSBuZWVkIGEgJyAnIGJlZm9yZSB0aGUgJygnIGNoYXJhY3Rlci4uLg0KT2ssIHRoYW5rcw0K
PiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCg0K

