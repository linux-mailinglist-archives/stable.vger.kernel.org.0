Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DDD39C40A
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 01:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFDXsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 19:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhFDXsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 19:48:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BDBC613BF;
        Fri,  4 Jun 2021 23:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622850379;
        bh=dVAsj97VPJExVgGrdFq6Ldjte9Nsu5o7m/Jf4r28Pps=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IulqhdVahvfo+xr3LJlYa8YVEWi36ultY/bi7bS2Edbl/pDTB3oM4BeWPc/VSl8hd
         47U4pEY+SLhs8wwGEMdoNyUkzK2Kd6InWHugqRoXsnm5/SzJjhjlgM/bnlfj8mX304
         QPs8kpvwAw4L+eDaytjzlfEEHq7KbIyQlSpXcuAsDFgAeqtbCBJ5EvK/071ggPgkot
         7Y7lCH8W7O5cjGeSFYRbg+EU6QaeP6ub5nwdhrda+MnyzUnCRRLbU/rymHfIt3WrdF
         0zRb6vcAg5S9AD5pjdaFarjKQWTX5bkazMlHqGEb9YousZLTsgyW0m75d4BvRar+Hs
         z8oZQcfV94EXg==
Subject: Re: [PATCH v2 1/2] f2fs: Show casefolding support only when supported
To:     Daniel Rosenberg <drosen@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-2-drosen@google.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <c0df4ead-7bb6-d9e0-db3a-58d4db1fe354@kernel.org>
Date:   Sat, 5 Jun 2021 07:46:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603095038.314949-2-drosen@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/6/3 17:50, Daniel Rosenberg wrote:
> The casefolding feature is only supported when CONFIG_UNICODE is set.
> This modifies the feature list f2fs presents under sysfs accordingly.
> 
> Fixes: 5aba54302a46 ("f2fs: include charset encoding information in the superblock")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Daniel Rosenberg <drosen@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
