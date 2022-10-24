Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3AD60B7CD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiJXTdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJXTdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:33:33 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD3B15DB2D;
        Mon, 24 Oct 2022 11:04:09 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id t25so6571471qkm.2;
        Mon, 24 Oct 2022 11:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xOnwiqhqmU2vuKfV5AqO+B/jD6mXaGSnSjTuitBAuvo=;
        b=lPOnS0Z0o1/InyYteCksInxAewCB3O5So3PMkBbconv36tRyL58HtDW96uSm/L01y2
         TDdPXgJdcqBBleAbVlIhmFk1UOciCbdSznUNWbRIykz590c89N9Qvn9jGi+8xwGaZ64Z
         jCKAUwQcOArzKqKaiJd55heLKIhht+Bk1Cgu2dGcVZ6Izpo2xuIcje7fmoOj4P+iQPX5
         lrOKTEH+FslD0dCZkNam8VEoZq5cv0NCtS9hub5+ZlX0/QSyA8pztXnvZ3K7ENLa8ltm
         Ru7R5yiOPY2hoq3mCKN1qcUY/d9NZf2NaGfezNhdlsmcAORlnid+YeOa/bWaHCgDA6yj
         6ciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOnwiqhqmU2vuKfV5AqO+B/jD6mXaGSnSjTuitBAuvo=;
        b=NMdsdtpSbe721GjLmxqmH7L7vDzkhItrW3/0dLdnJhIa7keKW9GvjvhSuHYxie0+6f
         DL2xb0a9ARkSP4U12RSgtvHTbwg/MXK3H5flLdAaXWlMocr3lo30zm8nFP+/7W9ee/zN
         O2X0sCnSygVimecYKyxzrOWmP25r/T40mGVosKxGJlXgeibXeCBifMOUqS4m4Kbv1xfv
         8mSFm880aJr63gjEjDvIik87y1XbQPnF6/ugYy+afcxeN9e0yj5F9PKAGJx8MiUpR5SX
         0LmrwYdHT9DIXawGyjuOzTd7sBchQM1wGM4moskbiHb4fi/29UXfrX0DPvU2T8GGwA1E
         YFOA==
X-Gm-Message-State: ACrzQf0TFHvDw4SgiI+BiQw1Ln7OV1ys23l9n9IKR6G5p5Q8kQw/wbNc
        AtrRO3XnRCPnDBIExhB5YjA=
X-Google-Smtp-Source: AMsMyM7NTxTI6fxf+uJ3Zu/TRzMRiYlJsU7z+Bv7BrBwx4ABlI2yLTPDNY6xtZxLHuk90IksZUs/XA==
X-Received: by 2002:a05:620a:490d:b0:6e6:b1ad:7a81 with SMTP id ed13-20020a05620a490d00b006e6b1ad7a81mr22216331qkb.695.1666634575332;
        Mon, 24 Oct 2022 11:02:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e10-20020a05622a110a00b0039cb9ef50b5sm332196qty.26.2022.10.24.11.02.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 11:02:54 -0700 (PDT)
Message-ID: <709b3a2e-4dfa-52e1-a75e-f72d73bd97a8@gmail.com>
Date:   Mon, 24 Oct 2022 11:02:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 1/7] mmc: cqhci: Provide helper for resetting both
 SDHCI and CQHCI
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Lin <shawn.lin@rock-chips.com>, linux-mmc@vger.kernel.org,
        Al Cooper <alcooperx@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Andy Gross <agross@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Faiz Abbas <faiz_abbas@ti.com>,
        Jonathan Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org
References: <20221024175501.2265400-1-briannorris@chromium.org>
 <20221024105229.v3.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221024105229.v3.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 10:54, Brian Norris wrote:
> Several SDHCI drivers need to deactivate command queueing in their reset
> hook (see sdhci_cqhci_reset() / sdhci-pci-core.c, for example), and
> several more are coming.
> 
> Those reset implementations have some small subtleties (e.g., ordering
> of initialization of SDHCI vs. CQHCI might leave us resetting with a
> NULL ->cqe_private), and are often identical across different host
> drivers.
> 
> We also don't want to force a dependency between SDHCI and CQHCI, or
> vice versa; non-SDHCI drivers use CQHCI, and SDHCI drivers might support
> command queueing through some other means.
> 
> So, implement a small helper, to avoid repeating the same mistakes in
> different drivers. Simply stick it in a header, because it's so small it
> doesn't deserve its own module right now, and inlining to each driver is
> pretty reasonable.
> 
> This is marked for -stable, as it is an important prerequisite patch for
> several SDHCI controller bugfixes that follow.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

