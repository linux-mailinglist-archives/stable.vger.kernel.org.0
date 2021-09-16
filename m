Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FBD40D8F2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhIPLoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbhIPLoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 07:44:04 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5880C061574
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 04:42:43 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y28so17405490lfb.0
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 04:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PUQk7iybu5WtIm/qZMASrmynw7Z5a2vpy/m8p2+iZe8=;
        b=MDg7v6ox6x0o3dfn7tgSllIApU6+EXugjT5h/sHE1X8f3CJ9vYDfcGnDMLhjlMEzzn
         NlYB0ZabvKyD3RBCK1cS4R1nvvh9S7HtvgYtXH88QdwIZBei7fIiT1sNb+A7dfFlSFmq
         xCRCRz5dkiR1j64YTuhzS3mPVgfRODdqwxX46cu/bNCjGXo0QuaultoU15K+lJUGnWz2
         z9UBHuILkhBIC9HW7FPfkqPQ3mOBGUUpZZZZ/xgCQP9RQHwbfvKnx1Y+VBPieN6jzVvc
         2kE2ra+vvY7GY33loXSss7lZYiG+0k/Qm1gKs66R+F7mp22AZ//RBYTjeJLT+sxZJIFf
         vzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PUQk7iybu5WtIm/qZMASrmynw7Z5a2vpy/m8p2+iZe8=;
        b=BquRFLo5L7FvI79spetSuH7LyGb30KCqyXR9UjaVWPom96551yXVywYBJJHiUyVw7p
         jw5CxNKcVp1SiNrXmQQFN7jFTvaRGRGMKn/hu2f1xc/I1G97xH7UzQkNmFV9VG01JELg
         BMUYAP6qVsG1TxUW/sVP7sOb0GvZEsNkIOhKRLlb4D31SM4LKSOLq6krX11/COVf3V3L
         VCShnWqeHQ9Rlu3Sxj4/3MvjTaeELb431dUxkJSUJ9TXocHUJf8b8rpaa0iGEBoryP1s
         ypnn7r2pBw1Q/vG4BSma3RrSKD/wTr8btpKw14/GBgUNpy8TTIe05DZZVv2elx/PUqmC
         VOLA==
X-Gm-Message-State: AOAM530I7ywS71KFyXbUvMhr9LI3ADDxuL+6O9CPmSwvU/cM1R1eCSJd
        avkaN9d9rZ6mtVsrcF7f4hn1NPUcopinnSL5IZk=
X-Google-Smtp-Source: ABdhPJza6hu/ncrOpwL7Lf2mvCRXBLaEbrjvI29b1pcjk3aPpiyh9OcqUow6EQtX7q/hL3NBu594dbpJIuOD+B8W4P4=
X-Received: by 2002:ac2:5d49:: with SMTP id w9mr3665501lfd.450.1631792561854;
 Thu, 16 Sep 2021 04:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210914174831.2044420-1-festevam@gmail.com> <96038e06b1141ad3348611a25544356e@codeaurora.org>
In-Reply-To: <96038e06b1141ad3348611a25544356e@codeaurora.org>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 16 Sep 2021 08:42:30 -0300
Message-ID: <CAOMZO5BzU3_x7nb8sEF_NDeDOxYM0bQLEpbRzv39jayX=fudYg@mail.gmail.com>
Subject: Re: [Freedreno] [PATCH] drm/msm: Do not run snapshot on non-DPU devices
To:     abhinavk@codeaurora.org
Cc:     Rob Clark <robdclark@gmail.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "open list:DRM DRIVER FOR MSM ADRENO GPU" 
        <freedreno@lists.freedesktop.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Abhinav,

On Wed, Sep 15, 2021 at 11:22 PM <abhinavk@codeaurora.org> wrote:

> Are you not using DPU or are you not using mdp4/mdp5 as well? Even if
> you are using any of mdps, kms should
> not be NULL. Hence wanted to check the test case.

I am running i.MX53, which is an NXP SoC, not Qualcomm's.

It does not use DPU, nor MDP4/5 and kms is NULL in this case.

Some debug prints to confirm:

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -557,18 +557,22 @@ static int msm_drm_init(struct device *dev,
const struct drm_driver *drv)
        case KMS_MDP4:
                kms = mdp4_kms_init(ddev);
                priv->kms = kms;
+               pr_err("******** KMS_MDP4\n");
                break;
        case KMS_MDP5:
                kms = mdp5_kms_init(ddev);
+               pr_err("******** KMS_MDP5\n");
                break;
        case KMS_DPU:
                kms = dpu_kms_init(ddev);
+               pr_err("******** KMS_DPU\n");
                priv->kms = kms;
                break;
        default:
                /* valid only for the dummy headless case, where of_node=NULL */
                WARN_ON(dev->of_node);
                kms = NULL;
+               pr_err("******** KMS is NULL\n");
                break;
        }

# dmesg | grep KMS
[    3.153215] ******** KMS is NULL
