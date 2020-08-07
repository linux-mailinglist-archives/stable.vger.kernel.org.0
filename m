Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1123F405
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgHGUz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:55:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:62789 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGUz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 16:55:26 -0400
IronPort-SDR: Gq6rGAGUsu5Arzw1n5q9EmC9F8QHy1/HtBIDYdShtJPj2zKW8Qy/Jg8/LPlirmTp6kvn5W92Qm
 +y1Nb4B4I9Dg==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="133260785"
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="133260785"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
IronPort-SDR: zZ0Ec+8tzcQogXgyu9epNBR/EvA9YiK4FhN2PKW13DD+o875Wvmwy3wAiowUyCIftSa874R86Q
 HbWrtarXLVPw==
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="325878060"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:25 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        aleksandr.loktionov@intel.com
Subject: [PATCH stable 0/4] i40e fixes for stable
Date:   Fri,  7 Aug 2020 13:55:13 -0700
Message-Id: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These stable fixes were not correctly noted as fixes when
originally submitted for 5.2-rc1. We are addressing the internal
gap that led to this miss.

Please consider these patches for all stable kernels older than
5.2.0, I tried on 4.19 and 3 out of 4 apply cleanly with a cherry
pick from Linus' tree, but one of them I had to rebase, so I'm
just sending the whole series.

If you'd rather I send one at a time in the format specified at
option 2) of the stable documentation, please just let me know.

Patch 4 depends on patch 1.

I tried to follow the stable commit format for each of the
individual patches, referencing the upstream commit ID. I also
added a "Fixes" to each, trying to assist the automation in
knowing how far back to backport.

Shortlog:

Grzegorz Siwik (1):
  i40e: Wrong truncation from u16 to u8

Martyna Szapar (2):
  i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
  i40e: Memory leak in i40e_config_iwarp_qvlist

Sergey Nemov (1):
  i40e: add num_vectors checker in iwarp handler

 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 51 +++++++++++++------
 1 file changed, 36 insertions(+), 15 deletions(-)

-- 
2.25.4
