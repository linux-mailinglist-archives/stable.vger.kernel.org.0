Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE3B532651
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 11:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiEXJYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 05:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiEXJYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 05:24:51 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5445D73780;
        Tue, 24 May 2022 02:24:50 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9so6970546ilq.6;
        Tue, 24 May 2022 02:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QXlGW3lxO911v1AmkXBeXTa7ip9ezS7XZgf/xjHOzQ4=;
        b=JzwLRlSiCoLDrsv9xeq7PY5OWI+1aVZ+smaN58D0N4lxp5TK8wdg6/1S6x/ug38Z7C
         JEVWTP9G/A2B+0oguqdZHjk0lpT3lOTYFRIjSCSg/CzBjnJUDVa0QF9LTUM1zvJUOZ1z
         Of2csCZ3AdithbF0/o+dF5z3Ax8FWrySYXKnX1n9SKkFWinyp2H7OnOWPeK0znIzPDbO
         eTfMP/WLCbSP+feQY+3W9c4X06FDCjGvwI3MHJqx0A5EI24zNuvddSKG4OA0IgD/szvF
         ESXxtOXXUvcxLCAobQAS40NPZ42zH8Bnhxk+/DqubWyS0KNKpETO625VdeidmZ9BkQpd
         +2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QXlGW3lxO911v1AmkXBeXTa7ip9ezS7XZgf/xjHOzQ4=;
        b=j+5tzXmK7tBEVjKJHEpAV66kXbDOnUdiKNHndbNue959nC5n+5ioKqDRtOhsp59qTW
         iXsv53I/GLYwjrqfSwlXF6f7t5c7CqRv44eLeMB6fDeahEzE8G7IWacHq7z8WENTnaUj
         YwFYEvp7OyEWsx5P/9n+H6f1Rdg4W6SQ7KIIiFs7jETSgVvFOuXbP5oyqfVoYwHiBax3
         OvGxwlpxlniHJBWirn3pe6+LdKveb9V4oWXxmxVXo55/ObD0kqLHYk5vj3+/HCqQncBb
         bA/YeLQtm3g2EmQ8k621j2mPpYNYLtX/QePj3SI7T24zg5x7dcIp8MKFWPaw3e33OkjG
         1TsA==
X-Gm-Message-State: AOAM531doZAOTFoIVvG/U2O4h2EGJhHHGXCa/cUsfF9IzGnnPqJWG0Pg
        9uM+JnHMl9LhGsLz+sjL60Cht2LwgApUWZQLLfk=
X-Google-Smtp-Source: ABdhPJxgJ/6LOAxqFk3roqf55bdGnRWZir73L6dmGO7UkVz0YB5PPIAgJFBKxYo5Y1hOFZjNq8452Q==
X-Received: by 2002:a05:6e02:1d1e:b0:2d1:78ad:e836 with SMTP id i30-20020a056e021d1e00b002d178ade836mr9968835ila.79.1653384289340;
        Tue, 24 May 2022 02:24:49 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id m133-20020a6b3f8b000000b006656ea096b0sm1076838ioa.6.2022.05.24.02.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 02:24:48 -0700 (PDT)
Message-ID: <628ca460.1c69fb81.9fb3b.4015@mx.google.com>
Date:   Tue, 24 May 2022 02:24:48 -0700 (PDT)
X-Google-Original-Date: Tue, 24 May 2022 09:24:47 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/97] 5.10.118-rc1 review
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

On Mon, 23 May 2022 19:05:04 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.118 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.118-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

