Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329C0573F9D
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 00:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiGMWbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 18:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGMWbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 18:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FF93AB1B;
        Wed, 13 Jul 2022 15:31:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 690AB61656;
        Wed, 13 Jul 2022 22:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE77C34114;
        Wed, 13 Jul 2022 22:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657751480;
        bh=Sf1OMFXsAQduC+bZithDp1ZWH16RSF+4UWMH4iSsQ+M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UHmDmw6lYXt1tWlaPBHrZHARY7UlFMsToN0up67K+MUegdx5pmJvYFw6h+BraN1Ap
         w1I30OqxVSQ8phSm1lhs/cNNhYghaZyRh3dL/jh9ktfmbX4xjhHgI75VJpwTfYu39M
         a0FI40CaGd2BOpm8CZEWpfRspssuVtoY+TVFuAM5EwtY8UyKG7G4LqJ3tVFH2m8Xqy
         3sOwkEA95azqcGWHLaWz6LEjONI6jdRblhQ6qoRk2eVXwIS1AuMdjiCEskpQe4tJGQ
         ZJcHsCyUditclh2DRd+X3n8L2gSrm4jYVmAWl6bylT0h5d6oS+SqPklrXaZFmYvaSZ
         VSn9yE1sT7Usw==
Message-ID: <d76cd438d325e874ededc4f58818f7edae6edd68.camel@kernel.org>
Subject: Re: [linux-stable-rc:linux-5.10.y 7114/7120] arch/x86/kernel/kvm.o:
 warning: objtool: __raw_callee_save___kvm_vcpu_is_preempted()+0x12: 'naked'
 return found in RETHUNK build
From:   Ben Hutchings <bwh@kernel.org>
To:     kernel test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable <stable@vger.kernel.org>
Date:   Thu, 14 Jul 2022 00:31:03 +0200
In-Reply-To: <202207130605.fX0cfbtW-lkp@intel.com>
References: <202207130605.fX0cfbtW-lkp@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-SFGnytdOQK4HdBVcrC3P"
User-Agent: Evolution 3.44.2-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-SFGnytdOQK4HdBVcrC3P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-07-13 at 06:39 +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> head:   53b881e19526bcc3e51d9668cab955c80dcf584c
> commit: 892f1f2b8631df5bdd0baba6e1ee3fa6eff396d0 [7114/7120] x86/retbleed=
: Add fine grained Kconfig knobs
> config: x86_64-rhel-8.3-syz (https://download.01.org/0day-ci/archive/2022=
0713/202207130605.fX0cfbtW-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce (this is a W=3D1 build):
>         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git/commit/?id=3D892f1f2b8631df5bdd0baba6e1ee3fa6eff396d0
>         git remote add linux-stable-rc https://git.kernel.org/pub/scm/lin=
ux/kernel/git/stable/linux-stable-rc.git
>         git fetch --no-tags linux-stable-rc linux-5.10.y
>         git checkout 892f1f2b8631df5bdd0baba6e1ee3fa6eff396d0
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=3D1 O=3Dbuild_dir ARCH=3Dx86_64 SHELL=3D/bin/bash arch/x86=
/
>=20
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> > > arch/x86/kernel/kvm.o: warning: objtool: __raw_callee_save___kvm_vcpu=
_is_preempted()+0x12: 'naked' return found in RETHUNK build
>=20

5.10-stable will need this fix that was already included in 5.15-
stable:

commit edbaf6e5e93acda96aae23ba134ef3c1466da3b5
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu Jun 30 12:19:47 2022 +0200
=20
    x86, kvm: use proper ASM macros for kvm_vcpu_is_preempted

Ben.


--=-SFGnytdOQK4HdBVcrC3P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmLPR6cACgkQ57/I7JWG
EQkvCxAA0etN0Vi6Coxs8ZetT/0sv42kHGry0UFhZtG8QWh7igkqssEJMWOtld1q
sRQtuKxnYdvKjHRPcY217ICUPJQgKcip8/HW2HhIqwtUiGPhdfVBVZXWixrmFbkM
UhZNGjVYJ+tM6M8fibgkyoU0s6dqHlCH8I51QhyyU3EKFg0zrUhIVn3TYWgPigPG
KEITq97iPMYOHWDXNAvAGbg16/+9pXqDv4F4qROcBnaD3K9L8NGIUHdx4Ym1kIBP
hdX2yjEoQ3qzAnwRBdI0zaA6MsqN7FUlOKf3/Ksrq8AAwjdSdM+nawWEFMPy1R/4
+pCbVvXASL3SYrM2PM1MQXPY8TtdVskG9xLSGJ4kCfxTEniITw+w2mKNmQsStX5K
gENdJLE2mkxxlr0oYHY42tWuKQ193IJgyNP7Z3Udfe9lQZA6yfKXXN3zSuGGEpht
nhI2xUytTQGyiCNhBD/bttv0z6CvtOvGzs32L2m6QFslrbRc+wieW6ZZr0fSzOAc
c1Px2whOwV+SM5f0FovRYipSFOO8jh0ay1j7ZHklLyi1W95G/ViNc8HF8cCU0ckq
vq4OJQT4xiqfeInyIRzFwk5IWvN66ZA1O1qwytygDqhh482grgLmcdeijmK81FMw
f4pBntO1wrLS01N+sQXk1GvEjXnhT7eQkgqvbEPRKfnIDzCe2Zk=
=yrmk
-----END PGP SIGNATURE-----

--=-SFGnytdOQK4HdBVcrC3P--
