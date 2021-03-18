Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400EB34021A
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 10:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCRJcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 05:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhCRJcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 05:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D300864F38;
        Thu, 18 Mar 2021 09:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616059944;
        bh=vNGR7hzP8F1F+55lYKLLJCozj3S16v54WJfSeeW6bZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WQOSF7Ph/faVBfig5CzmvMRfW8V0VfjvxhHJhhl0zG0xb/xIK6gwV/zoqQRyO3L3K
         qQHVAbAA+Hu0Y3onQ7SuQbDEj26uvAzSnfvfAyR1RvWaJnABtHoGsfV220pnvFQSQr
         dBYTZcwTgMVDPuTFtOlfgufJ+8OLWDjH+2yArrCI=
Date:   Thu, 18 Mar 2021 10:32:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     hulkrobot@huawei.com
Cc:     stable@vger.kernel.org
Subject: Re: [linux-stable-rc CI] Test report for 4.19.181/arm64
Message-ID: <YFMeJb8yrbkd1amZ@kroah.com>
References: <109d76e4-2f3c-4ece-a6ae-a08a070e3e06@DGGEMS404-HUB.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <109d76e4-2f3c-4ece-a6ae-a08a070e3e06@DGGEMS404-HUB.china.huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 05:27:12PM +0800, hulkrobot@huawei.com wrote:
> Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-4.19.y
> Arch: arm64
> Version: 4.19.181
> Commit: ac3af4beac439ebccd17746c9f2fd227e88107aa
> Compiler: gcc version 7.3.0 (GCC)
> --------------------------------------------------------------------
> Failed cases :
> ltp test_robind24
> ltp test_robind25
> ltp test_robind26
> ltp test_robind27
> ltp test_robind28
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4726
> succeed_num: 4721
> failed_num: 5
> timeout_num: 0
> --------------------------------------------------------------------
> Tested-by: Hulk Robot <hulkrobot@huawei.com>

Ok, but what does this mean?

Can you bisect to find the offending commits?

testing without intrepretation is just noise :(

greg k-h
