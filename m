Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A94E69E470
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 17:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjBUQWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 11:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbjBUQWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 11:22:04 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEBB1CF52;
        Tue, 21 Feb 2023 08:22:03 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id b16so1370047iof.11;
        Tue, 21 Feb 2023 08:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1GJtP+8RjhN3ucRBaCvPm/TRUilYHvgTU8JtJej4p/U=;
        b=qU59TttVz/e/wcOYB1SJLUkVQYB53HqGeelzg7cEIMsNsM26BkE5+15f+XpWxsfnBo
         0uhG4siyjADlAJl5wtonvS+OhaMge2/AbYWSF0jzU0qqt4kvO4+Meb88yeX2Dy0BGY8g
         0RMXs2Zo7E6a3xgIEaCtVTjALrgGgkqpD04VHO8mMvXxjvn9R24kxwjGUi6PN69i18+G
         HX62k1EysSqrYvREhC0gurx6kgBz3wDxZswimZI0qbeYxBqGBEtYAnrynRgrx4OEQ/F0
         3sInRtlPSdg1MwVWu00O49W3G7qnuKQcFKEOt9GEckTwj253AYBveIf373B5dKNwmAde
         fNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1GJtP+8RjhN3ucRBaCvPm/TRUilYHvgTU8JtJej4p/U=;
        b=dHWl5wQUxO16+fwvSsNWTb/LV/5YlXjB/ZY7JG0DI39kwDQDRq7vj/yaTPTzNW1T39
         ND2WKY5dtPomubMPYjt8a+H4FjEjJ5y/TLzWpCFqg+ZmpreWy16ishCMBuRD0Z94rcET
         OJ2EWuaRw1A0iOTNm+NmKruw+WnBLK5VNiy4kjIxmLjD5yyS6vIKfykfs2ap1eH9w6Dh
         RjPh9PXOmzdLERYLtVAxIDKsyRNnEG4KccoxI1nk81iEysDdwR7WXVUPWxtl4VTGGzEw
         Ul/W9RzBYPxDjjlM3VvLGkhubyigSqnxtxywfkVaHxCHxMapKxQN4jObgkwZwSzzIq5M
         K5/w==
X-Gm-Message-State: AO0yUKX5Nq3I7DLbbV49lTFb+pxjflbgsIYGellULFf4BC5Mju5EACtU
        QWpWU/oGLiWO241pvWOS+/4=
X-Google-Smtp-Source: AK7set8v2GVvSmrxflWjovVDNlprtI4a06+8hyX4uRMnTXqRcyFjwtGAKfHtNz03vKC1YuM+Sg/a6w==
X-Received: by 2002:a6b:590a:0:b0:71e:ea4a:cad2 with SMTP id n10-20020a6b590a000000b0071eea4acad2mr10831301iob.21.1676996522661;
        Tue, 21 Feb 2023 08:22:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w3-20020a5d8443000000b00745bc07f527sm1027464ior.10.2023.02.21.08.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:22:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Feb 2023 08:22:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Message-ID: <20230221162201.GF1588041@roeck-us.net>
References: <20230220133600.368809650@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:35:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
