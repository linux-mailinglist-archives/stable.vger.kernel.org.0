Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD4C609E05
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 11:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiJXJaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 05:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiJXJ37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 05:29:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD9222B39
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 02:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666603794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2J+v8LCLfwT0nxLmPoCSTbgMpOXu2TUzd0V0O0TAsnk=;
        b=Nbmng3VOe7CYavtsMbdF03ouqCD8DZOL0mBQk3+a5UBxScwzXe/7rjsz7Z6YJBWTUL1RLU
        KybHh/6u0EdBad6jfG/3KFVfi0o6HJnK5II7YFZVq9qE5hq8TulL+X7skkLy55IEd0aXJ6
        WITJSh8+3MTcyxfBtW8IW0VHj+vcilA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-84-NlIpcOQ5NbGvixlhw1D44w-1; Mon, 24 Oct 2022 05:29:50 -0400
X-MC-Unique: NlIpcOQ5NbGvixlhw1D44w-1
Received: by mail-ed1-f69.google.com with SMTP id y10-20020a056402358a00b0045d5cf18d4cso9075530edc.17
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 02:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2J+v8LCLfwT0nxLmPoCSTbgMpOXu2TUzd0V0O0TAsnk=;
        b=dgB9FRKC5BB7/LsPXrjUbsEoQ9Jm7CYaWwvBMtoyzpqk/v8nFgXH7HmJ9D+i463Skd
         4IFSwBPm37x3OXf2h52wqgHSoB6tMP440KHQlB78wwVzG/N4b97jJvuTxCBycndUaSnE
         TOIah1ua5g2AYZ7BuCrZbAgsRIu/BjrbuOg6cxQj90J7hd0OvflyBUqQwBUcesYa9A3L
         XVzqsn91frZqhPy6qXM8snVKbLQO7XN7jxm+rD6r0fIEplZHr/RsZLi0sNfGQ/ToyTfm
         HEP/q7a8xXdvilPX/3BHSa+TCr/x90nmIgGa9+qrMRU+CPIRP8cUgQl3eu0FdrHmNl/s
         ymvQ==
X-Gm-Message-State: ACrzQf1VXLawQalTipECXFAtErglIG+NC4vAbkuruwZUyysHTRrLX1Lq
        3naAeLhcsTF3a/cuh55w00KUTDf0COpYtQqgr45lVsx31LPXaL5EYZISWw4LNRMw1psoejujonS
        eMPV4qcYgYUU3RKAz
X-Received: by 2002:a17:907:1dec:b0:7aa:6262:f23f with SMTP id og44-20020a1709071dec00b007aa6262f23fmr934864ejc.38.1666603789359;
        Mon, 24 Oct 2022 02:29:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4qNz30I2hXeTcsHVYe0WVAvzWBknQAE9aJQWGh9/9nXVrfMT/BHVig/+ap++AWQpUwtuZGTg==
X-Received: by 2002:a17:907:1dec:b0:7aa:6262:f23f with SMTP id og44-20020a1709071dec00b007aa6262f23fmr934851ejc.38.1666603789179;
        Mon, 24 Oct 2022 02:29:49 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id r27-20020a056402035b00b00459012e5145sm18242902edw.70.2022.10.24.02.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 02:29:48 -0700 (PDT)
Message-ID: <195bfc65-5f51-227b-0c8f-73a87670bb65@redhat.com>
Date:   Mon, 24 Oct 2022 11:29:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/1] platform/x86/amd: pmc: Read SMU version during
 suspend on Cezanne systems
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Anson Tsao <anson.tsao@amd.com>,
        You-Sheng Yang <vicamo.yang@canonical.com>,
        stable@vger.kernel.org, Mark Gross <markgross@kernel.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221020113749.6621-1-mario.limonciello@amd.com>
 <20221020113749.6621-2-mario.limonciello@amd.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221020113749.6621-2-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/20/22 13:37, Mario Limonciello wrote:
> commit b0c07116c8943 ("platform/x86: amd-pmc: Avoid reading SMU version at
> probe time") adjusted the behavior for amd-pmc to avoid reading the SMU version
> at startup but rather on first use to improve boot time.
> 
> However the SMU version is also used to decide whether to place a timer based
> wakeup in the OS_HINT message.  If the idlemask hasn't been read before this
> message was sent then the SMU version will not have been cached.
> 
> Ensure the SMU version has been read before deciding whether or not to run this
> codepath.
> 
> Cc: stable@vger.kernel.org # 6.0
> Reported-by: You-Sheng Yang <vicamo.yang@canonical.com>
> Tested-by: Anson Tsao <anson.tsao@amd.com>
> Fixes: b0c07116c8943 ("platform/x86: amd-pmc: Avoid reading SMU version at probe time")
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Thank you for your patch, I've applied this patch to my review-hans 
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans


> ---
>  drivers/platform/x86/amd/pmc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
> index ce859b300712b..96e790e639a21 100644
> --- a/drivers/platform/x86/amd/pmc.c
> +++ b/drivers/platform/x86/amd/pmc.c
> @@ -663,6 +663,13 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
>  	struct rtc_time tm;
>  	int rc;
>  
> +	/* we haven't yet read SMU version */
> +	if (!pdev->major) {
> +		rc = amd_pmc_get_smu_version(pdev);
> +		if (rc)
> +			return rc;
> +	}
> +
>  	if (pdev->major < 64 || (pdev->major == 64 && pdev->minor < 53))
>  		return 0;
>  

