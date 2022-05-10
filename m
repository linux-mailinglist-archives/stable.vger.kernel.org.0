Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B53B52273E
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 00:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiEJWwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 18:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbiEJWwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 18:52:18 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530B21DEC5B
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:52:17 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a191so222269pge.2
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4xY5bF9UYm6MAVtzgNfATpmkNYNH44rnKMWoXQzjxrI=;
        b=FItJqMaNmWv33SShK+ZO3am8AWGCUIO6YZHO6V6G0rTg06JmT35pvYET0rD5wPSRKz
         PgAkOYcRvOg9plTi0Fpz6xMt09s+1bmZfMjbmpygVANoPcqVB3lrBOHQIGZKzyRQC2cz
         DERZv562zIwz3Y/CWl4EbJM59XeNRgMvRXdDxJ6wv3iRRZ0LV6Sxz60uF4f3G6yS4Jn+
         w45yjweNbsXo+XV4w/ghyJ+0ddsElP9+zEKMZyU97FyjBDsuZNWSuv+JBECRCBsFfFUP
         KnAri+dIhCAJdvlBSpRF1utp2WaUQN1LqnKN/58bGKpNR11aN2B1+2gLa7jOQ5itTpzd
         XzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4xY5bF9UYm6MAVtzgNfATpmkNYNH44rnKMWoXQzjxrI=;
        b=5cRzFe01XsStWMQcxJ5suLIgTQ4lNb1ES4pmvQAsJkrbfsY5pU5axgHGlUViJDIey8
         LfvM4PVNqbJamSGOwi+re6P/JrpGt4L3NxHiaZc+3OBPWypf8Gr2b7um2JJEyoCgO9C7
         2NR5BIl37+MyAdShhuPH7rxak1Wwq50dMnvqjWjkDFyuf8Digk9+t7PWAdIpe1bn+rLY
         7kWSOGh1nTShHw81aYTxfPrEmcea9kVZEnEPif4VP376l4vGI46EUJZhj2WTB9fKmgho
         bRh2K2VVwXWlROj9cJUwHBVmrSLwCwpGicRdLFKSPtBkFAFAMJM9L0KsDPHGU4hbFgKS
         oAgQ==
X-Gm-Message-State: AOAM530LeIQpkMB4RxrVnwgzZf0VmemnQYSLEdLQ2XXfTOqwo3X2areX
        2jhLZd2+eh/WCkv6mHLf4EGcZw==
X-Google-Smtp-Source: ABdhPJxBD7xz21Is5XyKacXGuURKZ97TVB0rCPcvgYeeGxXp0XTbwkIq3b31s//zgRAl/JwRiH+h9Q==
X-Received: by 2002:a05:6a00:1251:b0:50d:f2c2:7f4e with SMTP id u17-20020a056a00125100b0050df2c27f4emr22492045pfi.72.1652223136854;
        Tue, 10 May 2022 15:52:16 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id p2-20020a1709027ec200b0015e8d4eb229sm149967plb.115.2022.05.10.15.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 15:52:16 -0700 (PDT)
Message-ID: <ef6c9822-8099-99b2-0a88-50347934e62a@linaro.org>
Date:   Tue, 10 May 2022 15:52:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] exfat: check if cluster num is valid
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
References: <20220418173923.193173-1-tadeusz.struk@linaro.org>
 <CAKYAXd_9BT7je6-UHgDYCY-WD2maxYtam0_En8pgS_FiwRJP9Q@mail.gmail.com>
 <CAKYAXd8sQDJyftZ_N8bgCMcMCMraQ=6_8x+QZ5XprMN3P4x9gQ@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CAKYAXd8sQDJyftZ_N8bgCMcMCMraQ=6_8x+QZ5XprMN3P4x9gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/29/22 20:26, Namjae Jeon wrote:
>> Could you please share how to reproduce this ?
> Ping, If you apply this patch to your source, there is a problem. You
> need to add +1 to EXFAT_DATA_CLUSTER_COUNT(sbi).
> and please use is_valid_cluster() to check if cluster is valid instead of it.

Ok, I will try a new version with is_valid_cluster()

-- 
Thanks,
Tadeusz
