Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496D665C8ED
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 22:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbjACV3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 16:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbjACV3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 16:29:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA809140D6
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 13:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672781331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZnLAtcqTp9v7CKNQz0A0gkDdGfLpyhj/luPVno9CpPo=;
        b=MFnEdnz6pagmYqoltG8fqF2J42y0A1Km6tGw4TCMZS38K5cAbBi0DCCbHdVHIlqbdhfBOH
        jYlRoCkSjHsUsbDxly0NAgFD4P20kXSdvf9jZ2uXAkYa58Y5WKqVXIE7LUw359aDu4d9d0
        Z7lNRDCdYAfZp1sDz9+YHTFYo8G49mM=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-26-eI3IzgVxNNGxWLI1DNlz9w-1; Tue, 03 Jan 2023 16:28:50 -0500
X-MC-Unique: eI3IzgVxNNGxWLI1DNlz9w-1
Received: by mail-oo1-f72.google.com with SMTP id p10-20020a4a3c4a000000b004e21e7fb4e3so4388327oof.3
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 13:28:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZnLAtcqTp9v7CKNQz0A0gkDdGfLpyhj/luPVno9CpPo=;
        b=I74VSe+8H3glwtN3qsJ2nBAhpF1ZCvVk1i5LbTKTsv0lYGsHsY4S5lQrOwnv3NDXuU
         M6Hlw+s7tvUC1ECo4cd9gmL31TihdSLGNbX3bMckklqnW1Sd/0l8siLO29hY2fS32Fcl
         +3dR7YgOQTPK7Gi130Y0bHlbrvu4QLwShk5N3f9C2wWK0f6gPRHj83/Zsd11iaVlTwJJ
         YTVfccjYLHbv73t5cIjOKb9HkjJM3iZeaQSEE9mXUBPHe7hzlU4YCtNHRnIAjcOiPOmY
         kVNcw7W4xWnOKCaLTW6+Y/ojEw3XHI7yjLIpLt1bGqnBA7+EM0iiaTi3CPh6l27rqNJc
         d04Q==
X-Gm-Message-State: AFqh2kq7oj8kPkoQbwG4i7YwxMIoIfIwpVLAJOhjwnXIZL4Ecc+03z9R
        OAI8lrHFH/NZ8IWBjlEAwLFhnxU/zVEy2InSZ4USPLo3N8VaEHPDCRa30cfAImsdoxavI7rbw1/
        WgT180Mk3Uri5s2h2
X-Received: by 2002:a05:6870:8e08:b0:150:4af9:b29e with SMTP id lw8-20020a0568708e0800b001504af9b29emr10527783oab.33.1672781329453;
        Tue, 03 Jan 2023 13:28:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXukaFuUEzWapjWhOMxeon1UwGobABlsmOcJqe5BEVcQ7D1b4lncU6TrtoORrUZv+gkj4jsiQQ==
X-Received: by 2002:a05:6870:8e08:b0:150:4af9:b29e with SMTP id lw8-20020a0568708e0800b001504af9b29emr10527771oab.33.1672781329192;
        Tue, 03 Jan 2023 13:28:49 -0800 (PST)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::11])
        by smtp.gmail.com with ESMTPSA id h11-20020a056870d24b00b00150aca072e8sm3201153oac.38.2023.01.03.13.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 13:28:48 -0800 (PST)
