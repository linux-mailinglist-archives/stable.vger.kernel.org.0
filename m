Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B8646F76B
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 00:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhLIXcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 18:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbhLIXcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 18:32:10 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA98C0617A1
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 15:28:36 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id o1so13850519uap.4
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 15:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:mime-version:thread-index:date:message-id:subject:to:cc;
        bh=24NtrL3MdPFPrJ6l179KYlz7jTY9gQDdfPacUGs5k5M=;
        b=ICUD+qx6uiwvVphwyN/l9etCL707NEzdcjcLUrWjIWC3Fpx8nwmakBWksGjAhHeuDi
         4pSpixAp9BhOBqGPEbM7UsHEmMwkQ6bBSVwFHUbZCAtLWsV86YKMNxvT46lzIGrSC8p4
         bLqYUgrcH9LfluF7ZPUVTmYxmoMG5VPwoP0xA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:mime-version:thread-index:date:message-id
         :subject:to:cc;
        bh=24NtrL3MdPFPrJ6l179KYlz7jTY9gQDdfPacUGs5k5M=;
        b=HhyZhNd9qC+3nNcheA9m2grnsHwA9OVFB/VuYpyoSupVyD841XkFYdZZnh6HTPW9Ov
         U60mJqVldGBv9Y6bM9q1RFdR2Hdcfm39bJs25jtA0wdRWL3kOgPvArJcBXX3+Xj5TYL2
         ve1ZMzR6ObijRSVWao56iJE2zFUty7q/0HjBwZOJHgNlTClHhM2Hf0BXDeXoutznrjcr
         B++xYPBam2ORFquDGKmy5Qtk5ckPCIT7BU8BCF9KiEZLeupp0Dn44zle9o9EOhK6wymL
         wD3yQzttlf8Jw8LDbuhnUFnkWulClKGiAE+eEVFWWDEaS3gHeA/aWVdcQBoQ46it0ImH
         r0dQ==
X-Gm-Message-State: AOAM533BpRl8uAsb9fHfIqPmGG15bXkbDgDYKGy2nl4JXfT2XlZv9X1z
        FnFIYavtX8gM50TmK258GC2VxjqRj8u6v1BSzjD8QVmZvmuH2zXydPJzBrj4imLzHkSkt3bwS2C
        AX7wUDUQNVNnicg1FE+OntIL11DFf
X-Google-Smtp-Source: ABdhPJzlOH72fg9KuXeXSyeilyFnAO0qWsPUXuQ8HgWi55AdsXmwdjeH8/ORlSqiygr5T5V85rrkH3mUhJY7iOP1Px0=
X-Received: by 2002:a05:6102:2084:: with SMTP id h4mr11310544vsr.87.1639092514721;
 Thu, 09 Dec 2021 15:28:34 -0800 (PST)
From:   Alex Komrakov <alexander.komrakov@broadcom.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdftVB9mMprT/7ByRC+0IgAlowfbSQ==
Date:   Thu, 9 Dec 2021 15:28:32 -0800
Message-ID: <70960a71e92f34bfa0d0f3cd82fb289d@mail.gmail.com>
Subject: [PATCH 1/1] Calculate the monotonic clock from the timespec clock to
 genereate pps PPS elapsed realtime event value and stores the result into /sys/class/pps/pps0/assert_elapsed.
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Hoi Kim <hoi.kim@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001f17df05d2bef7b1"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000001f17df05d2bef7b1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi=C2=A0 ,

I created the PPS patch and it was sent PPS maintainer Rodolfo and to
mailto:linux@vger.kernel.org to include these changes into official ML
kernel for
Google.

Here are PPS patch and cover letter in the following locations:
=C2=A0- [PATCH 1/1] Calculate the monotonic clock from the timespec clock
=C2=A0 =C2=A0 https://lkml.org/lkml/2021/11/17/1247
=C2=A0- [New] [PATCH 1/1] Calculate the monotonic clock from the timespec c=
lock
=C2=A0 =C2=A0 https://lkml.org/lkml/2021/11/17/1246

=C2=A0Rodolfo's Ack for inclusion is below.

=C2=A0Can you check the PPS patch on your side=C2=A0 because we need to hav=
e
inclusion
into official ML kernel and share the commit id with Google.

=C2=A0Thanks,
--Alex

