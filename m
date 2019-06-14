Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E11045436
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 07:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfFNFqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 01:46:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:44216 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbfFNFqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 01:46:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00942ADFA;
        Fri, 14 Jun 2019 05:46:07 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v3 0/3] xen/swiotlb: fix an issue and improve swiotlb-xen
Date:   Fri, 14 Jun 2019 07:46:01 +0200
Message-Id: <20190614054604.30101-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
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

 drivers/xen/swiotlb-xen.c  | 34 ++++++++++------------------------
 include/linux/page-flags.h |  4 ++++
 2 files changed, 14 insertions(+), 24 deletions(-)

-- 
2.16.4

