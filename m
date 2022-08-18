Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EF3597C59
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 05:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbiHRDpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 23:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242888AbiHRDpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 23:45:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A655194ED7
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 20:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660794347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8CnuyrgMbGwbd9LjCBf/a/7eFEWFEt/rlXTJioi7X8Q=;
        b=FLTngx+7143cfnDnj5p4RrsWSF4zB+uzdIFwP350nvuWVSO+Kys/USiM/2v2ZYynHw0c4n
        GfEOhrJ5bCS7LqkmD6vPsKq1HPDWU438EA0rvuU8UKpxpDEx4J8rVSjGaAw9bbX7DpcfBW
        XOcxUIzHvAe1bO7fXOUzoxwAPXU+P6Y=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-183-S3yrGvwFNF2wovCqQg8FjA-1; Wed, 17 Aug 2022 23:45:45 -0400
X-MC-Unique: S3yrGvwFNF2wovCqQg8FjA-1
Received: by mail-pl1-f199.google.com with SMTP id u10-20020a170902e5ca00b0016f091c4b6bso382875plf.10
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 20:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8CnuyrgMbGwbd9LjCBf/a/7eFEWFEt/rlXTJioi7X8Q=;
        b=KXY3K6+xcOjvx+XGyq8xJDsRC4uFh85UuM9ldiW31v0kNVipN4MFnN67dZPWt6jWwB
         43uG3ONKcEny3pvOiZ/Os8CnSNNG6iIkBnYS1r2JeztDO2BeX6ECXHYtGLcQCFYANeZ2
         Goh3azGso99q6culfnnlCIj3vooYgcbnTNnhtg4X5bq3Ir6Pp+WQp+AosCz9F/EQwaTT
         cPJAntE6Fr2jB4boGYx9axjvYVeZCfdvtal9zFfRm+a3Fm6pEGtJ/lQj1a/Ne7XI8/NU
         rLk9CaXSplVII3Kqp5XVDXDFOcXYssFk7oWc8Pbj03NEHM29Sdpf7Eribf2Jfk260BNM
         2kew==
X-Gm-Message-State: ACgBeo00tjAIxPVCnkfnOewLGXfDFhWTZlu7j1vmXW2T94TSZZl239Jw
        He+IsrTWL5vzPPsPl60dc8RxvrJgA5Q880z7IxRIJ5zDhCv8hjwC4J7m2tINuKGVJElLieahyqV
        /xKYgkMyWX24GGuz8
X-Received: by 2002:a17:90b:3904:b0:1f7:314d:d463 with SMTP id ob4-20020a17090b390400b001f7314dd463mr1129633pjb.27.1660794344643;
        Wed, 17 Aug 2022 20:45:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ZoZKBmDet7n6HQi9CSzw9sTsyZQHl6ZxSTlkoWoVva9YkGuknHRAbaEXAks6R5FaBvKkSXw==
X-Received: by 2002:a17:90b:3904:b0:1f7:314d:d463 with SMTP id ob4-20020a17090b390400b001f7314dd463mr1129621pjb.27.1660794344355;
        Wed, 17 Aug 2022 20:45:44 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9-20020a654349000000b0041c45d76b6bsm270020pgq.38.2022.08.17.20.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 20:45:43 -0700 (PDT)
Date:   Thu, 18 Aug 2022 11:44:03 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     bhe@redhat.com, msuchanek@suse.de, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <20220818034403.fnytjbjf726sg5dx@Rk>
References: <166057758347124@kroah.com>
 <20220816063256.qzc6jh744i2zc6ou@Rk>
 <YvtOfWDg2SXdcqgL@kroah.com>
 <20220816104559.xwovh5y4bcx6n37a@Rk>
 <YvzZILTQYXBanipB@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YvzZILTQYXBanipB@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 02:03:44PM +0200, Greg KH wrote:
>On Tue, Aug 16, 2022 at 06:45:59PM +0800, Coiby Xu wrote:
[...]
>> > > > > From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
>> > > > From: Coiby Xu <coxu@redhat.com>
>> > > > Date: Thu, 14 Jul 2022 21:40:26 +0800
>> > > > Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
>> > > > image signature
>> > > >
>> > > > Currently, when loading a kernel image via the kexec_file_load() system
>> > > > call, arm64 can only use the .builtin_trusted_keys keyring to verify
>> > > > a signature whereas x86 can use three more keyrings i.e.
>> > > > .secondary_trusted_keys, .machine and .platform keyrings. For example,
>> > > > one resulting problem is kexec'ing a kernel image  would be rejected
>> > > > with the error "Lockdown: kexec: kexec of unsigned images is restricted;
>> > > > see man kernel_lockdown.7".
>> > > >
>> > > > This patch set enables arm64 to make use of the same keyrings as x86 to
>> > > > verify the signature kexec'ed kernel image.
>> > > >
>> > > > Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
>> > > > Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions
>> >
>> > This is not a valid commit id in Linus's tree.
>> >
>> > > > Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
>> >
>> > This is not a valid commit id in Linus's tree
>> >
>> > > > Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic
>> >
>> > And this too is not a valid commit in Linus's tree.
>>
>> Sorry for the confusion. The correct commit ids are as follows,
>>
>> 0738eceb6201 ("kexec: drop weak attribute from functions")

Sorry, the first one should be 65d9a9a60fd7 ("kexec_file: drop weak
attribute from functions").

>> 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
>> c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
>
>What order do they need to be applied in?

They should be applied from top-down, i.e.

1. 65d9a9a60fd7 ("kexec_file: drop weak attribute from functions")
2. 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
3. c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")

But I notice stable/linux-5.19.y has already the first two prerequisites
backported. So only the 3rd prerequisite is needed.

>
>thanks,
>
>greg k-h
>

-- 
Best regards,
Coiby

