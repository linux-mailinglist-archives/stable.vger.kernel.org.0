Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8525EF709
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 16:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiI2OAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 10:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiI2OAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 10:00:33 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D049EEF0A0
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 07:00:30 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id a10so1680709ljq.0
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 07:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=X4udh+F/jTTPAawHj+leYFUcEjOK0Up2+V5M2hR8VXE=;
        b=VjCYChWjn6iy+G3yVQ6tZ5L5GrU7JMx6AFQ+ZIwJs9EqJdAQec1TweUcsCGbcL5zbN
         IcYXCI9pbWIaq3GI3J98z7m8bU6Eg24TmmlRaBm3jWe2XdtHETo1oLcp8UAHlG2Ff7jY
         0nNtDetj7dDIdFNbbL1Pu7gFgvUcjrHf5auaM7kzTnxn8WGUuCdjAUPu9CQEBbD5QQLl
         EC91SUJqW/acBbe94NQt+/gD5IiMV6nwTx1Q+Hrr0rHdVRS9waYT7ZMQsRfHsPZwE92B
         fq+roLKRMKkFs0p5Dp6D3rH9Pql0spk3ObhDvl+0pHJMAOKdEN2L63cgu49/aN6W/BR7
         iThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=X4udh+F/jTTPAawHj+leYFUcEjOK0Up2+V5M2hR8VXE=;
        b=lqKY2CHWzuVSROKtx1Q1p3nDC8kQuVmzEP3MKE7gM3aaH7mSugaGyqEZ1SWKC9WfbQ
         3DKbJo5qS8KK3BGmqZfMJ8ex7bvzRg7Zq+Y7m1ToXCz8OT7nCERgI5Cw1QMGQTT2P8lb
         PwbcxeTIaIIK9tt1u8FXvp6ykTAV+t3/NqCuaD4wDckJ0YCwt0AHhREGEQ5HyRoG012g
         yUvWpeGSQlhaMGI3ATLZ8w8vUseiwRpNLVdZkkwf2AzRW//cc11Yum5gy9u8UEBFvOrk
         oKNp90pnGER6+8Ddft23zvnxgXCdvFloR4HbOBmP6dzmx6usVvRA/kyXruu+zLlJ9oHE
         9Hiw==
X-Gm-Message-State: ACrzQf09jsQKfgNHQHauV8nRJ316iS/ksYFQ5qtLIw8hM35Qxyp35NLD
        WpTNbdxBjYhwDzhOgkGeuEWgcA==
X-Google-Smtp-Source: AMsMyM7aoCdu9WHwG285Neg6d4thYouvRN6KfDb/QxWK+gc0PVmrUK/EJD+sPkftZalwKRWmRkCIdA==
X-Received: by 2002:a2e:9cf:0:b0:26c:3973:ec1f with SMTP id 198-20020a2e09cf000000b0026c3973ec1fmr1321095ljj.322.1664460028783;
        Thu, 29 Sep 2022 07:00:28 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id dt18-20020a0565122a9200b0049c86ca95bfsm794048lfb.52.2022.09.29.07.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 07:00:27 -0700 (PDT)
Message-ID: <88035bdd-3aeb-640e-c001-8823013e5929@linaro.org>
Date:   Thu, 29 Sep 2022 16:00:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use
 pm_runtime_resume_and_get()"
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
References: <20220929131528.217502-1-krzysztof.kozlowski@linaro.org>
 <YzWgescSJMKzYTAo@sirena.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YzWgescSJMKzYTAo@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/09/2022 15:41, Mark Brown wrote:
> On Thu, Sep 29, 2022 at 03:15:28PM +0200, Krzysztof Kozlowski wrote:
> 
>> Cc: <stable@vger.kernel.org>
>> Fixes: ddea4bbf287b ("ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()")
> 
> That commit isn't in a released kernel.

Oh, indeed, thanks. I'll send a v2 without it.

Best regards,
Krzysztof

