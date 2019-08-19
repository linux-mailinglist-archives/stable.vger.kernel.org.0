Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F01792731
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 16:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfHSOk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 10:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfHSOk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 10:40:56 -0400
Received: from [192.168.0.101] (unknown [180.111.132.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F3D3206C1;
        Mon, 19 Aug 2019 14:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566225655;
        bh=r3rHMKzGti8fbcfNxPYG44dYD1wPeB1bVCktItPFRgI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GWF3MfOgguDhxBe/OCmy1z9a1tpwa32uzDILjN1amLzQvxYZbjsQxjQ7ofmJu5H2z
         LyM3MRixhD6J100J+sFs8x1NPbdyY5eyEg3nyUON3CaY2Eq5c41E0pa/HmAy9ipg9X
         6JXsjZeXOTYGETNZFKa81ZrC7fD+SzG9Uizm8XWc=
Subject: Re: [PATCH 3/6] staging: erofs: add two missing erofs_workgroup_put
 for corrupted images
To:     Gao Xiang <gaoxiang25@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
        Miao Xie <miaoxie@huawei.com>, weidu.du@huawei.com,
        Fang Wei <fangwei1@huawei.com>, stable@vger.kernel.org
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-4-gaoxiang25@huawei.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <0d2a443b-3d06-014f-aa0b-7ca261a2437f@kernel.org>
Date:   Mon, 19 Aug 2019 22:40:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190819103426.87579-4-gaoxiang25@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, these error handling
> path will be entered to handle corrupted images.
> 
> Lack of erofs_workgroup_puts will cause unmounting
> unsuccessfully.
> 
> Fix these return values to EFSCORRUPTED as well.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
