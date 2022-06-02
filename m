Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095D153B5ED
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 11:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiFBJWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 05:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbiFBJWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 05:22:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652A3A1B7;
        Thu,  2 Jun 2022 02:22:32 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 129so4283785pgc.2;
        Thu, 02 Jun 2022 02:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KeRV9VlhwIAyg6EUqX0Fszd3cElW50+A7dVuut11Ql8=;
        b=T+n7HgqhezIBE0FWmfDqATn2184KpAXP/iUBPS/aT4g74LaP8h6NlWCDFhbPl8mpRJ
         R2yGxiwiyV8JqcpCwXj7EqCXJCPx22zf0k73jDaeWTk7K10kUeLuKEuLyuBLeBwxELq1
         j/aQGP/heKZ3lRsUTybuy+Q7zwjfB7TVvuXxZBNZVq15Q62NuqXrA2RriidzxWRpzvIZ
         Wyj2i2HlHc7IwTbPUdXr+RtwmfJo8gSmsrpknYgo0TQNyK1eCEug1LynaOtwjUYzc/YR
         wguayKEzzLIrTNXMPjiVKAUDzMXLboQZn52dz3F3z3KdETWWarbsMWMd7FXWvzIGUBFT
         2TtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KeRV9VlhwIAyg6EUqX0Fszd3cElW50+A7dVuut11Ql8=;
        b=P12mx1FeyMGq1KKmYTvxtCWe46oryaVt1dH6j4PYVwCNTBYW9juraZgq7aaDHBIs7n
         6NgFsn71Mf7hdeRGGs/Kf9CeUaDrAbVgrlGaOHgt/z7LS/bmMEsTAAJ4Raz4ZqxDj0ln
         C/UhioIB9BBEX1jCJ/o62wRknTsfMEchhJfQNWpKTIv2ieL/mnb/dRQfsGV1qx5YV5Xq
         0ffBT4dG8yh4Y1AMi7MNkgFUZAbfqcNetsyf56En5k8lpFq/pb+aXrnhuYJSBpxu1aT7
         679kAF545AQQIjcGCdfYS90yW9dPcoG7CYu0kerDLkAAX5ppxrAIyCYgqW/gB2JKV5bP
         7oUg==
X-Gm-Message-State: AOAM5302kGoaonuJ6uryBDSNBJyxPrH9OhauiHzMjQQlC6+7+V2050Vh
        JARgoWVaK43UxyLb9TJpRUs=
X-Google-Smtp-Source: ABdhPJxElJXyhXOh8nC4t31hIdIX4SCbS/dv8nLykVgt//DQhqD96RDYfw60Gxl+zsBbBK6OuVKtcg==
X-Received: by 2002:a63:65c7:0:b0:3fc:85b5:30c0 with SMTP id z190-20020a6365c7000000b003fc85b530c0mr3497048pgb.165.1654161751927;
        Thu, 02 Jun 2022 02:22:31 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-24.three.co.id. [180.214.232.24])
        by smtp.gmail.com with ESMTPSA id 129-20020a621787000000b005180c127200sm2946985pfx.24.2022.06.02.02.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 02:22:30 -0700 (PDT)
Message-ID: <7f1c7301-e622-f177-70ac-d64046347613@gmail.com>
Date:   Thu, 2 Jun 2022 16:22:25 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3] HID: uclogic: properly format kernel-doc comment for
 hid_dbg() wrappers
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-doc@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220602082321.313143-1-bagasdotme@gmail.com>
 <Yph09N8w4g7+d9ER@kroah.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <Yph09N8w4g7+d9ER@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/2/22 15:29, Greg KH wrote:
> None of this is needed for stable kernels releases as no code is being
> modified.
> 
> thanks,
> 
> greg k-h

Hi Greg,

That's right, however because I don't see any kernel-doc warnings for
hid-uclogic-params.c on linux-5.18.y. These warnings appear only on
mainline.

Thanks for reminding me.

-- 
An old man doll... just what I always wanted! - Clara
