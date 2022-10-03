Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F35F31EE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 16:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJCO0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 10:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJCO0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 10:26:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C374652473;
        Mon,  3 Oct 2022 07:26:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f140so5083617pfa.1;
        Mon, 03 Oct 2022 07:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=PzeAeqaSZJKBd05JeUXPdyknHEc39T8yXo+LnmqsF1U=;
        b=aoWSq74qJ9REl0zIgLaa0KgGPLWE/DZat1fE5kBaoooiAO74YJ/nBCOlZpXi9AwwMe
         uWQRZmOFd8BbD30eCn3LcWjW59TRPjLOo16cT7kXQqXTXodb3zpiXnqlFuwIjbQ93/5x
         twWHQeHpSeIiraZq89TpsXJHOWCJe4hUCe9G+6bl8kKfPeNRXlagzMTmk9uDZMHpyDqO
         RCR2J2yKpViO1NY1qAOOyZsu+A44AnTP4ZcDM9xM/q+CznDl/LHo2881W0lf82N2f0YV
         c4gtnfUBAGglL6WmQhaXJm9pgia0r0GC+EtBi43AEPw5Bsd2lRutNVGphVc7Xb7KQADF
         LgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=PzeAeqaSZJKBd05JeUXPdyknHEc39T8yXo+LnmqsF1U=;
        b=BgSQ5zVA/FpOwM1RoT/YR8BAtxHRTxY0oKz8RKQMThszzN8NkJT2k3IBigB+W+PdUE
         +tNaWaK/u8TYENk8gK5izcYQxXJPMTAbgnQH3QkXUaqTUWFMVHfjBjMrGtFlzpv+2XYc
         J7m2OnIpKcGYe01FwmxyIEnxzjkz9On0+xvOw7NiXj+YIMfiwex0d/ZraGy3dz5025Fi
         HCZDsgKsqC5jmF2ceXzD4uc4stiTrnJiS3CYwNGMx2rCSpJfnDitnpIQsH2UEE6BR0t3
         FESWsqNhWc01lIa442CVS3mcpiV52JW52VCimdx6jsrw87xyi0Hez5jWWfBpSBUcHIkm
         m6PA==
X-Gm-Message-State: ACrzQf217xfWWJUgSQOEA2lr3kEqWeD6K2Z081ZjuH4JfZD0Fv2JMTu/
        un3l1H+70RwKglvw2P9WByE=
X-Google-Smtp-Source: AMsMyM4/lGKwKkkCLaecjdWTR9NKfpIwm7cNoRA9R2HWACqOlgNofTHlrf9fBye2umpmYcNNNMtIQw==
X-Received: by 2002:a63:204a:0:b0:439:1802:dd99 with SMTP id r10-20020a63204a000000b004391802dd99mr19275061pgm.153.1664807206267;
        Mon, 03 Oct 2022 07:26:46 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e7-20020a170902ef4700b0017b264a2d4asm1589738plx.44.2022.10.03.07.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 07:26:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e7934bdb-fb0a-76cd-0fd2-f9b8da03170d@roeck-us.net>
Date:   Mon, 3 Oct 2022 07:26:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221003070721.971297651@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 00:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 

perf fails to build.

In file included from util/evlist.h:13,
                  from builtin-annotate.c:21:
util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
       |                                      ^~~~~~~~~~~~~
       |                                      PERF_TXN_MAX
In file included from util/hist.h:8,
                  from builtin-diff.c:13:
util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
       |                                      ^~~~~~~~~~~~~
       |                                      PERF_TXN_MAX
In file included from util/evlist.h:13,
                  from builtin-evlist.c:11:
util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
       |                                      ^~~~~~~~~~~~~
       |                                      PERF_TXN_MAX
In file included from tools/perf/util/evlist.h:13,
                  from builtin-ftrace.c:24:
tools/perf/util/evsel.h:266:38: error: ‘PERF_TOOL_MAX’ undeclared here (not in a function); did you mean ‘PERF_TXN_MAX’?
   266 | extern const char *evsel__tool_names[PERF_TOOL_MAX];
       |                                      ^~~~~~~~~~~~~
       |                                      PERF_TXN_MAX
builtin-annotate.c: In function ‘cmd_annotate’:
builtin-annotate.c:594:8: error: implicit declaration of function ‘symbol__validate_sym_arguments’ [-Werror=implicit-function-declaration]
   594 |  ret = symbol__validate_sym_arguments();
       |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Guenter
