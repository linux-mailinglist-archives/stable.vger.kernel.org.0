Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A77156CF2E
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiGJMiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 08:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJMiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 08:38:18 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9881115B
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 05:38:18 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id mf4so3486917ejc.3
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 05:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0/cVevrqtIlNwSrDYRb1yNT+zXLTMDcocIxqgxfTCG4=;
        b=KnlG9oD1j9lhQ8oobdyqCwscH40+Fnt6IblayORzbauWzebcZTeFIC4kaT61YZGVdj
         nXQl8bSaG2CFRq5pXyj/TpAcYxYb9bzbzRopjjBD1BzjMQVr/D0+ArDJ1AH8BXwlc+lt
         07MJOfmEh6H490qHwVODAHDLOYoFbSPH01meXLWLLZHO+dRYuuxU4DRIAtMhKMPNFfrk
         edicPNP3jnY9wMcp/s/orqhcrVPBqqdaxwPMlj8nf0qJ2NYji0wpn2KUsm4mIiAFCZeT
         qsXPXK8fA8dZUE614acbkKRvaIWVzfSNu/MDb6DrhHxn9nnfuk3HqZSy2KVngXdQ5jxG
         ajrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0/cVevrqtIlNwSrDYRb1yNT+zXLTMDcocIxqgxfTCG4=;
        b=pefUwyZbxByJbzXvEyUmLSBu0dQwv6BWqoc57o0zrklpbmDMDrnyee9Qkgv3ALLQrQ
         OrsnqQEvmmXW+t5JG8PURKq+r5kJMjqQPzbaNBqvpGJmQ4PlLggDUGanmKwRc2DmDb6y
         E+3FNt1V1BXcTUOTbO0jnzNTCQq1PiTQHBY+f0W+9IYWuJWR7AyvX1Evx/9LwfpORZ8q
         wfv4VYst0VKnTfWG2jdnwFyKibmofqRbnPAxfHbO3F/09LQh84OULGmXcjBxa5y2QlH4
         fCC8uLLJq+LhBefD9y5JhtMyqIket3k2533XkwtnhJHHw5CmvnXwdUa3UOXkXEzllsao
         vl5A==
X-Gm-Message-State: AJIora+byAlRZxwv/6V+nKBuUH8e9bWYaQ3dlshloNB9gWJA7ejwirV3
        QpMM3DXicLRJY9Rnaa4G4cmJlmXu1QkNPg==
X-Google-Smtp-Source: AGRyM1vcTXYE2bbDucK5WHA6BX3jpq8Sbfq4/bS826LexmlctC312d+4QtnwMJmd6l7cboSq4EU/BA==
X-Received: by 2002:a17:907:75e3:b0:72b:198a:b598 with SMTP id jz3-20020a17090775e300b0072b198ab598mr13609336ejc.401.1657456696647;
        Sun, 10 Jul 2022 05:38:16 -0700 (PDT)
Received: from ?IPV6:2003:f6:af42:a000:bd65:5b56:da6a:a3d? (p200300f6af42a000bd655b56da6a0a3d.dip0.t-ipconnect.de. [2003:f6:af42:a000:bd65:5b56:da6a:a3d])
        by smtp.gmail.com with ESMTPSA id a15-20020a170906190f00b006f3ef214ddesm1545646eje.68.2022.07.10.05.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 05:38:16 -0700 (PDT)
Message-ID: <1c9e8498-0621-4466-bfbc-4f166c633727@gmail.com>
Date:   Sun, 10 Jul 2022 14:38:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [GIT 4.9] LSM,security,selinux,smack: Backport of LSM changes
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
 <YslxiluWV9YnPPAY@kroah.com> <81f96354-cbed-26e4-9f3f-5287095ccece@gmail.com>
 <YsqyxydY1kbufgng@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YsqyxydY1kbufgng@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.07.22 13:06, Greg KH wrote:
> Make sure the patches you are submitting follows those rules on what is
> able to be accepted.

Looks like I have to exclude a couple of patches especially due to the 100-lines rule.
That especially hits the last one replacing 350 lines initialization code by 6 lines doing the same but avoiding potential errors by missing some initialization.

>> The Civil Infrastructure Platform (CIP) e.g. maintains LTS kernel trees which are now End of Life but still used.
>> They call that SLTS ("Super Long Term Support") and there is e.g. a 4.4.y branch with backports from the 4.9.y LTS branch.
>> That kernel is e.g. used in many Android phones.
> 
> What 4.4.y Android devices are still supported by their vendors?  And
> are they still getting kernel updates?

Actually the issue is that those devices are not supported by their vendors anymore, so they may only get updates through LineageOS.
That is a third-party Android build where maintainers rely on proprietary binaries from the original phone which are tied to a specific kernel.
Hence when the device falls out of support having a 4.4 kernel in the last release there is no way for those maintainers to switch to a newer kernel.
That's the situation e.g. I am in right now: Providing (mostly) security updates for a good phone that fell out of vendor support
by using LineageOS for an updated Android system and e.g. the CIP maintained SLTS 4.4 kernel.
And I know of at least 2 other devices using the same kernel as they share the platform.

Regards,
Alex
