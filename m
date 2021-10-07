Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15206424B37
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbhJGAnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhJGAnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:43:55 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67848C061746;
        Wed,  6 Oct 2021 17:42:02 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so5419140otx.3;
        Wed, 06 Oct 2021 17:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AhnNmiRta5KGM6gi0RdJzGq9aijwiP4McbfGn3Q6dPg=;
        b=fTC759PTv3AJi+DM0aD3Ex++CzwW3AgjR+nTkaVRcqhKpMzhZe2cZNI+jWns7g6YWN
         xudlxgCCCTk9oaE7KKnc6U2KNqtJCWoKAbrkAs+Fbxcm61BUcbuvC+zVUAeC+TBv/Qz5
         a48ZID4iht6I/Oi4t8nMcR2jn2gOgvOYljD2bbEokWQMihCT9f4Igcjf+M1VvuVtbM0U
         KZikP677MvGieM5jHjFIeSap9tkyhOJNyKdSlExJkdfp9Lxc73pOFPCeI5gvJyV/ngMo
         Ibpu9Eah6/p8pXwZrMrKYQsSFoOcblVJBkCCdK3KH479wgh3Upj51UWir3tmQO8VyKn4
         NoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AhnNmiRta5KGM6gi0RdJzGq9aijwiP4McbfGn3Q6dPg=;
        b=72iButb0oM9WxQx12yYhMlay0Bkrtqr3Vz5nulzn/kMyXOqFOesLKG33+nVTDYG++Y
         z6t7eLbfuB+rNC/YuotFsl/7for96siIy0CGZtZstcYfBvx49n6jU6VeIhcvb1E+PS/p
         7c3vGoVKAP+YiZ8q8+Hn5o2frkIoESoP+AX9NYf+nhlNFFa+scesJAUHmqLhutqPE0U1
         xsmxV0UrtTZ1WDygrPrY7Bjij/E3QyceEGvWlkgBErHWMP+qiSJOQYV8WPHyO9IKwKK8
         FYqGc8pgLbci0F/jSAxunjspMonLKDZWIsidHtv1nVLrbPmNJ9XK8zBhrwX1GA7LpYkX
         02xw==
X-Gm-Message-State: AOAM530CVFOD3dMe0JEtydjsghFyD1wjQ4SN71hYOMkSh99NGJ54LVjo
        zoGLx2vUwp4ql41Uc0Ygl+Q=
X-Google-Smtp-Source: ABdhPJwPDWExP4HFrwO6ImcWeH0UkKf80fZRsdGwypJkxFQJ18gAIBy8E1rsaqDVnR7n+yZkHrLm1w==
X-Received: by 2002:a05:6830:793:: with SMTP id w19mr1143629ots.23.1633567319955;
        Wed, 06 Oct 2021 17:41:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bc19sm680022oob.29.2021.10.06.17.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 17:41:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Oct 2021 17:41:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/57] 4.9.285-rc2 review
Message-ID: <20211007004158.GB650309@roeck-us.net>
References: <20211005083255.847113698@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083255.847113698@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 10:38:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.285 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
