Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF74ACFC8
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 04:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbiBHD3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 22:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242124AbiBHD3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 22:29:11 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411B8C043188;
        Mon,  7 Feb 2022 19:29:11 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id i10-20020a4aab0a000000b002fccf890d5fso16142190oon.5;
        Mon, 07 Feb 2022 19:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1AAZ5DI86KNzEVu6hc7CCCpyAZ1x5OZZFyPZDEWyzoI=;
        b=RR8of/o/89MJ4ngX5plmYwfJ5uTugad82T4YlOrDrjkE1Njep9K5FNHkBRyBlv1tQw
         LBUES2gT421V4jWdf4PDpYpFXPlX17AoqjtzxfQ7BrGyPR9d5557cp3whvkV0M9ojoyy
         PdpYYYYXX5Qqy8AcLkbNd5nq6Fokvf/bu8ieFpNWIHw5rybXekjimT9FygHXda/SSQKo
         9CbHnV4y3Uw9c6kkITjHNau6kAg+6rLZ24oVoxu1eD+DoM1DSdTZR5sZhGOvVn4jP2rE
         CUlt13S8WyV8C9CNoGG+Pp4+FdYqNMYnJqeS8gXq3iknJEcdH1eoretHSJkhnS/pCmlr
         Aeng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1AAZ5DI86KNzEVu6hc7CCCpyAZ1x5OZZFyPZDEWyzoI=;
        b=OsMTRR3FUrh+PHVHlh9LzyOwWo8a2I1zr13M0DINiKvNTKzQzFWLjeBmE8zgxTK/yF
         PTsTprYqbyfGk8TPc5Bld1Ce8ShE82QCcUey6ftwR+NjipCTeagoFAwiyzkDwyy0QSZM
         DysNc6COUPLXdP8IdgWGae3ATMVlyBhO44obzHEDjk34Bcklvbo4VGCOYz2dLlNWp5l0
         fJJ/zK6Zvy2rgzwPG7hcQVUQXlp0XkDD0+K5SsB6CdWlsK2CKT+M65zBup5/cao8h8wX
         9IfO18pVXPRQNHAwpMSws5W1BAkWgVU0KBuHEPGkwjarlll8eJuxRDMn7h2UsmYabZos
         TjSg==
X-Gm-Message-State: AOAM533ir46hShJRkniZuHiV3QKcNCR82o5s65vqMnE0ujDsdP1TVpo3
        59NvhfiREQNd/0JXVeU+vuE=
X-Google-Smtp-Source: ABdhPJwCy9emVvOs04KdM9w7kZ2pdw5f1ltXQa8WfHYKpjCVuyO1d5pfsl5lFVXoEiN6v6CIRp7iMQ==
X-Received: by 2002:a05:6871:4009:: with SMTP id kx9mr688997oab.111.1644290950711;
        Mon, 07 Feb 2022 19:29:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eq37sm5508647oab.19.2022.02.07.19.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 19:29:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Feb 2022 19:29:08 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/44] 5.4.178-rc1 review
Message-ID: <20220208032908.GA3403317@roeck-us.net>
References: <20220207103753.155627314@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 12:06:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
