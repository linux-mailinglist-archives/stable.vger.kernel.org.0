Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71001598903
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344431AbiHRQig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 12:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343766AbiHRQif (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 12:38:35 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4362149B42
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 09:38:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t5so2573108edc.11
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 09:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=2B8tvc8B2hGOQWJ0UIEwuS9k9Pi3iffbpMUFMt6cRTA=;
        b=ErGEvsdDtIIHCcxD24M8zXwYEB9SpeIIeJzzWl1gJpkkCmePawUmhzzEyHMxG94Ate
         GsURqbvPPl0c5qKNQiCNovk95SuLeVZazP7OmbqjwmpgPnpySNqwHgPlhjlPT1ccG1Bu
         Fns8MY8lhCRWCcYo8V/9qKS67ZVgGzkhMkhOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2B8tvc8B2hGOQWJ0UIEwuS9k9Pi3iffbpMUFMt6cRTA=;
        b=O4ra9vqdzYd93GHEoXSX7sJCT/d7kksMiBOQvDqITWJGY2Oiii2FrlnsrfX7yOd0+l
         Zc2tp/xif4LaclX/EZgPACJ8eb/03JUQpIj2einp8NwtwVNRgKnGPKrjjLh1Ac8zIhfH
         maiJ7TWP1H/caJwgkaZY4P7OBuYTC8VwX7oKrYB5V5CyZMnAlngosUKDiXUYgIu7BmMM
         4P4MrW9PFiCFCLylJo4zUAQXY6BjaNGAzHn/exPw39lhGs+QavJzycOdCeapt9XF4rEb
         51rOjz7vQmyn/8+45RPO08qHqIJsmC5KOiL/QPHgTVV0nOrUzh7HCYXarbXEmICY+j8G
         kL0Q==
X-Gm-Message-State: ACgBeo0g9AjeEG1xsCZV5T/DQCjdit20blh2Q67SLcjf+3bscCjpScoJ
        UwR6jNk7SRk0ojMREGfLRH+7acyz83vsZrRf
X-Google-Smtp-Source: AA6agR55zpPElHt9+qoYkEtqIBwF24HvQ6gg94dID5Oi5Csl9NCdWk6gD/c6uXzKLmWe0rfaVpp9zA==
X-Received: by 2002:a05:6402:2b98:b0:43e:107:183d with SMTP id fj24-20020a0564022b9800b0043e0107183dmr2896723edb.366.1660840712658;
        Thu, 18 Aug 2022 09:38:32 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id c1-20020a17090618a100b007304bdf18cfsm1033705ejf.136.2022.08.18.09.38.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 09:38:31 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so2870163wme.1
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 09:38:30 -0700 (PDT)
X-Received: by 2002:a05:600c:2195:b0:3a6:b3c:c100 with SMTP id
 e21-20020a05600c219500b003a60b3cc100mr2371564wme.8.1660840710358; Thu, 18 Aug
 2022 09:38:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220818110859.1918035-1-jens.wiklander@linaro.org>
In-Reply-To: <20220818110859.1918035-1-jens.wiklander@linaro.org>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Thu, 18 Aug 2022 09:38:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiEqhzrMskE=7_q4E+X+zPyxm6xvuADhaBxh8gD5p57kA@mail.gmail.com>
Message-ID: <CAHk-=wiEqhzrMskE=7_q4E+X+zPyxm6xvuADhaBxh8gD5p57kA@mail.gmail.com>
Subject: Re: [PATCH v2] tee: add overflow check in register_shm_helper()
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        linux-arch <linux-arch@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>, stable@vger.kernel.org,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Jerome Forissier <jerome.forissier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 4:09 AM Jens Wiklander
<jens.wiklander@linaro.org> wrote:
>
> Fix this by adding an overflow check when calculating the end of the
> memory range. Also add an explicit call to access_ok() in
> tee_shm_register_user_buf() to catch an invalid user space address
> early.

I applied the access_ok() part of this which was clearly missing.

The check_add_overflow() should be pointless with that.

And the "roundup() overflows" check should just check for a zero
result - if it is actually needed. Which I don't think it is on any
relevant platform (the TEE subsystem only works on arm and x86).

I do think it might be worth discussing whether
ALTERNATE_USER_ADDRESS_SPACE (and no-MMU) architectures should still
have access_ok() check that it doesn't actually wrap around in the
address space, so I've added linux-arch here.

That's m68k, PA-RISC, S390 and sparc.

In fact, I wonder if some or all of those might want to have the
TASK_SIZE limit anyway - they may have a separate user address space,
but several ones have some limits even then, and probably should have
access_ok() check them rather than depend on the hardware then giving
page fault.

For example, sparc32 has a user address space, but defines TASK_SIZE
to 0xF0000000. m68k has several different case. parisc also has an
actual limit.

And s390 uses

    #define TASK_SIZE_MAX         (-PAGE_SIZE)

which is a good value and leaves a guard page at the top.

So I think the "roundup overflows" would probably be best fixed by
just admitting that every architecture in practice has a TASK_SIZE_MAX
anyway, and we should just make access_ok() check it.

              Linus
