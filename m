Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD91D18E39F
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 19:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCUSTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 14:19:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39436 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgCUSTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Mar 2020 14:19:03 -0400
Received: by mail-lj1-f195.google.com with SMTP id a2so10036943ljk.6
        for <stable@vger.kernel.org>; Sat, 21 Mar 2020 11:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1HmzOHeO+HRpIjBM95vy/qqGNJoa4vZPLdaJZ/DoRpA=;
        b=lUadTanTr6oXRZjkSX1QtsJnaG4O7cUM2aFGiw4IIC/5e54AEgdPMxYflgrk9k9OWt
         mypz0RvgI39sw4Xh+GjOcHFY7oUIs5ynBD9jAuyitoHWJwWDrsy+8PR4iM8duH13sYUt
         ejh8xapRGxE/2gR+lo1moC8EIJfxMMT+LcR6e0crHpno4wGU6Pimr367YIjBK0YHZrc0
         Np/kPfN8SdsQwW2UraJ6ScdSsfTgRJaXPOIf5G/m8VCsigLHuoyeViyuhjVrKwR3mycr
         dQRMpwFRsQvWC2p6/LJAowxQHbuQIsjpHW1VZEuo7eKtnEK3MHhwoXspACSNMxVpsWBP
         qUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1HmzOHeO+HRpIjBM95vy/qqGNJoa4vZPLdaJZ/DoRpA=;
        b=C0CeaGGu1ej/QkeTQCpHvV2C6XUzE94KFYn3vosevSrE99o7/fV3XcGD5qXClR2GoC
         7PFeU4+tPWYloMieLnLPaPWZvgsSo0ZfQpPddx54+O3P7d990qp//vKleR6fEVOH05H3
         GXqr9buEUwB1QlOiRFUvD2jWkIdxvnDlQ71BkGw21Dm2gvoupBJnVGRpKRLzLcipGrhJ
         MFhg33vWk33IaHrx5KlDyv1eXskZoDIngXGepj+Gp1RxitQ5R8oUZjhfvGxDRia9lHa4
         PingwCbKTAPqoon1Mc/yHpnwFDDcvjTOn9za/O/nouc7MXd9uXQtMqiisYe86rkZi7OB
         pB6g==
X-Gm-Message-State: ANhLgQ08vApCX7YaNsv8SaAe/ZMcE6NVKdUgNed2f7/tYoTycWPCV/bO
        OWtHCDOJgZ7Ss1rs2UmBMtr0d59xlJBmMstOTqmfMQ==
X-Google-Smtp-Source: ADFU+vvNyMExf0IJEXBPI+NKwmfuZCT3vkDoT2RS+Gvogw0gj2xqD0bwee63UP2nZGymQY4ZgHKxTMQiI4A3qSBfD+k=
X-Received: by 2002:a2e:8885:: with SMTP id k5mr9159232lji.123.1584814741294;
 Sat, 21 Mar 2020 11:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200319123919.441695203@linuxfoundation.org> <CA+G9fYvLC7xBuULxhG9yRi+EbUqmQjnS0X+0j-vGpX6XPVskOg@mail.gmail.com>
 <20200320071256.GA308547@kroah.com>
In-Reply-To: <20200320071256.GA308547@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 21 Mar 2020 23:48:50 +0530
Message-ID: <CA+G9fYsd9nfwiYyuSh0C6JiAg8b-fhg2-MbbC=VuAPKoFcQs0g@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/60] 5.4.27-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Mar 2020 at 12:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 20, 2020 at 03:29:47AM +0530, Naresh Kamboju wrote:
> > hugemmap05.c:89: BROK: mmap((nil),402653184,3,1,6,0) failed: ENOMEM (12)
> > tst_safe_sysv_ipc.c:99: BROK: hugemmap05.c:85: shmget(218431587,
> > 402653184, b80) failed: ENOMEM (12)
> >
> > Running with 50*40 (== 2000) tasks.
> > fork() (error: Resource temporarily unavailable)
> > Running with 20*40 (== 800) tasks.
> > pthread_create failed: Resource temporarily unavailable (11)

On 5.4.27-rc3 the above report problem not reproduced.
I have re-tested multiple times to confirm this.

- Naresh
