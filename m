Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB9B55C2B0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242376AbiF0Xmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 19:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242290AbiF0Xmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 19:42:37 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B36E12D0B;
        Mon, 27 Jun 2022 16:42:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id bo5so10434016pfb.4;
        Mon, 27 Jun 2022 16:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yHrk3Ru/BmHoq6X5rHNQ4IrniQMDGYITLqWiJGP0J5Y=;
        b=Fr84w1pVtX1gJluJYLQbY2737Dg9MiTl2zTra7WZgfobfXFbeHaAx1jfSkrMfP7yP+
         OJYQRY5WTkLpnD0yT53edGd5MNfBFodGxIHNTO/9W8u6SUuHVFeAlm3GcJEHRKjFQOF6
         uE9zR1NRIGJgNxHaB74FcK6csgc1d/BLQql23Eya+QNJrTeiPJz1JV+aH71OEDI5Ll4U
         aoRJ+kQ4ZxK7hlrDlG31jthhlk18nGs58n0JtMbyXB3NMAh5T0KbgmMxoU0xqisb+dtW
         AjDZX2i/BwP0rEjLRBvwiWMZuzUJIKIan8rZF7VyXpaZf6z/CpNYh6Mgn6OzW2aYgRT/
         55nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yHrk3Ru/BmHoq6X5rHNQ4IrniQMDGYITLqWiJGP0J5Y=;
        b=scWdBVtoQRZBwa8dyBOhuEb8e8vQ5KmYL3Iq46yyfrtilBUzbLDQKJIib12cM9KSSt
         FCevtCvKyroMBcuaMlzcZO40LUaetgJxis6PEJxxSlz+CjkEu4jO6v98tP4ZOQ2Mkfgv
         z7k/orvdt2nxShGA3xupzP0B2jh2/Nts4A/AJDwWM0UqgigGhsQqhIlL7B5GHebcKsMp
         86jOzmOQb8mANp+TNibKsO7say84+HVN+LeGNans8cslD3spwvbXOvNQzAblxJbTX7L/
         xtVha6AuU4+oDI0uVLkXxHNfJqz1MPJMkzD4VAjdQD362qQapsdaOyPVjBRZ8hMY0y8Z
         zSQw==
X-Gm-Message-State: AJIora8AmMGiNgNNIWWqZXJ9i/LkcMiWfFpud2gSJvRyP7INMfGrn72Y
        7focZAsmLsa46U9IMphPA/I=
X-Google-Smtp-Source: AGRyM1uY0diTRcDDs+KtMjwK6Ted2m3xUXsToSE/RkXB3iP0GoTbki6AnVVZq9Hx7MTjBGdPw9EjEg==
X-Received: by 2002:a05:6a00:16c1:b0:520:6ede:24fb with SMTP id l1-20020a056a0016c100b005206ede24fbmr546108pfc.7.1656373356727;
        Mon, 27 Jun 2022 16:42:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i72-20020a62874b000000b0051b9d15fc18sm7913305pfe.156.2022.06.27.16.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 16:42:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 27 Jun 2022 16:42:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Message-ID: <20220627234235.GD2980567@roeck-us.net>
References: <20220627111944.553492442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 01:19:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
