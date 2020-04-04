Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9522119E330
	for <lists+stable@lfdr.de>; Sat,  4 Apr 2020 09:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgDDHKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Apr 2020 03:10:16 -0400
Received: from verein.lst.de ([213.95.11.211]:55410 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgDDHKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Apr 2020 03:10:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AF16B68C4E; Sat,  4 Apr 2020 09:10:12 +0200 (CEST)
Date:   Sat, 4 Apr 2020 09:10:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] nvme-fc: Revert - add module to ops template to allow
 module references
Message-ID: <20200404071012.GA14574@lst.de>
References: <20200403143320.49522-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403143320.49522-1-jsmart2021@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-5.7.
