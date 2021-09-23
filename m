Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE617416004
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 15:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241376AbhIWNgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 09:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232295AbhIWNgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 09:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB2761164;
        Thu, 23 Sep 2021 13:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632404081;
        bh=LqLYzE3HwM72W3M0qWRK4FmjKgjMOvzgm/+ibZFzY0M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Irw1kK6rPdCI9lE15ZkdAlF4md7Hovl3fABqEG9n0dgVhh3L3MH5O+srgtpw+jgkH
         Bg6AcWdBMrBzcQ21M1paqUcHpl1WoPdp/x8yUSv3q3swPS4TQCXGdJHTC9RL9Pk6uF
         owihBAnugJ3mkYk+oLlSVfhXnfghE3QVg/n6Ze+R4pBagWRE9aweluInkferJu44uQ
         WqzCpZ55gHywmeGsNR4g8rcRk6jAZ0rK8TjR0PvMqYwVvnEA4+U6KI5+w4CY4/1LMR
         mVm+zWFKJbRM/XvW6a7lqf3bUzvNGrcEH+mkxhn42WYWuFOrxXLtdXfaZBb3BUzVX5
         hgC4FlpY64s/g==
Subject: Re: [PATCH 1/2] erofs: fix up erofs_lookup tracepoint
To:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        linux-erofs@lists.ozlabs.org
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <20210921143531.81356-1-hsiangkao@linux.alibaba.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <4823f65a-5282-0496-44ab-0d471a5b2b27@kernel.org>
Date:   Thu, 23 Sep 2021 21:34:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210921143531.81356-1-hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/9/21 22:35, Gao Xiang wrote:
> Fix up a misuse that the filename pointer isn't always valid in
> the ring buffer, and we should copy the content instead.
> 
> Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
> Cc: stable@vger.kernel.org # 4.19+
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
