Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347756880D5
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 15:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjBBO7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 09:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjBBO7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 09:59:45 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4118B2704
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 06:59:43 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id d66so2084823vsd.9
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 06:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+oLCarSnbWm9l30IqXlSlJbB/Sspgw6Lli8fZQqOL3w=;
        b=lR42T0OOHxZom/O2kIv5W9S/umO0DLaJuzIMSW1lHstX3IXJQKC4aY2Cdx7zkx1DyH
         z/7Y7tLkZWBAHncNZcx0qJ0qd/+8PhEcBVTXgg691A7migWn0lvZiAw+WoS43M9yYAOF
         pKgvsnCxdzXNJQZaeHx61h3hwrKL+kgcW0ylndtg2+iHNlQcgfQS7EZ1O9rKyuP+yl60
         gYyNyfL3b7TMRhr7wJ5qIJH6uMrPkYwLGXEiu2UGAl3uDqHCHHJBK5nRqUFkSuPXQFmP
         a6WEJ+6uz2xEjAdnYbRTViz88rdB1pDnEQYM8pAoVRPvA27pryAGHnM7j7PgkgmG7GZB
         /CSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+oLCarSnbWm9l30IqXlSlJbB/Sspgw6Lli8fZQqOL3w=;
        b=3N7zNslQwtxayFH0Ws8JGhQhemRvAsc10d1q6WdPh/qrZtyZUr6qNn8VFS7+W7v91B
         2g9OyYScLJb5OlbbyBdGrvqtlDTW9pvSm974TI0H+fbcol0PTviqvZeR9fuVws/zhTnn
         JsD+qUDQ1V6Fpdzj64S2n8PGe3LJbK4PYFcjuV2/zdmkaF0vUZUNKfgE4vJeLs4IOIdL
         pm3wHA4/60pCtauUHZGySRt4gr+1UMOawSj4oc0eWWvciPWxE2SH5gFugDOfMEMl+eGM
         YnWGtuDSWepKo/eqcYSocl2zrmPH2fmLQEUgq7l4A4LNzkPQ+AUlmxZjm8/S2yd0V4z5
         ivIA==
X-Gm-Message-State: AO0yUKUmQUhyU4CqvmYDwpY3aTuJ+U+PO3H288sZnWVrk1LywOn/oHcR
        5qoQXpDDKOC/k+c52ItmrZ1PrUeo+6RiUQu0sNBOBA==
X-Google-Smtp-Source: AK7set/1VTblN/hGaphDW8ItFDqXbRBBkClqYBuZ91ZzszVwUlVtqXARv4RqxlDHHu+pSqXWJ80Yrhc7dPyfKyi7MUk=
X-Received: by 2002:a05:6102:3ce:b0:3f0:f82a:1f8c with SMTP id
 n14-20020a05610203ce00b003f0f82a1f8cmr970844vsq.74.1675349982148; Thu, 02 Feb
 2023 06:59:42 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com>
 <Y9B4/pR5t2o51coY@monkey>
In-Reply-To: <Y9B4/pR5t2o51coY@monkey>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Feb 2023 20:29:31 +0530
Message-ID: <CA+G9fYvC7RfM7Q+=S8N7dw9A88oa=HFyoDjz4=drSjBwXYYnLQ@mail.gmail.com>
Subject: Re: selftests: memfd: run_hugetlbfs_test.sh - invalid opcode: 0000
 [#1] PREEMPT SMP
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Jeff Xu <jeffxu@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pranith Kumar <bobby.prani@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000009008a505f3b8d0e1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000009008a505f3b8d0e1
Content-Type: text/plain; charset="UTF-8"

[Resending because logs.txt attachment was not successful ]
Hi Mike,

On Wed, 25 Jan 2023 at 06:04, Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 01/05/23 15:14, Naresh Kamboju wrote:
> > While running selftests: memfd: run_hugetlbfs_test.sh on qemu_i386 and i386 the
> > following invalid opcode was noticed on stable-rc 6.1 and  6.0.
> >
> > This is always reproducible on stable-rc 6.1 and  6.0 with qemu_i386 and i386.
> > Build, config and test log details provided in the below links [1].
>
> Hello Naresh,
>
> I have tried to create this issue a few times without success.  Since I
> do not have i386 HW, I am using qemu_i386.  If I use the supplied config,
> my kernel does not boot.  I then try to modify config options which I
> think are not relevant.  By the time I get to a config that will boot, I
> can not recreate the issue. :(
>
> Just curious if you have any suggestions?  Or, Wondering if anyone else has
> suggestions on how to proceed?

Please install tuxmake and run attached script to reproduce reported issues,
$ pip3 install tuxmake
$ ./memfd-crash-test-qemu-i386.sh

This script downloads kernel Image and rootfs and runs run_hugetlbfs_test.sh.
If you have any questions please get back to me.

ref:
https://tuxsuite.com/

> --
> Mike Kravetz

--0000000000009008a505f3b8d0e1
Content-Type: application/x-shellscript; 
	name="memfd-crash-test-qemu-i386.sh"
Content-Disposition: attachment; filename="memfd-crash-test-qemu-i386.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_ldn82ilt0>
X-Attachment-Id: f_ldn82ilt0

dHV4cnVuIC0tcnVudGltZSBwb2RtYW4gLS1kZXZpY2UgcWVtdS1pMzg2IC0ta2VybmVsIGh0dHBz
Oi8vc3RvcmFnZS50dXhzdWl0ZS5jb20vcHVibGljL2xpbmFyby9sa2Z0L2J1aWxkcy8ySnJ6dlpj
MjIzcGN0bEF4VmhDSWViSjhxMHcvYnpJbWFnZSAtLW1vZHVsZXMgaHR0cHM6Ly9zdG9yYWdlLnR1
eHN1aXRlLmNvbS9wdWJsaWMvbGluYXJvL2xrZnQvYnVpbGRzLzJKcnp2WmMyMjNwY3RsQXhWaENJ
ZWJKOHEwdy9tb2R1bGVzLnRhci54eiAtLXJvb3RmcyBodHRwczovL3N0b3JhZ2UudHV4Ym9vdC5j
b20vZGViaWFuL2Jvb2t3b3JtL2kzODYvcm9vdGZzLmV4dDQueHogLS1wYXJhbWV0ZXJzIFNLSVBG
SUxFPXNraXBmaWxlLWxrZnQueWFtbCAtLXNhdmUtb3V0cHV0IC0tbG9nLWZpbGUgLSAtLWJvb3Qt
YXJncyBydyAtLW92ZXJsYXkgaHR0cHM6Ly9zdG9yYWdlLnR1eHN1aXRlLmNvbS9wdWJsaWMvbGlu
YXJvL2xrZnQvYnVpbGRzLzJKcnp2WmMyMjNwY3RsQXhWaENJZWJKOHEwdy9rc2VsZnRlc3QudGFy
Lnh6IC0tICdjZCAvbWVtZmQgJiYgLi9ydW5faHVnZXRsYmZzX3Rlc3Quc2gnCgo=
--0000000000009008a505f3b8d0e1--
