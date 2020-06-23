Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1CD204FFB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732233AbgFWLGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:06:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:58894 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732227AbgFWLGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:06:02 -0400
X-UUID: 1746d2d9aaf84717a1868fe194cb0ea4-20200623
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=CcaM225zZP7WnZ1PC960F675Ck0YgebshhPK0DXhRCI=;
        b=WbyJeYa1YmwygxexZSRYMyPs+OMDQevvaC4W3kSL4FPHWPL7grOxDWN6fl7h0S2so88lZd9WHzAJLLq3fJQgV6Y6I4dbQW1w3rdfAecDj0pKbHfKiBlRDbTKa0iYVGGggX04cR05a73V+Luxu65JHBkh2+ZVB2B2EvxvPlT8Mis=;
X-UUID: 1746d2d9aaf84717a1868fe194cb0ea4-20200623
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1849796380; Tue, 23 Jun 2020 19:05:59 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 23 Jun 2020 19:03:25 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 19:03:19 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Tsoy <alexander@tsoy.me>,
        Jussi Laako <jussi@sonarnerd.net>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Dmitry Panchenko <dmitry@d-systems.ee>,
        Chris Wulff <crwulff@gmail.com>,
        Jesus Ramos <jesus-ramos@live.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        <linux-usb@vger.kernel.org>,
        Chihhao Chen <chihhao.chen@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] sound: usb: quirks: add quirk for Samsung USBC Headset (AKG)
Date:   Tue, 23 Jun 2020 19:03:23 +0800
Message-ID: <1592910203-24035-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 0C8C2E45E79FA20259A2A0BA8BD54FE967742A430CC67CFC5A05F99C5875173C2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

V2UndmUgZm91bmQgU2Ftc3VuZyBVU0JDIEhlYWRzZXQgKEFLRykgKFZJRDogMHgwNGU4LCBQSUQ6
IDB4YTA1MSkNCm5lZWQgYSB0aW55IGRlbGF5IGFmdGVyIGVhY2ggY2xhc3MgY29tcGxpYW50IHJl
cXVlc3QuDQpPdGhlcndpc2UgdGhlIGRldmljZSBtaWdodCBub3QgYmUgYWJsZSB0byBiZSByZWNv
Z25pemVkIGVhY2ggdGltZXMuDQoNClNpZ25lZC1vZmYtYnk6IENoaWhoYW8gQ2hlbiA8Y2hpaGhh
by5jaGVuQG1lZGlhdGVrLmNvbT4NClNpZ25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVs
LmxpbkBtZWRpYXRlay5jb20+DQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KLS0tDQogc291
bmQvdXNiL3F1aXJrcy5jIHwgICAgOCArKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2Vy
dGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL3NvdW5kL3VzYi9xdWlya3MuYyBiL3NvdW5kL3VzYi9x
dWlya3MuYw0KaW5kZXggYmNhMDE3OS4uZWJiYTI5YSAxMDA2NDQNCi0tLSBhL3NvdW5kL3VzYi9x
dWlya3MuYw0KKysrIGIvc291bmQvdXNiL3F1aXJrcy5jDQpAQCAtMTY3Myw2ICsxNjczLDE0IEBA
IHZvaWQgc25kX3VzYl9jdGxfbXNnX3F1aXJrKHN0cnVjdCB1c2JfZGV2aWNlICpkZXYsIHVuc2ln
bmVkIGludCBwaXBlLA0KIAkgICAgIGNoaXAtPnVzYl9pZCA9PSBVU0JfSUQoMHgwOTUxLCAweDE2
YWQpKSAmJg0KIAkgICAgKHJlcXVlc3R0eXBlICYgVVNCX1RZUEVfTUFTSykgPT0gVVNCX1RZUEVf
Q0xBU1MpDQogCQl1c2xlZXBfcmFuZ2UoMTAwMCwgMjAwMCk7DQorDQorCS8qDQorCSAqIFNhbXN1
bmcgVVNCQyBIZWFkc2V0IChBS0cpIG5lZWQgYSB0aW55IGRlbGF5IGFmdGVyIGVhY2gNCisJICog
Y2xhc3MgY29tcGxpYW50IHJlcXVlc3QuIChNb2RlbCBudW1iZXI6IEFBTTYyNVIgb3IgQUFNNjI3
UikNCisJICovDQorCWlmIChjaGlwLT51c2JfaWQgPT0gVVNCX0lEKDB4MDRlOCwgMHhhMDUxKSAm
Jg0KKwkgICAgKHJlcXVlc3R0eXBlICYgVVNCX1RZUEVfTUFTSykgPT0gVVNCX1RZUEVfQ0xBU1Mp
DQorCQl1c2xlZXBfcmFuZ2UoNTAwMCwgNjAwMCk7DQogfQ0KIA0KIC8qDQotLSANCjEuNy45LjUN
Cg==

