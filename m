Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC91188E5
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 13:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfLJMwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 07:52:39 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45595 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfLJMwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 07:52:38 -0500
Received: by mail-lf1-f68.google.com with SMTP id 203so13569090lfa.12;
        Tue, 10 Dec 2019 04:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=11UaFwrHfBxR4VmejSkI+P2hNy7cLkOsHvj3YmzzITk=;
        b=S5C/VJJScB2LEJiC/XQgc5RPmVOlqTmdOnlt+WltPzuZAZ3r/SuxvI795SLmvWcd2S
         wVkYoCQbWhfdt2gfaV92jSUIleizBDO0d00Fn76BO80nIxNnYKY0wV+mZWvb5o09sdCn
         EShU3YyP/ttbe4DAVTgx47RLl+cB9WZVjYI111I9NYdKoRRXwNeAuKKo6Y8JbGMITxh9
         +1tFjziK5J33mHefo4XzxtnRLTZcJreIvXh7X6dzxL9TawFNceY4nDY5/Zmy8P9T58Rh
         m/COqz/vCRuNiGS7Fi52+SJ5Y8sTxPt0M9w4mdGLyhojz3v50N5K1k09Rglr9BboVrHV
         Gbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=11UaFwrHfBxR4VmejSkI+P2hNy7cLkOsHvj3YmzzITk=;
        b=oQA4oYeR+xnSyxxwviQ/Bx1Q/kehMd9ZaArpkT26gOe1jZJmFZOOt4uXIr8NT5Qv2N
         y06tzoGpVDeI+bWNJ38CJMgJ1hy0k/O9cbHB51VHw63C2H8T0N5fpD+zAlvQ1aavCRN0
         FXJiWzwIi4SCtVrElL+dX7qC1NnxlSF8AK9t/8Cm98lqIxBHb2MgI5p3hQpOl61PKkAh
         2LDjJVdn0Uc3Tb0hZr96Jo4KxtYy0+5fbHY6NEG0LqG0y/p6c/hnSXgO9oiL//5rGsJo
         QjN/HpB+hRD0wraNZ3ioWSsg5OKnGP+DjlAG8Vqfak8TMohqajqVQ0FNOm8eWksXdJcY
         Mfzg==
X-Gm-Message-State: APjAAAUvPqoYzND2WT5/YsKE6W4gnjmliOPJUGpXgRCaQsqMbH46d1NW
        4+hdNhncORcsEY68Swj48R3pbFpx3r/gBw==
X-Google-Smtp-Source: APXvYqzzI+4OeMeScvMefnCEK2izwgK4Om0C9FFpINZSG4PKKLUvQb0UDx1j2JXPTDNuBMOv4v3kiw==
X-Received: by 2002:ac2:5503:: with SMTP id j3mr3846606lfk.104.1575982356327;
        Tue, 10 Dec 2019 04:52:36 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id b14sm1497204lff.68.2019.12.10.04.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 04:52:35 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
In-Reply-To: <f8af9e4b892a8d005f0ae3d42401fee532f44a27.1574938826.git.hminas@synopsys.com>
References: <f8af9e4b892a8d005f0ae3d42401fee532f44a27.1574938826.git.hminas@synopsys.com>
Date:   Tue, 10 Dec 2019 14:53:23 +0200
Message-ID: <8736dsl4u4.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com> writes:

> SET/CLEAR_FEATURE for Remote Wakeup allowance not handled correctly.
> GET_STATUS handling provided not correct data on DATA Stage.
> Issue seen when gadget's dr_mode set to "otg" mode and connected
> to MacOS.
> Both are fixed and tested using USBCV Ch.9 tests.
>
> Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>

do you want to add a Fixes tag here?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl3vlUMACgkQzL64meEa
mQYByw/9HWPfvaKdOzHIfsGeER+5WTWkVsu78JVr7uxZ9yqO3kEBpf+ZdDDDNWVi
1X5pHUQ+7shHjh9acj6oViLAtC/CVWXTjn1s7xVSQ8mOg6AqTM16Av/hGw7JhoNF
ceUOahRIl5XerPntLQgmEDDDV+HO3GDwStnxpnnku6XDc8LPBGObJc7C924g1kaJ
uomMzXNL4T3YEbsMHzLu/804tDgqQ/TQ7URhVmwmsSLtRj+z3TzJl95U4DxzN2Qi
Kq+M3Zn5jZqPAaKlDTrOthIwTDhzkLehzjzJFc/KX9hIgt43czBiwmbwNxKhSmwq
RucDRfqqMIPPgOXLmrmrTmE5EoWHBJtfsjTaRMkst6oJCHfqLbV8Ri2+m5ZubdDm
D8/xj6huukqGTqPoJn5oFEkghqidKl+nPbFdC+75rwm63SQE5O0etGehkT/gZJG1
wP2Dgadj5bExPVMbyui9aHtDITUrCsN84Z1y8iRw9BLavUnb8XgUj6jkC+bc86Ha
qUrEdKPa2qt5Sl75xqjrXdB4DuKOH3xNJIDZkSqaluF2VIx1jJipFOYMywSddrFf
gtH24FFk6y9ZqumJprFBe6x5IZvxkfvNFWKjltWuxETvqpyUwOQ/Se48dG63CEnJ
FYMa/BbezrG3LjKGvjDSU6lDo8BfAL88qkqp2O6S5+qphMlLfew=
=6wKo
-----END PGP SIGNATURE-----
--=-=-=--
