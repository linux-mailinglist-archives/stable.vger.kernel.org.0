Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB87447B066
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhLTPhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:37:08 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37442 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231516AbhLTPhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:37:08 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1BKFb5IZ004482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 10:37:06 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 41C4A15C33A4; Mon, 20 Dec 2021 10:37:05 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     stable@vger.kernel.org
Cc:     "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 5.10 0/3] Fix kernel crash caused by ext4/054
Date:   Mon, 20 Dec 2021 10:36:56 -0500
Message-Id: <20211220153659.2120506-1-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commits were cherry-picked from upstream to fix a crash
in ext4/054.  There was a minor fix-up needed in the first patch,
although no other changes were needed for the 2nd and 3rd patches.

Ext4/054 will cause older LTS kernels to crash, but unfortunately
these patches will need further back-porting to apply to 5.4, never
mind older LTS kernels.  But at least here are the fixes for 5.10....

Zhang Yi (3):
  ext4: prevent partial update of the extent blocks
  ext4: check for out-of-order index extents in
    ext4_valid_extent_entries()
  ext4: check for inconsistent extents between index and leaf block

 fs/ext4/extents.c | 93 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 30 deletions(-)

-- 
2.31.0

