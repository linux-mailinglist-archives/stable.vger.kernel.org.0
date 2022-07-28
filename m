Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD37583AAA
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiG1Ivz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 04:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiG1Ivy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 04:51:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F0118346;
        Thu, 28 Jul 2022 01:51:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id y1so1218317pja.4;
        Thu, 28 Jul 2022 01:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=brCDVHlbSzhWfeWZwVjuyjDWC1Yudq6Y4FN4pwOlp/c=;
        b=bgpfWBqshcqlEG9rFVkdSI5SJj35E5X6WvsHyIdWCBBniU1LHsKr6P5Fplj26LFLxo
         GO1h/v+L5IKba4sled7XBZ+G4k/gx5wz/qbBVWnmw/4f+nJ51/nRs3gCj4Gyvc2IGMF/
         AbZ7ZPu6cD2VbF4feSFEXFyPfTzHY3oDa2VSs8fKXSF3XqCM07nk+WYMKKYfhAlDloLf
         ERUShKV6Q5fwVDf5r0SoDIW1dRxq5UdNTRfzKpIotMPGQ6WoOY/ejXy8QACPjuQHCBL+
         qhUl9MZ33hGPk1daJV6xPmrbQ/x2R6c5U7Qf2ICsCwV+/B9PgznhL+luN6zTpxzR/ete
         SXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=brCDVHlbSzhWfeWZwVjuyjDWC1Yudq6Y4FN4pwOlp/c=;
        b=0iJzDqqYeqWk2v9XDpA2pR3Xd+myC8a3l3j1iyd7I7brk7afIIoiN9XMEnwnsotLZS
         fkx24G4YBavDrydfrSaUj/Tpd6WLThhnFaNYX0B1w2KcWHN1jxDEnOUxkAV1TRkmD4OJ
         1YFzG+82XJiR+bsYDM1B/1HYgCxzNGyPKPBBeSdwMVJyG8mqyBrypUkvncns1k5uWQch
         f+KdG4bxYJJvsGbaolGYDNVabFggFx25pMVw0rv1X24DhamnYJzMV3u14m8th29LO/Y6
         ZO/WK83ottmnD4G305cjBPjIzVeqA0Ub/mwigUHPGcQJoYWGNhHOqJhCjkPRHaowJqMu
         8HOw==
X-Gm-Message-State: AJIora+8Rwm58MHreP9tPGpmTCaLg17sQ07rPabGFbRzBYhV/mYLLXAp
        Q74xGV9tvz76famqyraLDMdM37v0Hhw=
X-Google-Smtp-Source: AGRyM1v5Qiamp9MCyzgoZMJAKt4tZylP9tvQEDYTPA0S7QyVTJI97a3XlOfAuavaza2CY0l2xnP5jQ==
X-Received: by 2002:a17:90b:3ec5:b0:1f0:3986:4502 with SMTP id rm5-20020a17090b3ec500b001f039864502mr9467107pjb.6.1658998312456;
        Thu, 28 Jul 2022 01:51:52 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-83.three.co.id. [180.214.232.83])
        by smtp.gmail.com with ESMTPSA id a28-20020aa794bc000000b00528bc6d8939sm96561pfl.157.2022.07.28.01.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 01:51:52 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 905BB103C68; Thu, 28 Jul 2022 15:51:48 +0700 (WIB)
Date:   Thu, 28 Jul 2022 15:51:48 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
Message-ID: <YuJOJFj1GCnVQOgr@debian.me>
References: <20220727161021.428340041@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 06:11:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
