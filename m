Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC268584870
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 00:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiG1W5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 18:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiG1W5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:57:17 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED51C50706;
        Thu, 28 Jul 2022 15:57:16 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id c20-20020a9d4814000000b0061cecd22af4so2176537otf.12;
        Thu, 28 Jul 2022 15:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FBTvJwg55p3iol1qM/0ePebD4lVCXH1uGzI49zIi9bU=;
        b=epk3OmjC0qg4KurOIE/BJg1gseabdyr3y73xgSZEhi1PbzsqzWfWTkACVJRptlbxZw
         znZ02GXG+IEXJyhE6+GxSdpeiWvYS0UXQrEl+1cGtOKUpNtbtjw4K6tOdR57wt/ezRRr
         +XRFIxd9s1Ngjd8viGDckAQqAiQ3eJIeYtLsG4xL+S+YTBpSElJbtFwvXf98pycyLILw
         hraHMzcmV4lLAN+03LnoivSW/cprGl0Nv0ZxA7VqjaxNZsRQIVdpUPG0qo3VgK1ayiUq
         uj+JxtaJEgEbLgP4FgIU4QBRJEqz8GxhRjn2SxAvMoOMCk5gtJiJm19CHkGjeLQJpLp0
         x5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FBTvJwg55p3iol1qM/0ePebD4lVCXH1uGzI49zIi9bU=;
        b=79whQwsuAY/7rrERZoT5JhI51OSVxbCMK17wgIcmlTpoz7NpHOOXWwJS5dZHY8pV8b
         XG0D696NQGDaI4mKJd+pvX/+u7zcF36xJDBq47rbCxeUbZROSiyQ6VR4mMGG5wLraclZ
         Ne6UoZ8pHSqi1VLUDDgR5N0HR4OCEYxWszO+c4PkvKc3GePi3PW1KDG/nkOHeBJ3LIKG
         tm8n/+bJDZGvyrlkd5NALh5SH4Vw/cCKEt8Dysnoy5Kr+njMPWPbUsRogz9k+LfuPHYi
         /B42db6lDR78CFs4eBkglDLh3NbvLdmDQF2JVDNEuauPnONKhCsMgJtlnG1D2TrH7Ad/
         /cJg==
X-Gm-Message-State: AJIora9Ruk0b2KdSBQi3diDXqfpZqGBwOoTv7P9WzOxBKfZRxA66FHLn
        71iGHjl+YJKOu/b9uBvqGIY=
X-Google-Smtp-Source: AGRyM1uIWAN5QEfMmwgaEecW0YFrelh09S9vFrY6AUdT5hclsIsO24bhKmlgCbVJw/bzQi8/Gh+YIw==
X-Received: by 2002:a9d:7097:0:b0:61d:9fb:ab51 with SMTP id l23-20020a9d7097000000b0061d09fbab51mr470282otj.270.1659049036242;
        Thu, 28 Jul 2022 15:57:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j8-20020a9d7d88000000b0061c3753c30dsm805886otn.17.2022.07.28.15.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:57:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jul 2022 15:57:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/26] 4.9.325-rc1 review
Message-ID: <20220728225713.GA1979085@roeck-us.net>
References: <20220727160959.122591422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
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

On Wed, Jul 27, 2022 at 06:10:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.325 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
