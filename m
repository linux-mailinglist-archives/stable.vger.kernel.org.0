Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4164650805C
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 07:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349647AbiDTFEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 01:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349475AbiDTFEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 01:04:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E673826109
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 22:02:00 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id i63so537051pge.11
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 22:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:organization:content-transfer-encoding;
        bh=Z49hV7aG3cCr4r4lkICwa9FUzeWeiunU3HJPDBi/31A=;
        b=bGZZuZqfebSgHmTSMjgZSvgzegCxTmsdlxXTzyK4VdLlkLzNC+eYDUUJhwbjD9HIzK
         IyCwazE2exmlvBB6wSNXv+3NnlLGKxKV0oS44m9BJwnu49HFa2rHLvwbEPlPwqiU+LNP
         bL6P75/ewLEhbFpeut+0csumOk/iH/7y8tc/WjSyEjpqHmjEeeUs+bPh85d2CyQg8rgW
         6TCAHGWVCmJMjGISEMa6++7OoRJXJHmMm66HJW50RAS9JT8bRRwSyHIKCfGX85l3lnd7
         vN9VwhUXaDmdL+kAkL85PC/abj/8fFfeven9hTITVVOk/sAPlarkNhbK7WCFBnl0BXum
         fCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:organization
         :content-transfer-encoding;
        bh=Z49hV7aG3cCr4r4lkICwa9FUzeWeiunU3HJPDBi/31A=;
        b=ImsVqPLFXTr8ZAcIPYfFzuq19KCjitWHz+QI66mv59L56rjqCtKs5Mw4tI40saA6NI
         6ZQSJ9P1hmL7hrMiDuU9KY3Lk0T/FhqAXLbC2LF31DTZtNhnWthPNPBZU1hdimSqsMDJ
         W4w17OklIntDCdoIPGpcGUvVrB5MDqxtFh30xlvIAKYHxcArsB1hCTLm0+D+OHOtEC5G
         fJl0uHtUCchLsLPFae+BnH60Gkm//eSMI8zObVUUtBmM4iGyfVZbhynsb4nZULfEQniI
         KNggqpinQQkfF0tk84nUHlVIr/MjMzL7PAvI2Fii7qDnBO0iSe9kCOKK0Y533/rzyg+0
         gg8w==
X-Gm-Message-State: AOAM532mG4gbENGZbKKlBH0xRVwx5UziCYrvy+0Uu1lmZbqZBZS4fTY5
        rEfXDSO9fCRFRxmLVdaPojxzjavZRE84Kw==
X-Google-Smtp-Source: ABdhPJzFtCsXwzJbWKdASUQgR0Ycggl7p030/xD6koy1l5VH+lVyR2OjBhZxEYapHFjVmiL8+onGOA==
X-Received: by 2002:a05:6a00:b87:b0:50a:5ff2:bb2d with SMTP id g7-20020a056a000b8700b0050a5ff2bb2dmr17998753pfj.68.1650430920093;
        Tue, 19 Apr 2022 22:02:00 -0700 (PDT)
Received: from ?IPV6:2601:646:9200:a0f0::309e? ([2601:646:9200:a0f0::309e])
        by smtp.gmail.com with ESMTPSA id k5-20020a17090ac50500b001cd5ffcca96sm20148474pjt.27.2022.04.19.22.01.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 22:01:59 -0700 (PDT)
Message-ID: <afb441a5-97ca-1488-e1ab-c399fd4e254d@gmail.com>
Date:   Tue, 19 Apr 2022 22:01:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Khem Raj <raj.khem@gmail.com>
Subject: Request to backport 2618a0dae and ca831f29f8f2 to stable tree
Organization: HIMVIS LLC
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

Hello Stable kernel maintainers,

I would like to request backport of below patches to linux-5.15-y branch 
in stable tree:

2618a0dae09e etherdevice: Adjust ether_addr* prototypes to silence 
-Wstringop-overead

ca831f29f8f2 mm: page_alloc: fix building error on -Werror=array-compare

These two patches are required to fix build with GCC 12 for arm 
architectures. I have validated it on top of 5.15.34

Thank you
-Khem
