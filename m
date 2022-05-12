Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D861524633
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 08:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350586AbiELGz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 02:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350581AbiELGz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 02:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2D5C229065
        for <stable@vger.kernel.org>; Wed, 11 May 2022 23:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652338523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KIW16efPZTPXF7vXmoAKJ6+LI7vVPqzYCyoW+qf9gM4=;
        b=iTkroI7BtTeCtx48soQ0tHwMZAY7wz3e88YBFNNzCUhNJ7aAyrS8oonJEHXT7LO/vWNuui
        QdA4bdnbLIyKv71xSqbPFO2iZk2F7JtQW79n2WnKt49HC0ZE/+YoPdalhWdBBesz65EREr
        QjkfPSVgXuVYQqCueOOKPi7NARPJBko=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-tebBWgNbP_-pHQDjN7lcmA-1; Thu, 12 May 2022 02:55:21 -0400
X-MC-Unique: tebBWgNbP_-pHQDjN7lcmA-1
Received: by mail-pg1-f199.google.com with SMTP id q143-20020a632a95000000b003c1c3490dfbso2181448pgq.20
        for <stable@vger.kernel.org>; Wed, 11 May 2022 23:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KIW16efPZTPXF7vXmoAKJ6+LI7vVPqzYCyoW+qf9gM4=;
        b=zajRTL1i+ftkVz9/Gz3/TL2/XVpnNULDiYBfnxHea6KT15M9yIqkHE6W257HzcaJOU
         oMZ6L/ajR0s3qaTkJyCNaehc5xfIPym8o2zNOCr+HdcyXhj6HgpoMPlPJU4ElakdaW40
         U3Bkt34rj07vw6b57fXr7zeJhz49UA9M+JWrajyMR8GxNYftRxYiPiBoahxMQFUN9pCP
         NooR137CtqP/DaVgXzK2JtOB7PbI35E32OlW2oL/6ICthfm8wfoOMW667eE0rpE5y4wh
         EW77F9vC1PwHcSxvUg2xSAMAXeNcN4TPvJSFr27uX4HmAK24ntSjMljIZZqfmQdDmHuE
         afKA==
X-Gm-Message-State: AOAM533oeZixTSCE1GKqsrGGvf1Dud8HKwRWEjrogxMyfsQdpmCCTh/E
        HsXCEHdgELbW7QA6Oh0iQino79lNtVrOytDLZ7pN/t3szyN9acJi7wZXwLRVyfvlzMouroMTSBk
        eLq6O4/Z6eV7YHT0P
X-Received: by 2002:a63:80c6:0:b0:3c2:88f0:9035 with SMTP id j189-20020a6380c6000000b003c288f09035mr24278689pgd.606.1652338520732;
        Wed, 11 May 2022 23:55:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkdTJ7sQGjP+3Rj3u8vSGTO9HWGPdcwyACt6Ww8UmyQOmDfjVrRB+T+y5XgfYVWwoXO1Gqrg==
X-Received: by 2002:a63:80c6:0:b0:3c2:88f0:9035 with SMTP id j189-20020a6380c6000000b003c288f09035mr24278669pgd.606.1652338520467;
        Wed, 11 May 2022 23:55:20 -0700 (PDT)
Received: from localhost ([240e:3a1:2e9:efa0:e73c:e550:ac9e:58fd])
        by smtp.gmail.com with ESMTPSA id l12-20020a170902d34c00b0015e8d4eb296sm3022491plk.224.2022.05.11.23.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 23:55:20 -0700 (PDT)
Date:   Thu, 12 May 2022 14:54:09 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     Baoquan He <bhe@redhat.com>
Cc:     kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Dave Young <dyoung@redhat.com>, Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>, Chun-Yi Lee <jlee@suse.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/4] kexec, KEYS: make the code in
 bzImage64_verify_sig generic
Message-ID: <20220512065409.xxegsttgwfh63fsv@Rk>
References: <20220512023402.9913-1-coxu@redhat.com>
 <20220512023402.9913-3-coxu@redhat.com>
 <Ynx1DUvDTL1R4Pj5@MiWiFi-R3L-srv>
 <YnyEafqEcSh/wRRN@MiWiFi-R3L-srv>
 <20220512043310.v3e22423ybe4z65e@Rk>
 <Ynynwe7Q0+0DSABQ@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Ynynwe7Q0+0DSABQ@MiWiFi-R3L-srv>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 02:22:57PM +0800, Baoquan He wrote:
>On 05/12/22 at 12:33pm, Coiby Xu wrote:
[...]
>> > Just to make clear , is this patch fixing an issue, or it's just an
>> > preparation for later patch's use?
>> >
>> > Or I should ask in another way, any problem is solved with this patch?
>>
>> At least it doesn't fix an issue that satisfy the criteria listed in
>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
>Then it should not be CC-ed to stable.

OK, I'll drop "CC:" in next version.

>
>>
>> >
>> >
>> > > > Reviewed-by: Michal Suchanek <msuchanek@suse.de>
>> > > > Signed-off-by: Coiby Xu <coxu@redhat.com>
>> > > > ---
>> > >
>> > > You can put the note here, it won't be added to commit log when merged.
>> > > Maybe it can be removed when merged.
>>
>> Thanks for the suggestion! Shall I send a version to fix this problem or
>> can I just bother the maintainer to remove it?
>
>Better send a clean one, it will save maintainer's time, they can pick
>it directly.

Thanks for the confirmation! I'll simply delete them because,
1. these notes don't make sense anymore if I don't CC the patches to the stable
    tree 
2. I've explained in the cover letter the first two patches
    are the prerequisite patches for the 3rd patch.

-- 
Best regards,
Coiby

