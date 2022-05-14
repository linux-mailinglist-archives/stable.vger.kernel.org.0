Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C40526FA0
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiENHvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 03:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiENHvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 03:51:35 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A041F7;
        Sat, 14 May 2022 00:51:34 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id k16so2849954pff.5;
        Sat, 14 May 2022 00:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=n8zKUiqbVDYxbvMgeTQJw/z7kwDYoKEYRpJkVqLfCl0=;
        b=qkIapbKjGm1MYr7T6YHW6xdb4kT+Pt3WxJ7tTF/Z4laMBY4hYoWdrelAadZhek4KZl
         Mk+IylB6oV7BBIEhotOBmzTEq7Z/p42GPgqZWwEoJVAWH//L2R7sfuSr12zHToHQjADg
         7xkX6N+NMHABcVRqC/9jK04DeR/yF8mzT+Pyy38Ur8SQ/oQ6xBzgN2tPdWNDIl1CzFoO
         yPyzqXMqPoXlN25zTPK5WfC7N0jTSBBJVVFe/nxZmCXJDUmUPAfOmTsCgRWm1RkcW8iV
         6B9z6tcPoMQ1E3NrQX9lPEXXdyQYpZff88IpcH8SjWssIFQsJstCeTUYBOx0FdvgfKBP
         wpVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=n8zKUiqbVDYxbvMgeTQJw/z7kwDYoKEYRpJkVqLfCl0=;
        b=SKIhnCadYHvoY1hrRe05WN/YKv/UNQOwiW7LpyjuF5q60wGllSbBNqUOZfj3QK3wQT
         mpNsOI30EuBeyPRNsh3q1OeLQya/N/vBZmLTt7TcjU1Kj8f+qdmtVzQOJYw1uNtT3IeD
         Yqm0YhpHlK7cJaDYBx90K3DR/TLMDGbIvAZEKBbN1UYd1rJeaSZfBawwqfUHw5lfEU8X
         VrHianPd6b6kuR565CWJ/Grvkocv0D1NYD2stmcUZQmQP4o13YlxIWvNBHAxQiA7RRgC
         v47bdoj49oLk4GNdxrcyR9W2dqO3Z9UQTGbbCjEU+Qyyzk8W8ocX7UjIypp2F19TVFMf
         G4Aw==
X-Gm-Message-State: AOAM531spvMcm/eQc2Bde1lcHsTjlKX1r4My9qXqGJsPof7o5uCjUK/U
        WzaV3jVoNKzYBBo61p4I8fJI6MiKWX2JwdhktbY=
X-Google-Smtp-Source: ABdhPJzJn4Fnur0ovSI2YYP4FxsU1V9nGoiDy06lN/Bp2fKAbKCRVIhy2dSPYRXmx5Bg65ziVVKu/A==
X-Received: by 2002:a05:6a00:806:b0:50d:dd03:a03a with SMTP id m6-20020a056a00080600b0050ddd03a03amr8248601pfk.57.1652514693584;
        Sat, 14 May 2022 00:51:33 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id k3-20020a17090ad08300b001d9781de67fsm2727179pju.31.2022.05.14.00.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 00:51:33 -0700 (PDT)
Message-ID: <627f5f85.1c69fb81.4b80c.7398@mx.google.com>
Date:   Sat, 14 May 2022 00:51:33 -0700 (PDT)
X-Google-Original-Date: Sat, 14 May 2022 07:51:26 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
Subject: RE: [PATCH 5.17 00/12] 5.17.8-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:24:00 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.8 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.8-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

