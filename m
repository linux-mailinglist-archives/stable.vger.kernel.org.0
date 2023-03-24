Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764276C762F
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 04:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjCXDP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 23:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCXDPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 23:15:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042B212858
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 20:15:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o11so703699ple.1
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 20:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679627749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hdx17vCNYV2qLoCsvooDCPi5rNQI2bUy5M3IQg4/xWk=;
        b=JK+i6OHp77Gh9yVqhRsByrp/7qPPA5poLkAPSVRQSqWwePWebgnMU09PRB7yJCqwg4
         c6Q8eNOFF+aoL+h5CypkP0Q9ErUU+fhG9/NcZRdYtKjIsaj7U3mhjiezHZCKL5RI9rkJ
         JYX4vV+dW+SUq/rsxDcj+FvIhkaeqrbHAUbO08ETLyV6guge5KZgcK/NFvNPQHBePuQZ
         9ER7/Rw0OI+l7HhKP5UDKk1t4A56QdqA656swjfMUjqVA7cfmSsYDkv/Yzjj24w/R/Aq
         c0Rf424NQ0gXK5ppnd03vjxggTarePvgR/Oyw78BXt9SzmPxNdZyIRGR6p49rkOhgain
         ADuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679627749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hdx17vCNYV2qLoCsvooDCPi5rNQI2bUy5M3IQg4/xWk=;
        b=AiePlpJkVL6HeKvyHdobVJLULoCQIlEsz2M0t9Ye8Kshf8W0W+E3wspZtCqOnuU+ul
         OJbaISdRDGjNvhReEpSLCKGEWuJ1IxMc5FLjS2uBPaIDIMymVDdcBeo2rTN/4BULQk85
         h/mZgGOKUS4SymBU3oMoEHFXJV+CQOgNXcvXBNEDLJTci8g2BVTVKqJ6bpP4CjE3qS2O
         kjPQRTaw68UJDWW8bsT2sn0HpfAUfxOgUGPR8Ikvc4EvKTWcYgogrvKld8X8m7uW0jwm
         d/TS1QhIss/oHvut2mdRtgpTvdgbqN2pSb60bBEXFLfBF5ucCF0jevleFD8KJXq+LJQ+
         JftQ==
X-Gm-Message-State: AAQBX9e1LO/gK/q9xREUQRO4U7rLmIu4JDJDoCy6cWzsZHiogVdL3rGE
        pgSop9qmbCdmHGC27xnEPKDnaAFmkc8Gmg==
X-Google-Smtp-Source: AKy350b4kA4WfvmHy4tmiCmwooO/ycbfDk2tkIx8YzyYXoTDnNRbbKq7XcujPcr1x6MYJixD89fHrg==
X-Received: by 2002:a17:903:110e:b0:19e:9807:de48 with SMTP id n14-20020a170903110e00b0019e9807de48mr1467352plh.23.1679627749334;
        Thu, 23 Mar 2023 20:15:49 -0700 (PDT)
Received: from [192.168.43.80] (subs09a-223-255-225-66.three.co.id. [223.255.225.66])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709029a9300b001a1f6f15c3fsm3264902plp.72.2023.03.23.20.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 20:15:49 -0700 (PDT)
Message-ID: <82822f1b-1c3a-bc3c-0ddb-fe875a17df87@gmail.com>
Date:   Fri, 24 Mar 2023 10:15:45 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [REGRESSION] kbl-r5514-5663-max hdmi no longer working
To:     Jason Montleon <jmontleo@redhat.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        stable@vger.kernel.org
References: <CAJD_bPKQdtaExvVEKxhQ47G-ZXDA=k+gzhMJRHLBe=mysPnuKA@mail.gmail.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <CAJD_bPKQdtaExvVEKxhQ47G-ZXDA=k+gzhMJRHLBe=mysPnuKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/13/23 23:34, Jason Montleon wrote:
> It looks like HDMI audio stopped working in 5.17-rc1. I ran a bisect
> which points to 636110411ca726f19ef8e87b0be51bb9a4cdef06. I built
> 5.17.14 with it reverted and it restored HDMI output, but it doesn't
> revert cleanly from 5.18 onward.
> 
>>From what I can tell it looks like -ENOTSUPP is returned from
> snd_soc_dai_set_stream for hdmi1 and hdmi2 now. I'm not sure if that's
> expected, but I made the following change and I have working HDMI
> audio now. https://gist.github.com/jmontleon/4780154c309f956d97ca9a304a00da3f
> 

Hi,

Would you like to post the gist above as proper patch (see
Documentation/process/submitting-patches.rst for instructions on
patch submission)?

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

