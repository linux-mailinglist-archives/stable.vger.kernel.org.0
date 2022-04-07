Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B355E4F812D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiDGOCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 10:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343807AbiDGOC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 10:02:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442D64ECDC
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 07:00:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 2so5706758pjw.2
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 07:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ilRZ4ek+6KKKYFW419BEN9rdb9L/EYrhdFBp0/hmrUo=;
        b=HwJDof5YSaWRbe0KrDpNtb2vyys012Tla6FVJeqfBFkpIwiK/lgZkwibLPvftaGvE3
         IvtDVbmOleQx7jby+JKRyynJN01kNpGQ46O0q9i3QVBPC6iDtnR97XRqyJfkr3AG5bcY
         AL7zygZ3cCJJTxhuGpho8lWd0glBno8gn1gydMS0jAyWTNBNkc2OFXmvnzMCVKlyddOO
         +nT83uVha6jRW+cPUwhC9sPv6kJb15hdfq61d8jFmQzlbYsdhgbpOKg44Y8vrhIGueGu
         GQV9SsJGVrMNdraRFniUYWANhsD96yuvw8oQ4DLKk73Hpf2A1tU+bB2eS0dJygOTXMMt
         sltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ilRZ4ek+6KKKYFW419BEN9rdb9L/EYrhdFBp0/hmrUo=;
        b=lIvg5yaUcpmuhdSgQ+gxY4GrpaVh19O22IE/CUS7L3IjJ51wjS190hkxcPgj8CjV0A
         e+Sl8iFAJpom36dyf4wcnWaT9sgn24b1Z5B0shHhjw+mHS4b2zyJwVZl5jLk5wO91iDw
         fsKdEvJ0vuAlFsXtusuDu9eU2UtQcDGCSGyIJvLAjmDa7OiITHmyr6IOzQVkrN6SxHnY
         GnzYWTogWutWap6d7W7TMpG2OG3Te0SEhRVYAe5nAScD1ifbv7raHPdw7f+SvgVbEeKD
         iBi+ftddeqZevt/4J9ODPuDIPYjhWmaZ22HQwrHi0r4c5htDlgveW2tFu8Xzt3CUhJo9
         R3Rw==
X-Gm-Message-State: AOAM531BnhSwCEqZOFg0KjEQjYFVgYNO8L9N8aIC+M3u5TgvWGOrA2VQ
        ffdKPfO177Os0mJATlUpVLds
X-Google-Smtp-Source: ABdhPJxEtFDjxi+tT5tmyYEIpEPga6hkRXXTZUaElIv8mgWuQu9ZKsYcnyxSEj7onHYXcxi9a+WBzQ==
X-Received: by 2002:a17:90b:164f:b0:1c7:8d20:ff6d with SMTP id il15-20020a17090b164f00b001c78d20ff6dmr16240981pjb.64.1649340027203;
        Thu, 07 Apr 2022 07:00:27 -0700 (PDT)
Received: from thinkpad ([59.92.99.101])
        by smtp.gmail.com with ESMTPSA id mn18-20020a17090b189200b001cac1781bb4sm9269222pjb.35.2022.04.07.07.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 07:00:26 -0700 (PDT)
Date:   Thu, 7 Apr 2022 19:30:21 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bhaumik Vasav Bhatt <quic_bbhatt@quicinc.com>
Cc:     mhi@lists.linux.dev, quic_hemantk@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: mhi: host: pci_generic: Add missing poweroff()
 PM callback
Message-ID: <20220407140021.GA118957@thinkpad>
References: <20220405125907.5644-1-manivannan.sadhasivam@linaro.org>
 <daafdfd8-312e-cf42-d7bb-3fb914d443dc@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daafdfd8-312e-cf42-d7bb-3fb914d443dc@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 01:23:22PM -0700, Bhaumik Vasav Bhatt wrote:
> 
> On 4/5/2022 5:59 AM, Manivannan Sadhasivam wrote:
> > During hibernation process, once thaw() stage completes, the MHI endpoint
> > devices will be in M0 state post recovery. After that, the devices will be
> > powered down so that the system can enter the target sleep state. During
> > this stage, the PCI core will put the devices in D3hot. But this transition
> > is allowed by the MHI spec. The devices can only enter D3hot when it is in
> > M3 state.
> > 
> > So for fixing this issue, let's add the poweroff() callback that will get
> > executed before putting the system in target sleep state during
> > hibernation. This callback will power down the device properly so that it
> > could be restored during restore() or thaw() stage.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
> > Reported-by: Hemant Kumar <quic_hemantk@quicinc.com>
> > Suggested-by: Hemant Kumar <quic_hemantk@quicinc.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> > 
> > Changes in v2:
> > 
> > * Hemant suggested to use restore function for poweroff() callback as we can
> > make sure that the device gets powered down properly.
> > 
> >   drivers/bus/mhi/host/pci_generic.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
> > index 9527b7d63840..ef85dbfb3216 100644
> > --- a/drivers/bus/mhi/host/pci_generic.c
> > +++ b/drivers/bus/mhi/host/pci_generic.c
> > @@ -1085,6 +1085,7 @@ static const struct dev_pm_ops mhi_pci_pm_ops = {
> >   	.resume = mhi_pci_resume,
> >   	.freeze = mhi_pci_freeze,
> >   	.thaw = mhi_pci_restore,
> > +	.poweroff = mhi_pci_freeze,
> 
> It is possible that .thaw() queues recovery work and recovery work is still
> running
> 
> while .poweroff() is called. I would suggest adding a flush_work() in freeze
> such that
> 
> we don't try to power off while we're also trying to power on MHI from
> recovery work.
> 

These two cannot run in parallel because the power down will only happen if the
MHI_PCI_DEV_STARTED bit is set in mhi_pdev->status and that's the last step of
recovery. But the real issue I found is, if the recovery didn't finish during
powerdown() stage, then the function will just return and the device might be
powered on later.

So to avoid this scenario, we should have the flush_workqueue() in freeze.

I'll submit a different patch for that.

Thanks,
Mani

> >   	.restore = mhi_pci_restore,
> >   #endif
> >   };