Date:   Tue, 3 Jan 2023 15:28:46 -0600
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Can Guo <quic_cang@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Message-ID: <20230103212846.2zwooig4c5sp4rl7@halaney-x13s>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222102121.18682-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 11:21:21AM +0100, Johan Hovold wrote:
> There is a lock inversion and rwsem read-lock recursion in the devfreq
> target callback which can lead to deadlocks.
> 
> Specifically, ufshcd_devfreq_scale() already holds a clk_scaling_lock
> read lock when toggling the write booster, which involves taking the
> dev_cmd mutex before taking another clk_scaling_lock read lock.
> 
> This can lead to a deadlock if another thread:
> 
>   1) tries to acquire the dev_cmd and clk_scaling locks in the correct
>      order, or
> 
>   2) takes a clk_scaling write lock before the attempt to take the
>      clk_scaling read lock a second time.
> 
> Fix this by dropping the clk_scaling_lock before toggling the write
> booster as was done before commit 0e9d4ca43ba8 ("scsi: ufs: Protect some
> contexts from unexpected clock scaling").
> 
> While the devfreq callbacks are already serialised, add a second
> serialising mutex to handle the unlikely case where a callback triggered
> through the devfreq sysfs interface is racing with a request to disable
> clock scaling through the UFS controller 'clkscale_enable' sysfs
> attribute. This could otherwise lead to the write booster being left
> disabled after having disabled clock scaling.
> 
> Also take the new mutex in ufshcd_clk_scaling_allow() to make sure that
> any pending write booster update has completed on return.
> 
> Note that this currently only affects Qualcomm platforms since commit
> 87bd05016a64 ("scsi: ufs: core: Allow host driver to disable wb toggling
> during clock scaling").
> 
> The lock inversion (i.e. 1 above) was reported by lockdep as:
> 
>  ======================================================
>  WARNING: possible circular locking dependency detected
>  6.1.0-next-20221216 #211 Not tainted
>  ------------------------------------------------------
>  kworker/u16:2/71 is trying to acquire lock:
>  ffff076280ba98a0 (&hba->dev_cmd.lock){+.+.}-{3:3}, at: ufshcd_query_flag+0x50/0x1c0
> 
>  but task is already holding lock:
>  ffff076280ba9cf0 (&hba->clk_scaling_lock){++++}-{3:3}, at: ufshcd_devfreq_scale+0x2b8/0x380
> 
>  which lock already depends on the new lock.
> [  +0.011606]
>  the existing dependency chain (in reverse order) is:
> 
>  -> #1 (&hba->clk_scaling_lock){++++}-{3:3}:
>         lock_acquire+0x68/0x90
>         down_read+0x58/0x80
>         ufshcd_exec_dev_cmd+0x70/0x2c0
>         ufshcd_verify_dev_init+0x68/0x170
>         ufshcd_probe_hba+0x398/0x1180
>         ufshcd_async_scan+0x30/0x320
>         async_run_entry_fn+0x34/0x150
>         process_one_work+0x288/0x6c0
>         worker_thread+0x74/0x450
>         kthread+0x118/0x120
>         ret_from_fork+0x10/0x20
> 
>  -> #0 (&hba->dev_cmd.lock){+.+.}-{3:3}:
>         __lock_acquire+0x12a0/0x2240
>         lock_acquire.part.0+0xcc/0x220
>         lock_acquire+0x68/0x90
>         __mutex_lock+0x98/0x430
>         mutex_lock_nested+0x2c/0x40
>         ufshcd_query_flag+0x50/0x1c0
>         ufshcd_query_flag_retry+0x64/0x100
>         ufshcd_wb_toggle+0x5c/0x120
>         ufshcd_devfreq_scale+0x2c4/0x380
>         ufshcd_devfreq_target+0xf4/0x230
>         devfreq_set_target+0x84/0x2f0
>         devfreq_update_target+0xc4/0xf0
>         devfreq_monitor+0x38/0x1f0
>         process_one_work+0x288/0x6c0
>         worker_thread+0x74/0x450
>         kthread+0x118/0x120
>         ret_from_fork+0x10/0x20
> 
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
>         CPU0                    CPU1
>         ----                    ----
>    lock(&hba->clk_scaling_lock);
>                                 lock(&hba->dev_cmd.lock);
>                                 lock(&hba->clk_scaling_lock);
>    lock(&hba->dev_cmd.lock);
> 
>   *** DEADLOCK ***
> 
> Fixes: 0e9d4ca43ba8 ("scsi: ufs: Protect some contexts from unexpected clock scaling")
> Cc: stable@vger.kernel.org      # 5.12
> Cc: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Tested-by: Andrew Halaney <ahalaney@redhat.com>

Thanks for taking the time to fix this, I can't get any UFS related
splats to show after a brief round of testing now.

For what it is worth, the change looks good to me as well but I'll leave
it to someone familiar with the UFS core to add a proper Reviewed-by tag.

Thanks,
Andrew

