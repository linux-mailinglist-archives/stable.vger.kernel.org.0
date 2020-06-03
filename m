Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC551ED084
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 15:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgFCNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 09:07:54 -0400
Received: from verein.lst.de ([213.95.11.211]:50731 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgFCNHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 09:07:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DC1ED68BEB; Wed,  3 Jun 2020 15:07:50 +0200 (CEST)
Date:   Wed, 3 Jun 2020 15:07:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de, gregkh@linuxfoundation.org, nirranjan@chelsio.com,
        bharat@chelsio.com, stable <stable@vger.kernel.org>
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200603130750.GA13511@lst.de>
References: <20200603091851.16957-1-dakshaja@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603091851.16957-1-dakshaja@chelsio.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 02:48:51PM +0530, Dakshaja Uppalapati wrote:
> This reverts upstream 'commit 530436c45ef2
> ("nvme: Discard workaround for non-conformant devices")'
> 
> Since commit `530436c45ef2` introduced a regression due to which
> blk_update_request IO error is observed on formatting device, reverting it.

Err, why?  Please send an actual bug report with details of your
setup.
