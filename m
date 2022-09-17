Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68E85BB5FE
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 06:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiIQELI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 00:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIQELG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 00:11:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48C85A88A;
        Fri, 16 Sep 2022 21:11:05 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 78so22042483pgb.13;
        Fri, 16 Sep 2022 21:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Io+HUzbS9Ne8BTdacwB7WIsyFHjkHKLnRQCl7dgy8uU=;
        b=qNti11DYvVDIXXP9FsQ3kUX2I85s0QJCofDngVPw72SJ97qA6PbtS2uuTJ7nkLji5B
         j29Kv0XXEGSMA3JEQHR0u9MEhIQkJfaz3IyfLn8yLzVJsWebXmIDrmDnjWjRaDae99SI
         xXE8PCEtWNUrQkiAzGhEYetVNYdJTbjF6KhG9fZUvkrESp37s20X1AgjG0vd7znwmjK2
         WUtkVcPcM35/ELWJpuZu3wNMQhNKj4NslpqEML1/eZ/AGNiiOG0VGCH4tO9y+muvb5ZB
         pjTRZTXNDycr6LGyEn+To69gEv5+mjnelejPWTUl/F0PvtLU8XzZ4NfhQIT4Oy33maP5
         s94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Io+HUzbS9Ne8BTdacwB7WIsyFHjkHKLnRQCl7dgy8uU=;
        b=qPeMrPfmPfrOOn6a2Kafr6zTs+wodObhQSr6cxObbgS5TCe4fv66dhxrDqPFiyJfDY
         1b10qj9HZIkreIru490AtUHq3uKYslIs1IY9Z0be3JBw2JE8HDI0DE5XviXZ6IdrMyGe
         wGwmZjpvnyhI8vFPJcZ34ikiIihVPRc1PhbEDFGctcirJY0UHycoPlM4O/0/BlT5OqmC
         vzlm0J8ZZav7B0oBxCEIc7Yqpi5vKhBH/2H7hsUsYkvAdYa66UiDB4yxCPCDfUB6ivDq
         rK4PCaG+SC2T8mHFzG1ggMqc5R6DWQApmDI30bqBGh5nxJimH8NUua9RWR3TOmOK3dKx
         wb6g==
X-Gm-Message-State: ACrzQf0KazywSNkBpTIoBGEsrs91RKzZDxkyKKOCuHOE/LVvr+e+e2kI
        lPmfPMsZkScICCyjMzr75SQ=
X-Google-Smtp-Source: AMsMyM6+bbip3q7dETPIOMPTuzZSHdNv2yw9alFv2ZExwfcfMeQOMaL4bPGo+YQaFNwQQlhFNV4GGA==
X-Received: by 2002:a05:6a00:d60:b0:53e:576e:bd8c with SMTP id n32-20020a056a000d6000b0053e576ebd8cmr8177740pfv.4.1663387865370;
        Fri, 16 Sep 2022 21:11:05 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id r1-20020aa79ec1000000b0053e42167a33sm15298752pfq.53.2022.09.16.21.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 21:11:04 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 60495102B77; Sat, 17 Sep 2022 11:11:01 +0700 (WIB)
Date:   Sat, 17 Sep 2022 11:11:00 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/35] 5.15.69-rc1 review
Message-ID: <YyVI1OdOjuEdVAjM@debian.me>
References: <20220916100446.916515275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 12:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.69 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
