Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FE96AD603
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 05:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjCGERF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 23:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjCGERF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 23:17:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2D95328A;
        Mon,  6 Mar 2023 20:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2333661207;
        Tue,  7 Mar 2023 04:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B88C433D2;
        Tue,  7 Mar 2023 04:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678162621;
        bh=AuLRsnr2m1yt1RnF7WnVA+dN3JGdSgU2wHQrIAXdDTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiPwRSyO4HNF3yUrwFx+eq23jLupgHqGQi5X9UxluTM5KOi9WJWdJKJ9EjBLueIyn
         rSTYT1mAo2E6Paa26Q2zZZCXqZTBy3GdGGx/jjtVjqcGwC/3e2nUi7k5/8dxIBEfEc
         QhS3JgH5Terhvr94vQKhY1Ufg/r1ybpFiVCQBioA9Dxt9f+XeGpt4+yb7ORNm+P98r
         0WLVoaXvqJ8PszAPdfnWddDrP94HLGVShB69vflH9F9Pmy0Xge8/GRsgBkhXQY5OG4
         DnrlMqDRS0nW9wwaClcKkS2SDtsOJyQKjmd3Hc+71zsJcMODymyOybVwB1Uo7u5N2k
         3MOtVo4qHOsFw==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Johan Hovold <johan@kernel.org>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Andy Gross <agross@kernel.org>
Cc:     stable@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] soc: qcom: llcc: Fix slice configuration values for SC8280XP
Date:   Mon,  6 Mar 2023 20:20:24 -0800
Message-Id: <167816282864.1458033.16156331438007521617.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230219165701.2557446-1-abel.vesa@linaro.org>
References: <20230219165701.2557446-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 19 Feb 2023 18:57:01 +0200, Abel Vesa wrote:
> The slice IDs for CVPFW, CPUSS1 and CPUWHT currently overflow the 32bit
> LLCC config registers. Fix that by using the slice ID values taken from
> the latest LLCC SC table.
> 
> 

Applied, thanks!

[1/1] soc: qcom: llcc: Fix slice configuration values for SC8280XP
      commit: 77bf4b3ed42e31d29b255fcd6530fb7a1e217e89

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
