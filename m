Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF8253F935
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbiFGJPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbiFGJPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:15:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5023C87A08
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:15:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d14so14229864wra.10
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 02:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=s+usQNQe61fUNXtftBnDDPOoqNzLMBH21NqyRZq7YLo=;
        b=QcJFOZkr6N0djzaiBVtwqiI34B4U1YPZDK+qqBxhWRvksqYGTnrdJ2l7ks6TzStesp
         CLefRAOdeVlWHQFXzog5tGhwMpXNRIK8rxeKr1KewPQnqDMI/TEosM2Oyidtx2FgNDkv
         heHtFS1yJhRiiNE1d2ZfRmVJmmpFVWPWDGsMQ8KTW/BxHe6NXSsxnEnkGR9y2I+xCAN/
         lYcVSSYtJoV2uSRZHEGaN8h+805AB5fGDQUfR352OQi25LWIjK+XwZ9DoHNTGmMZxafM
         rpdEA4LHFHBvqNW58ewZc2pwQN0+fcihCYVyXmOThiBzZpJGeS04EYqcHU9AEy3Vk76M
         fiZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s+usQNQe61fUNXtftBnDDPOoqNzLMBH21NqyRZq7YLo=;
        b=al4A5hkNX5kr52JAyYECGBtjTGtdyezZU6qeSTCe24KiFCuLONW/gr9CfOzYPubZEm
         0ORyl2YncekeAH8y/mXFK5AjiyXYL3HoHZdTvOQA3E8TwFySnvVFLQH9mfyrXMbV81Rx
         0XLRklIpA0SjiKcP+0ugTX94ac+xaexcV8PxYqGNIBpJXnPiYZGGHhbst8ZW3R5ZJJy+
         V0+T0TbugoOw8f/3grIX6q7/C3gifUzWjwBLSOjIOMlOgM6qXquY4JwW4Dr5Sen+dcI+
         MtNrzckQ3gwxH1dvLluH+K0Y4lUB8FnK60Qchbu1aMwoiGLhRblepaJSCmGPfqUKwGqU
         2bBg==
X-Gm-Message-State: AOAM533RB6i+S6lI2eupa2Q58MbipZjTrfkLzUhE/sY+3iB4xJTcboSZ
        nFwWcIIJX9Byn+JkXK4EhHYouA==
X-Google-Smtp-Source: ABdhPJxHljRDXDB6metlo+Ntzo/NbEmYZujGJW4daxhb1Oxt07a0tqGsmnY141RzHKXAo+xezbaUFw==
X-Received: by 2002:adf:fe0c:0:b0:218:4312:1230 with SMTP id n12-20020adffe0c000000b0021843121230mr7830352wrr.223.1654593327814;
        Tue, 07 Jun 2022 02:15:27 -0700 (PDT)
Received: from ?IPV6:2a00:1098:3142:14:901f:dbcb:c1e4:e4b8? ([2a00:1098:3142:14:901f:dbcb:c1e4:e4b8])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c3b8500b0039c4e2ff7cfsm6411598wms.43.2022.06.07.02.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 02:15:27 -0700 (PDT)
Message-ID: <8c3fe744-0181-043a-3af9-dd00165a6356@raspberrypi.com>
Date:   Tue, 7 Jun 2022 10:15:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9o6R2RRdwzB9f+464xH+Aw-9wx2dm=ZsQYFbTk_-66yJw@mail.gmail.com>
From:   Phil Elwell <phil@raspberrypi.com>
In-Reply-To: <CAHmME9o6R2RRdwzB9f+464xH+Aw-9wx2dm=ZsQYFbTk_-66yJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/06/2022 09:43, Jason A. Donenfeld wrote:
> Hi Phil,
> 
> On Tue, Jun 7, 2022 at 10:29 AM Phil Elwell <phil@raspberrypi.com> wrote:
>>
>> This patch is fatal for me in the downstream Raspberry Pi kernel - it locks up
>> on boot even before the earlycon output is available. Hacking jump_label_init to
>> skip the jump_entry for "crng_is_ready" allows it to boot, but is likely to have
>> consequences further down the line.
> 
> Also, reading this a few times, I'm not 100% sure I understand what
> you did to hack around this and why that works. Think you could paste
> your hackpatch just out of interest to the discussion (but obviously
> not to be applied)?

This is the minimal version of my workaround patch that at least allows the 
board to boot. Bear in mind that it was written with no previous knowledge of 
jump labels and was arrived at by iteratively bisecting the list of jump_labels 
until the first dangerous one was found, then later working out that there was 
only one.

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index b156e152d6b48..7b053521f7216 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -466,6 +466,7 @@ void __init jump_label_init(void)
         struct jump_entry *iter_stop = __stop___jump_table;
         struct static_key *key = NULL;
         struct jump_entry *iter;
+       int iter_count = 0;

         /*
          * Since we are initializing the static_key.enabled field with
@@ -499,7 +500,9 @@ void __init jump_label_init(void)
                         continue;

                 key = iterk;
-               static_key_set_entries(key, iter);
+               iter_count++;
+               if (iter_count != 1083)
+                       static_key_set_entries(key, iter);
         }
         static_key_initialized = true;
         jump_label_unlock();

I'm sure this could be rewritten in a less fragile manner making reference to 
crng_is_ready directly, but this is where I got to yesterday.

Ha! I just proved the patch's fragility by switching from a Pi 2 to a Pi 4,
so the saner version is:

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ca17a658c2147..ca7c8a67b8314 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -79,7 +79,7 @@ static enum {
         CRNG_EARLY = 1, /* At least POOL_EARLY_BITS collected */
         CRNG_READY = 2  /* Fully initialized with POOL_READY_BITS collected */
  } crng_init __read_mostly = CRNG_EMPTY;
-static DEFINE_STATIC_KEY_FALSE(crng_is_ready);
+DEFINE_STATIC_KEY_FALSE(crng_is_ready);
  #define crng_ready() (static_branch_likely(&crng_is_ready) || crng_init >= 
CRNG_READY)
  /* Various types of waiters for crng_init->CRNG_READY transition. */
  static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);


diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index b156e152d6b48..b79de9da036fd 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -484,6 +484,7 @@ void __init jump_label_init(void)
         jump_label_sort_entries(iter_start, iter_stop);

         for (iter = iter_start; iter < iter_stop; iter++) {
+               extern struct static_key_false crng_is_ready;
                 struct static_key *iterk;
                 bool in_init;

@@ -499,7 +500,8 @@ void __init jump_label_init(void)
                         continue;

                 key = iterk;
-               static_key_set_entries(key, iter);
+               if (key != &crng_is_ready.key)
+                       static_key_set_entries(key, iter);
         }
         static_key_initialized = true;
         jump_label_unlock();

And to answer your questions from the other thread:

* Without any fixing patches we see the warning messages because we are using 
rng-seed in DT.

* I've seen the problem on a Pi 2 and a Pi 4 running 32-bit kernels.

Phil
