Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61A4C8834
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiCAJkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiCAJkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:40:02 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF10583AA;
        Tue,  1 Mar 2022 01:39:22 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o26so13315328pgb.8;
        Tue, 01 Mar 2022 01:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E+BVVhJCud87ZJrms8Jysvy/5K9Pkkp5Ra0O8HOYuhc=;
        b=gCyJaz+Y8CoTDhXdEB85lg4sJHMTOOc6y05vyJEEE4lkIxGVQY01iFLCHdIqCnlcQN
         7uye+T1o1ZnNQ1tzzvsxP5D7w/0wqr4RadXt/k0WZcm8oWynWnTs0T7pxyIBnKJUhDz0
         rwOR9NBhHjJKmNsVqT1SfwJg+XxoB/4RC3DtWwowUzlI8ki026uwfSYIXVXGCWgWcYJT
         02g5V6G/bD71iqNikagw+3a9/zJJ6NZ4tBhV4YTPQEM4ohfXlBzKZJ0pyrtKETloY3tJ
         ecqsWHha9j6jAyZMMArlxqT83whCQfBcqHMhG+866sMK60DIRBDHoG6eTvYiBr3ntiIi
         KETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E+BVVhJCud87ZJrms8Jysvy/5K9Pkkp5Ra0O8HOYuhc=;
        b=EupeP8ZAdSDvI9yyt8L+nknsh0QYcOQjP8I3mXXdxv/uD8fOx9RRjIyUTNrYV4hghu
         Em6OkLhS4qaygpC0/50JeHEqSnaaJqnpF8DSzgxW5rKpOfOCHDOj4/fSB2lEQDdmyBLr
         Lp1SpttjpanuxY7PLDYo1PgE88YHJP81KAQely1AEnSkgKOzUdVKhU6Yd7jwaTUYp8Yw
         y7idw1K7h/+V8LO+Mmlc3pvoEzrn8RZarhAQL1rb1RdHE5ATZSwU+YIpcxUGelwXf67Y
         z12IYVtgc1Ugd2Z2mb016UkY31wvXF8pG8ja0V/3Sx6sYbTOlqsqT5nUwRGQ6dr77dxe
         7nkQ==
X-Gm-Message-State: AOAM533PBdn2xSxZEUWVSfQ0uhqms44qLU9rGOoH9s0GmBBsJOaatxWS
        h4oIlR9MM19TW+ZIBkL9Hkc=
X-Google-Smtp-Source: ABdhPJyxzBZkB1dz7VVhKlv2LaxY2Qa4WhDa7i4NR1n53EZlbIAHP15Inh0ay6q2gpAD46qrj8Q3uA==
X-Received: by 2002:aa7:918f:0:b0:4cc:3c00:b2dd with SMTP id x15-20020aa7918f000000b004cc3c00b2ddmr26737208pfa.77.1646127561607;
        Tue, 01 Mar 2022 01:39:21 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-83.three.co.id. [180.214.232.83])
        by smtp.gmail.com with ESMTPSA id u19-20020a056a00099300b004e16e381696sm16764025pfg.195.2022.03.01.01.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 01:39:21 -0800 (PST)
Message-ID: <ebe45c35-ebbe-3a02-fddb-08dbc3a95224@gmail.com>
Date:   Tue, 1 Mar 2022 16:39:15 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220228172347.614588246@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/03/22 00.22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
