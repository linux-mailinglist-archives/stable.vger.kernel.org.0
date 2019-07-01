Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17C5B6BE
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 10:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfGAIZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 04:25:38 -0400
Received: from verein.lst.de ([213.95.11.211]:59473 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfGAIZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 04:25:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F3D9D68C4E; Mon,  1 Jul 2019 10:25:36 +0200 (CEST)
Date:   Mon, 1 Jul 2019 10:25:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH V2] block: fix .bi_size overflow
Message-ID: <20190701082536.GA22539@lst.de>
References: <20190701071446.22028-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701071446.22028-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
