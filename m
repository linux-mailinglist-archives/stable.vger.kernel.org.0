Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2951F488
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 08:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiEIGcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 02:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiEIG2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 02:28:55 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DC611C376;
        Sun,  8 May 2022 23:24:36 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id d5so17929811wrb.6;
        Sun, 08 May 2022 23:24:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qtvtpCHrfy93i/AbWxDWLtbfIRHMiPM8nYvhcA78xXU=;
        b=EPLAdtTpo2QZPtF2HbhduxU07sw9IF/EKlpG8DpfANtmltO8i+qX/XRcT04MGwGa9t
         T+LubQfynbX3Sk+O85op+0oiECyD2NFTWEnHYoibSI+1P1Th5vmUXZDGd8AJjMlZGsk6
         n8GmuDWWx19WEwnRmsPHX3Y3rcji05hLrlsjkYXUyAMViqzCSQMSnupqDdm+GbQavEHq
         exaBK1AX6jZZ3w+dx2ah4PWiRg+LWKam7Vg0Cd3rHYe4plH2s+1ltyusTrwHDEkMP/NC
         Kzy0utxmjBnf4cBt16rLNjaYvnW+sXAzCuja/5Wwml87m6Y84ym8WthUomaXUaEFurAi
         X3KA==
X-Gm-Message-State: AOAM5304wMcrO9hQoJwAkJDDFEtxC4f9f1nsS+ZIuXbTy68wgh69FNxL
        ibVtMlLA1lSIY4kpvJ02tks=
X-Google-Smtp-Source: ABdhPJzfvVlWA7RIQyopwXpPTSq2utg0p+L5RrRy+sJq+0WsgQO9SYb4Y1so1BcxBaPDuOS4HG5wxg==
X-Received: by 2002:a5d:4148:0:b0:20a:d2de:d960 with SMTP id c8-20020a5d4148000000b0020ad2ded960mr12454920wrq.61.1652077421131;
        Sun, 08 May 2022 23:23:41 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d67ca000000b0020c5253d8cfsm12156105wrw.27.2022.05.08.23.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 23:23:40 -0700 (PDT)
Message-ID: <a36ad1b1-a6e1-4a80-cedf-a18dbab06fd4@kernel.org>
Date:   Mon, 9 May 2022 08:23:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.17 000/225] 5.17.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220504153110.096069935@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04. 05. 22, 18:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.6 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.

After the drop of "ASoC: Intel: sof_es8336: Add a quirk for Huawei 
Matebook D15", openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs
