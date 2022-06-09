Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA3B545577
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 22:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiFIUTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 16:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiFIUTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 16:19:17 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0BB23BCC
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 13:19:15 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p128so3856922iof.1
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 13:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pCT+y9wLdgLk9pr0qPxcnU+1Oz3gXAHCLeApcNSQYOE=;
        b=L9uVwEcY/Lap/ZIMMt3tnyaUdoQ9QD4lkE+EslYMWxv7mLtjl6CrudtW9ukzu08cwf
         ECC4NczaK2O4ruQ36eLwdwcU9SbAPD2uvCdsltcSDUuxfwAQLLKTstARjRKtU6z9Z+WH
         WREnbUTFFAj9MsTdqb6AmYI3ez3Tigxt48Zvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pCT+y9wLdgLk9pr0qPxcnU+1Oz3gXAHCLeApcNSQYOE=;
        b=3NRmdcwm3EzHsN+SdfoiH8UKtt+HImoWlNblRV+Fq/xHTyKAN5HUhZekbPnsZT6Tij
         6yvQhPuP+NtKLRS54DNlvBt/LnEo1gJAEQ9WP5K+jNjp9q07OMTnvOuyVqFb71jgurV3
         7JTlVVCpHKEFoPv+io4wRkQu54E8dUQ34u26iDXGIMOg2MbykLcf/oV3/mGnSleOMuD1
         7ecB8NtWwlnDdcgSsaf5VLlPCC6rgWck9NbPwQtVL91hRR3yCk9dlLXOhZEmspsBlbco
         S1MoVDK2ecrRfu8NLtJDZYf7S7UsJZRmMQH3DlxNIneKUiajvxQqOph28mOH02RfdJny
         ABXw==
X-Gm-Message-State: AOAM533vvhAS647Z58+663s2BWdB3HxYFGmBoKIURqYZ37Xi7jG1ilIn
        TfJ1uo0+Hax0FrzHUixL4Yv/7g==
X-Google-Smtp-Source: ABdhPJzRTU8kwv7jSdvQMG8MOudNQyXl9EUF4P4Q3k6sak9Oao0PkNq/Y2ae1NqlUVqdyOBK/hISkg==
X-Received: by 2002:a02:3506:0:b0:328:9a29:678 with SMTP id k6-20020a023506000000b003289a290678mr21945056jaa.33.1654805954469;
        Thu, 09 Jun 2022 13:19:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i3-20020a02a0c3000000b00330c5581c03sm10001148jah.1.2022.06.09.13.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 13:19:14 -0700 (PDT)
Subject: Re: [PATCH v2] selftests/sgx: add test_encl.elf to TEST_GEN_FILES
To:     Jarkko Sakkinen <jarkko@kernel.org>, Shuah Khan <shuah@kernel.org>,
        dave.hansen@linux.intel.com
Cc:     stable@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220523181120.54547-1-jarkko@kernel.org>
 <Yo7MS2+g9kcI39xq@iki.fi>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7d1a2605-d4c5-3e78-d3cf-ebb9a737abb5@linuxfoundation.org>
Date:   Thu, 9 Jun 2022 14:19:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <Yo7MS2+g9kcI39xq@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/25/22 6:39 PM, Jarkko Sakkinen wrote:
> On Mon, May 23, 2022 at 09:11:20PM +0300, Jarkko Sakkinen wrote:
>> TEST_GEN_FILES contains files that are generated during compilation and are
>> required to be included together with the test binaries, e.g. when
>> performing:
>>
>> make -C tools/testing/selftests install INSTALL_PATH=/some/other/path [*]
>>
>> Add test_encl.elf to TEST_GEN_FILES because otherwise the installed test
>> binary will fail to run.
>>
>> [*] https://docs.kernel.org/dev-tools/kselftest.html
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
>> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
>> ---
>> v2:
>> Use TEST_GEN_FILES in the "all" target, instead of duplicating the path for
>> test_encl.elf.
>> ---
>>   tools/testing/selftests/sgx/Makefile | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
>> index 75af864e07b6..7f60811b5b20 100644
>> --- a/tools/testing/selftests/sgx/Makefile
>> +++ b/tools/testing/selftests/sgx/Makefile
>> @@ -17,9 +17,10 @@ ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
>>   	       -fno-stack-protector -mrdrnd $(INCLUDES)
>>   
>>   TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
>> +TEST_GEN_FILES := $(OUTPUT)/test_encl.elf
>>   
>>   ifeq ($(CAN_BUILD_X86_64), 1)
>> -all: $(TEST_CUSTOM_PROGS) $(OUTPUT)/test_encl.elf
>> +all: $(TEST_CUSTOM_PROGS) $(TEST_GEN_FILES)
>>   endif
>>   
>>   $(OUTPUT)/test_sgx: $(OUTPUT)/main.o \
>> -- 
>> 2.36.1
>>
> 
> Dave, would it be by any means possible to pick this? My workload is
> kernel testing with buildroot [*].
> 
> [*] Related:
>      https://lore.kernel.org/buildroot/2c42570b01b2b51cc33d6623b25a736e4f20c601.camel@iki.fi/T/#t
> 
> BR, Jarkko
> 

I can pick this up with ack from Dave or here is mine to go through Dave's

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
