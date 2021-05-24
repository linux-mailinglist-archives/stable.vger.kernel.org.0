Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871A738E063
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 06:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhEXEjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 00:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhEXEjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 00:39:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D54C061756
        for <stable@vger.kernel.org>; Sun, 23 May 2021 21:37:46 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h12so1834098plf.11
        for <stable@vger.kernel.org>; Sun, 23 May 2021 21:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MDE07gsiuD4M3r2LCEJykHaQUxtgYgyzLwjRG2xiWSo=;
        b=cMlNRaFVHxk/Vg2m4FWR7arQ/ghKts+RBvLvpeQcGyy25qofos/zvz9gUv7jDeVjza
         93RZUp5BiFbSqTrO+NUWRNsYj8cyBstCJBjhS3klDTdiKbCqN8gQYBgUNRJElP+C925B
         ozyW+qN+zvi6L7UdnFuG8PIldHGPc/9jpIwBkA1t/2/3guTMpuunG+456UxWgZ7FDSuU
         PKXM46qji8s89yr0dCU8ihrFl+w/q4zR6/zhs4tvktAHndJV9fX6fUWVzafwUBwIk7Pl
         mkBAvXkgpVAt29Iz5EdNRiU+cSC3mZFHmUm6rQPX0IhZwaUVrnJ9CF9CJU0d8yU9TVjs
         mBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MDE07gsiuD4M3r2LCEJykHaQUxtgYgyzLwjRG2xiWSo=;
        b=NQxBx0fWzSVuxoWbOUk6dqsAZW0gqtl4757izxE6Y19RaAqz0IjTsqxK8EBu8YyNL3
         JZe1CMw3Tr1akL13X94ho8qpuPU0PFxmc0xDajHX1iAvDGJ8DKJhPF11XlCRQbML5Ud/
         qZEKGuORqViTyD2oKs6YgnVFP2zYaGPGN+njFTfEtjN34JZUlfeQTs6aCYoaqMpw6LHe
         +D5gdLde645y4b2cDVESinGUru7uFaKz/IMyFZnsRt/0PZ4IyCuAH6fJMCEq6HNf58OV
         Wuq50w5eg7Kow9thKmkkKwNqEvrcdmMvyi3kSar8WrDdMYi1Vp2Qa4Jf6sdr+4QEEU3n
         xw/w==
X-Gm-Message-State: AOAM533cXz08Wfn04X/VBrZMlDp4ajrCX4T8uCQICwr6U9K6K+71ivig
        rrwf0FAga1KmoMEa+66ssWqtXnJFiLSG
X-Google-Smtp-Source: ABdhPJy9QPbKkRIFtXdAwMIebxG5sg01nmgnd6EX7GHXpAgjDNbW5i8bMBIDNwjkg/fabwwZYgm8qA==
X-Received: by 2002:a17:90a:b38d:: with SMTP id e13mr22456179pjr.222.1621831065632;
        Sun, 23 May 2021 21:37:45 -0700 (PDT)
Received: from work ([120.138.12.48])
        by smtp.gmail.com with ESMTPSA id v14sm9680578pfi.25.2021.05.23.21.37.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 23 May 2021 21:37:44 -0700 (PDT)
Date:   Mon, 24 May 2021 10:07:40 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Baochen Qiang <bqiang@codeaurora.org>
Cc:     hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: mhi: Wait for M2 state during system resume
Message-ID: <20210524043740.GC8823@work>
References: <20210524040312.14409-1-bqiang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524040312.14409-1-bqiang@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 12:03:12PM +0800, Baochen Qiang wrote:
> During system resume, MHI host triggers M3->M0 transition and then waits
> for target device to enter M0 state. Once done, the device queues a state
> change event into ctrl event ring and notifies MHI host by raising an
> interrupt, where a tasklet is scheduled to process this event. In most cases,
> the tasklet is served timely and wait operation succeeds.
> 
> However, there are cases where CPU is busy and cannot serve this tasklet
> for some time. Once delay goes long enough, the device moves itself to M1
> state and also interrupts MHI host after inserting a new state change
> event to ctrl ring. Later CPU finally has time to process the ring, however
> there are two events in it now:
> 	1. for M3->M0 event, which is processed first as queued first,
> 	   tasklet handler updates device state to M0 and wakes up the task,
> 	   i.e., the MHI host.
> 	2. for M0->M1 event, which is processed later, tasklet handler
> 	   triggers M1->M2 transition and updates device state to M2 directly,
> 	   then wakes up the MHI host(if still sleeping on this wait queue).
> Note that although MHI host has been woken up while processing the first
> event, it may still has no chance to run before the second event is processed.
> In other words, MHI host has to keep waiting till timeout cause the M0 state
> has been missed.
> 
> kernel log here:
> ...
> Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.911251] mhi 0000:06:00.0: Entered with PM state: M3, MHI state: M3
> Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.917762] mhi 0000:06:00.0: State change event to state: M0
> Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.917767] mhi 0000:06:00.0: State change event to state: M1
> Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4338.788231] mhi 0000:06:00.0: Did not enter M0 state, MHI state: M2, PM state: M2
> ...
> 
> Fix this issue by simply adding M2 as a valid state for resume.
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
> 
> Fixes: 0c6b20a1d720 ("bus: mhi: core: Add support for MHI suspend and resume")
> Signed-off-by: Baochen Qiang <bqiang@codeaurora.org>
> Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>

Applied to mhi-fixes!

Thanks,
Mani

> ---
>  drivers/bus/mhi/core/pm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> index e2e59a341fef..59b009a3ee9b 100644
> --- a/drivers/bus/mhi/core/pm.c
> +++ b/drivers/bus/mhi/core/pm.c
> @@ -934,6 +934,7 @@ int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
>  
>  	ret = wait_event_timeout(mhi_cntrl->state_event,
>  				 mhi_cntrl->dev_state == MHI_STATE_M0 ||
> +				 mhi_cntrl->dev_state == MHI_STATE_M2 ||
>  				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
>  				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
>  
> -- 
> 2.25.1
> 
