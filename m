Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D0578D0B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 15:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfG2NnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 09:43:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:48791 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfG2NnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 09:43:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:43:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="370495825"
Received: from saranya-h97m-d3h.iind.intel.com ([10.66.254.8])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jul 2019 06:43:07 -0700
From:   Saranya Gopal <saranya.gopal@intel.com>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, fei.yang@intel.com,
        john.stultz@linaro.org, Saranya Gopal <saranya.gopal@intel.com>
Subject: [PATCH 4.19.y 0/3] usb: dwc3: Prevent requests from being queued twice
Date:   Mon, 29 Jul 2019 19:13:36 +0530
Message-Id: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With recent changes in AOSP, adb is now using asynchronous I/O.
While adb works good for the most part, there have been issues with
adb root/unroot commands which cause adb hang. The issue is caused
by a request being queued twice. A series of 3 patches from
Felipe Balbi in upstream tree fixes this issue.

Felipe Balbi (3):
  usb: dwc3: gadget: add dwc3_request status tracking
  usb: dwc3: gadget: prevent dwc3_request from being queued twice
  usb: dwc3: gadget: remove req->started flag

 drivers/usb/dwc3/core.h   | 11 +++++++++--
 drivers/usb/dwc3/gadget.c |  9 ++++++++-
 drivers/usb/dwc3/gadget.h |  4 ++--
 3 files changed, 19 insertions(+), 5 deletions(-)

-- 
1.9.1

