Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0288A4EE1B5
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 21:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbiCaTa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 15:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240707AbiCaTaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 15:30:25 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642355623C
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 12:28:36 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id z7so729817iom.1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 12:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KDv50hCOMSNm4tqOFej1XxVHswnaiqBQ/Ql5PRaAElM=;
        b=hr3WMnbNxfXX92/Y0t14FpEIS4pC+09DAI6p4oWqZgWnX03dIRuX74ev7qupnrKxzX
         n5Cz8IINdInr4rUCepEci1G0mhVdD9KS789z+ALBCwmklBUAZ+nFdcApJvLiaQ6DE1h6
         gsrrPum6Nsrl58HvbzUvPWVrmzlfcNkgPf0Os=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KDv50hCOMSNm4tqOFej1XxVHswnaiqBQ/Ql5PRaAElM=;
        b=hLsGRHGvM6hl7rwKfM9I9w6IFPjw9MprMZJ/arL/fsp5IfCuYbCCenKT/DsshtmgjC
         kt6AyX9339FfhoQF0lKEySE129neiqD0bsKN5QNFxP8WNVLCGRnhB3nP82cZbpYm/2wR
         ywt297HV9Kyfg3HtAJMB0Gz84PQ2k32heNFEDyYAb+YLvyEnVX9qAdiVqBZtpumAjmQM
         ra1QVhS0qiK3eIuw/fyW1hDqvlK3AW3OolF314GFPnLeWB0nyPQXLgGdphbGzk0HJTYQ
         9yV/PRNXsnhAh9Wn/Agljn2po8Esx8m/gAZLZUBjr6pmwx5HsVYKvCw894MAO/XdHUlC
         qPeQ==
X-Gm-Message-State: AOAM532Bc5MYyJXLw/F+gWZyLmxLKR3PkFiAhIQ7ezw9XIsE3pxNBLfN
        30axEYDcUicOE3OmWvVsZ+LWkg==
X-Google-Smtp-Source: ABdhPJxfJ3AXDmXIug9uhpRb3ABjQOmyzzRYZ0nfXa4ivrk5be6vqTiSy892fiqB2bYpvFEb5d7u9Q==
X-Received: by 2002:a02:7fc9:0:b0:323:6239:cfdb with SMTP id r192-20020a027fc9000000b003236239cfdbmr3849890jac.186.1648754915705;
        Thu, 31 Mar 2022 12:28:35 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id k12-20020a056e02156c00b002c9ad2b3dc4sm168559ilu.74.2022.03.31.12.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 12:28:35 -0700 (PDT)
Subject: Re: [PATCH] selftest/vm: clarify error statement in gup_test
To:     Sidhartha Kumar <sidhartha.kumar@oracle.com>, shuah@kernel.org,
        akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220330215257.112029-1-sidhartha.kumar@oracle.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9a752af3-8e3f-bfc5-eb24-eadcaf800bd5@linuxfoundation.org>
Date:   Thu, 31 Mar 2022 13:28:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220330215257.112029-1-sidhartha.kumar@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/30/22 3:52 PM, Sidhartha Kumar wrote:
> Print two possible reasons /sys/kernel/debug/gup_test
> cannot be opened to help users of this test diagnose
> failures.
> 

Thank you for the patch to improve rather cryptic error messages.

> Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Cc: stable@vger.kernel.org # 5.15+
> ---
>   tools/testing/selftests/vm/gup_test.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/gup_test.c b/tools/testing/selftests/vm/gup_test.c
> index fe043f67798b0..c496bcefa7a0e 100644
> --- a/tools/testing/selftests/vm/gup_test.c
> +++ b/tools/testing/selftests/vm/gup_test.c
> @@ -205,7 +205,9 @@ int main(int argc, char **argv)
>   
>   	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
>   	if (gup_fd == -1) {
> -		perror("open");
> +		perror("failed to open /sys/kernel/debug/gup_test");
> +		printf("check if CONFIG_GUP_TEST is enabled in kernel config\n");
> +		printf("check if debugfs is mounted at /sys/kernel/debug\n");

Instead of adding 3 messages in a row, please check the errno to figure
out why it failed and print an appropriate message.

If open fails because CONFIG_GUP_TEST is not enabled, the test should skip
the test instead of fail. Failing will indicate a test failure which is not
the case. The test couldn't be run due to unmet dependencies.

This test requires root access. A check for root privilege and skip the
test for the same reason stated above.

>   		exit(1);
>   	}
>   
> 

Please send v2 with these changes.

thanks,
-- Shuah
