Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A975B02EB
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 13:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiIGLbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 07:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIGLbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 07:31:11 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02887B0283;
        Wed,  7 Sep 2022 04:31:11 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y82so12928648yby.6;
        Wed, 07 Sep 2022 04:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=htQQOB82V/42KTcLd0mWmEHX6IR774JdlYtTcKgQ5uY=;
        b=J0hpqdXnf3ogu5jaZnQRInPEzYpKWw1bSpC3Fak9LMh0NOkMVK8yKh/D15/hBBbWls
         rqUsCXdMRhyzCMzIx4/hnJAcGNU14dFgoDGgefZgnI9LmYthGPxnRHxP8SwpkBx2WWMc
         APnS+XRSCbS1+z1crEqmKL7k7mQapnAg61SMc2NmRdEQc7K1oSU+vgtI/Vjy9T6KXHFU
         UwV51QN9LhqArah47LUrNdHlpHDbqL5GiPqlW2F8/m5Jd3liEd0fR8lr5FFeOw12XBTA
         T4zfPpc3w6QIaT/WkxMAFXHTxfzCf0uk8QJkD4CaYzGKjEQKOOWVAHhc4TVuuYOBZ0jj
         a0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=htQQOB82V/42KTcLd0mWmEHX6IR774JdlYtTcKgQ5uY=;
        b=TFzkhEnxuyWYqACHewBljcuGLSuz19+MeSXXRn3mbl3sJDV/sEIpQeKFwVh3SLrc52
         ROjZaVzUw3iWOy+k4bQgJa+6w2A9/CayLGBF5iZsfDCUsOUpBRJB41ihX1asWNhQZUly
         /r7X5CfS1vwFNl6XLmX1rM7KGX18WC+vRBB4p+g66+GsjoWIv/emYFNjcagPTBFl7V0w
         XnkEzRB1p7qO7fN9uQZNyqmGNDqUVgHRjDD1eGLZT4bjCBImpggIwW4xtvy+SKElQPP0
         QaIBqDdoW/PL6vPdo476sTWTARjXXMU1n4syoA0tlBxRZHtzWWJeRFufAzEsFtKhaXmj
         3dUg==
X-Gm-Message-State: ACgBeo1BKtc+WSHk8N9NHzY3fr1bGtL7KxujDqO+t3JOuI3yYzL3KnnI
        caZUNZaVz74uzmmKkfDp16IP9OzEVXLvAqryRDc=
X-Google-Smtp-Source: AA6agR71H+G6qVXzMIzOGHX5QXC/V9UhqXsgcDMknFubEQ5fmf1ViE8QltDfcI3uiFsMdrym6KaPtNAbOoHe2iN1Hi8=
X-Received: by 2002:a25:3b46:0:b0:69c:a60e:2e57 with SMTP id
 i67-20020a253b46000000b0069ca60e2e57mr2192680yba.364.1662550270206; Wed, 07
 Sep 2022 04:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220906132821.713989422@linuxfoundation.org> <YxhnDip9k6TfRCCc@debian>
In-Reply-To: <YxhnDip9k6TfRCCc@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 7 Sep 2022 12:30:34 +0100
Message-ID: <CADVatmN3hoxBB-knoTO6BGb=1fstiOPwakCu3tXHbV21bHR8Pw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 7, 2022 at 10:40 AM Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Tue, Sep 06, 2022 at 03:29:41PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.66 release.
> > There are 107 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> > Anything received after that time might be too late.
>
> Build test (gcc version 11.3.1 20220819):

Missed reporting that the build is full of "/bin/sh: 1:
./scripts/pahole-flags.sh: Permission denied".
On checking it turns out, the execute permission is not set in the
v5.15.y branch, but its set in v5.19.y branch.

On v5.19.y:
$ ls -l scripts/pahole-flags.sh
-rwxr-xr-x 1 sudip sudip 585 Sep  6 18:03 scripts/pahole-flags.sh

on v5.15.y:
$ ls -l scripts/pahole-flags.sh
-rw-r--r-- 1 sudip sudip 627 Sep  7 12:27 scripts/pahole-flags.sh


-- 
Regards
Sudip
