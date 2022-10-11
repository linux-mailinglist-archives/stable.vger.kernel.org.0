Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF95FAAB1
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 04:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJKCoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 22:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJKCn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 22:43:59 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426576FA05
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 19:43:58 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id z30so7747651qkz.13
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 19:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6i9xvvSsQD2yTk04TmeVes3fjoEAF2ePWkZcQJA7uzk=;
        b=dIrbNcBbr0Ci+kGmNJtzhtRw+Q7XzS0paYgTElSH1b2OKEJFR7JVoYfGS/qff0OxAd
         MtJS8mnVUAi7cJX38b3VgKU7zP3nyQJQcRNdIrElAscjzb+h27xLS6EjvyT7buc7wo/C
         XCeI6FkWGef0pC/QfSlVC8kz/zni1yF0O9wFcu6w7O5S7y1nXELL6uoon0fUcoEUfO17
         RWhaojYvoSE5mDpNRGIcLhAxQBjQQPLfk1eol5GDzjLWXGFIEnHO8Jci4g5+gvybXaXD
         i0Zg0AjzdfJ6O/Fs1f4wyX5wkO6CbRxnLkZzIPl6EM2SX2334q9+j3BZJFzydS9CSh3u
         Xqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6i9xvvSsQD2yTk04TmeVes3fjoEAF2ePWkZcQJA7uzk=;
        b=OuNtv03NXP5m26HLribSwgaApmvTsPum4svZspLYaFSfUg+hR4BxaMaRVWSpR+vY4u
         mItACuXrK7zDV4eJ9b8YYRaUSwRNyyeAHBPSmE21MOLS5LEmN50U/lOjHZgnePz/s1go
         YsXMu0YG2yAgWMWpagxqC6A/YUdemyArC4lqOiQln3hgjMAwkGji3cly/UfQfa/Io51Z
         wEy1NptdL5He6Ib8KhgIzUGtyFDgh0DXjZLxNyabSMEMSGk259QltOFs6KU7DZL4Cr8e
         js579D2DNppfrj+J2mGGpRUHiI8WA+ZuwVdbsJi/HTMtc/MiHEpz2ZO7LcahR0EAq6z3
         JafA==
X-Gm-Message-State: ACrzQf2VTu9sQI4c3T9BOhXC8d6bYogQWROiHcwPSMa9UR0i7W0/4IT9
        GGIQm4g9Uv9KMvUFsO0BOhfRYg==
X-Google-Smtp-Source: AMsMyM4XbgUeYhAK9x9eOFGVHGizsE2BCVNROCrpdXY5W/HQgkJoScfEge9JbEMWPhJ7Q/RyyLnDqw==
X-Received: by 2002:a05:620a:4108:b0:6cf:8490:fa77 with SMTP id j8-20020a05620a410800b006cf8490fa77mr15437302qko.734.1665456237350;
        Mon, 10 Oct 2022 19:43:57 -0700 (PDT)
Received: from sladewatkins.net (pool-108-4-135-94.albyny.fios.verizon.net. [108.4.135.94])
        by smtp.gmail.com with ESMTPSA id bp9-20020a05622a1b8900b00399d5d564b7sm4339810qtb.56.2022.10.10.19.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 19:43:56 -0700 (PDT)
Date:   Mon, 10 Oct 2022 22:43:54 -0400
From:   Slade Watkins <srw@sladewatkins.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Message-ID: <Y0TYagQVWLuGl0yz@sladewatkins.net>
References: <20221010070330.159911806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 09:04:23AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.

6.0.1-rc1 compiled and booted on my x86_64 test system. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-srw
