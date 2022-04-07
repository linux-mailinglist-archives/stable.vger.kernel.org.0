Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86C4F7BE6
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiDGJnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243954AbiDGJmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:42:42 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2BABE9D0;
        Thu,  7 Apr 2022 02:40:42 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id a19so582870oie.7;
        Thu, 07 Apr 2022 02:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FcHUUuQouyt/oY/Z43CP8YAaehl/b4UABsbX648Cgqw=;
        b=kBXvEADXYwY9BuAhBBmGchud4VtpU+9Lx9yTtwSP8/g3Hec0qg42N61sBeBSCYW8jC
         ux0tIR1TwlGJLD+RFvHbuaBYNmqKECfoqoLfaZm6QhtXezxd6dDMX5hVN3dxX0FQ2ffF
         MoujfsLpP6CVygYGjFkN5vxvsNVwhz+tdcvDQW+3l/mmeCcCDnaOFrTUOEVPzGcWhTXL
         I7tTEM0Iv05tnvclQxPvffVRZPviEGlpx0SD25bn8JiQO8w/U/cDwlgmn0nkJrNhzgIF
         3fFAd1m4sxb5UzRKdnQ27vl7uMrRsjFkJVN3NfsJh+RwrsDjwCCvWCV6nOcUo4qBD88r
         IrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FcHUUuQouyt/oY/Z43CP8YAaehl/b4UABsbX648Cgqw=;
        b=G38HdHlp7TNZsIGKVupaGpnsK6R6aRBh66wFb5qRbWArfB5NSAmnC5+gsr0JBHVnRl
         vIBUujWY4Bq6t2yGD7cxMXbKNIlmRRMHJGDjSdE/0iOhjXebJLMr+Fv/cpoetu5lTAk0
         oGimRnsE9VGu4nZw0EYZV5nJsGV+h8rAdP24o7kz/ZBzmK03QzVb4ElsNc6HrPyt9hjI
         DSf6FrFatnS+/eNghFzARDT3U03qiWTDkft2WWClKO0Vri8SQCi6/z292csp+Enf9ReA
         A53CbWL+yTr3kj72QlQaXpQP5ABVXU6CX5rC3uae6sx9piFQxEd1lCkkUialEMka0BJC
         KsUg==
X-Gm-Message-State: AOAM533I8zfTQBINcTHFN4SsQkq/O+4+hYW/4rHaWL7+rw7rbWGtaUZW
        ClVDyPtHuffQ+b0wWGj5YWc=
X-Google-Smtp-Source: ABdhPJwvBfUmqwK9rfS2jeAGA7uvk8UX3yAunbKvOTQM+QhppJvvPmT+e/wpWG2NQevnNdYHxurrng==
X-Received: by 2002:a05:6808:1719:b0:2f9:ab58:73db with SMTP id bc25-20020a056808171900b002f9ab5873dbmr974460oib.201.1649324442287;
        Thu, 07 Apr 2022 02:40:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r6-20020a0568301ac600b005cdbc6e62a9sm7665966otc.39.2022.04.07.02.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 02:40:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Apr 2022 02:40:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
Message-ID: <20220407094040.GC3041848@roeck-us.net>
References: <20220406133013.264188813@linuxfoundation.org>
 <fce71421-6afc-9f8c-31a2-a71fccb3259d@roeck-us.net>
 <CADVatmPpDpcX-0NYBUgVjNtgB_EjXL7GO5bfuTH2yGR6DB5_jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPpDpcX-0NYBUgVjNtgB_EjXL7GO5bfuTH2yGR6DB5_jg@mail.gmail.com>
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

On Thu, Apr 07, 2022 at 10:35:27AM +0100, Sudip Mukherjee wrote:
> On Thu, Apr 7, 2022 at 10:10 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 4/6/22 06:43, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.110 release.
> > > There are 597 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> > > Anything received after that time might be too late.
> > >
> >
> > I still see the same build error. This is with v5.10.109-600-g45fdcc9dc72a.
> 
> 45fdcc9dc72a was rc1.
> 
> rc2 is f8a7d8111f45 which is v5.10.109-598-gf8a7d8111f45

Hmm, you are correct, but I just tried v5.10.109-598-gf8a7d8111f45 and
get (almost) the same error.

fs/binfmt_elf.c: In function 'fill_note_info':
fs/binfmt_elf.c:2056:53: error: 'regs' undeclared

I'll restart my build server; it seems to have missed some of the changes.

Guenter
