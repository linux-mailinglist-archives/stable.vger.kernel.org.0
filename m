Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16C646EA34
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 15:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbhLIOqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 09:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhLIOqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 09:46:14 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081F7C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 06:42:41 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id np3so4573474pjb.4
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 06:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DlIzAa6h2Qdf88CQ4XAT+zAj7QyEiJFQv1x54NsjTKU=;
        b=izB4Ze5IwkTdDFN2UPnu25PTURU5BM0L76lRpnraNW9aOiFCIfT4kGA9KN4Hsp9dMI
         5yc45D+bNrTlgL5C6Ns35vhPzcgiVqugDyrdKVBl3GWVdyX7aH9sJ2i2mH2PkzvVFpfp
         FMB917/z54Wigzhm2+DyrWiRkYoIHWWOX/zgAVL3aB4rpx/GZM3/vGM6N0eWJ33hutyk
         cUzhIVJRdLGS1R6INlxbilcEnv2sI9plsP0iJ0PcxwL8zJooz2xqotKh3rt6BZUpHseP
         esFGUNhzXQuhALatzTkkVnEAVh3AG3FQzSy8RCUqvAmqnmf7IyCgQOFebnZCQFUodlQp
         EHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DlIzAa6h2Qdf88CQ4XAT+zAj7QyEiJFQv1x54NsjTKU=;
        b=y7YAqO9eNrBExZBBg3Z3LLf8tHDTIWaAlLvfP4KiqLonkzZSDl+5WD7kWM4Ie7iDSH
         ELgcrb+S7NsqIDKgqZZgbf8O80eAe9aQJc1HFc6tvwTnODT88YVKQrSbRHhia1p5sW9l
         uj1vwLNOkMlAuVt5KLXwn/Kd7hdseNT/ob7wMPBf8p+Ikhp80yqCElV44/5+43dtY5lq
         kfS7pBQuJ/sz/WBYj3NtzI1QhJFGE/IyoqXYnwbUF6+IH3tvaVCVlB89uMKdCfEg2jCy
         r6fTW+TpqECpuUpnmKCPJ67jPcirfkvUC2P8qI7dZU+wt71Qo9WyLwEk2kFWop2U5/uZ
         6OZA==
X-Gm-Message-State: AOAM532M4XMXuQ9yQhU7+dTTYKqWIRKzdSRguiB/5nSeH69yDOP+Rmdo
        fsI1AxewrKQS/m3J1IT5hwtK
X-Google-Smtp-Source: ABdhPJxBp3vk9RdIYD+lyw7hUsxgLabInUSRiWT7uujnDncQbAcGGL+tWLA/fU6V5Iel2x2ks7eahA==
X-Received: by 2002:a17:90b:3149:: with SMTP id ip9mr16188630pjb.77.1639060960427;
        Thu, 09 Dec 2021 06:42:40 -0800 (PST)
Received: from thinkpad ([2409:4072:902:fac4:6231:3e3b:50a6:33a7])
        by smtp.gmail.com with ESMTPSA id b1sm5985623pgk.37.2021.12.09.06.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 06:42:39 -0800 (PST)
Date:   Thu, 9 Dec 2021 20:12:33 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     gregkh@linuxfoundation.org, mhi@lists.linux.dev,
        hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Pengyu Ma <mapengyu@gmail.com>
Subject: Re: [PATCH v2] bus: mhi: core: Add support for forced PM resume
Message-ID: <20211209144233.GA9253@thinkpad>
References: <20211209131633.4168-1-manivannan.sadhasivam@linaro.org>
 <87fsr13kya.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsr13kya.fsf@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 04:35:25PM +0200, Kalle Valo wrote:
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> 
> > From: Loic Poulain <loic.poulain@linaro.org>
> >
> > For whatever reason, some devices like QCA6390, WCN6855 using ath11k
> > are not in M3 state during PM resume, but still functional. The
> > mhi_pm_resume should then not fail in those cases, and let the higher
> > level device specific stack continue resuming process.
> >
> > Add an API mhi_pm_resume_force(), to force resuming irrespective of the
> > current MHI state. This fixes a regression with non functional ath11k WiFi
> > after suspend/resume cycle on some machines.
> >
> > Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179
> >
> > Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
> > Cc: stable@vger.kernel.org #5.13
> > Link: https://lore.kernel.org/regressions/871r5p0x2u.fsf@codeaurora.org/
> > Reported-by: Kalle Valo <kvalo@codeaurora.org>
> > Reported-by: Pengyu Ma <mapengyu@gmail.com>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > [mani: Switched to API, added bug report, reported-by tags and CCed stable]
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >
> > Changes in v2:
> >
> > * Switched to a new API "mhi_pm_resume_force()" instead of the "force" flag as
> >   suggested by Greg. The "force" flag is now used inside the API.
> >
> > Greg: I'm sending this patch directly to you so that you can apply it to
> > char-misc once we get an ACK from Kalle.
> 
> Thanks! I now tested this patch on top v5.16-rc4 using QCA6390 and
> firmware WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1, no issues found:
> 
> Tested-by: Kalle Valo <kvalo@kernel.org>
> 
> I'm not expecting any conflicts with ath11k, so please take this via
> Greg's tree. It would be really good to get this regression fixed in
> v5.16, so is it possible to send this to -rc releases?
> 
> For the ath11k part:
> 
> Acked-by: Kalle Valo <kvalo@kernel.org>

Thanks. If this patch looks good to Greg, then it will be queued for the next
-rc release.

Thanks,
Mani

> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
