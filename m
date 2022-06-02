Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BBC53B4F5
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 10:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiFBIZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 04:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiFBIZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 04:25:21 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9556916581;
        Thu,  2 Jun 2022 01:25:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q18so3912342pln.12;
        Thu, 02 Jun 2022 01:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oRhnzCWuKPecicMPuwgDWmM/IRUGzVdqDQ7z87LQhbk=;
        b=IcVGagBvGn+NYxuFsRi/WEvN4rKiNa1PdLLhSog90tAfXeFzYHZJnMnp+5WKUfu8SY
         gw3Jkn0eRI50CNLBLEMlKvl5Vj8xP/4RTsMjKv79zUpM0DQxFOkMveY1CJlU3gN6lYmp
         SzAHH9EkX/wPyfdhlBgbY3RF3KqBCRKvqqGHe5NBl1dw+o7NPygu8k5WWhJZXNYhefdR
         vwuoXiVAzOvOtcI2Zp07VpEZPzzNh73dRbfM9bIdARmAio4OZErjsxHCKx1DquLc2X5D
         dAErk9vYuymzWVAFdJk7P7YbujpG79g26VxnlFUHLwTEoTXAaVCExP3dbiNW5Sbz89In
         cfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oRhnzCWuKPecicMPuwgDWmM/IRUGzVdqDQ7z87LQhbk=;
        b=uCeURKiw1nbC/Dve3sxZX2oRs8Y0iyaeaeNROAuCqCVZEjOlonoOOi1GiiVh2e5Ft9
         FVftszGsUUofmIjWvd9iZZx/t6d/fvB011syVulhRI4+/3tBCMtcOAhd/hQ4pcPJqfqA
         UV/kzMVd4VbIFspdmGYwYWh0VLZPeLwj4E6ATi060uS1ARu27TW1t2vB/ENhh+rQoDjo
         uuBrqNkwWK9ltxtjrzUKlEFNNiuIrjXGHwoacGsB4YptwJi0TL39a9DlewI62iXye4bm
         8vhySNHcaYo2DBgcTtCG/YSKoOXRa13r+dh51j1F+kyY0m7CJ8KImYfm+3by1nk8rNbW
         pT2w==
X-Gm-Message-State: AOAM533aDjmNYpfKJ9eNOL/tENI24ImSd7t/lnVwGDdL8BFseYWze9XL
        YfXvfWvqHTo3QwAitgmj+lQ=
X-Google-Smtp-Source: ABdhPJycPC+01SHXYkAI90I3AACl6PgQls13ile8bUJ7Q0/pCqYbyeqqhwtzkYpcZNFO9NVdlL9Clg==
X-Received: by 2002:a17:902:f552:b0:163:f64a:6154 with SMTP id h18-20020a170902f55200b00163f64a6154mr3704270plf.147.1654158320121;
        Thu, 02 Jun 2022 01:25:20 -0700 (PDT)
Received: from localhost (subs03-180-214-233-21.three.co.id. [180.214.233.21])
        by smtp.gmail.com with ESMTPSA id b20-20020aa79514000000b0051b97828505sm2865595pfp.166.2022.06.02.01.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 01:25:19 -0700 (PDT)
Date:   Thu, 2 Jun 2022 15:25:16 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-doc@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?utf-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: uclogic: properly format kernel-doc comment for
 hid_dbg() wrappers
Message-ID: <Yphz7EnxGSG2eMRM@debian.me>
References: <20220531092817.13894-1-bagasdotme@gmail.com>
 <3995c3d8-395a-bd39-eebc-370bd1fca09c@infradead.org>
 <YpcU7qeOtShFx8xR@debian.me>
 <053f756b-fafa-e07a-4308-0a5de8dda595@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <053f756b-fafa-e07a-4308-0a5de8dda595@infradead.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 01, 2022 at 05:18:52AM -0700, Randy Dunlap wrote:
> In Documentation/doc-guide/kernel-doc.rst, section Highlights and cross-references:
> 
> ``%CONST``
>   Name of a constant. (No cross-referencing, just formatting.)
> 
> So '%' before a constant value just helps with the generated formatting
> of the output. It's just "prettier." No big deal.
> 

Thanks for suggestion!

-- 
An old man doll... just what I always wanted! - Clara
