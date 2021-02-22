Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC74321139
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 08:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBVHNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 02:13:13 -0500
Received: from verein.lst.de ([213.95.11.211]:57319 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhBVHNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 02:13:13 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4934A68D0A; Mon, 22 Feb 2021 08:12:30 +0100 (CET)
Date:   Mon, 22 Feb 2021 08:12:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, chriscjsus@yahoo.com,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi/sd: Fix Opal support
Message-ID: <20210222071230.GA20510@lst.de>
References: <20210222021042.3534-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222021042.3534-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
