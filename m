Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A2F262D1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 13:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfEVLOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 07:14:52 -0400
Received: from mail2.skidata.com ([91.230.2.91]:25544 "EHLO mail2.skidata.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbfEVLOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 07:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=skidata.com; i=@skidata.com; q=dns/txt; s=selector1;
  t=1558523715; x=1590059715;
  h=to:cc:from:subject:message-id:date:mime-version:
   content-transfer-encoding;
  bh=5JFQ6JcTvBjlIsJ5xrGfIRwsGUxvWzfoGLugRZzf7Mw=;
  b=aKwlTuHTsVHV90CO4ovakttqVkTh1TcyGY79gmn//ZGZWCg4I2LqOdto
   4EPRluCR1WZgqMFqhExEgZEMGWOcYwlyIdrzvUQHKWqxN3VlHj7uTghdh
   QHM7qiqKlpNgJhai5VCPC2ZTc2NCJeUoy/GF6GgpOS6O2gn7DqDnuGFTw
   iyTUC98sGlfbxKqacenfqqSpB87GRMqVohkIfnZItGSNRSRn36R5nBsuM
   QfyOV4zbwI569cCcU9RtZWmZpj4vf5Y3DhKkvfqlBY03DlRZXyI6VudNJ
   AMvxN5joQuM6MfVMEWTdO1GVogqatZxQOR+wNts+cvPf5rOCaaDJHWJz4
   A==;
IronPort-SDR: mp+3F0xmdvvBfyfa9kG8gL6d+5NaBy1SmT1BGcCK3VqGh/JveyJ0q43/znSmNa4ba089JglOFy
 u2G6/r8xGk1wWu5wwF4aRweBpAQWGzi8GhwnYcaNnjmTttbvnlOvDwFyX376TmHzFCJ8tyXNu0
 1nQD4j3YvlF5s6rKTsB+8PFDtXyuYL3YZRLb8TqyRl7FuVQmvxyOE7ljbhD7zG8ol2Pske3xoB
 T4TcRegVCmTMDRV76h773DpAwUVosRic328d8RfcmURp/zozgTje4z/b4a2leR9qeiioAl6w9h
 CmA=
X-IronPort-AV: E=Sophos;i="5.60,498,1549926000"; 
   d="scan'208";a="2152039"
To:     <stable@vger.kernel.org>
CC:     "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Richard Leitner - SKIDATA <Richard.Leitner@skidata.com>
From:   Richard Leitner <richard.leitner@skidata.com>
Subject: dmaengine: imx-sdma: Only check ratio on parts that support 1:1
Message-ID: <b96a7d7c-30b1-3153-29ed-1a3ece561b4e@skidata.com>
Date:   Wed, 22 May 2019 13:14:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.111.252]
X-ClientProxiedBy: sdex4srv.skidata.net (192.168.111.82) To
 sdex5srv.skidata.net (192.168.111.83)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply commit 941acd566b18 ("dmaengine: imx-sdma: Only check ratio 
on parts that support 1:1") to the 5.1 stable branch.

Without this patch following error message is issues when writing to 
UART 3 or UART 4 on an i.MX6 solo lite with Linux v5.1.4 (which fails).

	imx-sdma 20ec000.sdma: Timeout waiting for CH0 ready

The problem is fixed when applying this patch on v5.1.4 tag.

regards;Richard.L
