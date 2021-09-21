Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B434F41333D
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 14:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhIUMOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 08:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhIUMOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 08:14:30 -0400
X-Greylist: delayed 520 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Sep 2021 05:13:02 PDT
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:c0c:51f3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BA7C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 05:13:01 -0700 (PDT)
Message-ID: <f759ec8e-cfcc-7f78-65c5-97ecc24aad17@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
        t=1632225857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=y/RMUVww3E23wLCQ6uat2Gai3dynOvQ+NyG24qMEVMo=;
        b=oCYDdtvDaXnKzV/barq2mWo9bgX3AHfLVLw+uaZ+mloRV0uHF2iQLokW1zPOWozif25joC
        i8Duy7oK7+YJQoJ0mUL79sm2pyl/t1Vgf1cAJ6LW1t0w5vxdHJSJ4CXcq+ldFhoGYYPArr
        mQc0gFSYNCmvT3tBKVkYePwhMZPgY6OUoK90G9OtYfWC/TkSUNdYRD3sdQxpNl/eJ0vp7K
        lgGCqDkAagwtdpVg26vsmkkkxhN/MjMTZF26QK+T2IVEGX5IssoLOizCQyt7D1tlOGfVUe
        rXMopA4cRfrLB4Z4oXDH3OUQ9uS/p79ZkrUEXlcGrYQkbx04+y88n10Ym0CWPA==
Date:   Tue, 21 Sep 2021 14:02:20 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Subject: 5.13,5.14 | ath11k/mhi regression: Wifi stops working
Organization: Manjaro Community
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------q0I8VvkzVtU9AdArZxoO0IE8"
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=philm@manjaro.org smtp.mailfrom=philm@manjaro.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------q0I8VvkzVtU9AdArZxoO0IE8
Content-Type: multipart/mixed; boundary="------------wHVqF5XjnMdLX5k7hPK30xlR";
 protected-headers="v1"
From: =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <f759ec8e-cfcc-7f78-65c5-97ecc24aad17@manjaro.org>
Subject: 5.13,5.14 | ath11k/mhi regression: Wifi stops working

--------------wHVqF5XjnMdLX5k7hPK30xlR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgU2FzaGEsIGhpIEdyZWcsDQoNCm1heSB5b3UgZ3V5cyB0YWtlIGEgbG9vayBhdCB0aGlz
Pw0KDQpodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNDQ1
NQ0KDQotLSANCkJlc3QsIFBoaWxpcA0K

--------------wHVqF5XjnMdLX5k7hPK30xlR--

--------------q0I8VvkzVtU9AdArZxoO0IE8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEE5M3+UKLahdWMioxwyqallhHH8H4FAmFJycwFAwAAAAAACgkQyqallhHH8H6F
WAf/QWuoiJJ8mBeBvYx6mYLraSR16jhtfkAkfqGvWrRrepKBLVAyQOJLMqZGtX7dcV/NmfjmrPS0
7WZlv5JrmkTbgp5sL66hGJI5oB8ZR0foCBNyhKu28jWvdDgG6pkIKNae0NW+jVUVmU38x3qRC59e
kjjJZEVjawlAATpu3JG3BGuYnMCWnyDFCKGeb8vxUME4fqvijjwBX+mzTDLiRUvcX3cY4/dSX5mR
Fm76BJOhzVh7Jm7IWxDQ/+kggyNXRWPepSQU027WBSJluxuL8OxP19GLKNDGzQH+DdPUltGJqMUM
fzLYHkg+L9iQZTC/I9fHo66wdny/gl6ObfoY7YtAwg==
=UVZY
-----END PGP SIGNATURE-----

--------------q0I8VvkzVtU9AdArZxoO0IE8--
