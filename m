Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26336276C15
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 10:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgIXIgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 04:36:17 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:1151 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726837AbgIXIgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 04:36:17 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2020 04:36:17 EDT
X-UUID: 0b4befb0c9e14a26bd31ae84c28b7256-20200924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=DVsde8Sxk23MLuOP2061BcZ00WNs3yYnS+BwpO2OdC0=;
        b=ZagBkT8LsKGA5lk7INzrhXmHg4ALNaUbomCfytyc14roUgl0Art4krlD0eoquvJi8es/V96qqoyoDaeMNNDcnwks2XndgtxPiQSsd2octfXd1SRuWp/Qev5ZpuI5yvqpz5d1Rex/Vwav1po9LccT35Kb8Uzoho5xpStfnnWBw3g=;
X-UUID: 0b4befb0c9e14a26bd31ae84c28b7256-20200924
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1474091165; Thu, 24 Sep 2020 16:31:03 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS31N1.mediatek.inc
 (172.27.4.69) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 24 Sep
 2020 16:31:02 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Sep 2020 16:31:01 +0800
Message-ID: <1600936119.21970.4.camel@mhfsdcap03>
Subject: Re: [PATCH] usb: gadget: bcm63xx_udc: fix up the error of
 undeclared usb_debug_root
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Felipe Balbi <balbi@kernel.org>
CC:     Kevin Cernekee <cernekee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Date:   Thu, 24 Sep 2020 16:28:39 +0800
In-Reply-To: <871rirehqq.fsf@kernel.org>
References: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
         <871rirehqq.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: B7859B15AFDE944996573D812135A52BDB5B7466C5FA3F1467BE71D06B2672CE2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTA5LTI0IGF0IDEwOjUwICswMzAwLCBGZWxpcGUgQmFsYmkgd3JvdGU6DQo+
IENodW5mZW5nIFl1biA8Y2h1bmZlbmcueXVuQG1lZGlhdGVrLmNvbT4gd3JpdGVzOg0KPiANCj4g
PiBGaXggdXAgdGhlIGJ1aWxkIGVycm9yIGNhdXNlZCBieSB1bmRlY2xhcmVkIHVzYl9kZWJ1Z19y
b290DQo+ID4NCj4gPiBDYzogc3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiA+IEZp
eGVzOiBhNjZhZGE0ZjI0MWMoInVzYjogZ2FkZ2V0OiBiY202M3h4X3VkYzogY3JlYXRlIGRlYnVn
ZnMgZGlyZWN0b3J5IHVuZGVyIHVzYiByb290IikNCj4gPiBSZXBvcnRlZC1ieToga2VybmVsIHRl
c3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogQ2h1bmZlbmcgWXVu
IDxjaHVuZmVuZy55dW5AbWVkaWF0ZWsuY29tPg0KPiANCj4gJCBwYXRjaCAtcDEgLS1kcnktcnVu
IHAucGF0Y2gNCj4gL3Vzci9iaW4vcGF0Y2g6ICoqKiogT25seSBnYXJiYWdlIHdhcyBmb3VuZCBp
biB0aGUgcGF0Y2ggaW5wdXQuDQo+IA0KUGxlYXNlIHRyeSB0byBhcHBseSB2MiwgaHR0cHM6Ly9w
YXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMTc3MjkxMS8NCkkgaW5kZWVkIGFkZCBhIGxpbmUg
Y29kZQ0KDQoNCg==

