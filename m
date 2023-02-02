Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D97687D32
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 13:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjBBMVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 07:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjBBMVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 07:21:30 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854388D435
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 04:21:19 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so1266793wmq.0
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 04:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HXw3bt4I3cMvPHyqkA7MenjqrJEIYl3h0G0pbW0M5Ds=;
        b=gqGOGYaMFQpHdvDSBJgq/0n0DQypu8Nga3v8ip8IlMbPsR+gp1tGjvP2cskBHWGqrp
         HCHYfcqUVaFltTAICWUfEIVPucuHJoHKiN+4VF/j1+Enj4E7R/w6QWfgUogeH+MwEknv
         OIkmA2R/bS+//l9vbWL6WQuz+U2R8g8SDX9nl/3Z5uOgM2JuA3nZNNu4F3VHv+6dzL9m
         tOrezE3HComLyaN1E7cqcVi1Wtpe/ikv6Ii3OWPp2AhqKPSQ+6ctrbmqQ2ZPRaV9J0qj
         T4sgcumS75tMK1HG5ybChyZOCfDhIbFCU9D0a2VAQt8xytn26WVDuB5HeZsAqE22VbdA
         yvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXw3bt4I3cMvPHyqkA7MenjqrJEIYl3h0G0pbW0M5Ds=;
        b=RINjBH0eQ48UUidMW8ZBf06/6/WNbfjJpwKCP+4WCUOwLHjb1GD2HdAF7pWiKSASoj
         Zz6uZC4W6ZfP4kfuFkb7xaHiA4Ww6libqBMD+jUtHIspeOAxth2aMkbuMRlB3tnz/fOb
         zsRsNv4uQRfQ+U7yJ3XxWUQT/2CyFdNKfcHI5K0OT0sEjVLHNwEzSigvcT3sUYBs6ZvL
         6+QniCE6g5SyWhpJmLZbNQNPqWoBIGqN6p8UVLh6WIXWli4OeTWg1VXbFx17LTf4vTw1
         rRK2qZEQK0tRlLUEvdATjPHRHRBRNzjSzBoGM5ny4AQt69Xj+jAtOyJDLu3iCmA0Egel
         /LHQ==
X-Gm-Message-State: AO0yUKVYoBwut4rfMoVTE93/t7ukkC8OABuFaaPlQ6me+uN9TGLaraFM
        oCBhxUItk3Yl1c0wsFbiGIA5Cw==
X-Google-Smtp-Source: AK7set89gD0s2fUw5qHWrT4EWVSzstvSKSvqzBxtcRO9Es9fSPJEB70Tfsmw6HkifxmtJXAo552uIA==
X-Received: by 2002:a05:600c:4f53:b0:3dd:97d6:8f2a with SMTP id m19-20020a05600c4f5300b003dd97d68f2amr5761886wmq.33.1675340477334;
        Thu, 02 Feb 2023 04:21:17 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c4fc900b003dc1300eab0sm5115509wmq.33.2023.02.02.04.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 04:21:16 -0800 (PST)
Message-ID: <eb6a352b-1131-922f-4318-56a277b46dcf@linaro.org>
Date:   Thu, 2 Feb 2023 13:21:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 19/23] memory: tegra20-emc: fix interconnect registration
 race
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?B?QXJ0dXIgxZp3aWdvxYQ=?= <a.swigon@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-20-johan+linaro@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230201101559.15529-20-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/02/2023 11:15, Johan Hovold wrote:
> The current interconnect provider registration interface is inherently
> racy as nodes are not added until the after adding the provider. This
> can specifically cause racing DT lookups to fail.
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.
> 
> Fixes: d5ef16ba5fbe ("memory: tegra20: Support interconnect framework")
> Cc: stable@vger.kernel.org      # 5.11
> Cc: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

