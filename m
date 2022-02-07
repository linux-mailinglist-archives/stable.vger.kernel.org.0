Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E06E4ACBF7
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbiBGWUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiBGWUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:20:38 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAEEC061355;
        Mon,  7 Feb 2022 14:20:38 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so15346092ooq.10;
        Mon, 07 Feb 2022 14:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+dK48uVj0k3aU+1COXYft3k4olQvQM3U7K5F7RnibMI=;
        b=HmMhiuh3r1n9wGOT6mhwA/epDvAXghCp83nCmiJFCfRNe+4H6O3Z1C3wmNzcLSamZB
         MFeqUJhlLn5Or7TbbzlhO4QqJJQ7gFLA4dYVUi89xTBxX4eLMG+5Lokof3PBCd51nVQg
         XeTYce241ETs/Z1ab4/TVxSjiNrlN1nnwHUs1RaZl5/d6khzzTG1U5zEkbvZFqLmb4EW
         s4ZCn+offMQtQxCbE32+4s1irn+pjDMija+m7pg+7aSjPAjtYfn+yqYB1vlBLnV8tsqP
         J+Gsa3q1+a9e72289Gdii6E931ifV2v8Oj4fDz4QP1eXVUl9vunehzRD/1Ge8xmmXAEp
         jlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+dK48uVj0k3aU+1COXYft3k4olQvQM3U7K5F7RnibMI=;
        b=YzzuMshj8p0wSFAKozLSo796AuPs7+DqlID+X+jQchY3eJH90jyIPfPDvrKuHF4lSc
         NSPZwuvA4CIo+eDl63RsiPxPNXGwFNq6MkxUh2Iw3msW9OuqkE6+KtxQ7FVxuq8Oan8h
         yjJ0NMK8P+W31zpfF1wtkzKmi/GrsVrPp9kqimKA4bp4/srUeIhVT8akrFHIpYj8f6MK
         6e1iyNw5tibe0vyMEMyaay1Cwk3UQXniTwYcFUhYfIZREpP0rz/GVKBvLIsd70fKFkbv
         zjSQDkMd5B//HWsS/8ZQ/n369v+r7tiNbY46wMVijCYVxMAVuiblE+0dMbnrtB7ZjnGk
         JMWw==
X-Gm-Message-State: AOAM533tOR+782fu9mZ+7XOzEWvA821sA8i/m6YxkxfriTDTyl713/da
        +mvNc08WAHIwRUee3E25kKY//BSY39eJHQ==
X-Google-Smtp-Source: ABdhPJyefZMttAOmPv+bgufYcQ00Dg91WKBg4Lwd17NVpsTdrq3bLXGKu02Cqco+nk2+LzI6wIf1Ow==
X-Received: by 2002:a05:6871:4091:: with SMTP id kz17mr339055oab.93.1644272437422;
        Mon, 07 Feb 2022 14:20:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y3sm4865195oix.41.2022.02.07.14.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:20:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Feb 2022 14:20:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/69] 4.14.265-rc1 review
Message-ID: <20220207222035.GB3388316@roeck-us.net>
References: <20220207103755.604121441@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 12:05:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.265 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
