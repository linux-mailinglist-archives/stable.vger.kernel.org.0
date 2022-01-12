Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0B48CB3D
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356475AbiALSrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 13:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356483AbiALSrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 13:47:31 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359F5C061751
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 10:47:31 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso14060096pje.0
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 10:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ej6+dzQXYBNYBghW2L5wnTD1qTCyFwEQze4u8PLMM8c=;
        b=k9T3MzlCu7qh8lbrZMe83Xi2hfmMkadDB+O1cBHpL7WOorRnSxHeHwXL9Ssk3f0wmd
         hS+rh67RzV4VyThVS7uI3PzlZ5Y2TQ+CssEiAKxtGvTQP1rpm7OeHzduw3rRGnB8GzcO
         cxzrrXYYYTYI32kxY3ywU9+MVbZP2M5NSd0pnY/1X3so+evKJxUfw6oBj1V+eYOEhofk
         bWDDeZHW1s5meAJywrAU407L/RM6zu81HK8CzU6LdABFlX1qZXRAK6S9mG5Nx2t8cu9l
         CLf772yfZwKv6neNpkSbSCyYLzTdrIAOv9dH8ag8PZiISwSSi6PU6uWLR1JH0y3xmxjM
         0rHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ej6+dzQXYBNYBghW2L5wnTD1qTCyFwEQze4u8PLMM8c=;
        b=yGg40Q1L5FHuHJsaXbzo7VAXYrnXBUviSEZfwef8mXW2VJ9aXF8acfxx1Z8TfjwvD6
         Xy7154m+tbXfVoHcIBY7kDIZzSXkZe2b/rY2i43TX26Gq1hRAFZR1+yIeGkxLdqjl1Sp
         kETSCW9ZYxVXmSOlCPVo4wjPlUsZUlTSspN6eSgWwo54Du/7c+M54oA3VPRtedOfufNy
         eFUybRVWHe37RH+uXTnhVrOCJEdKOUznSJuKmDZJi+I3ij2DUIAl8iG83D9sNErIfKV3
         yzMF2Ekw3db2M4hu1dBQ8k9bQQOCN1hBfyiuuMFWYxSE8lYkIvgwcMvzqb82Fak7R9vO
         19iQ==
X-Gm-Message-State: AOAM531rRb1qSLZWT0dsk8f9knrbqHrhBWdr7dCPvPOwO1NF2HFTvsnY
        tigU9xNCl8WXpKB5bUzqazZM1w==
X-Google-Smtp-Source: ABdhPJzFpL8XksOuR6w6J5ddL6p8mmeC1OPP8IFYeXebroqx48h3ogwBFXpq6MS1gdcueN+4pULAKA==
X-Received: by 2002:a17:90b:3910:: with SMTP id ob16mr10314729pjb.181.1642013250654;
        Wed, 12 Jan 2022 10:47:30 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id gt22sm367722pjb.35.2022.01.12.10.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 10:47:30 -0800 (PST)
Message-ID: <3c2eeee7-0d3e-8000-67ad-3054f229cbe0@linaro.org>
Date:   Wed, 12 Jan 2022 10:47:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 1/2] tpm: Fix error handling in async work
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Tadeusz Struk <tstruk@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220111055228.1830-1-tstruk@gmail.com> <Yd8fY/wixkXhXEFH@iki.fi>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <Yd8fY/wixkXhXEFH@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/12/22 10:35, Jarkko Sakkinen wrote:
> These look good to me! Thank you. I'm in process of compiling a test
> kernel.

Thanks Jarkko,
You can run the new test before and after applying the change and see
how it behaves. Also just noticed a mistake in the comment, sorry but
it was quite late when I sent it.

+	/*
+	 * If ret is > 0 then tpm_dev_transmit returned the size of the
+	 * response. If ret is < 0 then tpm_dev_transmit failed and
+	 * returned a return code.
+	 */

In the above could you please replace:

s/returned a return code/returned an error code/

before applying the patch. I would appreciate that.

-- 
Thanks,
Tadeusz
