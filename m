Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6A8678E8A
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 03:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjAXCt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 21:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjAXCt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 21:49:56 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A877634C26;
        Mon, 23 Jan 2023 18:49:54 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id p185so12191835oif.2;
        Mon, 23 Jan 2023 18:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X86lwB3K6qQT9EBDO+x3sCvlNaBGJ0K6Kl/k/JA7UI8=;
        b=krA7WJ4TMyuOR3dd7H6AipFrcxlQqvEOz5xkhXQ0vxtvQ/ZtK2xMyAhUGtRsV1QoU6
         XJnZvEMyJfesK23PSSMC6a0FiphHXjM+ria+6RpyB+OpILLOBvOfim1p9vsMagm7i3O+
         cVkpvh025Cw2/gBAODAfah09Qvu5BEOZDu0QYhSw3rZHNdTOr+C/2aZL+NnTy8oMZBGw
         QbvRCwmJObF9bTknxUaHX6bc1GuSFM+5dHB9N247k1dTEX6sn0eG44aVGO19TqGu4C0o
         OqWPvwRi6ilw95sRgXiy9Ko+xg1RRLVfRENumexDuKNeQp9hV6ofEjWktC2xcqY1iyrX
         waKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X86lwB3K6qQT9EBDO+x3sCvlNaBGJ0K6Kl/k/JA7UI8=;
        b=U6+mATgHKzVaDl8spvf3biDUOkZqapAHd79xhdRmu/xCIKC/xHoAni3/RUNIpBWlyO
         CYMqTwuu5Zc/2ql0VvLqL3ZaCfUQhHpVC5CF6lcVAqcYZE4TabN1OtoqdjB9AuqlvTna
         Ri3hjZ1pc4pNta5JTyzUiLugRgkbyyxkATMR1VQdAAHdkdMPcthFBo4C/y7Ry0elBieL
         uaH2+BpWmIwFU5Oozaphwr8ya/Gyx+pvogIdzw19U9RGBjlJodtWs6iMx4ZqvbIOwY/C
         E2uc6KIzelgTgI5l4EC8mLB6zTDWNBrVIcyDmrS4It2IEIvn7zQ0B6pkBFMv7OSy5vsF
         3MbA==
X-Gm-Message-State: AFqh2kq5vFgGhBUrp8lqocLAKtJnhOJruyekTzJn3J4NCfcEAQF+rQB5
        fMp2anesNXYs7Y2izYaZ7P4=
X-Google-Smtp-Source: AMrXdXudWHmqckEuJORV+M8lJTUXqcJkZ8AuZq+6QGE547MiIpL2AbiKgFGPazKe2lYugY3Dc0f5WA==
X-Received: by 2002:a05:6808:2895:b0:35c:3a60:6ab7 with SMTP id eu21-20020a056808289500b0035c3a606ab7mr12982412oib.49.1674528593970;
        Mon, 23 Jan 2023 18:49:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r21-20020a056808211500b0036e3bb67a20sm488462oiw.38.2023.01.23.18.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:49:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 23 Jan 2023 18:49:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Message-ID: <20230124024952.GF1495310@roeck-us.net>
References: <20230123094931.568794202@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 10:52:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 502 pass: 502 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
