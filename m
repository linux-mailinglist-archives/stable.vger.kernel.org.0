Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3496ED976
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 03:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjDYBDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 21:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDYBDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 21:03:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F8E93E6;
        Mon, 24 Apr 2023 18:03:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a66e7a52d3so40552775ad.0;
        Mon, 24 Apr 2023 18:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384631; x=1684976631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uU63uYraJHI8toeOh6onSgWIkE13niAeeyHZ610UQo0=;
        b=stAJvkIEj7Td7QdUJIew8hYIOegUMfhFUqQ4pG7xO0mDcKx6wNKUj3n2RekU6nQqpq
         1EolTCuSYmPx33Ra4kegm4XRIHoH6P/Rddg4y5xvWwaBZox3sk1X8PFeZG3qvp77i/Cp
         VjN/g+P7iO0jc1QGDfEB1v5CMwEp6ULvqGOZENF5pAvihMGnC61GTsMAVw1gBuuYvBi3
         pDvBLb0mDu2X+Nfvdj0gLvNP3ORt2WGm8ehazj1EBcS10VKtpOM4aIFrD01hxgjuIFFo
         3rRGuS/02ZavHu0sn0oBWmXw6zy3+yOx6kWKQRfP0lyvawjqZwXVo43oHf238YXOroCR
         +aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384631; x=1684976631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uU63uYraJHI8toeOh6onSgWIkE13niAeeyHZ610UQo0=;
        b=UiYYqiB5Y7e4ai3DhvUd07/liZ4jJGyR26K7uvJLdHG34FZtKI2sjs0KpNkMeA8yHd
         i/oYb0SvGKcncsyJo2rK6eIhOwSZ+PHub6YjedEf0McIjgvODUyRQwaTaturofepzB5O
         qc1Z6v3Pdde7KqiKlAnhlFyrVuZXsG7LCjeTsbSlVCao4PCWmJ+YdYIG7YJLY/Bk7wVj
         cESq3eUif+w5IHkF2AqyIQN4keUJ2octKRtZHSc7cLIpYBUgt61j61Fju0EHummjccam
         mY5DjJPkeF0XyOb2QmYm1O7d0YQ7MVoLC1nbc78BleyQOEguTJT1VkuUWSr+38Klno/V
         XF0w==
X-Gm-Message-State: AAQBX9ca3VG61DOJqGAfnGb49NrZ+03TcvhzoR3R7N0X20FafQnMczfC
        duih8JHectCcw2uvhzUelmeU/G7CzrM=
X-Google-Smtp-Source: AKy350YVGjlhBK4YxhTx5cYbwFRcDuLywoWA8lN+VCcTrFCWoLBzGoKl1ZDsyvqYz7qt5GxVk3mqyA==
X-Received: by 2002:a17:902:dad0:b0:1a9:433e:41e7 with SMTP id q16-20020a170902dad000b001a9433e41e7mr15921845plx.43.1682384631156;
        Mon, 24 Apr 2023 18:03:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902d90200b001a6dc4a98f9sm7093837plz.195.2023.04.24.18.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:03:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Apr 2023 18:03:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/28] 4.14.314-rc1 review
Message-ID: <9621c9a1-ddb8-4478-91b6-4d77a923d778@roeck-us.net>
References: <20230424131121.331252806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
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

On Mon, Apr 24, 2023 at 03:18:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.314 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
