Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E486656C2B
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 15:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiL0Oqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 09:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiL0Oqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 09:46:43 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A84A101
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 06:46:41 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ud5so32400531ejc.4
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 06:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jftR37JDPZhhDCefSRbq5JLiyo4/OB0mmFtDa14MfrU=;
        b=Ut1jV9fiZF0EMh/I5rK/wNnrD9neIh4Mbz2by75q5UwOVQQq/9ybjJwCLiBv1WZb37
         2doyUY03hhrSZ3/2ZH9kJueWq4X6jgNX7rv5cxwxNTiV09JwIezBr1BKfn7xpwwf95H7
         WPWRc/WsGa5EiV3sJNeE9S0YpFWCbaZb/NTPQ006NVCbERIQgRuhsX2Y7JMNagBe8ni2
         Z04Co1GNVr/CkTjjCq1FBNLgc+DsuEMypS4nMO7kkWUltxQzgbjYoLZ3qHR4jQilUkWq
         5QnqoQjzYXRyCnVsMLzRH7QvPrpJEB3oqjOW19exQlzFIdtRQSMZvoRSgXWVwlpsx0Iv
         cSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jftR37JDPZhhDCefSRbq5JLiyo4/OB0mmFtDa14MfrU=;
        b=ba+Dv99rW51l+uJW18ZCgSsz30coVxyQhXtpHbC1GzR0V6XaTmoVL3DwOd1QM+trX2
         q9fqe0WMkbsQtMGAWMoC58/SnI7m1sS93E8M40NQN/9JLXfUasjTSGe0DfOsUB9jAruN
         3FVd5C/VIdgAhSdm70NfdRiXHM7023CrO8WftqNbkpu5GhkU9KzB4eD0AN75tRVfpZno
         tH6rGe75vslhNabrRKIx4TtcLiGF3c4+PX1gWs0XH7PNnUGH9u+Myknhp4wOlXcMMI9/
         eJjX9pxGUKsZOKUT3dPGSAHD/XfpZjy2HwWtXU/C2XQBJLrZL4TpAMWXa+DLLxZT/du8
         3+YQ==
X-Gm-Message-State: AFqh2kq3o3kPT2l0vmMFd88jjMSXmVkH0DA1qUEVIktDjM4q3DT8FoKU
        yot/OIkhJrS91uA+KUeNXOnMZIzyaBfeQw==
X-Google-Smtp-Source: AMrXdXt/FMi8HPCMHBv/HJkH/IEj0UADwY03Mkk9wmrMngAqf1d9p0CQgGlX37N3xI9Gp1ww366a0w==
X-Received: by 2002:a17:906:724b:b0:7c1:7669:629 with SMTP id n11-20020a170906724b00b007c176690629mr18581452ejk.49.1672152399480;
        Tue, 27 Dec 2022 06:46:39 -0800 (PST)
Received: from [192.168.10.127] (net-188-216-175-96.cust.vodafonedsl.it. [188.216.175.96])
        by smtp.gmail.com with ESMTPSA id t20-20020a170906949400b007c10bb5b4b8sm6131867ejx.224.2022.12.27.06.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 06:46:38 -0800 (PST)
Message-ID: <18216b2c-d5f8-ada5-6110-192895772cbf@gmail.com>
Date:   Tue, 27 Dec 2022 15:46:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Possible regression with kernel 6.1.0 freezing (6.0.14 is fine)
 on haswell laptop (issue identified and patch already available)
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
 <Y6W6Qxwq94y9QGFl@kroah.com> <38cd1c38-b469-f25d-369e-57877865fdbb@gmail.com>
 <8c3034f1-bedd-0e43-46e5-1e1fdca238a5@leemhuis.info>
Content-Language: en-US
From:   Sergio Callegari <sergio.callegari@gmail.com>
In-Reply-To: <8c3034f1-bedd-0e43-46e5-1e1fdca238a5@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My issue was the one described in 
https://patchwork.kernel.org/project/linux-wireless/patch/20221217085624.52077-1-nbd@nbd.name/

Thanks!

Sergio

On 24/12/2022 06:22, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker.
>
> On 23.12.22 20:51, Sergio Callegari wrote:
>> On 23/12/2022 15:25, Greg KH wrote:
>>
>>> Reported to the distro, but seems serious enough to report here too.
> Out of curiosity: where?
>
>>> Can you use 'git bisect' to find the offending commit?
>> Must learn a bit more about the distro I am using and what it requires
>> for a custom kernel but I may try.
> I'm writing a document I plan to submit for inclusion that might be of
> help for you:
>
> http://www.leemhuis.info/files/misc/How%20to%20quickly%20build%20a%20Linux%20kernel%20%e2%80%94%20The%20Linux%20Kernel%20documentation.html
>
> It doesn't cover bisection, I left that for later (and maybe separate
> document), as I want this one reviewed and merged first.
>
> Ciao, Thorsten
