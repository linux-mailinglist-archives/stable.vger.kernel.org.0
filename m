Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9B439C40D
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 01:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhFDXsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 19:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhFDXsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 19:48:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FAB2611AD;
        Fri,  4 Jun 2021 23:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622850403;
        bh=zSqYRKt3AKTNAslcAW+pxGjDfLkejzE4sjKMLJf4zJI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=T05xuJSXooNKkWiZrrXr7ff1s5nmbdsNi6cqlsOvbNAn1zFJF5H//P/6yTglmMP53
         YS/T6IB3hWllmEFP0VJibkI7l8W7fJDd9N3nUtJec7jGxOGGMURbKR+5mxE79AhOsD
         kbNQ3m+6LZWzIS0KS0Bfb/duGsL70Y0RR078RZMviiNpTQNB5BjMDjs0VDA6bjfPtP
         8C3cbEeM4UNOyOHqc7SIXAl84pqPJlRLA46JPU+zZpyDSJyvAArokm2r9vi+UamxSH
         twAODzReuwlLXhe+Kkvd/TGQmit1UJIXfgF4YGp2PpZ3ybvpOYBImhZODTvqYbuLX4
         jKAaKWlksRU5w==
Subject: Re: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
To:     Daniel Rosenberg <drosen@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-3-drosen@google.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <b05632b2-6d60-02c4-7610-51e3c10379f5@kernel.org>
Date:   Sat, 5 Jun 2021 07:46:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603095038.314949-3-drosen@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/6/3 17:50, Daniel Rosenberg wrote:
> Older kernels don't support encryption with casefolding. This adds
> the sysfs entry encrypted_casefold to show support for those combined
> features. Support for this feature was originally added by
> commit 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> 
> Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> Cc: stable@vger.kernel.org # v5.11+
> Signed-off-by: Daniel Rosenberg <drosen@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
