Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7F810CE8D
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 19:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfK1S2V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 28 Nov 2019 13:28:21 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:43385 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1S2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 13:28:20 -0500
Received: from marcel-macbook.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id DE51ECECCE;
        Thu, 28 Nov 2019 19:37:26 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH] Bluetooth: btusb: fix non-atomic allocation in completion
 handler
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191128182427.21873-1-johan@kernel.org>
Date:   Thu, 28 Nov 2019 19:28:18 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        stable <stable@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1083B04A-190D-4573-84A3-0F86AD6B5E6C@holtmann.org>
References: <20191128182427.21873-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

> USB completion handlers are called in atomic context and must
> specifically not allocate memory using GFP_KERNEL.
> 
> Fixes: a1c49c434e15 ("Bluetooth: btusb: Add protocol support for MediaTek MT7668U USB devices")
> Cc: stable <stable@vger.kernel.org>     # 5.3
> Cc: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> drivers/bluetooth/btusb.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

