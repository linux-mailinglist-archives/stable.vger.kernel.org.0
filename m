Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66AB965B8B6
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 02:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjACBNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 20:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbjACBNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 20:13:33 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF354B869;
        Mon,  2 Jan 2023 17:13:09 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id t15-20020a4a96cf000000b0049f7e18db0dso5536377ooi.10;
        Mon, 02 Jan 2023 17:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhV+coCt023WBtzXdvWNjSoF8qcnXWnriESldMGqZj8=;
        b=UA5nLR8T2Ngd0Z0p1WxR9r+On3POIsvTS4mlpGJgRgPTE2e1ZJNuND96rrMtk6Rf/Y
         rZ7ekr85nN/LAW8sB/UQ4oLh6mPbwlI35o56d4M+pLgHVT44dXPQuoVT2HX59ODFonoj
         1uZJ1KJMqMS6LkOcvWFYk2ZT+6o/giHGx7vbXQMO60zijtFQlm8PsKQl8iZMmnxmqxIf
         vGqlBC0paZOKA70GSL9xrnAeGVsaAbfLdqkZMMBlFe0vf5oJQRvgOO0KjXsdHB6LmUr9
         nngUjyeH700r6so3cJpAnqTgwsh4Pmxg5aUf41bZm9advLu2rD5ia4URaAEUKZfa3Rhv
         msPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhV+coCt023WBtzXdvWNjSoF8qcnXWnriESldMGqZj8=;
        b=dWg15xMCbMgz6HNvNJU0sSo5tXjh6fuKLyh4Az7wQl8bWX4nrX0NDtj+xZ5/5hdmX2
         hvCDe1ayuIM4V0cH+pG5JFmMYSPe7z276WZNihY9uNv+mKbEby4rDsNHvub+TJwxINL0
         2uLcHXXtANjqmvErkUMwC3xBR+nnzlXLckvxaET0ih6VwiWSQ4vKw20LmoescVIFq6bC
         +qej9wIhwPbbgzcbbzyldJAQZQrgBDZAIXh+bB1jekWUEGsPXnAUvmHqnkvOJRsXH1hL
         jn8w+DqwWqFt7qBYhTOmMxR1bSrU8cSbAOP3lB0AoL1lX2pd2wJghmMdwKhBaOKmvysj
         qRKg==
X-Gm-Message-State: AFqh2kprPHnEMFy255YOMwZiB+JdK76TA0+XcCZF4YER9Pl2ngmD6jaz
        viFUyWIc35lD+P2dxOR6J5E=
X-Google-Smtp-Source: AMrXdXuG/u/wjKJf+KXqN2kQlK3hJlKVL3lDMl3By0ft81iv02T4SxcBZKpjqHny3BDsfHZk5j1lbA==
X-Received: by 2002:a4a:ba8b:0:b0:4b1:1ffb:a267 with SMTP id d11-20020a4aba8b000000b004b11ffba267mr23999917oop.7.1672708389204;
        Mon, 02 Jan 2023 17:13:09 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q184-20020a4a33c1000000b004b0037cebc4sm11728494ooq.9.2023.01.02.17.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 17:13:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 2 Jan 2023 17:13:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <20230103011307.GA149144@roeck-us.net>
References: <20230102110552.061937047@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
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

On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
