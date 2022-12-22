Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C467D654171
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 14:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbiLVNBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 08:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbiLVNBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 08:01:41 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857BFDF7F
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 05:01:36 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qk9so4758833ejc.3
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 05:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rbavzlc4Bw8Z/v5DZKRqyI5fqrkF3zyQ0FpajSOg87A=;
        b=KeN3qk5ceYjn02YPthf1HZfHYDiCir/vsa+yOfoenxeY0JoHuM2ClXD71AtesBuJYI
         dz9m3oUWVKFMWpJjDU/ictBRy8x+TIyo3Z9BEnzL3dyjpMKRQ0gZsScP6vHrphV9aTku
         7Rm3KjZsGW2DCR1AeFcbWoG+x7g9O4uxSHoFtHJ8j/Vnkd20XI6QrqWaY3q83sz2rAMd
         g5VWiOh9Pu7x8BTlvqqyypOv8mGtY/jRupWJkpcTRB7iNGvDAEOsZhuyKXNiyI0BAl+e
         fzEFQH3cfPk0o2ex6bYFEAz6ssztO6Wl9pS+4WviRWv5OGM6phszlD6k6hyXI7DLmM/t
         Kl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rbavzlc4Bw8Z/v5DZKRqyI5fqrkF3zyQ0FpajSOg87A=;
        b=F16X0LUfpwBGSeuPJUXkHPxm6H0zkWiEr2QD1ryvKhehOgg3vxv16r50f73w0VQmcK
         1ocoCbC5Sx1cNMn5R4eohWBwBY5FZUZ9i5FGQgs0jed8r/13W5/9k1KvFc+dEfkblOoA
         GF8o8I5M5vyD61n1vfP3qkW3mmtwtbgH8IfgwjUQsg1MMg0BWJTourwxPqmWq7Op464s
         27szrwEEOJgLW09+D51rE7PROqHFHhcKsYTi65UawfzlsrPSo5HVXuFkuz/yKTxlsjUs
         SakTBwPwXUTpMXgNotndpGOXFIRnpb4cWheqzrdCPTJU2ETWncfzB2h+/YpZ53jfBkpX
         +OUg==
X-Gm-Message-State: AFqh2koF8X5uIUWmOOxR9GvAr67LTv9+Df+Nk1emWGHEwF8A+huOcLL3
        EFut2R9vMkz0Vgy7BUoV5IKHyg==
X-Google-Smtp-Source: AMrXdXt5QMW8Cdt06g0rbKV7kERm4JFQIJXzEHfozhef4SE14EbEjp4wGwpJ0RxuX5M9GkZVqCp79w==
X-Received: by 2002:a17:907:8b11:b0:81b:fbff:a7cc with SMTP id sz17-20020a1709078b1100b0081bfbffa7ccmr4710225ejc.18.1671714095071;
        Thu, 22 Dec 2022 05:01:35 -0800 (PST)
Received: from [192.168.0.104] ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b0080345493023sm217542ejt.167.2022.12.22.05.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 05:01:34 -0800 (PST)
Message-ID: <5fe3c17b-44c3-1e1a-9ac5-1db8766120f4@linaro.org>
Date:   Thu, 22 Dec 2022 15:01:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] Documentation: stable: Add rule on what kind of patches
 are accepted
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>, gregkh@linuxfoundation.org,
        sashal@kernel.org, corbet@lwn.net
Cc:     stable@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, joneslee@google.com
References: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
 <4fbc9e89-24af-9d59-dab0-73925ac94df1@gmail.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <4fbc9e89-24af-9d59-dab0-73925ac94df1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 22.12.2022 14:56, Bagas Sanjaya wrote:
> On 12/22/22 16:16, Tudor Ambarus wrote:
>> The list of rules on what kind of patches are accepted, and which ones
>> are not into the “-stable” tree, did not mention anything about new
>> features and let the reader use its own judgement. One may be under the
>> impression that new features are not accepted at all, but that's not true:
>> new features are not accepted unless they fix a reported problem.
>> Update documentation with missing rule.
>>
> 
> Are there any other examples of problems that can "only" be solved by
> introducing new features? Or new huge features that are virtually
> harder to backport?
> 

Here's an example:
https://lore.kernel.org/linux-kernel/20221222083545.1972489-1-tudor.ambarus@linaro.org/
