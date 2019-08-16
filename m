Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1976A8F971
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 05:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHPDaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 23:30:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46698 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbfHPDaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 23:30:15 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A2D90E5A7ACA03E00971;
        Fri, 16 Aug 2019 11:30:09 +0800 (CST)
Received: from [127.0.0.1] (10.57.101.250) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 16 Aug 2019
 11:29:59 +0800
From:   Wei Xu <xuwei5@hisilicon.com>
Subject: [GIT PULL] Hisilicon fixes for v5.3
To:     <soc@kernel.org>, "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        "Arnd Bergmann" <arnd@arndb.de>
CC:     "xuwei (O)" <xuwei5@huawei.com>, Linuxarm <linuxarm@huawei.com>,
        "John Garry" <john.garry@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Zhangyi ac <zhangyi.ac@huawei.com>,
        "Liguozhu (Kenneth)" <liguozhu@hisilicon.com>,
        <jinying@hisilicon.com>, huangdaode <huangdaode@hisilicon.com>,
        Tangkunshan <tangkunshan@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>, <stable@vger.kernel.org>,
        <sashal@kernel.org>
Message-ID: <5D562335.7000902@hisilicon.com>
Date:   Fri, 16 Aug 2019 11:29:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.101.250]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi ARM-SoC team,

Please consider to pull the following fixes.
Thanks!

Best Regards,
Wei

---

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

   Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

   git://github.com/hisilicon/linux-hisi.git tags/hisi-fixes-for-5.3

for you to fetch changes up to 10e62b47973b0b0ceda076255bcb147b83e20517:

   bus: hisi_lpc: Add .remove method to avoid driver unbind crash 
(2019-08-13 14:54:34 +0800)

----------------------------------------------------------------
Hisilicon fixes for v5.3-rc

- Fixed RCU usage in logical PIO
- Added a function to unregister a logical PIO range in logical PIO
   to support the fixes in the hisi-lpc driver
- Fixed and optimized hisi-lpc driver to avoid potential use-after-free
   and driver unbind crash

----------------------------------------------------------------
John Garry (5):
       lib: logic_pio: Fix RCU usage
       lib: logic_pio: Avoid possible overlap for unregistering regions
       lib: logic_pio: Add logic_pio_unregister_range()
       bus: hisi_lpc: Unregister logical PIO range to avoid potential 
use-after-free
       bus: hisi_lpc: Add .remove method to avoid driver unbind crash

  drivers/bus/hisi_lpc.c    | 47 ++++++++++++++++++++++++++----
  include/linux/logic_pio.h |  1 +
  lib/logic_pio.c           | 73 
+++++++++++++++++++++++++++++++++++------------
  3 files changed, 96 insertions(+), 25 deletions(-)



