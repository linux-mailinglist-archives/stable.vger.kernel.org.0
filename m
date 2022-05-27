Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49935368ED
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 00:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352798AbiE0WkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 18:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345610AbiE0WkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 18:40:20 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CD962A13;
        Fri, 27 May 2022 15:40:20 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id x28-20020a4a621c000000b0040e85d338f2so1038400ooc.5;
        Fri, 27 May 2022 15:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TurEXzANC1uCu7/KYQmjxeuFlXYOHJCivWzkXb/t5Fw=;
        b=Kwleiu7GHa02IBkDO5Msh8Am0ncuIYKwE61eBe30HSTRgS0KtVc3BDHh5Gtc30A7pu
         rqstyY/yE9JM+Xc5ezi3fERiAFsVxBl5dHo6xBvmKVM+b+cdennbFMqbAiHU4r1TuVO8
         4pXfSsoQ1lorY+oNDSH0N6VZ599NLOXHDZw7STT0nCTqSJKK53rSh47fE6deybjAUaPW
         eo9fw2vmkuodpFJSutdLJ2RuXElEYMNPsO+INns/7P1lHIdm+luwdYOGP2XkuVPJ8BB+
         UETMxqXnlFkxYyBPH5Cw1QJcUth2iCZz8mu+ukYUODbqwuLpfIUxNarFQBQZFmdI+tOS
         nq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=TurEXzANC1uCu7/KYQmjxeuFlXYOHJCivWzkXb/t5Fw=;
        b=mJ7o4ugHG0XeWBFKfpsb60DiogtkI4UAwztPKi/tVN/uTyied+F4//h7SsRlEPmpAI
         i8JfYna4JXdl0H9RIBgmRAtmQjBoWUnF4Czq2YlbVKhOwByNDHE914NtFChhovyNDPM4
         lkmEKZipX6mMm6Bvvnlhwk7LFbaeCSKwpQq52gOkLcS0b3vs8JaH6gEi1GkwoLW23CL4
         /g1OyhOQrpwXIWROsq4D28e98pFPnNMv660sTcd3bK5y2yRhA7+BYjYC+GxgRjdGdK2J
         Rl+AVZ5oK22xUq7ccTaGfd7SDN2HAghaYV6pyOf0SuJw6ICh8i7YRSxPbCOAPKuVKkEP
         HujA==
X-Gm-Message-State: AOAM532zZ9M4OP2xAAVlF9ZePQcxQ+lBq4PAYAOZh290rnxYS1SkakUx
        WMJrZKw58qDnlOfJrfUjyS0=
X-Google-Smtp-Source: ABdhPJzihOrziCfHYSna/8aAHcwds175PE2lDpyw0ZMQ6K7Q+wnKWqSb5w0gx9N0hrLbnkwtxk5dcA==
X-Received: by 2002:a4a:b307:0:b0:324:c7f2:386 with SMTP id m7-20020a4ab307000000b00324c7f20386mr17816713ooo.18.1653691219834;
        Fri, 27 May 2022 15:40:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g19-20020a9d6493000000b0060aeb49fdd4sm2250385otl.79.2022.05.27.15.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 15:40:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 27 May 2022 15:40:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/47] 5.18.1-rc1 review
Message-ID: <20220527224018.GE3166370@roeck-us.net>
References: <20220527084801.223648383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:49:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.1 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:45 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
