Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC75443DA0
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 08:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhKCHX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 03:23:59 -0400
Received: from verein.lst.de ([213.95.11.211]:58520 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhKCHX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 03:23:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C7DBF68AA6; Wed,  3 Nov 2021 08:21:17 +0100 (CET)
Date:   Wed, 3 Nov 2021 08:21:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH] bcache: fix use-after-free problem in
 bcache_device_free()
Message-ID: <20211103072117.GA31003@lst.de>
References: <20211103064917.67383-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103064917.67383-1-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
