Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7E446494
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 15:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhKEOGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 10:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhKEOGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 10:06:45 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C23C061205
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 07:04:05 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v127so7127274wme.5
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 07:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eRUkcnCsnW/Jzom+fJQ9Oipyz+BV70fkQqo1JE5ywEA=;
        b=cXPj0JABQ+GK1CEytrm6xlSeCoC9XwJ1CfhKZdPkRfSxvEUkzoM/ysmGThm3oJpvNa
         62LQSfxa8K1+HhVHR/+SJQzyuqGD076s8Ly/moUKR7KOXxObdWlNTbrQ28F5d2ojdlVp
         Snfv57tHUpWo67DPyEeQSIhlzfOP9hnqmKGBftgeRlGxEFRGQujqcD7vth5N3iU0jMK8
         kXUaiMMjoK1DCTYlyiIErVW+RYqgvlYMJU5iVHbyFrjlI1mlwOoKdd0oBvovuiNzuKyK
         zqTpjzzYCgRE2NNYEsIswXj3GyB299wu/XCmYGd4SkVnbCJzpgZravvgkKajjGof68FK
         FH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eRUkcnCsnW/Jzom+fJQ9Oipyz+BV70fkQqo1JE5ywEA=;
        b=PETqj1Tib/cydludWGcVmVYKLoXT81dS/sGvqqNI7gabFhhgnBxY152GXvW9rwsjO2
         MsO4fZ6c+WPnxH2AN7b6MZKuSNYjVWV44Dnvk2RlXLPVM/1duqV22DESRMusGuRtTdzN
         Vsz1lcvIV2TFVzGHpUnVWOas+BrEulZNabSymzCjNP31/VyiHV6f+eqo2K0sCEt2yhd3
         1y0RLzcPj12ZP0hg+qjSM/llM9HPqWCNh8uVlNAiIOA7IO9f0l90kibYAkYePgTGqlS+
         tzoI9pRMebhlynPU+gYcbAo3Nbi5CCjVUT2q77VAitOdQuJimD9yePxI3L2lzkNrcp9X
         MUXA==
X-Gm-Message-State: AOAM5321M++HaJ0JIvDiwTsRS9S8q5q66KwBwJKSm8g0s1IgKJbVJKOU
        DVZN+/yJc3OCSO+Jhbudr2bwlQ==
X-Google-Smtp-Source: ABdhPJweRjIy2I0BF+5yqtXWRpmY9TSE1UB7YhjgzcsASgtRjHCvCizFmbEh43py53M433Nyf7DHIw==
X-Received: by 2002:a05:600c:2195:: with SMTP id e21mr31062039wme.187.1636121044500;
        Fri, 05 Nov 2021 07:04:04 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id c17sm8213987wmk.23.2021.11.05.07.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 07:04:03 -0700 (PDT)
Message-ID: <ff8187bb-a9ab-11a1-f658-911c1b601ce7@linaro.org>
Date:   Fri, 5 Nov 2021 14:06:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 5.10 14/16] Revert "wcn36xx: Disable bmps when encryption
 is disabled"
Content-Language: en-US
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
References: <20211104141159.561284732@linuxfoundation.org>
 <20211104141200.061783376@linuxfoundation.org> <20211105131848.GA9566@amd>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <20211105131848.GA9566@amd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/11/2021 13:18, Pavel Machek wrote:
> This explains why revert is a good idea for mainline, but it may still
> cause problems for 5.10. Is someone able to test it in 5.10?
> 
> Best regards,
> 								Pavel

I have to pull in a bunch of out-of-tree patches to boot on the target 
device but..

Sure, I can have a look over the weekend

---
bod
