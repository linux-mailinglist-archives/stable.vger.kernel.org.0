Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FEE6A15D4
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 05:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjBXE1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 23:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBXE1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 23:27:14 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFBD2A6D9;
        Thu, 23 Feb 2023 20:27:12 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id b12so4031221ils.8;
        Thu, 23 Feb 2023 20:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=t+DpcZDS2FvDgnuMoKZFyv7FRUek1ue38SSe6bohPe0=;
        b=RU4EE9eHQ2IgOSNy4B0fyMUnX+s3TpS9bbx7ql0OKkQouTzemsqLnUYKSTFPURkNtK
         OEuC1hR+r5Qc4XD3VLkoQQtZp1LqQBPVgOAVzmhMiv2yRElrAFsq6Vz4NyTmFU6wzB/q
         0ORLASft8jUYOrvDVECBvopyvM2/zPVyrlyvn+6A5GUSRlL8T7dqrADhxrfMzR/qHaV+
         9EpmyJ8yXsWh7vw+bEmRZmwTFYx57a+WUQm4ZrSvNIjhe3yPs2XMAH5R3OxBTNzm/vBu
         bI006IFzP4nUKg6nn9otByoURZhobbqVSTRhnNiSZH/GH6LXww99jgQ1A4XeOkbvlv7r
         Rb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t+DpcZDS2FvDgnuMoKZFyv7FRUek1ue38SSe6bohPe0=;
        b=UA91Wl0OH5Yz7Kspl10gK74stcqNrQnqCL80cINWaAJw5f2qIXUNnXzYlIzvlbYse0
         30Sbk2zDPN4cbinERbuJHtpE1L2yssW9sb+LVFwVLoUPbwboe1Maaf2WabKzi9GBEfm4
         vRZyd+2HAYmrf8urvKYYjwyNpBS1/NN8ebgho5G0C4mHa2Bsc4zZ6sZ5GcGDkGJoPZbh
         iqmMjMZDVFQOc4WB0El7I6GyP8BtVg1k4Z1gttX4aL4maIxQouDLvRo7xTh4dHepHz4Z
         ibI/mN4tDH1VHqK+fEohMd7lrUNlhcXB2dtk09g3X+2MNgQotQQAx8doM8TMoJq+Yhl0
         5SqQ==
X-Gm-Message-State: AO0yUKUX/GXOHR7ZS80Pa9zcSqn8atJ6dHpgRiZthQgec6BvjLPYAjSn
        C7+JNJ2827wOenQ/YLPyEO0vLbN17Xs=
X-Google-Smtp-Source: AK7set+B1PgxUeVhk+CzJ4fyVf8B8ploSe4nm1k86TpZlF+Hcie3ifEl1mbTCuOVSXi/FEqcbcUmkA==
X-Received: by 2002:a05:6e02:1988:b0:316:f93f:6baa with SMTP id g8-20020a056e02198800b00316f93f6baamr6387299ilf.31.1677212832290;
        Thu, 23 Feb 2023 20:27:12 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a9-20020a056e0208a900b0031578323bc5sm3305138ilt.56.2023.02.23.20.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 20:27:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <805e4f64-84d4-37a8-2529-8ed65395ab56@roeck-us.net>
Date:   Thu, 23 Feb 2023 20:27:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.14 0/7] 4.14.307-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223130423.369876969@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 05:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.307 release. There are 7 patches in this series, all will be posted as a response to this one.  If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000. Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
