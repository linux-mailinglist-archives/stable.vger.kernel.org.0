Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CCE44B0D4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 17:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbhKIQIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 11:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbhKIQIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 11:08:19 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1613C061764;
        Tue,  9 Nov 2021 08:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=HKqZVUTyITTKjgy2bSV7h4abqd5N6tsdpToL4Lb0mKc=; b=Xz8Jhef9yQSyM4bHzlcdA32i3e
        PyDBMANcwcbhPo4zFx69oE+cnWHgIViH/8GIUv8YiGxaB0YbY/9NzMUSgXLunYsidm8W9hZfm5jxT
        MfoNs4YehQA8Hvr0jkp10nf/fGIHnDH2nLPBhfXg8ZoI6rAWZewXPs3fiCdVLtVxKN5qCHrwfIOzk
        yq0kZIcFl+vUn3B9ZBT2/6PFjHV0JN+xkmJa4IjniApZyP05znVwVu66ZRPgfy1manp4ctHepA1HP
        rwCjUHGioV1FU3XaiSSKqeWv7ks6TZUzjFhRDsG9qPSfSrGrU51mcuKSG3iEoXeLJ8kHeqfNT//og
        +fgVl8cw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkTcl-008nze-Vs; Tue, 09 Nov 2021 16:05:28 +0000
Subject: Re: AUTOSEL series truncated was -- Re: [PATCH AUTOSEL 5.15 001/146]
 dma-buf: WARN on dmabuf release with pending attachments
To:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <20211108174453.1187052-1-sashal@kernel.org>
 <20211109075423.GA16766@amd>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3957633e-9596-e329-c79b-b45e9993d139@infradead.org>
Date:   Tue, 9 Nov 2021 08:05:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109075423.GA16766@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/21 11:54 PM, Pavel Machek wrote:
> Hi!
> 
> This series is truncated .. I only got first patches. Similary, 5.10
> series is truncated, [PATCH AUTOSEL 5.10 035/101] media: s5p-mfc: Add
> checking to s5p_mfc_probe... is last one I got.
> 
> I got all the patches before that, so I believe it is not problem on
> my side, but I'd not mind someone confirming they are seeing the same
> problem...

Yes, several of the patch series were incomplete for me also...

-- 
~Randy
