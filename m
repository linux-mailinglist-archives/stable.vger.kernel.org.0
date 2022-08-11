Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3CF58F9FA
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 11:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiHKJUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 05:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiHKJUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 05:20:51 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8EB2559B
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 02:20:49 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l22so20646256wrz.7
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 02:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=lOO2aeAi0b7sj61cQHI01uqKCThf1pf/8iDBTRjtIls=;
        b=jqhlAQxdtNUdmhncwqqUEM+OihmvUATY8IwXYYKvjC/mlIFUXM0/vmIrSGwlI/kp63
         AM5h6ljBFPhOPdX5490dR/hIcPz3KqppNSADKG6qb9NJZE/3I4nV+7l50pCkKESYA1B4
         ZmJgoYiIxqwslAgkyIVsTcfi+E2ENpViGRKk6awxc7kLj3/Bt5/4+9PZAX21gEkwIuVm
         8TudmKupAfc7aDNqEPHG1WQ9Fsa37SPlQYxveBrQ/mfYK2PJVUznzLELY3B7bzdVm6Re
         uAOUoKYxWmUG95S7T3X9OAF72UxbchEbAqUYGVDIxnQtdFuQOZLdSWOYl7tjyacfNbJw
         03gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lOO2aeAi0b7sj61cQHI01uqKCThf1pf/8iDBTRjtIls=;
        b=KPVItWssbXj/D4KOUXBDzWC3w0iS/fzKAWYjS3wReAfbk8z/us7CHST11DWf/nTnHo
         T6MCiGZVX1f4mZi1hXBXnaRCvA33XHW5nW12P6Q0ejb376xn2gUVzmJQGe9X0RQl/+yz
         D5Gq4i6wBTTtwAUtpo2o5YY5TPR5WV+eaX6bOMchmVNfgHsqgWAZN6naofebGkl3rFfr
         8BDe6cvIV6jaU8ri+EB5WSo9OG8lCh7wRccwI8N8WSQsEZcgbRuABgBcAjILFXth2aox
         PITKrFezZ0zYUysYTmVcItVXyzagheICcQ56eIfXiAIwbDUli5H9cs1ySFRFr9M5yPLx
         GCpg==
X-Gm-Message-State: ACgBeo2shsI6dRtBRQiSwoLkFT0Yu4U8RYdV0ITfEWH4qrL7Xbw1xJkG
        MxwoQYRGHypFwqsdV+RXf1FhlmyvNIg=
X-Google-Smtp-Source: AA6agR4eSdO7m1m3Sk95ImnEOgSvodXbODTnd+gW1qD7IjYsEjSkeRWp7nso+USYJlWty1NLzMOLig==
X-Received: by 2002:adf:f650:0:b0:221:7d49:3595 with SMTP id x16-20020adff650000000b002217d493595mr16015985wrp.670.1660209648386;
        Thu, 11 Aug 2022 02:20:48 -0700 (PDT)
Received: from ?IPV6:2003:f6:af09:a700:e423:d3e6:c12e:483e? (p200300f6af09a700e423d3e6c12e483e.dip0.t-ipconnect.de. [2003:f6:af09:a700:e423:d3e6:c12e:483e])
        by smtp.gmail.com with ESMTPSA id l3-20020a5d4803000000b0021e42e7c7dbsm18269118wrq.83.2022.08.11.02.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 02:20:47 -0700 (PDT)
Message-ID: <a46a36bb-7e1c-0fae-15c0-3051c808fcd5@gmail.com>
Date:   Thu, 11 Aug 2022 11:20:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 0/1] selinux: allow dontauditx and auditallowx rules
 to take effect without allowx
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20220808102049.46386-1-theflamefire89@gmail.com>
 <YvEQBYO11g9ynGGz@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YvEQBYO11g9ynGGz@kroah.com>
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

> So this would need to be backported to 4.14.y, 4.19.y, 5.4.y, and 5.10.y
> before we could consider it.
> 
> BUT, as this is something that just never worked, why is it needed at
> all?  Making it work is a "new feature", not really a bugfix for these
> older kernels as it is not a regression.

I agree it is not a regression but following the original discussion on this 
I do think it is a bug worth fixing, see the already quoted:

> The behavior of dontauditx and auditallowx appears to be broken making them useless.

At least it is a pitfall for policy writers which can be easily avoided by this small fix.

I don't mind porting this to the other LTS releases if you agree on this judgement.
If so, what would the best/simplest way to do so? An own thread with [0/1] & [1/1] mails
for each LTS branch or e.g. replying to this thread with a patch for each of the LTS
branches?

If you don't agree I won't send those mails which is also fine.

Thanks,
Alex
