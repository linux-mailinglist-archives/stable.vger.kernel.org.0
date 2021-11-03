Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69164446E5
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhKCRVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:21:30 -0400
Received: from verein.lst.de ([213.95.11.211]:60441 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhKCRV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 13:21:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 175D568AA6; Wed,  3 Nov 2021 18:18:49 +0100 (CET)
Date:   Wed, 3 Nov 2021 18:18:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 2/2] scsi: core: remove command size deduction from
 scsi_setup_scsi_cmnd
Message-ID: <20211103171848.GA5250@lst.de>
References: <20211103170659.22151-1-tadeusz.struk@linaro.org> <20211103170659.22151-2-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103170659.22151-2-tadeusz.struk@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

