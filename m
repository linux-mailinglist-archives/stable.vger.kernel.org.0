Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188932E8C3D
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 14:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhACNIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jan 2021 08:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbhACNIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jan 2021 08:08:38 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9913CC0613C1
        for <stable@vger.kernel.org>; Sun,  3 Jan 2021 05:07:57 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s15so12972694plr.9
        for <stable@vger.kernel.org>; Sun, 03 Jan 2021 05:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=C3S40nvZ1KAibgqq4pRXsnZvOWvafLFfNFHpOMGPYUI=;
        b=lCur1Tqzj/PqbigBDEUxB3Ub/Es5qanDj2Acs1+oXsmtBpsu8nQ2LP8HqLGZnwltkE
         64ysv4wdvFPIMRoN3CYxdO3ZhnSahvXQB2bpAL3wp1fedlkweZXxQNZ31A4IoiVKEO9K
         S/hvKI+72NWNQbY4i8EJ2J3LptB9QgiiJXdAjMWyrRI+ixN4g8NFMcrdLAyBSUpDcDgv
         /NqExZnqs+RyIPrA4kgXiNEpjIFRzKL5bdEie1mFQDAWxzsMaXzpFKX2pq/Il1k/Xvkd
         KOI4fdWEH8oeNVl2US2jy30I2gpbvgzl6u78gW/eOn6kt7SBR5oKXzwXbzIXHHF3taUI
         KXKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=C3S40nvZ1KAibgqq4pRXsnZvOWvafLFfNFHpOMGPYUI=;
        b=BuFzMOW99l0MHI7RD7+sfKa9YLzswRgj1bNhq1W9scGa54SzXJKicWWITXUsNxq4NF
         mxixSY51NAc8VL1emBTI9syw30PMDGgk5e4IWAB3CTj7YZi6BG86Uk25MFXX6S4E8hlh
         tKEggpOuqJ+hhBIawz41sT+dfUm9ijPi8ovjhXykXWyVRJ2zfTi3Qv8xaKdkfNtXc3Ua
         j/heBCvCgLVz840uMfap/ny8c8h3+ajpWA5fEqfOS7d+TPU2rLT1YVWexfg+0QBmO2uL
         681nBuvzvXIxpPLOPPgM/wZfiFh7oWsull8lRx2wdvzmJesPkzgFWbiNE+JzVhrHCyNW
         0pRA==
X-Gm-Message-State: AOAM530IB67w+Rr0djD2O0imjPp6cV0wIXj00wC6DJalEvJaEoeiVwFq
        bjT4vyn7EuDywORfV4KQT383iQ==
X-Google-Smtp-Source: ABdhPJwez4WC6sAAewfXlPN5fm3y9LM4NL4JvawZzmyKypaDteHj0yDJEVMRHUYs+fUznYgQa5IWCg==
X-Received: by 2002:a17:90a:6589:: with SMTP id k9mr25293215pjj.100.1609679276903;
        Sun, 03 Jan 2021 05:07:56 -0800 (PST)
Received: from [192.168.0.4] ([171.49.190.54])
        by smtp.gmail.com with ESMTPSA id s7sm17365616pju.37.2021.01.03.05.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 05:07:56 -0800 (PST)
Message-ID: <aa62485a757305b46df190e6f90dfbd6bc31a144.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Date:   Sun, 03 Jan 2021 18:37:51 +0530
In-Reply-To: <356ddc03-038e-71b6-8134-5b41f090d448@roeck-us.net>
References: <20201223150515.553836647@linuxfoundation.org>
         <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
         <X+dRkTq+T+A6nWPz@kroah.com>
         <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
         <X+iwvG2d0QfPl+mc@kroah.com>
         <c7688d9a00a510975f115305a9e8d245a4403773.camel@rajagiritech.edu.in>
         <20201228095040.GA11960@amd>
         <356ddc03-038e-71b6-8134-5b41f090d448@roeck-us.net>
Content-Type: multipart/mixed; boundary="=-0uUBTdt2BAmFpi40ELnT"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-0uUBTdt2BAmFpi40ELnT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Mon, 2020-12-28 at 12:41 -0800, Guenter Roeck wrote:
> On 12/28/20 1:50 AM, Pavel Machek wrote:
> > Hi!
> > 
> > > > > > > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > > > > > > > or in the git tree and branch at:
> > > > > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/s
> > > > > > > > table/
> > > > > > > > linu
> > > > > > > > x-
> > > > > > > > stable-rc.git linux-5.10.y
> > > > > > > > and the diffstat can be found below.
> > > > > > > > 
> > > > > > > > thanks,
> > > > > > > > 
> > > > > > > > greg k-h
> > > > > > > 
> > > > > > > hello ,
> > > > > > > Compiled and booted 5.10.3-rc1+.
> > > > > > > 
> > > > > > > dmesg -l err gives...
> > > > > > > --------------x-------------x------------------->
> > > > > > >    43.190922] Bluetooth: hci0: don't support firmware
> > > > > > > rome
> > > > > > > 0x31010100
> > > > > > > --------------x---------------x----------------->
> > > > > > > 
> > > > > > > My Bluetooth is Off.
> > > > > > 
> > > > > > Is this a new warning?  Does it show up on 5.10.2?
> > > > > > 
> > > > > > > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > > > > > 
> > > > > > thanks for testing?
> > > > > > 
> > > > > > greg k-h
> > > > > 
> > > > > this does not show up in 5.10.2-rc1+
> > > > 
> > > > Odd.  Can you run 'git bisect' to find the offending commit?
> > > > 
> > > > Does this same error message show up in Linus's git tree?
> > 
> > > i will try to do "git bisect" .  i saw this error in linus's 
> > > tree.
> > 
> > The bug is in -stable, too, so it is probably easiest to do bisect
> > on
> > -stable tree. IIRC there's less then few hundred commits, so it
> > should
> > be feasible to do bisection by hand if you are not familiar with
> > git
> > bisect.
> > 
> 
> My wild guess would be commit b260e4a68853 ("Bluetooth: Fix slab-out-
> of-bounds
> read in hci_le_direct_adv_report_evt()"), but I don't see what might
> be wrong
> with it unless some BT device sends a bad report which used to be
> accepted
> but is now silently ignored.
> 
> Guenter
> 
hello,

Did  "git bisect" in  a typically ok fashion and found that 5.9.0 is
working for bluetooth related. But 5.10.0-rc1  related is not working.

some related information in bisect.txt  attached.

-- 
software engineer
rajagiri school of engineering and technology - autonomous


--=-0uUBTdt2BAmFpi40ELnT
Content-Disposition: attachment; filename="bisect.txt"
Content-Type: text/plain; name="bisect.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

JHN1ZG8gZ2l0IGJpc2VjdCBiYWQKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClsxOTQ4MTBmNzg0MDIxMjhmZTA3Njc2NjQ2Y2Y5
MDI3ZmQzZWQ0MzFjXSBkdC1iaW5kaW5nczogbGVkczogVXBkYXRlIGRldmljZXRyZWUgZG9jdW1l
bnRzIGZvciBJRF9SR0IKCiRzdWRvIGdpdCBiaXNlY3QgYmFkCkJpc2VjdGluZzogMCByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzM2NTBiMjI4Zjgz
YWRkYTdlNWVlNTMyZTJiOTA0MjljMDNmN2I5ZWNdIExpbnV4IDUuMTAtcmMx


--=-0uUBTdt2BAmFpi40ELnT--

