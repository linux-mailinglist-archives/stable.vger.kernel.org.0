Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED7157ECC7
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 10:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiGWIhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 04:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiGWIhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 04:37:14 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09CC48E90
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 01:37:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bp15so12221702ejb.6
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 01:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X3KeQgkPHY16nye1TlfkQBApLXjT17YE1LOibxMGAoQ=;
        b=Jn1PGrrbcnflGJST+2oJiFEYwUHC3BC3JM+DDaSwuIghVQPU7ceHqv306KVkzpOTk6
         pnAXnZmF2vJT9hRmjmUlVY9wjCbPwFLqJ3hIfjRwTndGbXrAztfM+OB5B5AfyvVdfdh7
         uMYejhnlZdYyxBQUiFM3LrXCk/JuW8VBRo3To9j56DkHM9/+9iXfZfy5VrnB1Faz/SiI
         UpAlAZWGc2xrvSJ6/hvPDwjbzeASB2WgVmvrogu8RqrOG2eq7doZvFcjniUeznd7nX6v
         Sn3G47RHeEeN2cpXGn7XiB1zmxORgNuVjobSodqzk8u7EyAd85kPvwt4veGdFBQHsLwj
         aJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X3KeQgkPHY16nye1TlfkQBApLXjT17YE1LOibxMGAoQ=;
        b=1Yoz9+D8R8Ns9WQ8DHoJ8F4Y4dsv5p2ET6kTsP51qmuUTnmj+JYmsNmh901clako6c
         7RbAy681J53cWmk2EDPNZ3eUAukwmae1xItM7n4gnRsuqarCbLlxtY+WDq2gwLA9RVVR
         2wOcNGAbXDf6InHItCSrs1N1346WmdknzsYiQnQkDEQRh7OXbDJIAhFEMv2dcsXbOMMm
         DiPDOwm5Qe1OQuhhWjxNFCt21o+hDhJ3jsBQAFxGBoAoIXmNfMpZdDBvcQYEqXKQ6o3/
         T6j1SXXopr1BODYlxju9/Ilfu9R55yrIsm+eBcuW0inJlsk+94SeaKqXAbLj6s/tMQl3
         0iaQ==
X-Gm-Message-State: AJIora+PvZnyce5OQKuBiuREdW+qerhFG631lySBIlYJgLkfOBR+jH9P
        jPIlMGADKNvVXg+KTuP2OVZCm/+o+FOnDQ==
X-Google-Smtp-Source: AGRyM1u3H+L0jl3Mj8fzXIxMpeaVyjrqtJBmB0fD0lVoO2beDiuozpCwVMvCdWdRGtOp7Yl6WO34NQ==
X-Received: by 2002:a17:907:760f:b0:72b:7eb4:be52 with SMTP id jx15-20020a170907760f00b0072b7eb4be52mr2775678ejc.737.1658565432153;
        Sat, 23 Jul 2022 01:37:12 -0700 (PDT)
Received: from ?IPV6:2003:f6:af33:9600:9c72:8d47:64a7:9cdf? (p200300f6af3396009c728d4764a79cdf.dip0.t-ipconnect.de. [2003:f6:af33:9600:9c72:8d47:64a7:9cdf])
        by smtp.gmail.com with ESMTPSA id s25-20020a056402165900b0043bc19efc15sm3685484edx.28.2022.07.23.01.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jul 2022 01:37:11 -0700 (PDT)
Message-ID: <f5b1e4e6-28bb-9c92-8939-e49db8cba0dd@gmail.com>
Date:   Sat, 23 Jul 2022 10:37:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.9 1/1] security,selinux,smack: kill security_task_wait
 hook
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20220711095608.4723-1-theflamefire89@gmail.com>
 <20220711095608.4723-2-theflamefire89@gmail.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <20220711095608.4723-2-theflamefire89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

after the previous discussion about what kind of patches are acceptable for stable
and your hints on how to send them to the ML in https://lore.kernel.org/all/YsrfDfe3urGkepvJ@kroah.com/
I'd like to know if this patch meets the requirements and if it can be considered.

I do have a few more similar ones which I think meet the stable requirements
and finally the init-cleanup patch
(upstream 3dfc9b02864bt "LSM: Initialize security_hook_heads upon registration.")
which I'd like to backport to 4.9. But first I want to know whether I now got
the formal requirements right before sending further patches.

Thanks,
Alex


On 11.07.22 11:56, Alexander Grund wrote:
> From: Stephen Smalley <sds@tycho.nsa.gov>
> 
> commit 3a2f5a59a695a73e0cde9a61e0feae5fa730e936 upstream.
> 
> As reported by yangshukui, a permission denial from security_task_wait()
> can lead to a soft lockup in zap_pid_ns_processes() since it only expects
> sys_wait4() to return 0 or -ECHILD. Further, security_task_wait() can
> in general lead to zombies; in the absence of some way to automatically
> reparent a child process upon a denial, the hook is not useful.  Remove
> the security hook and its implementations in SELinux and Smack.  Smack
> already removed its check from its hook.
> 
> <snip>
