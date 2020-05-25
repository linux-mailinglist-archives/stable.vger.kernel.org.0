Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C0A1E072B
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 08:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388827AbgEYGlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 02:41:42 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:60899 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726393AbgEYGlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 02:41:42 -0400
X-UUID: 3141a7b4d1dc49c0874af76805d7c1e3-20200525
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=rPpVOTNMfIfxzbe8ETe1dm7/wf5N3sl6Al3g3yCdGBA=;
        b=GLSosxCzgrZVU3EH3VE+cnZIpkCtJkNDv9/mYyryejePguRwrJwSZ+C5ImAAI2B93qX/O+JSL3Hsv1aXGMnmaiwV5sCc/faxC4mxlzFQlQxf6fVAIwOyFZZK8/Sk9BkT/AzAHeSYo01Mq0upww0AhzJAgdnY0OyFrdnT7emH45w=;
X-UUID: 3141a7b4d1dc49c0874af76805d7c1e3-20200525
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <weiyi.lu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1933868565; Mon, 25 May 2020 14:41:39 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 25 May 2020 14:41:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 25 May 2020 14:41:36 +0800
From:   Weiyi Lu <weiyi.lu@mediatek.com>
To:     Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>
CC:     James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-clk@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <stable@vger.kernel.org>,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Owen Chen <owen.chen@mediatek.com>
Subject: [PATCH v1] clk: mediatek: assign the initial value to clk_init_data of mtk_mux
Date:   Mon, 25 May 2020 14:41:29 +0800
Message-ID: <1590388889-28382-1-git-send-email-weiyi.lu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SXQnZCBiZSBkYW5nZXJvdXMgd2hlbiBzdHJ1Y3QgY2xrX2NvcmUgaGF2ZSBuZXcgbWVtZWJlcnMu
DQpBZGQgdGhlIG1pc3NpbmcgaW5pdGlhbCB2YWx1ZSB0byBjbGtfaW5pdF9kYXRhLg0KDQpGaXhl
czogYTNhZTU0OTkxN2YxICgiY2xrOiBtZWRpYXRlazogQWRkIG5ldyBjbGttdXggcmVnaXN0ZXIg
QVBJIikNCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NClNpZ25lZC1vZmYtYnk6IFdlaXlp
IEx1IDx3ZWl5aS5sdUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL2Nsay9tZWRpYXRlay9j
bGstbXV4LmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXV4LmMgYi9k
cml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXV4LmMNCmluZGV4IDc2ZjljZDAuLjE0ZTEyN2UgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXV4LmMNCisrKyBiL2RyaXZlcnMv
Y2xrL21lZGlhdGVrL2Nsay1tdXguYw0KQEAgLTE2MCw3ICsxNjAsNyBAQCBzdHJ1Y3QgY2xrICpt
dGtfY2xrX3JlZ2lzdGVyX211eChjb25zdCBzdHJ1Y3QgbXRrX211eCAqbXV4LA0KIAkJCQkgc3Bp
bmxvY2tfdCAqbG9jaykNCiB7DQogCXN0cnVjdCBtdGtfY2xrX211eCAqY2xrX211eDsNCi0Jc3Ry
dWN0IGNsa19pbml0X2RhdGEgaW5pdDsNCisJc3RydWN0IGNsa19pbml0X2RhdGEgaW5pdCA9IHt9
Ow0KIAlzdHJ1Y3QgY2xrICpjbGs7DQogDQogCWNsa19tdXggPSBremFsbG9jKHNpemVvZigqY2xr
X211eCksIEdGUF9LRVJORUwpOw0KLS0gDQoxLjguMS4xLmRpcnR5DQo=

