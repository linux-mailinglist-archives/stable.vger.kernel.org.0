Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECCA12D56B
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 02:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfLaBH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 20:07:57 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59174 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727804AbfLaBH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 20:07:56 -0500
X-UUID: dbcaebf665d74cc38c01b5a7a40fb24b-20191231
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=1DALIjMAa3VPAHp/FXzxCF3UEMNVielZSGUhpi/fyng=;
        b=ZEFc5YVkfvPBqZykwQQzGG+GCahQGaCHadcVU9sJzVjusN32npqTX3MgSbLcKHO7lmsx6ri3uXnOSC/qZctadWZB8UzF3+iMmqkOkw1Zc4crBPQW/RJu6DtdqSU1ZGZg5CLWdyeFiz8TniwSEdjhQZNe5mR5590Ue08DLtsFWWE=;
X-UUID: dbcaebf665d74cc38c01b5a7a40fb24b-20191231
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1846196873; Tue, 31 Dec 2019 09:07:51 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 31 Dec 2019 09:07:03 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 31 Dec 2019 09:08:13 +0800
Message-ID: <1577754469.13164.5.camel@mtkswgap22>
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power
 mode during initialization only
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <asutoshd@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <subhashj@codeaurora.org>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <stable@vger.kernel.org>,
        <linux-scsi-owner@vger.kernel.org>
Date:   Tue, 31 Dec 2019 09:07:49 +0800
In-Reply-To: <fd129b859c013852bd80f60a36425757@codeaurora.org>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
         <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
         <fd129b859c013852bd80f60a36425757@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQXN1dG9zaCwNCg0KDQo+IEkgc2VlIHRoYXQgdGhlcmUncyBhIGdldF9zeW5jIGRvbmUgYmVm
b3JlLg0KPiBTbywgaG93IHdvdWxkIHRoZSBzdXNwZW5kIGJlIHRyaWdnZXJlZCBpbiB0aGF0IGNh
c2U/DQo+IA0KDQpXb3VsZCB5b3UgbWVhbiBwbV9ydW50aW1lX2dldF9zeW5jKCkgaW4gdWZzaGNk
X2luaXQoKT8NCklmIHllcywgaXQgd2lsbCBvbmx5IGhhcHBlbiBkdXJpbmcgaW5pdGlhbGl6YXRp
b24uDQoNClRoZSBydW50aW1lIHJlc3VtZSBwYXRoIG1heSBnbyB0aHJvdWdoIHVmc2hjZF9wcm9i
ZV9oYmEoKSB3aXRob3V0DQp1ZnNoY2RfaW5pdCgpIGludm9rZWQgYmVmb3JlLCBmb3IgZXhhbXBs
ZSwNCg0KdWZzaGNkX3Byb2JlX2hiYSsweGUxMC8weDE4NzQNCnVmc2hjZF9ob3N0X3Jlc2V0X2Fu
ZF9yZXN0b3JlKzB4MTE0LzB4MWE0DQp1ZnNoY2RfcmVzdW1lKzB4MWQwLzB4NDgwDQp1ZnNoY2Rf
cnVudGltZV9yZXN1bWUrMHg0MC8weDE4OA0KdWZzaGNkX3BsdGZybV9ydW50aW1lX3Jlc3VtZSsw
eDEwLzB4MTgNCnBtX2dlbmVyaWNfcnVudGltZV9yZXN1bWUrMHgyNC8weDQ0DQpfX3JwbV9jYWxs
YmFjaysweDEwMC8weDI1MA0KcnBtX3Jlc3VtZSsweDU0OC8weDdjOA0KcnBtX3Jlc3VtZSsweDJi
NC8weDdjOA0KcnBtX3Jlc3VtZSsweDJiNC8weDdjOA0KcnBtX3Jlc3VtZSsweDJiNC8weDdjOA0K
cG1fcnVudGltZV93b3JrKzB4OWMvMHhhMA0KcHJvY2Vzc19vbmVfd29yaysweDIxMC8weDRlMA0K
d29ya2VyX3RocmVhZCsweDM5MC8weDUyMA0Ka3RocmVhZCsweDE1NC8weDE4Yw0KcmV0X2Zyb21f
Zm9yaysweDEwLzB4MTgNCg0KVGhpcyBjYXNlIGhhcHBlbnMgaWYgbGluayBpcyBpbiAib2ZmIiBz
dGF0ZSB3aGlsZSByZXN1bWUuDQoNClRoYW5rcywNClN0YW5sZXkNCg==

