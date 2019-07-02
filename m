Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE9C5DAA2
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfGCBTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:19:25 -0400
Received: from verein.lst.de ([213.95.11.211]:46876 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfGCBTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 21:19:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 11A9568C4E; Wed,  3 Jul 2019 00:50:54 +0200 (CEST)
Date:   Wed, 3 Jul 2019 00:50:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org, hch@lst.de,
        hirofumi@mail.parknet.co.jp
Subject: Re: +
 fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch
 added to -mm tree
Message-ID: <20190702225053.GA24248@lst.de>
References: <20190702224959.sBsBg%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702224959.sBsBg%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I still very fundamentally disagree with this patch.  We did a concerted
effort around the other file systems to move to the device level tweak
and remove the badly misnamed option, so we should not add it now for
fat.
