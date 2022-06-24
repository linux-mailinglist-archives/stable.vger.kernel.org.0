Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC06D55A4E3
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 01:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiFXXfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 19:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiFXXfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 19:35:19 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DA8857B7;
        Fri, 24 Jun 2022 16:35:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m14so3343323plg.5;
        Fri, 24 Jun 2022 16:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gE671YojBPu3KTZGhH2zl5gy2vZRYeRfFum634VbfxU=;
        b=Iw9aHiXo+GjUxvv5YtaCP26VwrJomCmZp58HZjo4h6MA2MjxzEmsUwoE7bh7vowrWW
         gL6aMPBj+dWMh16YzJ3h4o41dEAH5ychiedEzqALgvcZyQAMWssNn/+po1ahfWOUZrGf
         T73Zhs1EBoRRm5/irP1tODlXDyBsoUZKhyDY4REurH0mkHXrnQhOcSNGlLzqrnzi+Pnc
         kmSH3jxEu8wJeARJvoa7TFknbCQKxMbpZmmPr0yzgYbv7mj2/jc8WUVFGTmP8Fp6gBjU
         5c/EhH3StS+qf2FERV667LSOOzh5MjB5YvfXn9FCej9jyxOSRVcpP6C9RIJEBLZyiB1o
         VOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=gE671YojBPu3KTZGhH2zl5gy2vZRYeRfFum634VbfxU=;
        b=t1rcH0glS73DAceuIqPtiwJ14HGUbUViy2MWmm7pSnYXzpTRDBu2aHI5xDsZf7f2CS
         BU8LFfKd8tG/cW+lgOJLbHNpzNgQGofTGt8rQCR2y0/A+gWdVh7l0zeRcEdxfZeZZm6a
         tag0mr6M/IoBs4UceShPzs3Z13NHXVuTssfGckYTDIjZbn6lPzTbFaHvOqRUr9yIssGD
         ZphD48Wf7mrtlSUTPN1F4UK+QL0tWWnzR2bNC6PY8UF6MKy73Y+i8PvHnSxbM3eYA0L8
         v6Va4x54SgjP3CQ6tvKqjnCi6g+q61wMeLTZnEWjtUjSRKwCE2fydpBx+kJjoHA3EUL3
         CVxw==
X-Gm-Message-State: AJIora/4XlSNWMxD8aoFy2Z9mvIYoLEXuXQ1xcFEDQXPOipFwtWQSfHY
        3bs+Wy0W/oVRmYhklSr1TQU=
X-Google-Smtp-Source: AGRyM1vDW5CDbeo253Qf4z9qRYTp2p9bwS2y8UoSYQWjb3MpCLHsBAMCFjDuKTs75ZlvwQiEy5JC6A==
X-Received: by 2002:a17:902:cec9:b0:16a:416c:3d27 with SMTP id d9-20020a170902cec900b0016a416c3d27mr1474965plg.107.1656113718365;
        Fri, 24 Jun 2022 16:35:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bj28-20020a056a00319c00b0051bc36b7995sm2241504pfb.62.2022.06.24.16.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:35:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Jun 2022 16:35:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/11] 5.4.201-rc1 review
Message-ID: <20220624233516.GE3341529@roeck-us.net>
References: <20220623164321.195163701@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:45:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.201 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
