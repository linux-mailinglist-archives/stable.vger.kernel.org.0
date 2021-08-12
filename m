Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E163EA42F
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 13:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHLL67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 07:58:59 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:39494 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S237053AbhHLL66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 07:58:58 -0400
X-UUID: 6e88e811bc1b4aa9b524485d52498068-20210812
X-UUID: 6e88e811bc1b4aa9b524485d52498068-20210812
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <lecopzer.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1064340420; Thu, 12 Aug 2021 19:58:29 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 12 Aug 2021 19:58:28 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Aug
 2021 19:58:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 12 Aug 2021 19:58:22 +0800
From:   Lecopzer Chen <lecopzer.chen@mediatek.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <yj.chiang@mediatek.com>
Subject: Request patch to -stable 4.4+ "media: v4l2-mem2mem: always consider OUTPUT queue during poll"
Date:   Thu, 12 Aug 2021 19:58:22 +0800
Message-ID: <20210812115822.5411-1-lecopzer.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

Reason:

We found without this, Poll() infinitely wait because OUTPUT queue
will never signaled after last CAPTURE queue is de-queued.
And some buffer can't be popped as expected.


commit id: 566463afdbc43c7744c5a1b89250fc808df03833
subject: "media: v4l2-mem2mem: always consider OUTPUT queue during poll"

This should be applied to 4.4+ without conflict after 
(f1a81afc98e315f4bf600d28f8a19a5655f7cfe0 "[media] m2m: fix bad unlock balance")


Thanks,
Lecopzer
