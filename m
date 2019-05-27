Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4502B3BB
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfE0L6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 07:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfE0L6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 07:58:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB38F20883;
        Mon, 27 May 2019 11:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558958294;
        bh=QjrVjfg5pul9t4blHkgJYGKkvTN++xLuFtJT70jCQU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=boiJ7oOHExcM726HctGTyDOcJIdfcrETpVL2nWuHAmWWS7AaH7S99hkkebrimHPI2
         9qChglJjpTLQQRGtRSQcdCZiNp0qVALogrEOfC+9aXo9jKxGuxe916uR6NC8kISQcf
         NhUJdaa67zISkYSg5wzAO0RXStWURjurtzUwoAvI=
Date:   Mon, 27 May 2019 13:58:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] f2fs: Fix use of number of devices
Message-ID: <20190527115810.GA607@kroah.com>
References: <20190527061717.3202-1-damien.lemoal@wdc.com>
 <20190527061717.3202-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527061717.3202-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 03:17:17PM +0900, Damien Le Moal wrote:
> commit 0916878da355650d7e77104a7ac0fa1784eca852 upstream.
> Backport for 4.19.y stable tree.

Thanks for both of these, now queued up.

greg k-h
