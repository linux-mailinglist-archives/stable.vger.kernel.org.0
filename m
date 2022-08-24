Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC3759FFDA
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 18:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiHXQy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 12:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiHXQy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 12:54:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF13AE7C;
        Wed, 24 Aug 2022 09:54:55 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x23so16175940pll.7;
        Wed, 24 Aug 2022 09:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=KqNFaFPHcc3gAC4NXdiDPBYjVvtei+p83QWy8+fa+Io=;
        b=bHJY6ZHgS0cVaG8dhhHyEhYI3myRY0I06v1Fw7fckGjpZSiJ+IZ5szJVtHWFK6h+/T
         n/OmH7RJT38/zWhX2ELeBfabYLt8cUuusNm54VCuXsIHUeoeNiQy0iT9KXLwrwPY+BQm
         JQeEHWIGxjn4ry25TBPjgKVepT0EBNKrRdyzOqb5Pw9UFKvnZPgaq/v62TPNb+j99UUd
         CHhvKpFbo8kZFDlRi/AbeqG0ueFGoOHv3rdQgEFvkwPM4cDFWrED8pDB33DkHq7iAFS6
         4GjVsrt/qn5IJDH2D9vHoyYfLUxb7jQDMMmyRwtiCkjOJno11Y7GMS6BP5OG8WogOxDa
         x4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=KqNFaFPHcc3gAC4NXdiDPBYjVvtei+p83QWy8+fa+Io=;
        b=gGTE9jFZA3+L8UFaGjUs6gb/+CwoNp8qsZ/agqspKANs7/+Gx72EKcMQp7eC3OG+3L
         InXhRI6+qsxheItEGgO1Hvbem8DiBBb3jbGGdaws6+Z9CayIjFNOkRrmUEWq8lexLqtW
         ThjyZjrlPnXecCj0yzqiU5XFqW6GPIEPixjL00xIcTo1bn01sL8gjTrjRnuCl0FiVDTw
         jPmnDDsihsVEC0VvsVE5d1OmhedE1Kk/1J9BFVmO7/qULkIk6l31g+bsYzMcJc8/2g6J
         hIct4lxjRWqfn92704IW+D0Nglr78FzLCot4oL/JC68FMAi5ZMttUBkiTNmzHm3WMTIq
         p4gg==
X-Gm-Message-State: ACgBeo2X3M0WOkrs3/xlJC+uO9IdXxIj7cSerU+kJiJHXC/einSRkZyj
        Y1dasuQ5qv/75p8yf0iKi8o=
X-Google-Smtp-Source: AA6agR4mMWrUFg4IZ/EGX0Lf7f4Rnc+qklbnToH8LnXW2ZaqJ+V5RL0GQKuEe0mP8G4wJk2T51NcHw==
X-Received: by 2002:a17:90a:3e48:b0:1fa:99af:d881 with SMTP id t8-20020a17090a3e4800b001fa99afd881mr9334107pjm.243.1661360094740;
        Wed, 24 Aug 2022 09:54:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg8-20020a056a02010800b0042a59ecdbdfsm8967781pgb.84.2022.08.24.09.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:54:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Aug 2022 09:54:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/157] 5.10.138-rc3 review
Message-ID: <20220824165451.GA708846@roeck-us.net>
References: <20220824065856.174558929@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065856.174558929@linuxfoundation.org>
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

On Wed, Aug 24, 2022 at 09:00:52AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.138 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
