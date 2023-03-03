Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7AE6A8EBF
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 02:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCCBad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 20:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCCBac (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 20:30:32 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A116C39292;
        Thu,  2 Mar 2023 17:30:31 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id t129so391217iof.12;
        Thu, 02 Mar 2023 17:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677807031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XlGgobBosr4aLTqWYDgJgB9Kw3mIrz4zp2pRXMgYa9s=;
        b=RBdfXRCpwEQJHNG5UbkFvEE/B38F2OqP6WtzGfctEeb9dmnVdLYytcncweeP+AWDWY
         dQETkD8JiX7fHVW5iFFacWbWQ42MmpDgqqRnOUfv/ZT5pBCJOSOWh1dikegN0CtBkhCg
         eg71MN81Qq7KffVgCygD9G9v8BrhKKWGXffipDAiOWVEpM8wjEEDXGIdGcW+RfiQqQoK
         ginWcdT7n/UPOS72cufWclqYPPUWA5Jixc5PNPz8fk6ySBLKkOyXd+nS4dtU/aG79Yom
         0LjHACjm5Q0oyMlXGA7XYaYxynG+t6fanhU0dLCHD4xkJg4eSxQV98qUGPlde4YUHqlJ
         RVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677807031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XlGgobBosr4aLTqWYDgJgB9Kw3mIrz4zp2pRXMgYa9s=;
        b=y4M8pE5/KvzGvApM9JTSp1Bd94OT8IR2CNMAH9scGPQjOzovQnkaCljheAN+lC2g/b
         RsRIlrE1pnpqC4lvyH8OWEYpYiopJQ1D785oes2tyUy7PD/6J1HIgbl6nudG4UcSE25e
         8+NxxqC7Dj8m7mJ6YgvFpT7C3pcGnKe6GM4G6Jq2yh2IcXLhOiebcJN/ZCq8fKIj4ECz
         OmqOCRTY6Juh6eXfbrUVFdSr0mhZaW3lxaaU26tA65/pQBt9Qw6ICCmN8fe7pyEdVF9h
         lgpZuXvxaaTrA8as4dtrc0qhH3bjbkeq5aP/fXICZ8SjUuGxL4nubT4Yaudu6KGSLFIW
         Gvag==
X-Gm-Message-State: AO0yUKXb07ySw2zS5DezWAIlhrQ4/ugam9nMca/yevHRqnmCUDY9aMvY
        cSq9yCTYaplG/bQpUR5lbqY=
X-Google-Smtp-Source: AK7set/eXBvlGlBYJfZPV306b20XP5u5rJAyiTezRWvpnOvnYZA144L4ZBc48sm5eezIermQxyJp2w==
X-Received: by 2002:a5d:8795:0:b0:74c:e1a4:a285 with SMTP id f21-20020a5d8795000000b0074ce1a4a285mr16270ion.2.1677807031044;
        Thu, 02 Mar 2023 17:30:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9-20020a6bfd09000000b007407e365832sm303927ioi.23.2023.03.02.17.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:30:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Mar 2023 17:30:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
Message-ID: <29c4a6d6-b073-4b09-93d7-a5602ea1c0dc@roeck-us.net>
References: <20230301180652.658125575@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
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

On Wed, Mar 01, 2023 at 07:08:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
