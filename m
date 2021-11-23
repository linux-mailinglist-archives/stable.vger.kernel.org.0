Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5545A259
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhKWMWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:22:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:15358 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhKWMWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 07:22:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="232501958"
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="232501958"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 04:19:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="509007596"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2021 04:19:31 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.10 0/2] scsi: ufs: core: Fix task management completion
Date:   Tue, 23 Nov 2021 14:19:28 +0200
Message-Id: <20211123121930.1464738-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Here are 2 patches backported for v5.10.  Upstream there is a third patch
associated with these i.e. commit 5cb37a26355 ("scsi: ufs: core: Fix
another task management completion race"), but it is not needed because
v5.10 has different lock usage.


Adrian Hunter (2):
      scsi: ufs: core: Fix task management completion
      scsi: ufs: core: Fix task management completion timeout race

 drivers/scsi/ufs/ufshcd.c | 57 +++++++++++++++++++----------------------------
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 24 insertions(+), 34 deletions(-)


Regards
Adrian
