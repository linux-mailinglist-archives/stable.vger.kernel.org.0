Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3627E5E90AD
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 03:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiIYBuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 21:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiIYBuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 21:50:00 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2101D13D10;
        Sat, 24 Sep 2022 18:49:59 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w2so3598868pfb.0;
        Sat, 24 Sep 2022 18:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=h/xeqg+wtEQqa6F/N8BOgtLasB2ZkQRon2kmjus8Dxw=;
        b=nHAto2qbuUqbmNEGsg92BLf9TRRpjHqQ1w5KfRj49pw5ytiLHQdSqgH81DaXETmGLI
         XSZiFT4/Mk+6k1ed9vFGHyG6G/oXdZLWyozaDukQbKTpE1X5yecv659E8wM6G1bjkvw8
         INhO7ciIh+GAPnWrdxacNMHeO6bJXSn8T7qKjEyXXqStngRWkrsZI/W804aH6nh9OJrm
         KKNW81BEWZcGvgFXO/COSrN36vYMotrjXZ/a1ouZoRYvDBh5nntihHifZF7s3IHBGcvK
         pQeDzDj2xq2hGVlFJKEF2rgLR5fgDCydhXDX7J2Tpi95CXoSZh5GNxyp9N5E4PQQvHDM
         JrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=h/xeqg+wtEQqa6F/N8BOgtLasB2ZkQRon2kmjus8Dxw=;
        b=xRZItfwChgwdeKlPlUJs7X/aJfDK43ytKwQlgpxiEa1U/+W4zAyHTZ7MHat6AqXgLw
         HhSegF3R7e9GRxmRX+qMiqsXSWLKGCnHiFlyXLaTL0ZQ/riW+T6sip8XelVMFV86IAQ9
         umPkJLkAeEhOahFAaDjcPL539AS83JfT9gWkIFKAa4B7NGX12sJHG5ckXll9FXWa/Stl
         OxUc1AzRq829ZeaCkuEYQnAxizRjzMnG75sMoOIRuZI7NPRlAFR9NcyPXU3jmVJUieBv
         X10HmkzfbOezAtUxQaEyfrqELqcDBy98STQvMw/6NhlBL+f+2HTZGQfuYW6Jlafow8dR
         gZ6w==
X-Gm-Message-State: ACrzQf0DMSGeN8JIgF2uhjvaKggA2a4JWNDNa/XBVuX2q7O8La2sVtoj
        /KuEoTooiBJ+KflUMlimxhbQITXt5Ns=
X-Google-Smtp-Source: AMsMyM7ctXt2bsR+uC7TWX5wXPCI08LCsY58xzULtX++zkcOFD/ptmV+eWjDmrEkwpv9MRhy5IJG0A==
X-Received: by 2002:a63:2cc2:0:b0:41c:681d:60d2 with SMTP id s185-20020a632cc2000000b0041c681d60d2mr13423275pgs.502.1664070598601;
        Sat, 24 Sep 2022 18:49:58 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-93.three.co.id. [180.214.232.93])
        by smtp.gmail.com with ESMTPSA id bk21-20020a17090b081500b001fbbbe38387sm3967520pjb.10.2022.09.24.18.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Sep 2022 18:49:58 -0700 (PDT)
Message-ID: <d5fb6967-01df-6f64-2f07-718e1becca63@gmail.com>
Date:   Sun, 25 Sep 2022 08:49:51 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: stable-kernel-rules need updating? Re: Linux 4.14.294
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>, Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz, Jason Wang <wangborong@cdjrlc.com>
References: <1663669061118192@kroah.com> <1663669061138255@kroah.com>
 <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
 <445878e0-d8c9-558f-73b7-8d39fa1a5cde@gmail.com> <YywGcg/Qgf8B8wEj@kroah.com>
 <e4852207ed36662a7c53e36fbbc31a71c5a3396e.camel@perches.com>
 <Yywdpyn814NkBJY8@kroah.com>
 <c4f2d581ef0cbb84c4ad3b244863fc4b7d48fd2f.camel@perches.com>
 <20220924182124.GA19210@duo.ucw.cz>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220924182124.GA19210@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/22 01:21, Pavel Machek wrote:
> To make problem worse, sometimes "too trivial" patch is prerequisite
> for some other patch; but there's no marking making it easy to
> identify such stuff.
> 

Seems like these prerequisite trivial patches should have been
Cc: stable, right?

> Basically... stable-kernel-rules.rst "needs some updating", or some
> explanation that people can not expect patches in -stable to follow
> them.
> 
> # Rules on what kind of patches are accepted, and which ones are not, into the
> # "-stable" tree:
> # 
> #  - It must be obviously correct and tested.
> 
> Known-bad patches are applied and reverted.

Shouldn't kernel test robot catch build failures due to bad patches?

> 
> #  - It cannot be bigger than 100 lines, with context.
> 
> Way bigger patches are often seen.
> 
> #  - It must fix only one thing.
> 
> If upstream patch fixes 3 things and does 5 cleanups, stable accepts that.
> 

As long as these multi-things constitute as one logical change and
requires hundreds of lines, that's OK.


> #  - It cannot contain any "trivial" fixes in it (spelling changes,
> #    whitespace cleanups, etc).
> 
> This is not enforced, nor it can be enforced easily.

But some people had like to see these trivial fixes go through stable tree
(perhaps timing of merging to mainline issues that such fixes miss the
intended merge window).

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
