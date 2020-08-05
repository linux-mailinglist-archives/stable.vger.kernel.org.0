Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EC623CF0A
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHETMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgHETLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 15:11:15 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811B2C06179E
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 12:10:27 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g19so13345168plq.0
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 12:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MSc8CdvlCTlS/rGODV3WIim2Ov5AsAV8L4wkS3+KWFo=;
        b=idSzx3n4pWz9Jn5VzUw18k8vT8Zqk5XKIVWctP9xBlwThvAzZR5b7tqeTjNVOmv2/b
         +ghB68zl424YO86Yz6Xwswe92NQX1ka5n3LUvFbj/hRYZOzSrmgjYWlFxlZKOPEAn8Qn
         cogo1aaCZgl3yZqFM+ggrt7SXbXSkWkd0GtLCNXa0uMGRDsDABo8JU7Hblz9x5r6qGSS
         GsFmA7IwGhkpJxNtJVPZTa6hhv+xdlq+GgZ2jWMrQRgwdPWkyC4dG//F8i/QMEjtJVE2
         EMzXGlv56yZrRnJMFKyP7im8a/QBdzr8FF5dmLh3mNlkAkBKo+f5E4eQas635A5+SPE6
         Nh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MSc8CdvlCTlS/rGODV3WIim2Ov5AsAV8L4wkS3+KWFo=;
        b=NKktm+eZptwLy//z/qXLewgWcOYRDsUvJJRyt9Nl+3jMiZYi/Zs2sip5HV+OD9XOpb
         KetkSymnPnkcT5qK1roOxFxRtFZiebfhb2qFSM7lfdIG6uwqf/UUPZltxXNYktmQwTuo
         s1snZVkVU+SBKxH+jpZ+y+zysfUp0GW9gLsOiHD6iNZE7DLDrVikp40j7Ak1fxnFhQ/C
         KkTuxiPGyiF3arMMoVAKcQwePwUXLiBtoklPYH7SZr8bM82xCjZoJUHDTCpbdVr1cWYO
         hZ4K8AVue5GSTl503+CZn5S0dhsL8FqrqZjWpPCNBLX2+18z+aEGsj+iDT+BP88WkwXI
         YjxA==
X-Gm-Message-State: AOAM531PgEAGqEMZ7X9GJBlrNjf7dQvOKdv/gDNvDdIoNDHAeuJspreP
        VxJVllM6xiNM1rrD38MFeLe2cTh8y/U=
X-Google-Smtp-Source: ABdhPJyDhSQpINp5ZlVOnfD2Gxs3lXUd7xxsv4cvbzzDxWTQh7M2Mcta9TwAaTORaBcq77VObiAAGw==
X-Received: by 2002:a17:90a:d901:: with SMTP id c1mr4689996pjv.175.1596654626709;
        Wed, 05 Aug 2020 12:10:26 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z4sm4270111pfb.55.2020.08.05.12.10.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 12:10:25 -0700 (PDT)
Subject: Re: 5.4 stable inclusion request
From:   Jens Axboe <axboe@kernel.dk>
To:     stable@vger.kernel.org
References: <9740b863-25f0-7adc-7bdc-f95bf8c664f5@kernel.dk>
Message-ID: <69e11137-dd04-5c95-e73c-6c826196d46d@kernel.dk>
Date:   Wed, 5 Aug 2020 13:10:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9740b863-25f0-7adc-7bdc-f95bf8c664f5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 12:34 PM, Jens Axboe wrote:
> Hi,
> 
> Below is a io_uring patch that I'd like to get into 5.4. There's no
> equiv 5.5 commit, because the resulting changes were a lot more invasive
> there to avoid re-reading important sqe fields. But the reporter has
> also tested this one and verifies it fixes his issue. Can we get this
> queued up for 5.4?

And on top of that, this one as well which is also only applicable to
5.4. Thanks!


commit 33757992d5627b986757fd70ff86d73f2bda0dac
Author: Guoyu Huang <hgy5945@gmail.com>
Date:   Tue Aug 4 20:40:42 2020 -0700

    io_uring: Fix use-after-free in io_sq_wq_submit_work()
    
    when ctx->sqo_mm is zero, io_sq_wq_submit_work() frees 'req'
    without deleting it from 'task_list'. After that, 'req' is
    accessed in io_ring_ctx_wait_and_kill() which lead to
    a use-after-free.
    
    Signed-off-by: Guoyu Huang <hgy5945@gmail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8bb5e19b7c3c..be3d595a607f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2232,6 +2232,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		if (io_req_needs_user(req) && !cur_mm) {
 			if (!mmget_not_zero(ctx->sqo_mm)) {
 				ret = -EFAULT;
+				goto end_req;
 			} else {
 				cur_mm = ctx->sqo_mm;
 				use_mm(cur_mm);

-- 
Jens Axboe

