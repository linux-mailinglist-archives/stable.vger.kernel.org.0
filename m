Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EB7571402
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 10:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiGLIJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 04:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiGLIJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 04:09:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8673E558E0;
        Tue, 12 Jul 2022 01:09:17 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f11so6032004pgj.7;
        Tue, 12 Jul 2022 01:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mf64p6IVaP9Hci3QPNE+Bn67PkfAD3xjmW63tzAmGCQ=;
        b=BPXMUa/9LvoaABZiKfxwgew6ncC6tYy8HoIjGTUbJ+MZUKJmacs+lKcuehLWsZ3Fi4
         EXnlf/ao8fcTonT0pTgNZrmfOnxyJS/C7FJGsRDIo/bVyEP0rGBGrat4k/6/V7+dyHvT
         rEYMsztmYeO7uDri7lh3dynDi2xQRVs4CQbfkMutrOlUgXKsy/Su6NBvRKM5vnhXJexJ
         rYHKLiZD4XdG7jJ2UGDCeZHQ0SiOyLNrLgPcXJRzPAXjfnXIp4C0Ifgon9tqe1NCQeX5
         aG2mTv1zbmJFRyE0dr+nbzMFoxjxPTzHIDjZ1K0q3Rpw9L0QpYR+z+gKyk5bCvHXaNPu
         smtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mf64p6IVaP9Hci3QPNE+Bn67PkfAD3xjmW63tzAmGCQ=;
        b=m5Qn9Z3ibaav5qHgW6dHgm7UMxArSU3zFy5fAPr3foDDFJIzH8hl67c7dWPYXAsnKZ
         ra3PJgpdR8tURDPDwuu+rfhC6znLArqVxL4DOhphV18r/sVnSX4BSw66gG3Fll3p37WG
         OeBMLksHIrtk9Qtd2rG2ONH84NIcF7aSX9lWFRhv1wxhhXRDYfSzFXQLfaDAtxqyNkAs
         fLf/ntfyZAHGZ+wr3PXwvxHnA1TzR1TqnP2wL7gTTL5m3XaylSBDCnj3KYHJyzo3vohw
         9TZNrG/VYQThHYfZ0SdE2MHDNr/+rGUWADRryjtyjOzaQm/18qQoyjGseR8JAedkM94c
         HAeg==
X-Gm-Message-State: AJIora9b6uavGQWAEpIXyyUIMYamXjYHIIdIwL3QlmkdTTcd2pSuxsGh
        r3baGsUT2c4oZGoixuvG+So=
X-Google-Smtp-Source: AGRyM1sWcHqPHK0pmVykvXon8fJB8LDcUlnnVllisCl+oHyWzkXZ4nzas5Mwu73MdNC1QssldxIc/g==
X-Received: by 2002:a63:481a:0:b0:411:7951:cbcd with SMTP id v26-20020a63481a000000b004117951cbcdmr19424157pga.66.1657613356965;
        Tue, 12 Jul 2022 01:09:16 -0700 (PDT)
Received: from sol (110-174-58-111.static.tpgi.com.au. [110.174.58.111])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79590000000b005289cade5b0sm6079093pfj.124.2022.07.12.01.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 01:09:16 -0700 (PDT)
Date:   Tue, 12 Jul 2022 16:09:11 +0800
From:   Kent Gibson <warthog618@gmail.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] gpio: sim: fix the chip_name configfs item
Message-ID: <20220712080911.GA240577@sol>
References: <20220712074055.10588-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712074055.10588-1-brgl@bgdev.pl>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 09:40:55AM +0200, Bartosz Golaszewski wrote:
> The chip_name configs attribute always displays the device name of the
> first GPIO bank because the logic of the relevant function is simply
> wrong.
> 
> Fix it by correctly comparing the bank's swnode against the GPIO
> device's children.
> 
> Fixes: cb8c474e79be ("gpio: sim: new testing module")
> Cc: stable@vger.kernel.org
> Reported-by: Kent Gibson <warthog618@gmail.com>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> ---
> v1 -> v2:
> - use device_match_fwnode for shorter code
> 

Works for me.

Reviewed-and-tested-by: Kent Gibson <warthog618@gmail.com>

Cheers,
Kent.
