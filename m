Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCB143AA3A
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 04:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhJZCW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 22:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbhJZCW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 22:22:56 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63902C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 19:20:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s136so12586204pgs.4
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 19:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject;
        bh=Pg48QTZx+jDkuJyy4SlzpgS/5+aNIwIhljDXd0iYy0U=;
        b=U58QeXmj6Ujqbwac3NBWc8sdQQOO1mekqYPTy4KmIzAy5ZkHcQ41F6kuG+ETqDtkOR
         MdiUInE3X2AFhAjSf4+8XFwOUaCuu2dZNT7jLIehD+dZmRuqRj3hbpKDOMDVi4J5IoNR
         awJMt5RQWVAyodnurUPI7A0SXWzI/fULSY6A2KIR/DlqKT0leyYcJJ17nyANmSr+YdQJ
         inNFzk0bjkv4aCpiptR6xZODRCzUHNuVAwv1ApH0F5kKUD/YOQLPRZT3dpGzuRKMVjCE
         aCrtL3K1GR8Pu1nfpJdzgqxqgi0hujwkwS9roO6Qt8x1viCLVs10mIIGWD14Fyo5HE05
         7aHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject;
        bh=Pg48QTZx+jDkuJyy4SlzpgS/5+aNIwIhljDXd0iYy0U=;
        b=OJogIRkL9gEEeiSOFSFh8n1WtGmRipDEzh5DZGxu24ZANqiCCA0E1E2v+wnPY9sqHM
         r3nUnR+DFjPJwLBXxLYM9+3Xz3uaqDAmmX0alKhdcGdLCEurcDylpTaRYGdgiN/jitjJ
         Yzdc4IFl3+wFY/eiTvCsEZGLXy+jOH+sHJ22TqJCgc7Z8qm5E6ILBuhUobB6k8VnQI6W
         nTZn+ruxkQgoDZ7p0ym7GNdCkOVcNFIadMnSMeAu4DfKj9boTdEkJ4SoHktv0ZtGCXrg
         Teid/5QHqSSgVf8WIc6XpK4cmXg7+CWuzvxFO8mTEumoCpWxByzjmpii8uclFxzJ9Mvw
         j3Wg==
X-Gm-Message-State: AOAM530lf2ZnV+HfrADf1UzVtJbDyFEQFYhwBVsU174jTM3/5vK+pOpH
        dduaZ86YwC5YRd6Q5g4zDXEHL6sN9jbO4dyC
X-Google-Smtp-Source: ABdhPJxzii12Gc0WudL6dtMfVMjwNZ9tphNfDhdRx7AdTDs0oVFwWiLBXBWqgjvFZtKHh0Ax+sJZAA==
X-Received: by 2002:a63:8c4f:: with SMTP id q15mr12032753pgn.225.1635214832476;
        Mon, 25 Oct 2021 19:20:32 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id b10sm21414719pfl.200.2021.10.25.19.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 19:20:31 -0700 (PDT)
Message-ID: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
Date:   Mon, 25 Oct 2021 19:20:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        tadeusz.struk@linaro.org
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH] usbnet: sanity check for maxpacket
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ACQFrAV0F2Ay6AutXGYsiHXE"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ACQFrAV0F2Ay6AutXGYsiHXE
Content-Type: multipart/mixed; boundary="------------DSYO6tPByGTicvDl35rL0HsI";
 protected-headers="v1"
From: Tadeusz Struk <tadeusz.struk@linaro.org>
To: stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
 tadeusz.struk@linaro.org
Message-ID: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
Subject: [PATCH] usbnet: sanity check for maxpacket

--------------DSYO6tPByGTicvDl35rL0HsI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQpVcHN0cmVhbSBjb21taXQgaWQ6IDM5NzQzMGI1MGEzNjNkOGI3YmRkYTAwNTIyMTIz
ZjgyZGY2YWRjNWUNCnNob3VsZCBiZSBhcHBsaWVkIGJlY2F1c2UgaXQgZml4ZXMgYW4gT29w
cyAoZGl2aWRlIGJ5IHplcm8pIHRoYXQgY2FuIGJlDQp0cmlnZ2VyZWQgZnJvbSB1c2VyIHNw
YWNlLiBTZWU6DQpodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/aWQ9MmViZjdl
NWViMzAzYWM5YTU5OGUwZGFiMmMwYzhiMDNlYWQ3YWJjZQ0KDQpJdCBzaG91bGQgYmUgYXBw
bGllZCB0byBzdGFibGUga2VybmVsczogNS4xNCwgNS4xMCwgNS40LCA0LjE5LCA0LjE0LCA0
LjksIDQuNA0KLS0gDQpUaGFua3MsDQpUYWRldXN6DQo=

--------------DSYO6tPByGTicvDl35rL0HsI--

--------------ACQFrAV0F2Ay6AutXGYsiHXE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEb3ghm5bfkfSeegvwo0472xuDAo4FAmF3Ze8FAwAAAAAACgkQo0472xuDAo5P
xhAAkuIQDohqVwFoKur8JrS47aC4XqB4ThmULwD7EYSA83b7RvUsl/8uJdswUvTF9dpHCY5X43T9
LBGMh+NoAjtBtOSN5nyzCioqQw57ZpBdo0ujm8k2S9mGQxYT4ho5LRQj3ndznc4fNgV7vUDy7XFv
9fS/VsYjTP8bkoqgm+akvcZwQIsQY5sW3iFpbL+UdTazy0twl7LCXOt0rTR+iC4Seo3AFoh20JG3
JDqV1IYCZQeVUW2JSFzcmL6AZk+uxxvrW7oD1T8g0BHMX236tDWubfJL3mWZGlJ3Je+z5yJT1str
LgvV3q071UVWYu13LZjmtaQ2QH0IlTngOfzoEkWd7WMIEdrQzQIKl7JvyzLNirzGGUhjag/3YQt2
eLR4CWMm6qoJoheQle04mVwLsIftO5N/yIGgqnElvT0jkchD8ze0qt/5/stywtzetJx5FMsOtVRy
8C2U9GOrTy53yiQMe1iYBtG1juZM5wkziHV0E2jL0svF0VJK5WVoL1hfp4xk2WWDRWKY7h8U34C7
S0sG6oCkm1WTr58PjfkDXMv9LecpXs+Ov/SgJjJsO/Ez6Hylo9Ih6+tLBauTrvp1/pKXKlO7hddW
M5zKDVYFIrD1kQeTzjCX0pbcPsgNEKuvH/Nm5ZZvTHao4Wu2jT9S7UaB3vTFL+2uwYV8AC745j5F
sTU=
=jnLk
-----END PGP SIGNATURE-----

--------------ACQFrAV0F2Ay6AutXGYsiHXE--
