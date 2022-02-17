Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FB04BA9ED
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244292AbiBQTh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:37:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiBQTh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:37:27 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A68141F97
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:37:12 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j4so5361822plj.8
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=ajlKrZnxVnowc5VxXdoOa048W0a2dBo2i3SpHHAcHbg=;
        b=KNFX0mZQFSvXZ9LvDcOWv8PDI77LU/h4h+xkehWN0Rom31GqvNfGv8wxG5y1y0nxaj
         +AapKPFmoybI2IVFLg5c5OpL+9slRVSRFiMIzff81hiygWCuekZlBcEuPscZ/kScsRIt
         BH8Wct4hvvoNhetO6eECCr+T1Bb3XlpydjhwQp7EepTGtHJfdp9KDSeQuKSZhVPhIEfa
         wR9m2udtnbbR3TFrQp2SKUpYf4KOicVNVwpPlfT2HFkBgkDNk8eZSDqZmJLnJwobuFnR
         lFxwDdQzhwfU6BwyzybbkH2sFA3uIRq1LLKnm2l+dppl4AtIGQGYMQo5PUa/CcWJ3UVO
         OMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=ajlKrZnxVnowc5VxXdoOa048W0a2dBo2i3SpHHAcHbg=;
        b=fkfG30BPOmZNhwy3WMLDCrpm6Wn39idN0cihCHyyV7NXioMv6qo/Z2mydUW5PNwHbr
         LnDAry1dc6R8kfrjOaSYOyO58m5kgLsjkCGqtvzl2nN3o1BfPj2w6SLwtRmyYsmNPDLP
         M44NQTwJlOitk/arbFbYsThMCiH6d7t2XW+H48a45i9PMrlWK41ZQXJn99qeQS9kuxXm
         0KXzML1Oom+ul6vrmb6gFg2vesnKy+Eph7k7g1XyCkiKi9pN2IMqXRu2iz/hi1OLIqJv
         eWFpmfitDdt6YpDTXxpZt2DJPTXaIO6+eP1I+U9fNAhonvomaO59rUS7mvmQH18fcUYg
         rg2g==
X-Gm-Message-State: AOAM530z7nbFaOomz+crMVPzCjV4GqLriyKtD9184a4+lAgbZOH2VA6s
        Xngmnwf2zNwlLnnD6XbfeLSTx7TGQSQfARWj
X-Google-Smtp-Source: ABdhPJw7UmQ2qcKc5IcszpStubBI1ZqcQsCQHEEmSkps6ANzFiEipPN4Ik4gKo52TmL2I48mprIsPg==
X-Received: by 2002:a17:90a:4493:b0:1b9:256f:dbe2 with SMTP id t19-20020a17090a449300b001b9256fdbe2mr8811373pjg.18.1645126631489;
        Thu, 17 Feb 2022 11:37:11 -0800 (PST)
Received: from [192.168.0.199] ([45.126.144.166])
        by smtp.gmail.com with ESMTPSA id g6sm338750pfv.158.2022.02.17.11.37.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 11:37:11 -0800 (PST)
Message-ID: <43574959-000b-b71e-9ecd-9346b72a985a@gmail.com>
Date:   Fri, 18 Feb 2022 01:07:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org
From:   Fenil Jain <fkjainco@gmail.com>
Subject: Version 5.16.10 boot test summary
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey,

Booted the kernel 5.16.10 on x86_64

No crashes detected

