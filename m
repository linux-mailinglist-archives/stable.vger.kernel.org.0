Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FF5682294
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 04:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjAaDME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 22:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjAaDMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 22:12:03 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2603D4699;
        Mon, 30 Jan 2023 19:12:03 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id k91-20020a9d19e4000000b0068bca1294aaso1994817otk.8;
        Mon, 30 Jan 2023 19:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WfBbkbDd95gVhRjbU6KPFTWVPnygLYHxiav1fmang+k=;
        b=D84fgyEGkhZmHGOZPs0/Oq4c7kpBmjjF7qMmDgno9kCjwzBaynZXeTrzwfQybWqMBV
         Z/bNbtb5Tt44eL8R2No+nuXTjjlDqkv7UyR82v9pbH7QC5cvlS+/eM3FuwgkDNwUsSj2
         WJZHz67MiEIqWhIqbxTLrZtK7syM2ASYlOf0997PivecCajm6aZ51ejedY3JSgOKF5A6
         KdY+UEMK/S5lbO6ywojFM0IzbOTJ50jSeApKlF0zmznHs009PXPRf+SR5oOnVwTlkZVs
         VKF18kcDndpf5rYZFED88d0UPYcUK3iq7vUb/5KloM/o6cx2AF7Opagr2WOpdKNDucEc
         8iZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfBbkbDd95gVhRjbU6KPFTWVPnygLYHxiav1fmang+k=;
        b=DWEXv6PWI4vdPpS9W6lHuk1n3Wvg+fMcXkS+vIuINXkCv+AMU0zs2uPwK9Ze+vzGs1
         XW+tEozMA6J3TAkVFBCco0NB0wee9ZZ/wRhlqinX2yj+fY/5+f9xkv0aCYYdPOCenzuz
         lOuoZLzH1pB0CeO/l6GeIkIII0A3w6kY35FCFi2JliiLHY1DR3LKeT4yRYz1Qc7FFimj
         SznHkYeMUXmxeyQnq/heg64eAfeqDFg/AADMgIcC11lsxnv9KJvFPrHL1uLQteYg43EU
         A71qgSOshfisvvy5ZxTXhSSkYSVwaqomfQ+xddes1DSR9jMw5cYa6qO5MMOAwzoX4Ou9
         +tGg==
X-Gm-Message-State: AO0yUKWbWKpzlhJS+jO55sCiBUWydKNae+5uToKvAX3t2fiLOifEgiyI
        KuQEqEDgKaTuDezipT5XxZ0P864HhyQ=
X-Google-Smtp-Source: AK7set8tfstPQPTJxw5ir484oQAonXMmk2eEazJQlEthqCUhQqnUirTFBxAXG5UnN5NCU86pXh/KVA==
X-Received: by 2002:a05:6830:b93:b0:68b:b06a:5b8b with SMTP id a19-20020a0568300b9300b0068bb06a5b8bmr7625975otv.0.1675134722240;
        Mon, 30 Jan 2023 19:12:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h27-20020a9d3e5b000000b0068bce6239a3sm2315333otg.38.2023.01.30.19.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:12:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 30 Jan 2023 19:12:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Message-ID: <20230131031200.GB835036@roeck-us.net>
References: <20230130134316.327556078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
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

On Mon, Jan 30, 2023 at 02:49:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
