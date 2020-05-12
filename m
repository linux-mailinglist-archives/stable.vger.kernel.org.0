Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D1C1CF89F
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgELPKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 11:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgELPKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 11:10:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376AAC061A0C
        for <stable@vger.kernel.org>; Tue, 12 May 2020 08:10:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a7so9541134pju.2
        for <stable@vger.kernel.org>; Tue, 12 May 2020 08:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=073Eq2bwhyzWj+BykInJ5CqWRmlAFO/y7oIO+dj6Etc=;
        b=i5M5CC1QThXHZH+CTgWGAIPGX3XnvFhiTjwHru2s05kjK5k6YjXsDFBkc/xpQKurP3
         zOCrO/pZi9fa4WdxmFAjBYMh/aw4tFr4VxoI11Bt++iSELBixnt8feKxWG/5DoZEDDjh
         MLVPxyZ/nrVdsIVUyQZZ1VHd5c5k4JNjJ/QQhvqlfNDw9kl7hqLxrPRcYU/JfMJIO6WL
         Z9oByGMgE0yCCVtyMc8X89KiAtY9fnkQuHTW51QfJg5bMpH411QN957nRnv5cp3MvjRI
         iwCt1lfx8KjAiHYpnHAETt4f4mrSiCauk1AGJPRaG06shx6tPnPcw+whGerorKMck/nz
         Uh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=073Eq2bwhyzWj+BykInJ5CqWRmlAFO/y7oIO+dj6Etc=;
        b=eL2YKafQxgkyP30URppLQUTLBV+mx5PZ5ag8Dox/VzF+iwyyjHyeSvBdcSg1+k4Ubv
         +U9TvUtknoC5gbF4+f+GMJ7uqMrw/rH76NQtLnqHnJyC7112p8LgEc4I30vXEf7EQVUr
         DpXSyNnhO5pUtjRItVVoV9F2iXj66DHMOUVY+VxEZNJHSm5bmkf2xCyCZPDwZDcQ+NjE
         LSMDRKNZw+/nWVHHTLOIttA3jR0KD2xr0pz31KIVKp+Tfw+v3qzrk/1loNl57ZGUFIU5
         MRvx9qNw9qzWRHnlSf0rQKdafyNYTqAeL9UdwrPqBCGJVS3MVRaE/6PmK35elbL+cZMr
         nFMQ==
X-Gm-Message-State: AGi0Pua6cD2a2LE/BlAtMKojQauqZbcK/ljh8kLo3HKWXpCZ0dYhFtix
        fTSPmxH8eERuZEHxgIcAylps8bVFqZ8=
X-Google-Smtp-Source: APiQypIDjzx/VWjw7FzSvkDKx4LHmsfcErgiDg4jfpp4iS1INBsFjrusGQbyvzpge7xrj0L5+5tLVQ==
X-Received: by 2002:a17:90a:db46:: with SMTP id u6mr28832996pjx.15.1589296211294;
        Tue, 12 May 2020 08:10:11 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:25cc:e52:aad5:83c2? ([2605:e000:100e:8c61:25cc:e52:aad5:83c2])
        by smtp.gmail.com with ESMTPSA id t206sm12360575pfc.212.2020.05.12.08.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 08:10:10 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] bdi: add a ->dev_name field to struct
 backing_dev_info" failed to apply to 5.6-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     hch@lst.de, bvanassche@acm.org, jack@suse.cz, yuyufen@huawei.com,
        stable@vger.kernel.org
References: <158928427224231@kroah.com> <20200512143851.GQ13035@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bccfa4fa-33e7-cec8-0a05-994e09e5629d@kernel.dk>
Date:   Tue, 12 May 2020 09:10:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200512143851.GQ13035@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/12/20 8:38 AM, Sasha Levin wrote:
> On Tue, May 12, 2020 at 01:51:12PM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.6-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>>From 6bd87eec23cbc9ed222bed0f5b5b02bf300e9a8d Mon Sep 17 00:00:00 2001
>> From: Christoph Hellwig <hch@lst.de>
>> Date: Mon, 4 May 2020 14:47:56 +0200
>> Subject: [PATCH] bdi: add a ->dev_name field to struct backing_dev_info
>>
>> Cache a copy of the name for the life time of the backing_dev_info
>> structure so that we can reference it even after unregistering.
>>
>> Fixes: 68f23b89067f ("memcg: fix a crash in wb_workfn when a device disappears")
>> Reported-by: Yufen Yu <yuyufen@huawei.com>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> I've also grabbed eb7ae5e06bb6 ("bdi: move bdi_dev_name out of line") as
> a dependency and queued both for 5.6 and 5.4.

Thanks Sasha!

-- 
Jens Axboe

