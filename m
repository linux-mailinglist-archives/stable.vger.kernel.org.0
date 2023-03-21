Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629826C3E54
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 00:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCUXNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 19:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCUXNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 19:13:04 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5E2CDCD;
        Tue, 21 Mar 2023 16:13:03 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w4so9039635ilv.0;
        Tue, 21 Mar 2023 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUNVtXTLAxWYM0b/A1ZTGJcL1PBuc2/bSARaicUf2+w=;
        b=S8Gv/Ta5cHjRIJGMB53cTEO+K/BICRG5/WYhjakfVrvdZo1mTjMuZOIdPIAt1OQOs5
         MHYKN2GBec+ySZnKTW2B1GX9Q2919smFwb0Ty5DCyW6jHcuy9bg8Z+dFW+w2r+O9z0Dj
         DDA4d9IOVem24pcp1KCcQ05eMjzGJwJRBg0Yv1fwvYZ++OsWlf+1zGo0aPO5ATnpa4Nm
         Njjg7G4mHikwtJE+l8dTpqyMNpt1sZhvb9abWoonRFI7c6opW/8M/c36ezKlwxfXInWf
         XY3UXiQz1jGNst0ewEVIutHYahcnafaZ0ZSw5SOsVQiZ70wG2Ubg3KUQhDYiHTvrckvC
         caNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUNVtXTLAxWYM0b/A1ZTGJcL1PBuc2/bSARaicUf2+w=;
        b=l2rJpIMyF3SKEOW9J2tBp1CNB8iqlsv03UFJMBs3IYD1l4BZeR+YXnKaFBJW4KVSOw
         kWcSEi0OOs7BedvNBXmzMw6ocoRf/Nuaejlv7Iq2WcuW5fHSv/w0Q+GEKFjszDKLkWFC
         aHXfo+nDE6PeyUe7NCSEMMPOnZddLyjkvY/EWsINawOx6KgdcoNErawlKTB6AtEoq9up
         RBm/4mCZTq2MCXcKRx4CrWMeYLrxpNov7umQppZ/aNluAp6fAiagC1z6unogluLXUeYR
         5i4Aegpo1AMa29WIAkU3xDIFfQ9AtpHlflxlbHbAJJTSkUTIQxbBkWlvo+5/+LHYFre7
         HMzw==
X-Gm-Message-State: AO0yUKVtF+IxA3BaaEdb5ShEv77sBPTinn+EBRWjpdvTmHE3quMmxChi
        ALSq7urVxkYb5e4T/XxkPyU=
X-Google-Smtp-Source: AK7set+Azzc9dn3DEe+Bh29zBK8lHCg17Fp01fnoimMKptZhooGN+9tJzx89MSB7bKAQ5fi4AW9geA==
X-Received: by 2002:a92:d3c7:0:b0:315:51c3:2ad9 with SMTP id c7-20020a92d3c7000000b0031551c32ad9mr2815805ilh.21.1679440383151;
        Tue, 21 Mar 2023 16:13:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u26-20020a02b1da000000b003a958f51423sm968487jah.167.2023.03.21.16.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:13:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Mar 2023 16:13:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/36] 4.19.279-rc1 review
Message-ID: <865c1eeb-1efa-49ee-9508-c25fbb7d833f@roeck-us.net>
References: <20230320145424.191578432@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 03:54:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.279 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
