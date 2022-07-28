Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D12C584878
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 00:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiG1W6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 18:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiG1W6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:58:30 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ECE5072C;
        Thu, 28 Jul 2022 15:58:29 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id y10-20020a9d634a000000b006167f7ce0c5so2222435otk.0;
        Thu, 28 Jul 2022 15:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90Kxs9PTGWeGXXth0tDaDV1bn7pulViWQcQ9PRDtWEo=;
        b=qzkw4QWq5TMWhZdmh7TPekNHTBTnVwoqxmdfjdGzU3yKDKCF3SFj7kI38M6KUKE1Rd
         TScDWKPdSXox3Q4zmv1zfdYqHq1eVgYMgTp8KKjLbElWVuPBxFuoN3HcX7tbXiRokBXv
         Qa6trpd5bBEU+7BWp33EHGygXxukeYkys7prFxa2U8fStLUkIPVJQQTnWHUp8GJhHrlw
         qKDHZx9ELBavR9IsCzhyDgZoiqvCtJT+Vpl13AxTQlWOseh4x6zFfVbqhHMLnfG+afk1
         /ahhnHOjPxldQPk5cYRVnZzziAKdXICXrPdvx7pBQr0+8wf2/9oUim2jnSE9FSzirc8a
         QfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=90Kxs9PTGWeGXXth0tDaDV1bn7pulViWQcQ9PRDtWEo=;
        b=hh7m88nAuf8W9qP49l9/ZK5Py9jEcNKDBOrPSq3Nlv58bJ3Uk1HfB/gKr8J9Q9CDyr
         +44rQJ/AMBChujfiOsN+y+LMR7s1C8G2lYfYINaD3pXCaz4btbQkyOT1f7mAa4D7x8e5
         UAAeqj7UQyOrCCSuqMTdU5mQI9N0Q15p75trPzHrt+uZTM2oM0W5Vr1vV9VxWqEDrm0J
         sLeiWvFC6F7xDCbHOHzHVHEXPMO+8LhcWo3WekBQG+KaziM6n7Q0dLZbxBy+3YkFcpCr
         wKq1V8I58lw/rTlgo9TdlxWwL98shc3qkE6RGAbx3M0HqgT1uYSWAaf+pHpcdUaOeOWw
         zj2w==
X-Gm-Message-State: AJIora8qvulbW+5Q52xG/8GWAW3h/8781W+YX7vpITxy+qiSSiNk4SoA
        tzLfs5J2wbrbDlM1TKi1gkA=
X-Google-Smtp-Source: AGRyM1u7I+X/a8GYRk1g/nYBSzcTO5VRq/u5ZxKdXJRBhHytjYYJigCdMyyYY6r/EyNJDBcTnKBkfA==
X-Received: by 2002:a9d:5e95:0:b0:61c:3efd:d0ef with SMTP id f21-20020a9d5e95000000b0061c3efdd0efmr468974otl.164.1659049108829;
        Thu, 28 Jul 2022 15:58:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v18-20020a05683011d200b0061c9eb11e43sm812266otq.56.2022.07.28.15.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:58:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jul 2022 15:58:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/87] 5.4.208-rc1 review
Message-ID: <20220728225827.GD1979085@roeck-us.net>
References: <20220727161008.993711844@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 06:09:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.208 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
