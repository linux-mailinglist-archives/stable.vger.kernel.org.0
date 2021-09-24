Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B700417035
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 12:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbhIXKWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 06:22:45 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:58730 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229436AbhIXKWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 06:22:45 -0400
X-UUID: dc7194de7bfb4aaeb6ce86fa3bfe36e3-20210924
X-UUID: dc7194de7bfb4aaeb6ce86fa3bfe36e3-20210924
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 753075355; Fri, 24 Sep 2021 18:21:10 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 24 Sep 2021 18:21:09 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Sep 2021 18:21:09 +0800
Message-ID: <83e782d0f08d4fae48edfd19312a6dd5607bdd11.camel@mediatek.com>
Subject: Re: [PATCH v4 1/1] scsi: ufs: Fix illegal address reading in upiu
 event trace
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Jonathan Hsu <jonathan.hsu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <wsd_upstream@mediatek.com>,
        <stable@vger.kernel.org>
Date:   Fri, 24 Sep 2021 18:21:09 +0800
In-Reply-To: <20210924085848.25500-1-jonathan.hsu@mediatek.com>
References: <20210924085848.25500-1-jonathan.hsu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-09-24 at 16:58 +0800, Jonathan Hsu wrote:
> Fix incorrect index for UTMRD reference in
> ufshcd_add_tm_upiu_trace().
> 
> Fixes: 4b42d557a8ad ("scsi: ufs: core: Fix wrong Task Tag used in
> task management request UPIUs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonathan Hsu <jonathan.hsu@mediatek.com>
> 

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>


