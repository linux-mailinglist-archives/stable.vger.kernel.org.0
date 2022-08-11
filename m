Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71CF58FA3B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 11:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiHKJqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 05:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiHKJqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 05:46:12 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE5679A45
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 02:46:11 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a7so32592042ejp.2
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 02:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=OQNphwbiHSRws0r1N3cNdIZbJN9PzBvq15y9hAVAZLM=;
        b=G0jmwzUmF71V4BqUX1ricsw73AfcWfWApDGEl6S3XFH7HbNf6hBPqtIijkRA1XrRRi
         sn6W/BuwHy+ywe++tNmdHogBQjxujcboEZSjSBB3EdtvbFnjGaI+dmDfj99DaU6NXBTI
         RgSoIMnS22wZisQM0d/HsnAmX34Nq/j/ThvtJmFhM9Ibu1d3km4DElOD6OUVpuH/EYeb
         CiRF9aSxzQolp71aGFZRZIJY+WsKL2+TvHymgyW3cSFemQoNhjkKhw6nBTvjy2Og++fb
         cMUe0GxsfTGmaaR4saSHAXgb5/aQ0723oFGkvEXgtPTwwxavXchuN6Ka/dq8S9UzlNRf
         0rKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=OQNphwbiHSRws0r1N3cNdIZbJN9PzBvq15y9hAVAZLM=;
        b=JJ7pWq+vJsdI16GMcZgW3+7zize3+v+fvOLSbIMUeUMMesU+Q6kJ7krZeCYWryKl/T
         5NGTWcFagSZAaIZQDSIO4PG0afL6cadxR9I7hZFMgkjKbLe/1sHDK2J8HA3UQgSGqn5D
         ADwiXLWqF2S6qg6qqeK/snoHgPXburZigyuUihIUwbo9qQsMAf0CUD5wVaEcKk+5iUE6
         zhiDDfvRziTI4hOBEGsiLikt0JKHhFYbZplzlCM9bUjAOEvo0D5ATpcpLHFm2pHiD5Of
         MP3B8pO1l4BbXtcvbxtKD3TCPtPFt5B5hIcOYam/zxqcd9eQkW6gqRbxhlq6SmBfg1tN
         ch8w==
X-Gm-Message-State: ACgBeo3bQIuhiyKUhka6Ty+METhAhfP1fVVXjRF+wbrF/Y93EMmTqeyF
        L2DJtq6mF93Zr32BOpKtbu3F3iy1LxE=
X-Google-Smtp-Source: AA6agR4T7JtHOBibfJvi8mWd4IaxMICLkTixoEb13akVoYbE13JgJaCljoumYA5FORlQ1znG1OXvZQ==
X-Received: by 2002:a17:907:2672:b0:734:a952:439a with SMTP id ci18-20020a170907267200b00734a952439amr1620954ejc.539.1660211170447;
        Thu, 11 Aug 2022 02:46:10 -0700 (PDT)
Received: from ?IPV6:2003:f6:af09:a700:e423:d3e6:c12e:483e? (p200300f6af09a700e423d3e6c12e483e.dip0.t-ipconnect.de. [2003:f6:af09:a700:e423:d3e6:c12e:483e])
        by smtp.gmail.com with ESMTPSA id p19-20020a170906785300b007305d408b3dsm3327288ejm.78.2022.08.11.02.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 02:46:09 -0700 (PDT)
Message-ID: <7769a909-9054-3215-dd3e-00bfb822d003@gmail.com>
Date:   Thu, 11 Aug 2022 11:46:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 0/1] selinux: drop super_block backpointer from
 superblock_security_struct
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20220808115922.331003-1-theflamefire89@gmail.com>
 <YvEPfSBGdBV0ZohA@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YvEPfSBGdBV0ZohA@kroah.com>
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

On 08.08.22 15:28, Greg KH wrote:
> But, we only take patches that actually do something.  This one doesn't
> do anything at all, and has no measurable performance or bugfix that I
> can determine at all.

Isn't "doing less" also worth the patch?
I mean this patch removes a superflous pointer of the superblock struct
making the kernel use less memory.
It also saves a code line and operation during init and removes the
(somewhat hidden in syntax) superflous indirect access (and hence memory read)
of a pointer already available (likely even in a register) during get/set_mnt_opts.

Of course the effect here is small but I think cleanups are always good to avoid
a "death by a thousand cuts" scenario, i.e. that even small things help.

But of course you may disagree, just wanted to provide my reasoning especially
as you wrote earlier that deleting code is always good and I thought this
patch fits that.

Thanks,
Alex
