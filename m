Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEB8DCBD1
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 18:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437357AbfJRQrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 12:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbfJRQrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 12:47:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3938820854;
        Fri, 18 Oct 2019 16:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571417259;
        bh=8xD3wdafhWgjlDEI6INTsrIxjs65mBOXDJteXMKxprE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yzmPsOSYrF4NBHalNi6v3Xc7zTqPMY/bfCoNq8rXY9nOt19YN9+k8CrxHRFbR4Rad
         /QlzN6tYe/nRQEVZ+cmG840m2n6uErhkckovgPpy29psCrjVNgJCYb+dfG17y8KzRi
         7PowcOfxstD7xstFMbULVTngtsDL9rXY6EN4BYVc=
Date:   Fri, 18 Oct 2019 12:47:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Tuowen Zhao <ztuowen@gmail.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 2/4] lib: devres: add a helper function for ioremap_uc
Message-ID: <20191018164738.GY31224@sasha-vm>
References: <20191016210629.1005086-3-ztuowen@gmail.com>
 <20191017143144.9985421848@mail.kernel.org>
 <b113dd8da86934acc90859dc592e0234fa88cfdc.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b113dd8da86934acc90859dc592e0234fa88cfdc.camel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 11:49:50AM -0600, Tuowen Zhao wrote:
>Sorry, patches in this set should have tag # v4.19+
>
>Should I resubmit a set with the correct tags?

Nah, this note should be good enough, thanks.

-- 
Thanks,
Sasha
