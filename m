Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6705E243790
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 11:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgHMJXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 05:23:48 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:54062 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726106AbgHMJXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 05:23:48 -0400
X-UUID: 7c4e8901d0e34812a12b8637e4fb56cd-20200813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=v5RL6V9x3ufySZ6lQXXP3W0N4mG04Wkwj8+hcLlIG0M=;
        b=Clk7BRDRvNrBBhwS9M1ZMY4aFRmBWZp5jHizm/mkWmcOi1z92EJIGxaYBmLh/HIBjs6fQjyu1wCsAJ9wWTFRpzhYfMFK9HwjMQ4G73TNRHNyaEU0WhW6UJBsiFEf6Mvsyg1dG7fTcomLewaDKhadAF+Q3aaVcuYLQHMSYGao560=;
X-UUID: 7c4e8901d0e34812a12b8637e4fb56cd-20200813
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1047951617; Thu, 13 Aug 2020 17:23:40 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS31DR.mediatek.inc (172.27.6.102) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 13 Aug 2020 17:23:38 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 13 Aug 2020 17:23:38 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     <yong.mao@mediatek.com>
CC:     Wenbin Mei <wenbin.mei@mediatek.com>, <stable@vger.kernel.org>
Subject: [v4,2/3] arm64: dts: mt7622: add reset node for mmc device
Date:   Thu, 13 Aug 2020 17:22:01 +0800
Message-ID: <20200813092202.28341-3-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200813092202.28341-1-wenbin.mei@mediatek.com>
References: <20200813092202.28341-1-wenbin.mei@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: FA6FF2048A2EA81B6E663CB6A3DD047AAFF3CD3FC9924D3D91C770F1662865512000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpcyBjb21taXQgYWRkcyByZXNldCBub2RlIGZvciBtbWMgZGV2aWNlLg0KDQpDYzogPHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuNCsNCkZpeGVzOiA5NjY1ODBhZDIzNmUgKCJtbWM6IG1l
ZGlhdGVrOiBhZGQgc3VwcG9ydCBmb3IgTVQ3NjIyIFNvQyIpDQpTaWduZWQtb2ZmLWJ5OiBXZW5i
aW4gTWVpIDx3ZW5iaW4ubWVpQG1lZGlhdGVrLmNvbT4NClRlc3RlZC1ieTogRnJhbmsgV3VuZGVy
bGljaCA8ZnJhbmstd0BwdWJsaWMtZmlsZXMuZGU+DQotLS0NCiBhcmNoL2FybTY0L2Jvb3QvZHRz
L21lZGlhdGVrL210NzYyMi5kdHNpIHwgMiArKw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIy
LmR0c2kgYi9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi5kdHNpDQppbmRleCAx
YTM5ZTBlZjc3NmIuLjViOWVjMDMyY2U4ZCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvYm9vdC9k
dHMvbWVkaWF0ZWsvbXQ3NjIyLmR0c2kNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0
ZWsvbXQ3NjIyLmR0c2kNCkBAIC02ODYsNiArNjg2LDggQEANCiAJCWNsb2NrcyA9IDwmcGVyaWNm
ZyBDTEtfUEVSSV9NU0RDMzBfMF9QRD4sDQogCQkJIDwmdG9wY2tnZW4gQ0xLX1RPUF9NU0RDNTBf
MF9TRUw+Ow0KIAkJY2xvY2stbmFtZXMgPSAic291cmNlIiwgImhjbGsiOw0KKwkJcmVzZXRzID0g
PCZwZXJpY2ZnIE1UNzYyMl9QRVJJX01TREMwX1NXX1JTVD47DQorCQlyZXNldC1uYW1lcyA9ICJo
cnN0IjsNCiAJCXN0YXR1cyA9ICJkaXNhYmxlZCI7DQogCX07DQogDQotLSANCjIuMTguMA0K

