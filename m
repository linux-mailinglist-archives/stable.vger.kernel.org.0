Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11474606FE1
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 08:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJUGOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 02:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJUGOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 02:14:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B1A23643E
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 23:14:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g27so2750164edf.11
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 23:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2nHHTLIz8GT8Lbf8Wr4ApLWkm0E2FJMhCJBg0DAxPyM=;
        b=XP9PuTqEEklwIpLG31H6La949r6GPi6DdRNqYoHKsMUGSc5sD+8pAJFgM3UwLP50fH
         kMKqqsb81gKVpCejIOvNEE+MnD0/MJ0mnirxWKS6VqFBpqKscPoJnVI3RoiwOJFZ4FPO
         moxNoVr2MjpyFMq9k/QCeu7aBURX6FL5jqHEjHpnFPHrjrwC3QMDxKX3owxqcuw6teeu
         M90cgSYiQxfbV981LqGxWZcghC1H11OSTyaWaeGG/vqOErtvMrPH+jRQkAQ4iBUFvU3k
         5N8qyriHRpebErQ8Fwjumq5t0md3CEHXXemvS3oBZ7+BfEm+pq8QFhBjlFyECi4WQdhL
         Pulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2nHHTLIz8GT8Lbf8Wr4ApLWkm0E2FJMhCJBg0DAxPyM=;
        b=TRNEVPEGrKBxXDwAuHvcXYDwiMkQyxdd0b3jCYoU7a09IqlSMdCtHd/ay7KVRALBIX
         B1vT5F+kz0sU7Tk9uV8ndP6GGCEHPoWSHq+Qi5uN2Wua2SD6o0Hbpyl4G5I5nPtaMP88
         NSoX8wRvTXj5FTur1XqOtliMnZfVQUy2+zgF1WDhenpm6sX2K5rA0l3WG8WD5tiuDToB
         KLn6qJorYcDcPJTg9w8wZg7MrSC3Bqq8aiBlb/B4KLgBUaRLGw6tmlhEbVNtiQIeTH5L
         MgFs0ten/hWOaWz7oVT3bMx/BEzB3fASuzm0i3p4sYgkiYLbIGP2eJRn1b5PjbTjr4N2
         KTaQ==
X-Gm-Message-State: ACrzQf3Am+n9aabmxGqyrgXvuxTSVj41u095NWHIL8rin8QHb/0IiPuY
        pa6HjICh4uevExs2TJ3rXNs=
X-Google-Smtp-Source: AMsMyM4rIsHNIX/JWICxPILGfrcwIEHs92hBoANTe7B1o8Jy6vOSnFsvSfcDTOQkTWnAfVTPBdJm1Q==
X-Received: by 2002:a05:6402:3588:b0:45d:7d14:baf2 with SMTP id y8-20020a056402358800b0045d7d14baf2mr15507739edc.1.1666332846041;
        Thu, 20 Oct 2022 23:14:06 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id f13-20020a056402068d00b0045c3f6ad4c7sm1835826edy.62.2022.10.20.23.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 23:14:05 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 77507BE2DE0; Fri, 21 Oct 2022 08:14:04 +0200 (CEST)
Date:   Fri, 21 Oct 2022 08:14:04 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Diederik de Haas <didi.debian@cknow.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range()
 into sdma code for vega"
Message-ID: <Y1I4rC37gwl367rt@eldamar.lan>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
 <2651645.mvXUDI8C0e@bagend>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2651645.mvXUDI8C0e@bagend>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Oct 21, 2022 at 02:29:22AM +0200, Diederik de Haas wrote:
> On Thursday, 20 October 2022 17:38:56 CEST Alex Deucher wrote:
> > This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> > 
> > This patch was backported incorrectly when Sasha backported it and
> > the patch that caused the regression that this patch set fixed
> > was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER
> > reporting in get_port_device_capability()""). This isn't necessary and
> > causes a regression so drop it.
> > 
> > Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
> > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > Cc: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: <stable@vger.kernel.org>    # 5.10
> > ---
> 
> I build a kernel with these 2 patches reverted and can confirm that that fixes 
> the issue on my machine with a Radeon RX Vega 64 GPU. 
> # lspci -nn | grep VGA
> 0b:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/
> ATI] Vega 10 XL/XT [Radeon RX Vega 56/64] [1002:687f] (rev c1)
> 
> So feel free to add
> 
> Tested-By: Diederik de Haas <didi.debian@cknow.org>

Note additionally (probably only relevant for Greg while reviewing),
that the first of the commits which need to be reverted is already
queued as revert in queue-5.10.

Regards,
Salvatore
