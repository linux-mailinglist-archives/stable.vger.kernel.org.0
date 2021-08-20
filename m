Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439FD3F2698
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 08:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhHTGDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 02:03:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:54982 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhHTGDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 02:03:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="216715438"
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="216715438"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 23:02:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="490213733"
Received: from louislifei-optiplex-7050.sh.intel.com ([10.239.154.151])
  by fmsmga008.fm.intel.com with ESMTP; 19 Aug 2021 23:02:23 -0700
From:   Fei Li <fei1.li@intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        fei1.li@intel.com, yu1.wang@intel.com, shuox.liu@gmail.com
Subject: [PATCH 0/3] Introduce some interfaces for ACRN hypervisor HSM
Date:   Fri, 20 Aug 2021 14:03:03 +0800
Message-Id: <20210820060306.10682-1-fei1.li@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add some new interfaces for ACRN hypervisor HSM driver:
  - MMIO device passthrough
  - virtual device creating/destroying
  - platform information fetching from the hypervisor

Shuo Liu (3):
  virt: acrn: Introduce interfaces for MMIO device passthrough
  virt: acrn: Introduce interfaces for virtual device
    creating/destroying
  virt: acrn: Introduce interface to fetch platform info from the
    hypervisor

 drivers/virt/acrn/hsm.c       | 102 ++++++++++++++++++++++++++++++
 drivers/virt/acrn/hypercall.h |  64 +++++++++++++++++++
 include/uapi/linux/acrn.h     | 114 ++++++++++++++++++++++++++++++++++
 3 files changed, 280 insertions(+)


base-commit: 7c60610d476766e128cc4284bb6349732cbd6606
-- 
2.25.1

