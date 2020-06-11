Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157501F6B19
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgFKPfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:35:37 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50874 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgFKPfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 11:35:37 -0400
Received: from localhost.localdomain (p200300cb871f5b00895b3f12fcab1eee.dip0.t-ipconnect.de [IPv6:2003:cb:871f:5b00:895b:3f12:fcab:1eee])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dafna)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 266C22A5079;
        Thu, 11 Jun 2020 16:35:35 +0100 (BST)
From:   Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
To:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc:     dafna.hirschfeld@collabora.com, helen.koike@collabora.com,
        ezequiel@collabora.com, hverkuil@xs4all.nl, kernel@collabora.com,
        dafna3@gmail.com, sakari.ailus@linux.intel.com,
        linux-rockchip@lists.infradead.org, mchehab@kernel.org,
        tfiga@chromium.org, stable@vger.kernel.org
Subject: [PATCH v3 0/4] rkisp1: bugs fixes and vars renames
Date:   Thu, 11 Jun 2020 17:35:23 +0200
Message-Id: <20200611153527.24506-1-dafna.hirschfeld@collabora.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The first two patches in this patchset are two bug fixes related to the enumeration and
settings of the sink format of the resizer entity.
The next 3 patches are renaming/removing of macros and variables.
patch 6 adds documentation to the struct rkisp1_isp_mbus_info

changes from v2:
- patch 3 is new - remove macro RKISP1_DIR_SINK_SRC since the code is more readable without it.
- patch 5 - rename 'direction' to 'isp_pads_mask' instead of 'isp_pads_flags'
- patch 6 is new - add documentation of the struct 'rkisp1_isp_mbus_info'

changes from v1:
- added "Fixes: 56e3b29f9f6b "media: staging: rkisp1: add streaming paths"
to the commit log of the first two patches.
- added two patches. One patch rename the macros "RKISP1_DIR_*"
to "RKISP1_ISP_SD_*", another that rename the field 'direction'
in 'struct rkisp1_isp_mbus_info' to 'isp_pads_flags'

Dafna Hirschfeld (4):
  media: staging: rkisp1: remove macro RKISP1_DIR_SINK_SRC
  media: staging: rkisp1: rename macros 'RKISP1_DIR_*' to
    'RKISP1_ISP_SD_*'
  media: staging: rkisp1: rename the field 'direction' in
    'rkisp1_isp_mbus_info' to 'isp_pads_mask'
  media: staging: rkisp1: common: add documentation for struct
    rkisp1_isp_mbus_info

 drivers/staging/media/rkisp1/rkisp1-common.h  | 20 ++++++--
 drivers/staging/media/rkisp1/rkisp1-isp.c     | 46 +++++++++----------
 drivers/staging/media/rkisp1/rkisp1-resizer.c |  2 +-
 3 files changed, 40 insertions(+), 28 deletions(-)

-- 
2.17.1

