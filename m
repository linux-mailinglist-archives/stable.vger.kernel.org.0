Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D1C5BB111
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 18:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiIPQZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 12:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPQZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 12:25:01 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9501E3F5;
        Fri, 16 Sep 2022 09:25:00 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id m130so6748482oif.6;
        Fri, 16 Sep 2022 09:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=U5AYJvax+i2EMubMe6fD3KCYINyj/ItK7CWW73D66sI=;
        b=gIv6oYKsjrSP/2YfL/tjL4UCSavJrEUmLSf9v4eDo1jRkumKKDPkbcHs+GuNf3Dukl
         Ii7Eh6NSJv5vXNzU6n7gsuQrnc0LYxjftkHpsYcXPvkkpHkSlmKb4Z/F0LI3xjVXS9SB
         aqtnWopiIT2ZiRXQySJUZHTRKIeMyzIZgmFAgu3K1EnyqPrXXhFlnL9zQmhcK6ovfX10
         TKd949RA5XeKySmgrSVSlAQXkVu9CMuPHBDnD2OQY8T03isToIsf3/nqe+Y8CTd2I8Tl
         VMG2CNeZMrPATjStDNNBY5JIBgxYQlzIU6LSiAyYdnQ0Do2baMDM+W5zY5/5+hOLh8qg
         g8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=U5AYJvax+i2EMubMe6fD3KCYINyj/ItK7CWW73D66sI=;
        b=Cvctue1wn+msSHLABHkE3r0wLf7Bw42QuBmcKqZL0SjmUaX3N7mWmQW+jLVljxAXkg
         4il3g0yn46wHA765vx9TNaYO7zpObjZuvrabTRSt2+TQt5Zis1T5UM9jh1Hto43VrbRB
         cn9A5KTbAw8lTpSnCytatDcKYjxOPgzPIKMQDGqbUZMdiXx2QMrj1ZCmneKY9xRPQ9O1
         onioRN3ATddLkfovQA2TqidXvpagGkwdQsdi6uHBurZUvxOQXMxfGLleqbDh2AHvaTx5
         BKXN85PgEHuOlqhXRf/YkWDWRnCQgb0gMKiYiaQCPr8HjwbVqsmCo3MxkxaJKlSXAXiY
         ocaw==
X-Gm-Message-State: ACgBeo1oBxuxevDExoY9CWn22EJzsxrgM/wPJIGimcEWJqV8Q8a79B9w
        f5upfKXI6XK+9Jdn221+X/x2E/Md6LU=
X-Google-Smtp-Source: AA6agR5+WBFT+s1ltH0THiFbRQOT/8M1i6Vr2Qrxos/nJAccwseA1/bCBTnZLLtP9z0sEZ/NbmbYPA==
X-Received: by 2002:a05:6808:1524:b0:350:1965:8a1 with SMTP id u36-20020a056808152400b00350196508a1mr5816711oiw.211.1663345499597;
        Fri, 16 Sep 2022 09:24:59 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id j12-20020a4aab4c000000b00475652b97d8sm1166174oon.42.2022.09.16.09.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 09:24:58 -0700 (PDT)
Message-ID: <9f2f639e-2ccc-fe53-b285-041cddb9a92b@gmail.com>
Date:   Fri, 16 Sep 2022 13:25:19 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 5.15 102/107] kbuild: Add skip_encoding_btf_enum64 option
 to pahole
Content-Language: en-US
To:     Thorsten Leemhuis <linux@leemhuis.info>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132826.180891759@linuxfoundation.org>
 <20ad29b8-be2c-8c1e-bd34-9709e5a9922f@leemhuis.info>
From:   Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20ad29b8-be2c-8c1e-bd34-9709e5a9922f@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/22 07:21, Thorsten Leemhuis wrote:
> On 06.09.22 14:31, Greg Kroah-Hartman wrote:
>> From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
>>
>> New pahole (version 1.24) generates by default new BTF_KIND_ENUM64 BTF tag,
>> which is not supported by stable kernel.
> 
> Martin, when you wrote "not supported by stable kernel", did you mean
> just 5.15.y or 5.19.y as well? Because I ran into...
> 
>> As a result the kernel with CONFIG_DEBUG_INFO_BTF option will fail to
>> compile with following error:
>>
>>   BTFIDS  vmlinux
>> FAILED: load BTF from vmlinux: Invalid argument
> 
> ...this compile error when compiling 5.19.9 for F37 and from a quick
> look into this it seems this was caused by a update of dwarves to 1.24
> that recently landed in that distribution. This patch seems to fix the
> problem (it got past the point of the error, but modules are still
> compiling).

Thorsten, by stable I've meant both current stable and longterm, i.e.
5.19 and below, and yes, I didn't sent a patch according to the stable
submission guidelines for 5.19 in time so I apologize for that. Gonna
send the patch for it. Thanks for reminding me.