-----Original Message-----
From: Rodolfo Giometti [mailto:mailto:giometti@enneenne.com]
Sent: Friday, November 26, 2021 2:53 AM
To: Alex Komrakov <mailto:alexander.komrakov@broadcom.com>
Cc: Hoi Kim <mailto:hoi.kim@broadcom.com>
Subject: Re: [PATCH 1/1] Calculate the monotonic clock from the timespec
clock to genereate pps PPS elapsed realtime event value and stores the
result into /sys/class/pps/pps0/assert_elapsed.

On 26/11/21 11:26, Alex Komrakov wrote:
> Hi Rodolfo,
>
> Please give me a response about last my steps about sending
>=C2=A0 mailto:linux@vger.kernel.org <mailto:mailto:linux@vger.kernel.org>.
> Does patch is ready for official ML kernel?

Acked.

Sorry for the delay... ^__^"

Ciao,

Rodolfo

--
GNU/Linux Solutions=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 e-mail: mailto:giometti@enneenne.com
Linux Device Driver=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mailto:giometti@linux.it
Embedded Systems=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0phone:=C2=A0 +39 349 2432127
UNIX programming=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0skype:=C2=A0 rodolfo.giometti

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--0000000000001f17df05d2bef7b1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVkwggRBoAMCAQICDHYIL0hy7FtCa0iawzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNDMzNTVaFw0yMjA5MDEwNzU5MzNaMIGV
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFjAUBgNVBAMTDUFsZXggS29tcmFrb3YxLjAsBgkqhkiG9w0B
CQEWH2FsZXhhbmRlci5rb21yYWtvdkBicm9hZGNvbS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQC9plVHzugCEzdkg+8eZF4DLPZ5fqspSSVbjMcgMDJQcAR76/SGGJnSJiHOj/rn
okK4r4HXW8cTMmw/ePqLs+eX7+h2TlrLFdwnPs6ThKSnKe7aNihCrk9rF+WyTTX/VrqyKPYICkp0
/XhRuIlIO0cP979rZRsxD4LKmC6x1msVkkM7JxkWhkktTzQwowAemtij6uzfYeh5BzQd2+LaWp8g
ZX2NhNnwh9gNMFxHdE5c6+G3LG7AHwFOPA6G1TuzZ35urQXh4HWGbGoCJPszKLgccfOBBHYaXyo6
yiBn77ZVlo89La3IlKW/J8Bg1ZiYHcR6RtGGylxCCKgFDdESfV03AgMBAAGjggHgMIIB3DAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCoGA1UdEQQjMCGBH2FsZXhhbmRlci5rb21yYWtvdkBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYI
KwYBBQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFElfe2CJ
evQgM+vs7qmUiI/AGUBAMA0GCSqGSIb3DQEBCwUAA4IBAQCmTMsF9VHjT0L2ycGjBg8eb/+aTBhL
U6r4e4vaGj/xmDd1cWfvz4brxodjpmuSnjfyWvU/odcNIepLv17Xc91OiZBWGYgr4jNViUqunvaH
DCnJlLbrD88ITE1uo7OCdlN/SS+Sskp2dDvL/Xlyorb+PaS7/AaIwEmuGyJv2uv1wQ+UZzPXXo1B
vOM4N+PxiEKCkmmYhfeSVye92Bta6vjf0b+oDE2JT82+D+9nAfiyJ9P/SRVTTvLlSzcO2fqX6GOc
37xY9F5HGjunD+cc5mqKM/r5PXyM/LEzWjdU1lVUVuvLRerUn+GNFgAPzpksTVYDv2kuseIFwRrF
845kQxaRMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBu
di1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIM
dggvSHLsW0JrSJrDMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCzP2QsacrpML0R
udPwt6txUzJnhRpml7L2EGYfiPrDQzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMTEyMDkyMzI4MzVaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEACU0MSHXAltLXFlmkpv9+SFMHdGeZbOm8
QqkcrYAL/X/4FEktan9dxyCQAOI3itS73UhIENRYce1zrmyIMd1m7O31V9mfiAY0q4wcBRSOudqG
3Bxs5diBbgfUGv8cAbN/K3cBTLE+7TSBBWn2/sngELMCqyAdpcoGN7jtPBI3qE10c2I0EmuE3gHH
ydM2fbnUJHO9V/c3sqTlxhR6zz1Ws7yJJgyfg6ys6AZxPbF99xAC2yXWcXYLesJuIt/WJUQBLVa+
I+7pKyMf1gnpTzRhvKeIIf2LKD6xhq+MII8CYmyPTC/F0ZP5QB/DjfzIRcmL5Lp4Zhh5Fh69nybh
JA++9g==
--0000000000001f17df05d2bef7b1--
