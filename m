Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142E75AF3DF
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiIFSpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIFSpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:45:06 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013534620F;
        Tue,  6 Sep 2022 11:45:04 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id h22so8766370qtu.2;
        Tue, 06 Sep 2022 11:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=lpN2OCAZ8P4GFwjnfuKVcmszQEHpOwxxMRO45UtvrGY=;
        b=p5GGMRndemtcx9BxNJi7oBUnDhbVmt++iYIriym+u1XAhJZTTAMO8FCoN432Mr/m45
         Giy4urae0S67qmg4Be85NWnzoqO7FXjlDebVEL0MtYenfODMcZVDGJrD+zIS6APdGe/x
         uu8qPt/Xuj2ISDp38BZwCwnJNFryXyrG7Ii1N9D7qLYOUwnKDaTG/3k2/whSY7rqn/Eh
         wues3KPYt8S/cUnLIO3c9xXhaAfb44682861sbkMDlGw4pLt6BL8jlTQJxCH2gOGtihL
         Pqmja2bd3KlowkiZt3bBIARHhCKiPOOYHWxIc/y7yf8hr5P9SbDKYF8evN1/XJHqFr9c
         mxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=lpN2OCAZ8P4GFwjnfuKVcmszQEHpOwxxMRO45UtvrGY=;
        b=siwL72RqvlvPz58HKTb8phh1lePo+7E9rvdvynHHfDnGcvjOje7ph5o4NvPcQRNmp5
         cIU5A1RNPJD/KWhsrWy4EyM7a6QehDUiUn2cfuoOcX4iFuk9UXSuHC5g01E8Pf0j+cz8
         Nf9gboUzCxwlE0Shc4eyxvRp2ukfzsC+4zNRDnOzavkb7b+JCITHrm604LxcbjJMSv6v
         OVwBDoHYQaiucSNe2w0aCCOe/1FEelLmZs+3KEQFlc6s4HVEEc0Pa1rsqcvjH0ENobM7
         vTF1pd2iw7yQPb4FQDyzjDPMgIKFCPUCgZlwik0Enl5xDhcGLhzJBkX1wVpc/30zqVJf
         HPWA==
X-Gm-Message-State: ACgBeo2RZ3LlYNPafZvfWgdFDD7L40QdreSmcnX4FwGj1Orrvz3w+SzA
        H2OG7clYZp4yxQgZjTGoEWI=
X-Google-Smtp-Source: AA6agR5tCVW5OlNS3CjJeLYdWJ/cKlTRm7EolBuTcihlXVx/pWAwBKhpABTG2vTCnOjPBo+wTTgMxQ==
X-Received: by 2002:a05:622a:259b:b0:343:4c3b:caa7 with SMTP id cj27-20020a05622a259b00b003434c3bcaa7mr45971563qtb.148.1662489903032;
        Tue, 06 Sep 2022 11:45:03 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id cd9-20020a05622a418900b00342fdc4004fsm10389436qtb.52.2022.09.06.11.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 11:45:02 -0700 (PDT)
Message-ID: <291d739c-752f-ead3-1974-a136b986afb7@gmail.com>
Date:   Tue, 6 Sep 2022 11:45:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.15 101/107] kbuild: Unify options for BTF generation for
 vmlinux and modules
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132826.130642856@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906132826.130642856@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2022 6:31 AM, Greg Kroah-Hartman wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> commit e27f05147bff21408c1b8410ad8e90cd286e7952 upstream.
> 
> Using new PAHOLE_FLAGS variable to pass extra arguments to
> pahole for both vmlinux and modules BTF data generation.
> 
> Adding new scripts/pahole-flags.sh script that detect and
> prints pahole options.
> 
> [ fixed issues found by kernel test robot ]
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Link: https://lore.kernel.org/bpf/20211029125729.70002-1-jolsa@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   Makefile                  |    3 +++
>   scripts/Makefile.modfinal |    2 +-
>   scripts/link-vmlinux.sh   |   11 +----------
>   scripts/pahole-flags.sh   |   20 ++++++++++++++++++++
>   4 files changed, 25 insertions(+), 11 deletions(-)
>   create mode 100755 scripts/pahole-flags.sh

My linux-stable-rc/linux-5.15.y checkout shows that 
scripts/pahole-flags.sh does not have an executable permission and 
commit 128e3cc0beffc92154d9af6bd8c107f46e830000 ("kbuild: Unify options 
for BTF generation for vmlinux and modules") does have:

diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
new file mode 100644
index 000000000000..e6093adf4c06

whereas your email does have the proper 100755 permission set on the 
file, any idea what happened here?
-- 
Florian
