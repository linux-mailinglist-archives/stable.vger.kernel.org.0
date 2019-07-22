Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AAD7043A
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 17:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfGVPoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 11:44:03 -0400
Received: from 8bytes.org ([81.169.241.247]:44834 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbfGVPoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 11:44:03 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 29EA11F2; Mon, 22 Jul 2019 17:44:02 +0200 (CEST)
Date:   Mon, 22 Jul 2019 17:44:00 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/vt-d: Don't queue_iova() if there is no flush
 queue
Message-ID: <20190722154400.GF12009@8bytes.org>
References: <20190716213806.20456-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716213806.20456-1-dima@arista.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 10:38:05PM +0100, Dmitry Safonov wrote:
>  BUG: spinlock bad magic on CPU#6, swapper/0/1

Applied both patches to iommu/fixes.
