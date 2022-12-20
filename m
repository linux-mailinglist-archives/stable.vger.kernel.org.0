Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C362B65230E
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 15:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiLTOt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 09:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiLTOsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 09:48:41 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F2D1C415;
        Tue, 20 Dec 2022 06:48:37 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id j16-20020a056830271000b0067202045ee9so7272910otu.7;
        Tue, 20 Dec 2022 06:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=br8OaTd1jmDrjbOIMn6DNbL6n+WVDgDsFDt7T1bWXIs=;
        b=DzwRqJ3VXgF7MH+6Y1xCnqo8qCN30QMRKekMEl7vIC43FBj3ptBDRNbfNc6LDZNV4N
         TZ7zhmFrjDD6lAM59NSrmeLUHUP3x3Fusw8LcDZE3ytrjBHF94aRerT9f2eOkLJqzTjG
         FXSyNZ5U7hCFAfIBWIoOt33Pv54j2THG3C4QQaFwlvikU6KtBl3W1C8EtZ7gm3zU0rIj
         60g9ICZmu0wM/tnbu9PeBxzN+4osSdJFA5i6RigrwrnsA5UqYqUtx6LW6Lol7A3g/JBk
         ScF4sIxgEuVNPgCDQ6E6ZcdroqWbPC/Z71zOAUB4qKPC3ndtBhYdWyy4lBy7VuoIflKW
         Hw5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=br8OaTd1jmDrjbOIMn6DNbL6n+WVDgDsFDt7T1bWXIs=;
        b=23n+KCtSKZ1Om7UVyX4nPYwwss5Q57TqyaW+if301mGG1Iu/4Fiha93nLKSPS+CSBL
         xDeMPb7nWHydhUGsup3t+IRosqf5breVDsHDAwdFl9MP91w2avV5Dc5Fq7bED4zCRNk8
         KoSBoarpL4Amayx5P2vQVI3s97M5ff/OpWNCyHfuR8fqKvC6twkOfdn7ZsIeMbGh+L1y
         QvRlR5xdi95f5VIRqrKUM3MEbKsEmWWyTe6n2a88T0BVuyGoyVeb1NckSg71Bt8r06LE
         qH8rVa8Xvra258ynHDB8feZpJt6v3bQcxvok+lqBfQnE4rn7PO/OuZCPa1wJ5HH03Eew
         WMdA==
X-Gm-Message-State: AFqh2krhkbroJ+u8IBRYLox8JfuGh+qxTBKZ2SdR25cQ6Ye0egvdgx7C
        27eDZFI4m16rFnFqSwtHRQI=
X-Google-Smtp-Source: AMrXdXts8Q0Ag37eRlfRPOQMiddlxmPHjiwR8oLevZc+7XE5aQZPzvr3ISCGX4LQwHyYUJUbSFQw+A==
X-Received: by 2002:a05:6830:1e6d:b0:676:205a:605d with SMTP id m13-20020a0568301e6d00b00676205a605dmr8865959otr.37.1671547717051;
        Tue, 20 Dec 2022 06:48:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n27-20020a0568301e9b00b00661a05691fasm5624889otr.79.2022.12.20.06.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 06:48:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 06:48:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <20221220144835.GC3748047@roeck-us.net>
References: <20221219182940.739981110@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
