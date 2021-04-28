Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C5C36DCD3
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 18:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbhD1QTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 12:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240653AbhD1QTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 12:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1729613DC;
        Wed, 28 Apr 2021 16:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619626700;
        bh=Tq1wZ69jMu/ePLqeuzoDnviyq3W92Tl+i7ykbKFxY2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iwp9unrOYK8cXOJvewY4puG6wTnil57d+0L0OWvF/myEauJaUQt74CrJEC5/MRC8n
         UWPTgxR32N7a4fCKHanjvN4PefESo4+IYvnLgZqSp+yzfcAWs0lQ61avzlx3o4tEVF
         jpD9c1uxwbSxn3Wl3/go1UDMNwhU5hq2sU+oYeTu2aqNK8h2k5uILn2jGgp5QkStgr
         AD36j54asvEtIB4AVO0BAYlqX8vGG7GZxi7SCS07pXnrLGSG2k+MC3cMxnwyeK42b+
         3luWHBSlfaugL9IeOoUhxLu/oSurTqErG6fuAdBPZ/mYeeTuL143vmXZ+2Y5DcsXIV
         GgLzTD4erW7DA==
Date:   Wed, 28 Apr 2021 12:18:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        marcorr@google.com
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
Message-ID: <YImKy+EW2EzMR7x0@sashalap>
References: <20210405210230.1707074-1-jxgao@google.com>
 <YG2q6Tm58tWRBtmK@kroah.com>
 <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
 <YILkSsR4ejv5CraF@kroah.com>
 <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
 <YIQupJuzbdgif6WA@kroah.com>
 <CAMGD6P3SY=BeXjKAajCiHXXRXzLMnDiPo8weagJVurY_Ew0T2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMGD6P3SY=BeXjKAajCiHXXRXzLMnDiPo8weagJVurY_Ew0T2w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 11:00:56AM -0700, Jianxiong Gao wrote:
>On Sat, Apr 24, 2021 at 7:43 AM Greg KH <greg@kroah.com> wrote:
>> Ok, and what prevents you from adding this new feature do your "custom"
>> kernel, or to use 5.12 instead?
>>
>> This is a new feature that Linux has never supported, and these patches
>> are not "trivial" at all.  I also do not see the maintainer of the
>> subsystem agreeing that these are needed to be backported, which is not
>> a good sign.
>>
>So this is not about a new feature. This is about an existing bug that
>we stumbled onto while using SEV virtualization. However SEV is not
>needed to trigger the bug. We have reproduced the bug with just
>NVMe + SWIOTLB=force option in Rhel 8 environment. Please note
>that NVMe and SWIOTLB=force are both existing feature and without
>the patch they don't work together. This is why we are proposing to merge
>the patches into the LTS kernels.

Could you re-spin this series with the comments around patch formatting
addressed, and explicitly cc hch on this to get his ack?

-- 
Thanks,
Sasha
