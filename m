Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9ADF524448
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 06:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347397AbiELEdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 00:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347244AbiELEdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 00:33:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94DA2217FFF
        for <stable@vger.kernel.org>; Wed, 11 May 2022 21:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652330017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9m59m31zWjI88PU/fkJ+2jBtK+MMPKzeFSYoFIaJt9c=;
        b=ivM6D6GEBeNeUYxB9rgO4yZWXgPa8JN5ohn4mf31fEvvs1GM+GpTw6RpG5SvN9e1Nn3OAS
        mjpTwfHB+2vgtsRH5MmLarUVUnCQqhZAnwfO/eFQ+B0bGFAmJnelMr9Gk07ClatmD3WPVN
        Vjz00XzdUNLYI4PVPzbmxRLdCxy8jBQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-Nhogmzl5Mgqg6APIzIz9Gw-1; Thu, 12 May 2022 00:33:36 -0400
X-MC-Unique: Nhogmzl5Mgqg6APIzIz9Gw-1
Received: by mail-pf1-f200.google.com with SMTP id i127-20020a625485000000b0050d3d1cab5fso2066296pfb.5
        for <stable@vger.kernel.org>; Wed, 11 May 2022 21:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9m59m31zWjI88PU/fkJ+2jBtK+MMPKzeFSYoFIaJt9c=;
        b=Us0IJsSQ+qp22Q/A4GEaHvWNDX+MD3XxhI5UAuUZLdKzdZias1rnT45myj08vuUSqH
         H13c8L4F3EAi7Dlou8JkhtcLprXiJnrUUhgOvKCLn2VkTUBwqJOJ3WDkgX85E51sOvAQ
         vKwj/I81LqCCUZLXJ21XJ/NYab9EndH+nN+4qlEZ2sAh6HE/CBJgAkyFQhIaVf/DVpI/
         BF6+g1AvR7LFVzcSAXMRdMrYnl5XTfRncA0KZaq4OFEqb4sBDFdbc9eWB26csHnypg3U
         nZLYyWqAGQo0CVpjZ9nZdoqQgEOKESoRX0gr5BQvleQxa0ek/RncvgQ3hY5XT2z6GXAt
         moOw==
X-Gm-Message-State: AOAM530yA5+ZX4u0nEB56iyoAzY+a7MWFexX4rGijBuRB9zBx6MKSNVQ
        /XWjsjBq8KmqMdEaMSRFIRcHKG9zccYJbBtACCyk8IIQaeSs/tFdbt+hanMl8rxxrmAFCZSVQNW
        zQPJFkJQyJIT0awUJ
X-Received: by 2002:a17:903:32d0:b0:15e:8cbc:fd39 with SMTP id i16-20020a17090332d000b0015e8cbcfd39mr29480052plr.95.1652330015204;
        Wed, 11 May 2022 21:33:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwywe5Nh4a9dE8q7MbA+N0sqO4+GFmGOMSIJl/Vpj8aBpEmmVY8aRc6/9wvIdpdBGVwqi/Qbw==
X-Received: by 2002:a17:903:32d0:b0:15e:8cbc:fd39 with SMTP id i16-20020a17090332d000b0015e8cbcfd39mr29480024plr.95.1652330014959;
        Wed, 11 May 2022 21:33:34 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0015e8d4eb293sm2755119pll.221.2022.05.11.21.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 21:33:34 -0700 (PDT)
Date:   Thu, 12 May 2022 12:33:10 +0800
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
Message-ID: <20220512043310.v3e22423ybe4z65e@Rk>
References: <20220512023402.9913-1-coxu@redhat.com>
 <20220512023402.9913-3-coxu@redhat.com>
 <Ynx1DUvDTL1R4Pj5@MiWiFi-R3L-srv>
 <YnyEafqEcSh/wRRN@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YnyEafqEcSh/wRRN@MiWiFi-R3L-srv>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 11:52:09AM +0800, Baoquan He wrote:
>On 05/12/22 at 10:46am, Baoquan He wrote:
>> On 05/12/22 at 10:34am, Coiby Xu wrote:
>> > commit 278311e417be ("kexec, KEYS: Make use of platform keyring for
>> > signature verify") adds platform keyring support on x86 kexec but not
>> > arm64.
>> >
>> > The code in bzImage64_verify_sig makes use of system keyrings including
>> > .buitin_trusted_keys, .secondary_trusted_keys and .platform keyring to
>> > verify signed kernel image as PE file. Make it generic so both x86_64
>> > and arm64 can use it.
>> >
>> > Note this patch is needed by a later patch so Cc it to the stable tree
>> > as well.
>>
>> This note should not be added in log.
>>
>> >
>> > Cc: kexec@lists.infradead.org
>> > Cc: keyrings@vger.kernel.org
>> > Cc: linux-security-module@vger.kernel.org
>> > Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
>
>Hold on, should we CC stable when it's not fixing an issue?
>
>Hi Coiby,

Hi Baoquan,

>
>Just to make clear , is this patch fixing an issue, or it's just an
>preparation for later patch's use?
>
>Or I should ask in another way, any problem is solved with this patch?

At least it doesn't fix an issue that satisfy the criteria listed in 
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

>
>
>> > Reviewed-by: Michal Suchanek <msuchanek@suse.de>
>> > Signed-off-by: Coiby Xu <coxu@redhat.com>
>> > ---
>>
>> You can put the note here, it won't be added to commit log when merged.
>> Maybe it can be removed when merged.

Thanks for the suggestion! Shall I send a version to fix this problem or
can I just bother the maintainer to remove it?


>>
>> Otherwise, LGTM
>>
>> Acked-by: Baoquan He <bhe@redhat.com>
>>
>> >  arch/x86/kernel/kexec-bzimage64.c | 20 +-------------------
>> >  include/linux/kexec.h             |  7 +++++++
>> >  kernel/kexec_file.c               | 17 +++++++++++++++++
>> >  3 files changed, 25 insertions(+), 19 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
>> > index 170d0fd68b1f..f299b48f9c9f 100644
>> > --- a/arch/x86/kernel/kexec-bzimage64.c
>> > +++ b/arch/x86/kernel/kexec-bzimage64.c
>> > @@ -17,7 +17,6 @@
>> >  #include <linux/kernel.h>
>> >  #include <linux/mm.h>
>> >  #include <linux/efi.h>
>> > -#include <linux/verification.h>
>> >
>> >  #include <asm/bootparam.h>
>> >  #include <asm/setup.h>
>> > @@ -528,28 +527,11 @@ static int bzImage64_cleanup(void *loader_data)
>> >  	return 0;
>> >  }
>> >
>> > -#ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
>> > -static int bzImage64_verify_sig(const char *kernel, unsigned long kernel_len)
>> > -{
>> > -	int ret;
>> > -
>> > -	ret = verify_pefile_signature(kernel, kernel_len,
>> > -				      VERIFY_USE_SECONDARY_KEYRING,
>> > -				      VERIFYING_KEXEC_PE_SIGNATURE);
>> > -	if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING)) {
>> > -		ret = verify_pefile_signature(kernel, kernel_len,
>> > -					      VERIFY_USE_PLATFORM_KEYRING,
>> > -					      VERIFYING_KEXEC_PE_SIGNATURE);
>> > -	}
>> > -	return ret;
>> > -}
>> > -#endif
>> > -
>> >  const struct kexec_file_ops kexec_bzImage64_ops = {
>> >  	.probe = bzImage64_probe,
>> >  	.load = bzImage64_load,
>> >  	.cleanup = bzImage64_cleanup,
>> >  #ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
>> > -	.verify_sig = bzImage64_verify_sig,
>> > +	.verify_sig = kexec_kernel_verify_pe_sig,
>> >  #endif
>> >  };
>> > diff --git a/include/linux/kexec.h b/include/linux/kexec.h
>> > index 413235c6c797..da83abfc628b 100644
>> > --- a/include/linux/kexec.h
>> > +++ b/include/linux/kexec.h
>> > @@ -19,6 +19,7 @@
>> >  #include <asm/io.h>
>> >
>> >  #include <uapi/linux/kexec.h>
>> > +#include <linux/verification.h>
>> >
>> >  /* Location of a reserved region to hold the crash kernel.
>> >   */
>> > @@ -202,6 +203,12 @@ int arch_kexec_apply_relocations(struct purgatory_info *pi,
>> >  				 const Elf_Shdr *relsec,
>> >  				 const Elf_Shdr *symtab);
>> >  int arch_kimage_file_post_load_cleanup(struct kimage *image);
>> > +#ifdef CONFIG_KEXEC_SIG
>> > +#ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
>> > +int kexec_kernel_verify_pe_sig(const char *kernel,
>> > +				    unsigned long kernel_len);
>> > +#endif
>> > +#endif
>> >  int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf);
>> >
>> >  extern int kexec_add_buffer(struct kexec_buf *kbuf);
>> > diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
>> > index 3720435807eb..754885b96aab 100644
>> > --- a/kernel/kexec_file.c
>> > +++ b/kernel/kexec_file.c
>> > @@ -165,6 +165,23 @@ void kimage_file_post_load_cleanup(struct kimage *image)
>> >  }
>> >
>> >  #ifdef CONFIG_KEXEC_SIG
>> > +#ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
>> > +int kexec_kernel_verify_pe_sig(const char *kernel, unsigned long kernel_len)
>> > +{
>> > +	int ret;
>> > +
>> > +	ret = verify_pefile_signature(kernel, kernel_len,
>> > +				      VERIFY_USE_SECONDARY_KEYRING,
>> > +				      VERIFYING_KEXEC_PE_SIGNATURE);
>> > +	if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING)) {
>> > +		ret = verify_pefile_signature(kernel, kernel_len,
>> > +					      VERIFY_USE_PLATFORM_KEYRING,
>> > +					      VERIFYING_KEXEC_PE_SIGNATURE);
>> > +	}
>> > +	return ret;
>> > +}
>> > +#endif
>> > +
>> >  static int kexec_image_verify_sig(struct kimage *image, void *buf,
>> >  		unsigned long buf_len)
>> >  {
>> > --
>> > 2.35.3
>> >
>>
>

-- 
Best regards,
Coiby

