Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04CA2A6344
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbgKDL1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:27:51 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:58996 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgKDL1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 06:27:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604489270; x=1636025270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fDDF0p52VZ+bUECmVnAo/niCpxwKmufCt0gCwQnVZjA=;
  b=WhTTc9EK+Fsz9gTVy7d8lSQU+e/bczgKvqZuuEwbflbUREWM9KMtf7Jq
   n1v+Hy1xINDE2LDUyCj4COqVW8C4x9sVJU+zkqv8U5CCScWRd52zu0rtt
   Z7hD12E02Kbxqc89sdQdrK5S6UZ7djdleL8eMxvgFDuMrLNfXPhBCOWeF
   kINdmHl+nKLUH+kwO/hLJPDLPez6pyrl8Q0sVEpMYYqdQZLl+bN08E4CV
   c2sBMC7eD9EmdOOBrKCRitu83DAEmi1YcXhHlWVKLfODlUtOlFJ2o/YhL
   trgXHOv+OCyH5/2MFVPoUcv0yxLCadVc1KkJ5plubfeJv23/k0P4j9+ys
   w==;
IronPort-SDR: ar+nZ549fU0TmvqVqMoJsdeRDf1LYZZozNW04Q3/yteB11jMOQcyS1kWWcmXRJcUTrK1CZfOvz
 TtKa7Hd7Sp8NL4KYvPg5CIRWyvoaZS0eVwraUUfViQ1yGn7Z6ep+cbv+CMphDkQrPuaS+YG4F7
 a4J5FzCDU0w8jbfI3YY9wLeS6zrpNDjYOrACwQSO1zo21feXkSetSUF4np848F/8AuS0KtaM1V
 cAl+UbgGDcMn7HXSyqtIoyTwrfuZv4MtFkNrFMz6Bp+AaOInEWuj5ipGfVvx22p4uCDoreOAcL
 I3Q=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="151681621"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 19:27:49 +0800
IronPort-SDR: TitWE1GohEMEf5KuL7WjiCpdEO2BYg9NGtxaeGqcgqVNJ7Ao1CLxuu6yXbFoByIGfE+vrs8NaK
 QhA5VvnZLyVpT0XOw4P/4fYDcc6gf2eDmq+dJwTWdDaaT8ihhu6Ku+iADfrgOMrbzssiavGtJI
 B9FmMjUPKOR50yJiF1L8f7iPXTEgrrOpImb8tsjWkD3mdQYob81jMU5EpE2UBRoEEVSiMtKnFp
 BCTxmZwmWxIgKe/WiNcnkESlXd0EEjOQc/bopTl5g+S3Gv54rYPERe2aF9aWxGts5GfCcPfmZt
 tAI/kuM1o4pFVw0opVLKwQBs
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 03:13:58 -0800
IronPort-SDR: Bjnktp3ke9q/2a9dbXBVdWErNQEwSoubgXtVTPUxJBMe19qTxl1wmzaGUoEY4RwNzHm3zdzj/n
 UPOQJJmSXh7/E2yU8UpUJI47BynwB0d1/eOP87wj3/KxZp6ULDfFEdtzuF8cYpXu7HspZDSboo
 l8QkG8R/CCiimA+vv1lBtJVUy8rCSftFGjyBNmt1+ywThMW2Gx9pnfobWnzJEcD9LajXdK2UxY
 fh532IErwu5F4plYKRiSrcU+k52YI09FDEc7+egvWKzmZObKNQiwesz+UgfGtfNdMYvRUy2Y9z
 Y/Y=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Nov 2020 03:27:49 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 0/3] null_blk fixes for 5.9 stable
Date:   Wed,  4 Nov 2020 20:27:44 +0900
Message-Id: <20201104112747.182740-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104095141.GA1673068@kroah.com>
References: <20201104095141.GA1673068@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

Here are three backported patches from this cycle for 5.9 stable. The
upstream patches are:
1) 35bc10b2eafbb701064b94f283b77c54d3304842
2) f9c9104288da543cd64f186f9e2fba389f415630
3) aa1c09cb65e2ed17cb8e652bc7ec84e0af1229eb

Thanks.

Damien Le Moal (2):
  null_blk: Fix zone reset all tracing
  null_blk: Fix locking in zoned mode

Kanchan Joshi (1):
  null_blk: synchronization fix for zoned device

 drivers/block/null_blk.h       |   1 +
 drivers/block/null_blk_zoned.c | 157 ++++++++++++++++++++++++---------
 2 files changed, 118 insertions(+), 40 deletions(-)

-- 
2.26.2

