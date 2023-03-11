Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2C86B5C78
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 14:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCKNyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 08:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCKNyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 08:54:07 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7795BC98;
        Sat, 11 Mar 2023 05:54:06 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id h18-20020a4abb92000000b00525397f569fso1216157oop.3;
        Sat, 11 Mar 2023 05:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678542846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JezEZK+AICOI0aCjZw5wcLy2MWny1R1bm5pTOcZP52Q=;
        b=IWAV33oZ0R5ipeJENHaR0hu1TGcacho1kb7emu57od+tpeEKaDo61d820eI0a/8oyl
         wepF0Xf0e8or6G8wJ8CsgD+5B48L+1QpiFgqAvoTeAqS0BN6QQRftwNUzopboFuHTpy7
         Ik6PRxu+/WK4xV3GE0plW3F+zQ7gSLq65jHT0/eOSzdGRiPIsj+DBLRhBqHxLpL+wW9/
         H7iaOddJ2V0AScorw1EsPaHRubnAD6leTmHyZzihfZzhBp7gcLBi17LvA39Ksb7SWxtL
         3t7bdwr+DTuqYxcuu3DQXMZVk6JWk9m9BC6R62UEWmCfjD2AzH7pxNTqnmpcaEvetIdt
         qBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678542846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JezEZK+AICOI0aCjZw5wcLy2MWny1R1bm5pTOcZP52Q=;
        b=Mdh247yIcg2F+Tw++kegeslAM3rG1tn4GHCRKXUBmrdmDA02Nqpr79gnQbw25CZvKe
         EjZwUnevaF7hSD1rL83t10Zk17i3odW9i+Qd1EXCOJJiV7rkGpwrFANbRB+BYZqGNZSx
         ACPES4zOb+6GLdPG8TrFIiN6qo1x4HFk99uPB1pOIyCZUz3izYWMI4daBT+Mqe0FH/x7
         9kexLiUz/uyw9S2b6df+b6RkYP+SnxHiKw/csI73GpJckJKZrfZ+lFs9ScKyfBnjy75Q
         MxZGI8oQqBJw5wbUbxJhTB4qoZKJW7HjE+2ndZvPLDXINgICJe+H3Lfr1qnH690kjoDM
         cbzg==
X-Gm-Message-State: AO0yUKWeCOXv3p8USZ+tvUzyzunR6Pl1K5tuYNt44CQkpBGkZuta+bxt
        OAfjtmwniQz/JEbJyoapBIQ=
X-Google-Smtp-Source: AK7set/WcLHiSCysTRUjU/YKJhjf7PBNSIjZybwnHqg+QYQ1QJM00HSm+hdT/yVTcZoCLL+49bNHmg==
X-Received: by 2002:a4a:d74f:0:b0:525:34e:1f02 with SMTP id h15-20020a4ad74f000000b00525034e1f02mr11262226oot.3.1678542846086;
        Sat, 11 Mar 2023 05:54:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x16-20020a4aca90000000b00524f546997esm1104510ooq.0.2023.03.11.05.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 05:54:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 11 Mar 2023 05:54:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/528] 5.10.173-rc2 review
Message-ID: <b755d647-a363-46fd-9bf1-c97e68d8700a@roeck-us.net>
References: <20230311091908.975813595@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311091908.975813595@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 10:20:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
