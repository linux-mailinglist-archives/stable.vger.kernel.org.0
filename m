Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596F96AD605
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 05:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCGERG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 23:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCGERF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 23:17:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977495505E;
        Mon,  6 Mar 2023 20:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1843961204;
        Tue,  7 Mar 2023 04:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61ADC433D2;
        Tue,  7 Mar 2023 04:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678162623;
        bh=rdizhYVQ/mfuEzqZPHTPOUiZWOqs/sSV94pectJOceg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJust9j6uE2epqc7aYW4EDxoFLYasGT/vdh8KqLbDa0jcsKcGPUQb+abkBZuIejJb
         Jqxbtw8wlIs1KLeA/UKG7zkPSUFOl+sVJA2ASMZF+8osuh2qHn1+y+98H/0P8WS1ck
         YEFD06jvO+sptaI/HJzTB56weHbS5J+MZmUhovSS0MKXUEDyOl8wogTrEydgIIOihf
         FwoI0QWEFxyOF6ScaqYy34VoPqyqqmK+sYbOnJLmbfXy+KiBlq1yEFWzvVvoPByI8f
         u4STTXAy/l3/36DUt+YjkBiwWhz/9vU8YCDQ0/kPJz27DCAJnl+iU/TSkesWJo2ZZT
         VzJJ9Eb59LY6w==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Johan Hovold <johan@kernel.org>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Andy Gross <agross@kernel.org>
Cc:     stable@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] soc: qcom: llcc: Fix slice configuration values for SC8280XP
Date:   Mon,  6 Mar 2023 20:20:26 -0800
Message-Id: <167816282864.1458033.14750605365789550573.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306135527.509796-1-abel.vesa@linaro.org>
References: <20230306135527.509796-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Mar 2023 15:55:27 +0200, Abel Vesa wrote:
> The slice IDs for CVPFW, CPUSS1 and CPUWHT currently overflow the 32bit
> LLCC config registers, which means it is writing beyond the upper limit
> of the ATTR0_CFGn and ATTR1_CFGn range of registers. But the most obvious
> impact is the fact that the mentioned slices do not get configured at all,
> which will result in reduced performance. Fix that by using the slice ID
> values taken from the latest LLCC SC table.
> 
> [...]

Applied, thanks!

[1/1] soc: qcom: llcc: Fix slice configuration values for SC8280XP
      commit: 77bf4b3ed42e31d29b255fcd6530fb7a1e217e89

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
