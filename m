Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F5A31F6E4
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 10:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBSJ5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 04:57:41 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:61828 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhBSJ4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 04:56:09 -0500
Received: from localhost (pvp1.blr.asicdesigners.com [10.193.80.26])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 11J9tCA0001750;
        Fri, 19 Feb 2021 01:55:13 -0800
Date:   Fri, 19 Feb 2021 15:25:12 +0530
From:   Krishnamraju Eraparaju <krishna2@chelsio.com>
To:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>, bharat@chelsio.com,
        krishna2@chelsio.com
Subject: backport of dma_virt_ops related fixes to 5.10.y kernels
Message-ID: <20210219095510.GA24256@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

Below commits needs to be backported to 5.10.y kernels to avoid NULL
pointer deref panic(while trying to access 'numa_node' from NULL
'dma_device'), @ Line:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/nvme/host/rdma.c?h=v5.10.17#n863)

commit:22dd4c707673129ed17e803b4bf68a567b2731db 
commit:8ecfca68dc4cbee1272a0161e3f2fb9387dc6930

The panic is observed at nvme host(provider/transport being SoftiWARP),
while perfroming "nvme discover".

Hence, please backport the below patch series to '5.10.y' kernel.
 "https://lore.kernel.org/linux-iommu/20201106181941.1878556-1-hch@lst.de/"

Thanks,
Krishnamraju.
