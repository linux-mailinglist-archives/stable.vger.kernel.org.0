Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C882959D2C7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbiHWHzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241449AbiHWHza (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:55:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208F71EEE1;
        Tue, 23 Aug 2022 00:55:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f21so13314701pjt.2;
        Tue, 23 Aug 2022 00:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Xxc+am8JnZzn38/YDRBLpPnG3B37sa007H6emh7sE1Q=;
        b=R5xBAQKoFl+3tgqEOz+RslovkAqgtUwmbSJqJbDX8B1c8NmMSCIwNWjdl/0syrbgWt
         ut68/XCzsoTvkQYqU+36wRCNb49XsTNU4wwS1Hy0ILDfwwdhi66kMAVmIGrgns32Zvsi
         FQ6Mch1DXKHhq1VZpdG4xfSP+VEoWiPCOF6Vmu1KemQdPLi47EAxYSb5lgfZMrWR7PQy
         MXGNlClcX7/lqGHrMT2Ia3aigTO1SNHAntfbitDynXtzDAAPrEg+tmG6eTfeNF+9K20V
         rhW023/By44bb1Xl8ZH1DgagEHsSHPTzu4cY6XLsQhIiBjP2Ggn+nXY78lfBWfyVdZNE
         MXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Xxc+am8JnZzn38/YDRBLpPnG3B37sa007H6emh7sE1Q=;
        b=pptgG7ZDjo9Q5WGOgAfjRKnhkedr6WKJkfj1t4uoA7C0Y4efEuWk64Vvl5J06uv5Av
         njD+doeZupi3thF5ROCrXm+nG7AdkFn2xZ4SNioWXQsyW8TwY5w/QYZhGkMDpmlRtHnD
         wjX3F2PX5w1mjeVB6/4xCvfmn6DFXzxTmKRad9gfvbonRXheewwO4pLWGD3MkdfzSVcT
         2z0E7/8gqRWR8Pu731FS1cPwUszhUjDu5+4J+T8HYjYRqAii0s5qCwrSSUL5ZRaWRXae
         G1W8dwhx+5JOdfUHdNV+xpXsouVxg2u/W6D3oHltS61OpHZ9SOEM/5vCMSWuZClUpHck
         e0Uw==
X-Gm-Message-State: ACgBeo3zE2lufuadwZGuKLWiVn1lb5TuK5a3PyUZ5bp7G8HWczfH4+kh
        +IkVNk8G3dFyul1FVSpjxy0=
X-Google-Smtp-Source: AA6agR5ZqZn05y3setXe2Ki853S0taRN0SeK5U8VFr0708OGCldReMvivNFDBZIb4kfxxohTcbMs+g==
X-Received: by 2002:a17:90a:304a:b0:1fa:d832:5aca with SMTP id q10-20020a17090a304a00b001fad8325acamr2104066pjl.16.1661241328592;
        Tue, 23 Aug 2022 00:55:28 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-14.three.co.id. [180.214.232.14])
        by smtp.gmail.com with ESMTPSA id z124-20020a626582000000b00536531536adsm5988664pfb.47.2022.08.23.00.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 00:55:28 -0700 (PDT)
Message-ID: <468ecea7-81fb-4a61-2094-3223bfbf55d4@gmail.com>
Date:   Tue, 23 Aug 2022 14:55:22 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] mips: pci: remove extraneous asterisk from top level
 comment of ar2315 PCI driver
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-doc@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Aditya Srivastava <yashsri421@gmail.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
References: <202208221854.8ASrzjKa-lkp@intel.com>
 <20220823030056.123709-1-bagasdotme@gmail.com> <YwRzqiJjHdnCA65Y@kroah.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <YwRzqiJjHdnCA65Y@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/22 13:28, Greg KH wrote:
> On Tue, Aug 23, 2022 at 10:00:56AM +0700, Bagas Sanjaya wrote:
>> kernel test robot reported kernel-doc warning:
>>
>> arch/mips/pci/pci-ar2315.c:6: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>>     * Both AR2315 and AR2316 chips have PCI interface unit, which supports DMA
>>
>> The warning above is caused by an extraneous asterisk on the top level
>> (description) comment of pci-ar2315.c, for which the comment is confused as
>> kernel-doc comment instead.
>>
>> Remove the asterisk.
>>
>> Link: https://lore.kernel.org/linux-doc/202208221854.8ASrzjKa-lkp@intel.com/
>> Fixes: 3ed7a2a702dc0f ("MIPS: ath25: add AR2315 PCI host controller driver")
>> Fixes: 3e58e839150db0 ("scripts: kernel-doc: add warning for comment not following kernel-doc syntax")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Cc: stable@vger.kernel.org # v5.15, v5.19
> 
> kerneldoc issues are not stable worth, sorry.
> 

Thanks for reminding me. Should I resend without Cc stable?

-- 
An old man doll... just what I always wanted! - Clara
