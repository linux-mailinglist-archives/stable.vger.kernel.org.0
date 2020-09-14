Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6932684B4
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 08:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgINGUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 02:20:08 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:22499 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726033AbgINGUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 02:20:01 -0400
X-UUID: 4db4b5caade74da3baf0199f3a4e85a0-20200914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=wrw9ErLmusz8Mzqi1finrY3zRs9O8FuYizuUfANpacw=;
        b=F9TBXArQ8GftL+udERxkKLmV6ItUd6F8S7DEpoXLPJsqQNeoWpS1U/o/zoH5TYU7lk+SudA6jxJa0NP7vMLIK0m6z7u0F4LybeNdBc/7oDcXHK4jT0MJBsg0LrqqMeCH55kbcvEdKPOd7aiFb857kv8Gc0x/Z2UrlpAoEYTWb4s=;
X-UUID: 4db4b5caade74da3baf0199f3a4e85a0-20200914
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1680536980; Mon, 14 Sep 2020 14:19:54 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS31DR.mediatek.inc (172.27.6.102) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 14 Sep 2020 14:19:33 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Sep 2020 14:19:33 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Felipe Balbi <balbi@kernel.org>
CC:     Kevin Cernekee <cernekee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2] usb: gadget: bcm63xx_udc: fix up the error of undeclared usb_debug_root
Date:   Mon, 14 Sep 2020 14:17:30 +0800
Message-ID: <1600064250-1662-1-git-send-email-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: A5A618360A84B577C1F0FD2679A7857DC670EC5A23B24CE3103BD5D7D8A1B49E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rml4IHVwIHRoZSBidWlsZCBlcnJvciBjYXVzZWQgYnkgdW5kZWNsYXJlZCB1c2JfZGVidWdfcm9v
dA0KDQpDYzogc3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KRml4ZXM6IGE2NmFkYTRm
MjQxYyAoInVzYjogZ2FkZ2V0OiBiY202M3h4X3VkYzogY3JlYXRlIGRlYnVnZnMgZGlyZWN0b3J5
IHVuZGVyIHVzYiByb290IikNClJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGlu
dGVsLmNvbT4NClNpZ25lZC1vZmYtYnk6IENodW5mZW5nIFl1biA8Y2h1bmZlbmcueXVuQG1lZGlh
dGVrLmNvbT4NCi0tLQ0KdjI6IGFkZCBhIGJsYW5rIHNwYWNlIGFmdGVyIGZpeGVzIGNoYW5nZS1p
ZCBzdWdnZXN0ZWQgYnkgR3JlZw0KLS0tDQogZHJpdmVycy91c2IvZ2FkZ2V0L3VkYy9iY202M3h4
X3VkYy5jIHwgMSArDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvdWRjL2JjbTYzeHhfdWRjLmMgYi9kcml2ZXJzL3VzYi9n
YWRnZXQvdWRjL2JjbTYzeHhfdWRjLmMNCmluZGV4IGZlYWVjMDAuLjljZDRhNzAgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQvdWRjL2JjbTYzeHhfdWRjLmMNCisrKyBiL2RyaXZlcnMv
dXNiL2dhZGdldC91ZGMvYmNtNjN4eF91ZGMuYw0KQEAgLTI2LDYgKzI2LDcgQEANCiAjaW5jbHVk
ZSA8bGludXgvc2VxX2ZpbGUuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRl
IDxsaW51eC90aW1lci5oPg0KKyNpbmNsdWRlIDxsaW51eC91c2IuaD4NCiAjaW5jbHVkZSA8bGlu
dXgvdXNiL2NoOS5oPg0KICNpbmNsdWRlIDxsaW51eC91c2IvZ2FkZ2V0Lmg+DQogI2luY2x1ZGUg
PGxpbnV4L3dvcmtxdWV1ZS5oPg0KLS0gDQoxLjkuMQ0K

