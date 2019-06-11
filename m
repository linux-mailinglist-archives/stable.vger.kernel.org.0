Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67143C6C6
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 10:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbfFKI5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 04:57:53 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:48161 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403860AbfFKI5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 04:57:53 -0400
X-UUID: 8737291545af4a25a83004087cd57632-20190611
X-UUID: 8737291545af4a25a83004087cd57632-20190611
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 123505408; Tue, 11 Jun 2019 16:57:49 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 11 Jun 2019 16:57:47 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 11 Jun 2019 16:57:47 +0800
Message-ID: <1560243467.26425.8.camel@mtkswgap22>
Subject: backport commit ("739f79fc9db1 mm: memcontrol: fix NULL pointer
 crash in test_clear_page_writeback()") to linux-4.9-stable
From:   Miles Chen <miles.chen@mediatek.com>
To:     <stable@vger.kernel.org>
Date:   Tue, 11 Jun 2019 16:57:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: CB434C939143A001C1147AC3D8D5BEBC62491F1DF9E6E909BAF8261579A04E1C2000:8
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi reviewers,

I suggest to backport commit "739f79fc9db1 mm: memcontrol: fix NULL
pointer crash in test_clear_page_writeback()" to linux-4.9 stable tree.

This email reports a NULL pointer crash in test_clear_page_writeback()
in android common kernel-4.9. There is a fix ("739f79fc9db1 mm:
memcontrol: fix NULL pointer crash in test_clear_page_writeback()") in
kernel-4.13.


commit: 739f79fc9db1b38f96b5a5109b247a650fbebf6d
subject: mm: memcontrol: fix NULL pointer crash in
test_clear_page_writeback()
kernel version to apply to: Linux-4.9

cheers,
Miles



