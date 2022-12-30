Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E256593F4
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 02:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiL3BCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 20:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiL3BCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 20:02:40 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6B1758F
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 17:02:39 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id e13so18324059ljn.0
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 17:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3iu66IXaYWbK0UFw1ZBZT29FpWCa6Vb+57KKmvLtbkM=;
        b=xCV9gXX503oKit//7hQNRIyYp/Ul+NBBup1ItzCa0hDX+cqQl+St2c6Q947j5h4XUE
         0toehrSNQwzYZo8ZZNDppqnEesPFt+WgUUgVnR1C93KVNaP/G2m8W+Mmwi+e4+4qt+vt
         Y+i25BXtYyab2qk6yubpOWo4MvSiOw6OCSiN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3iu66IXaYWbK0UFw1ZBZT29FpWCa6Vb+57KKmvLtbkM=;
        b=Ru7fBo7QruzMt5jqayAJlnyb6JRP8Dz27HrwtFvPTsL08k2IJpFsLcqmM7W3aN4Cbw
         xrRoNZM+AjsEg1tWoZoubHjA9ZOMwbwWeSqvg/7v/z19GXECgoh7B4Cp0lYxT1+9RCsD
         fxGdAdtF7cqvHmyGP8Ij8xXCcPsB+xq4k7olRslHI9SNKwlrTqFdyeAxiRQQhmngsxo8
         EpPZIsai6Se4JIbvEwG2MYRcjSN1DQ0fE4LzbYAM5fDEszqNAt1UXA6zobBB2Y7LmPnH
         nJc6hOfTWccCubv3g7xRr22PkYFdpuaUb7xOSiq6Z9N9gyqft/wMnyPmU3BJF04zKQ/Q
         L6eA==
X-Gm-Message-State: AFqh2krsK2wQ3jmJ/SmW+bjPyTXL5tgga5PHg2C2AY7Vc3f6c+29l7Wo
        LxhP8RzJH0bgnV+vUUyWOzX3XjUtnYdgyJBblpjyJ1mgxWsAFw==
X-Google-Smtp-Source: AMrXdXtTDPKgOoxiS3bsYrIi0oAEix+DZcAlAqrz8JRNbyAr8y7p6EmymmNnGK8ofvFZAzj6RHsoEkw7na7I6PUr4fo=
X-Received: by 2002:a2e:3c15:0:b0:27f:dca1:8584 with SMTP id
 j21-20020a2e3c15000000b0027fdca18584mr205922lja.313.1672362156936; Thu, 29
 Dec 2022 17:02:36 -0800 (PST)
MIME-Version: 1.0
References: <Y6z9ygSGmPNz5hfd@google.com> <FA3EA215-5F84-4CFF-BC32-4B9CB7643948@joelfernandes.org>
In-Reply-To: <FA3EA215-5F84-4CFF-BC32-4B9CB7643948@joelfernandes.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 30 Dec 2022 01:02:25 +0000
Message-ID: <CAEXW_YSBW-vfn6DzLY5vmCRRu6GJfVUFAT7vdj=ZPyDqz1U-3Q@mail.gmail.com>
Subject: Re: Please apply to v5.10 stable: 4d60b475f858 ("rcu: Prevent
 lockdep-RCU splats on lock acquisition/release")
To:     stable@vger.kernel.org
Cc:     paulmck@kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,WEIRD_PORT autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 29, 2022 at 4:10 PM Joel Fernandes <joel@joelfernandes.org> wro=
te:
>
>
>
> > On Dec 28, 2022, at 9:39 PM, Joel Fernandes <joel@joelfernandes.org> wr=
ote:
> >
> > =EF=BB=BFHello,
> > Please apply to v5.10 stable: 4d60b475f858 ("rcu: Prevent lockdep-RCU s=
plats
> > on lock acquisition/release"). The patch made it in v5.11
> >
> > Without it, I get the follow splat on TREE05 rcutorture testing:
> >
> > [    1.253678] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.162-rc1+ =
#6
> > [    1.253678] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 1.15.0-1 04/01/2014
> > [    1.253678] Call Trace:
> > [    1.253678]
> > [    1.253678] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [    1.253678] WARNING: suspicious RCU usage
> > [    1.253678] 5.10.162-rc1+ #6 Not tainted
> > [    1.253678] -----------------------------
> > [    1.253678] kernel/kprobes.c:300 RCU-list traversed in non-reader se=
ction!!
> >
> > I tested with the patch and the warning is gone.
>
> Please hold off on this particular one. After a 12 hour test, I am seeing=
 some new warnings. Will update the thread after some more debug.
>

Weirdly enough, the warning seems to be a false-positive from the
rcutorture scripts:

WARNING: Assertion failure in
/root/.jenkins/workspace/rcutorture_stable_linux-5.10.y@2/tools/testing/sel=
ftests/rcutorture/res/2022.12.29-02.23.56/TREE05/console.log
TREE05
WARNING: Summary:

But opening the console.log shows a normal flow followed by SUCCESS
message from the rcutorture kernel module.
Also "Summary:" is supposed to provide more information.

Here are some logs:
1. http://box.joelfernandes.org:9080/job/rcutorture_stable/job/linux-5.10.y=
/10/console
   (Scroll to the end)
2. http://box.joelfernandes.org:9080/job/rcutorture_stable/job/linux-5.10.y=
/10/artifact/tools/testing/selftests/rcutorture/res/2022.12.29-02.23.56/RUD=
E01/console.log

So this is probably something wrong with my setup, say something
interfered with the test. Or, there is something weird with the
scripts.

Anyway, re-running it with this patch overnight again!

 - Joel
