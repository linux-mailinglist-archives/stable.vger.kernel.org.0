Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF103C9D92
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241810AbhGOLQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 07:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241139AbhGOLQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 07:16:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E952613BC;
        Thu, 15 Jul 2021 11:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626347603;
        bh=zagrihgDRoo1hqbAygIIr5cILA2U3B6BwooCsj6HERQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f1KCnQ0FGxjfmySEoIc/SBe0KCrQsG4vvw/62X4RJ2ml+AGV+gee9obCRTGmNcM4k
         WrUZJ7pQ3Ouz6UcbVW2md/ZsNuN9/r8yCraL8b52RI0mH+MM06RS+cIBcXSPLMs10E
         BqPyGsugq4pf7YSa1tByBEVO0T38sI+OhToFTxQM=
Date:   Thu, 15 Jul 2021 13:12:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [Backport for 5.10.y PATCH 0/7] Patches for 5.10.y
Message-ID: <YPAYCN+cQfgsGbYw@kroah.com>
References: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 05:18:30PM +0800, Hanjun Guo wrote:
> Hi Greg, Sasha,
> 
> Patches below are some collections of bugfixes, those fixes are
> found when we are using the stable 5.10 kernel, please consider
> to apply them, I also Cced the author and maintainer for each
> patch to see if any objections.
> 

All look good, thanks for these, now queued up.

greg k-h
