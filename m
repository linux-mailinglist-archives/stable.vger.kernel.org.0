Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1CA2D872
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfE2JEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 05:04:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:46168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfE2JEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 05:04:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75ED5AC4F;
        Wed, 29 May 2019 09:04:10 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Cc:     Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH v2 0/3] xen/swiotlb: fix an issue and improve swiotlb-xen
Date:   Wed, 29 May 2019 11:04:04 +0200
Message-Id: <20190529090407.1225-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While hunting an issue in swiotlb-xen I stumbled over a wrong test
and found some areas for improvement.

Juergen Gross (3):
  xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()
  xen/swiotlb: simplify range_straddles_page_boundary()
  xen/swiotlb: remember having called xen_create_contiguous_region()

 drivers/xen/swiotlb-xen.c  | 36 ++++++++++++------------------------
 include/linux/page-flags.h |  3 +++
 2 files changed, 15 insertions(+), 24 deletions(-)

-- 
2.16.4

