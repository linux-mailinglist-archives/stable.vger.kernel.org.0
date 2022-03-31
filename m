Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15884EDE63
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiCaQIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiCaQIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:08:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810C2100749
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:07:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso2794922pju.1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Nki8v1tyiyo+tquKFXOfKDGwQw/wiRkFS4l4It2djOo=;
        b=co7lB2nIpD1sftmae/M9R838hO0Jcu5ka8VAS10ofHdc79XCig0Pn46rNK5z+ucLNM
         47c3LTdIdERBAvKGT8+n9MFEBgfLDzWdOy9CGtHhpT9N52cLgoThsn2T9KVkXJJ7HQgN
         JPG0F+UaZkupJ9qjlCGVpgUBKAvRliXwnRlo4OhUimW+VJM2gUCwpCzeTkrHSablc++A
         ZlQlkgrZxFlvy016y6rooWXi4p1xYFyoaaSAIY3x83NZ2Yb+SFArOrHOuQlgF5uIrNpx
         24QhMJYczLOG5Pti7ViK3qklBkeHkSsl1AJSXqxCT//ohWU5gzRyJqeQnSw35hwAXvef
         XupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Nki8v1tyiyo+tquKFXOfKDGwQw/wiRkFS4l4It2djOo=;
        b=5ANgPFdfHWxfkC5LaPiGa/mLpPjwgBh0jyqHVj5h00sKXiBLjQI0eX2OYRBH14nRRx
         EZ1xXSVPYRkf26pbTBjTsPV0Ft7/rm5b1vWp8TZMXLxXw7L7KWW178bNtWCeJwLGc44O
         HM5yrkzQvOhb7e8sV52H7eACXwHdCMB2XRCJyLfC/2Pg6h55P773mS/RdJV7bRiBUCKp
         HqyzJePfFVgrb/WahkWUj4f7mJwyZhgUAGNKi96zkJ/bmmQopha7kAY23pwWp/A0XTrc
         oCwLNa/CD71J0at5CNVvGjivBTSJ1G/kaKUAdkvHCVona4/KEXL2b2y07l15ql8lv2bl
         kMKg==
X-Gm-Message-State: AOAM531TitxQuFeL7sEE21wBkngTRRVOVmz9LLnkUBpLfSLblwQSZq1N
        6ln6ehqFYgRMtTI8M+4VH+2EoC0Ufeexacin
X-Google-Smtp-Source: ABdhPJx9GHOiCmB18Th6y5uPg49bTMvu42hVh7w8CxDEOocXp3SC8Ie9QAW3PxId6kVooZCwQLVZPA==
X-Received: by 2002:a17:90a:e7cc:b0:1c7:bb20:924e with SMTP id kb12-20020a17090ae7cc00b001c7bb20924emr6931052pjb.226.1648742823772;
        Thu, 31 Mar 2022 09:07:03 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id lx13-20020a17090b4b0d00b001c9989c721esm11298489pjb.17.2022.03.31.09.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 09:07:03 -0700 (PDT)
Message-ID: <a12b6cf4-2002-09d6-80a4-56bfea0b4e56@linaro.org>
Date:   Thu, 31 Mar 2022 09:07:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10] ubsan: remove CONFIG_UBSAN_OBJECT_SIZE
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220331160219.10687-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220331160219.10687-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/22 09:02, Tadeusz Struk wrote:
> Upstream commit: 69d0db01e210 ("ubsan: remove CONFIG_UBSAN_OBJECT_SIZE")
> 
> The object-size sanitizer is redundant to -Warray-bounds, and
> inappropriately performs its checks at run-time when all information
> needed for the evaluation is available at compile-time, making it quite
> difficult to use:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=214861
> 
> This run-time object-size checks also trigger false-positive errors,
> like the below, that make it quite difficult to test stable kernels in
> test automations like syzkaller:
> 
> https://syzkaller.appspot.com/text?tag=Error&x=12b3aac3700000
> 
> With -Warray-bounds almost enabled globally, it doesn't make sense to
> keep this around.

Hi,
This back-port is for 5.10 only. Please also cherry-pick the original
commit 69d0db01e210 ("ubsan: remove CONFIG_UBSAN_OBJECT_SIZE")
to 5.15.y and 5.16.y. There is no back-port required for these kernels.

-- 
Thanks,
Tadeusz
