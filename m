Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B34FB364A
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 10:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfIPIR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 04:17:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:43584 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbfIPIR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 04:17:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59C25AFA9;
        Mon, 16 Sep 2019 08:17:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH for-4.14 0/2] btrfs compression type validation fix
Date:   Mon, 16 Sep 2019 10:17:24 +0200
Message-Id: <20190916081726.7983-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Here's the backport of aa53e3bfac72 ("btrfs: correctly validate compression
type") for v4.14 with it's prerequisite e128f9c3f724 ("btrfs: compression:
add helper for type to string conversion").

David Sterba (1):
  btrfs: compression: add helper for type to string conversion

Johannes Thumshirn (1):
  btrfs: correctly validate compression type

 fs/btrfs/compression.c | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/compression.h |  3 +++
 fs/btrfs/props.c       |  6 +-----
 3 files changed, 35 insertions(+), 5 deletions(-)

-- 
2.16.4

