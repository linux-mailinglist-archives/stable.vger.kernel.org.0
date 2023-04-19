Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB876E71A7
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 05:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjDSDf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 23:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjDSDfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 23:35:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AD92708;
        Tue, 18 Apr 2023 20:35:24 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a667067275so23009435ad.1;
        Tue, 18 Apr 2023 20:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875323; x=1684467323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wa+6Weqi99+2cMzOYJs7dkr4M9BIqG1QIOg6cp94MLA=;
        b=EpZXLJSIM+h04gLWSd2K357yF8tsIJqMwRErdeshY83QqfcVZZLkALfy3nQTAGkoSw
         e6M6FXTmbQlmDtVKNvyVjnswAR86Q9REUicpEQEQrsIa/zlHY3jTONl5KuZovHiCHd1D
         MQZqBL1IAdqJqD68N93NCrROtXqFzY/9wCUeln/NO8a84Kct9AANwXQmMlOxXFwC1bv2
         axitMoCVX7x37O8jg2zIQyrJsrShQ1GRQHjnQuZK/ZtIpKUPHSANhs7fkiQsDt76MrP2
         0sxhMoCEsVrYohUSMLqyWXs0wZRWLI6OS1ew03dvW6hs+vVQBckhmDVjYfwAOHSkwtMp
         Rs3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875323; x=1684467323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wa+6Weqi99+2cMzOYJs7dkr4M9BIqG1QIOg6cp94MLA=;
        b=B1woyzNVJBQ42V7YfLAT3LAblvv03XMY1nEZIN1b8/stHMgWmF1GLZHyRN+SNzfUZQ
         N0WihPFHK4oJ1ozgzvEACuvLQ1fz7kNZKxYI1LprXpOua/m+/E7bHnqfFjzACCx8eCvB
         7g2dXR6ev87VfZ2eninIpv7X9L0gMkrJ93e8HpLYcQqFOWcNodVhx2bMjl8NW/DY7bTu
         4gwzK1EKiAVdg48vGdfmvdOandW1bpAd30fD3CpBkHiLQmF5aqs13sICksSepNcwvHkx
         MYI79Ixmwbwg2dG4h5cBCeRVkImpzVCVb/oc6v/mCZ1wZgDbYbrNJqYD9iK+Tv85hM0X
         JsxA==
X-Gm-Message-State: AAQBX9cswJDUL08LOT793948E8U7q/K97sBBCLP8Os8AtfXXo/WUyLJ6
        UHDi03EP+cT1LG/HgSQweUs=
X-Google-Smtp-Source: AKy350ZYZxUtiSSyhM+Q8fMkS4W7z7TsrDfZZezs5h9oFZgA6PCnf/wSoL0TpR3o+3hXQrCj7tnN5g==
X-Received: by 2002:a17:903:1205:b0:1a6:c12d:9036 with SMTP id l5-20020a170903120500b001a6c12d9036mr4339072plh.33.1681875323658;
        Tue, 18 Apr 2023 20:35:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902820e00b001a240f053aasm10241989pln.180.2023.04.18.20.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:35:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 Apr 2023 20:35:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
Message-ID: <bbcd6d92-a7ed-4f3e-a49f-9397c8a05a7d@roeck-us.net>
References: <20230418120313.001025904@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
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

On Tue, Apr 18, 2023 at 02:20:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
