Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489B46C282D
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 03:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCUCbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 22:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCUCbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 22:31:01 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C06836087
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:30:59 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id e19so12249666vsu.4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679365858;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e1g+y4vwchmoHb1LwcoQF8dkuFlTZyQwIn7TEQTepo4=;
        b=ltxu4bDvD7ybBPQAtJcmLAd0AjM25wA8x9dyWZOKY+Kgcxw29C6ecPoXkfWNyQ5GNO
         J3HS2qtpOF8Rfz5pElFKB0NggIDvWCQRV6vNE3KTPsDyGSPzpS2CWQnRqpHiyQNd1Ugy
         mFGFdk87zORhovlFddQYQ+FcLVYJvBmgrMBy9Py09J9fulEgaSQwFZLQcXKVjY23p7tX
         T+hzg/lYhmhUDDBldrDmwybyoIPCm0N3liFrdvPB3smWKusJwZf3jlkFZoiwcwOE4uxC
         ciqLI6KOEVMr1PC9TY4GQvZmqGO7/ohWl3Fo+maSNBnRQTs7P0eKIDA0EPQw9MX8KBrF
         7X6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679365858;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1g+y4vwchmoHb1LwcoQF8dkuFlTZyQwIn7TEQTepo4=;
        b=v1cCmxYiJ+l5Ae0bFzZZQKJD5syYokF8QFlHI1g9pJgd0xIbw/WtFHNBA1O754glPU
         ETtxvfyZs79VkFyWKbLVdYWEZt0I+ab2Y7230JprZlj7UbcAMIK2OSf9xnecDEA1dqHS
         Lnv0m0WIDWiVqL8Gq4kbE21t2bKoIVNiNQqjjVYGJ81JqhKRXpbBi1OSCJBzUli/Ptp/
         VUuYPIVQ3pEVi929I07be824QjcUkelAKmGJtu8HwirQVYBlGZwor4KK3HAw+ruQU8p5
         hZ3xg0GRSsZBiG/9SIVEVqx+UKPpxJhbs4oquZPBeT6vMdQKTFHN+dm0Vv4G3ICt/Dr6
         UlgA==
X-Gm-Message-State: AO0yUKWaWSZpRxG55X1bYBu37zu5mEIoq57oSXVIRojmTHkiQ1ly+/7E
        1004nD4eu1nVCpnf/PkCx/3T35nJ3zSe5Z4twotvOA==
X-Google-Smtp-Source: AK7set+sG6/8F+H20vXpFrS94fpodkjGDeoSNmfqlajPi/bTm+Yjhg6T3SJXGP104/FOjSRyjrbyJgzSEhh6fLe3txk=
X-Received: by 2002:a67:e086:0:b0:425:875f:50c6 with SMTP id
 f6-20020a67e086000000b00425875f50c6mr649582vsl.5.1679365858088; Mon, 20 Mar
 2023 19:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230314124435.471553-1-sashal@kernel.org> <20230314124435.471553-2-sashal@kernel.org>
 <ZBhPV61xAvXfjHw3@duo.ucw.cz>
In-Reply-To: <ZBhPV61xAvXfjHw3@duo.ucw.cz>
From:   David Gow <davidgow@google.com>
Date:   Tue, 21 Mar 2023 10:30:45 +0800
Message-ID: <CABVgOSnawZ3vKUy69qAQC81Ctfcqo9vo_5ot35+fHQs4OqytVA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 2/5] rust: arch/um: Disable FP/SIMD
 instruction to match x86
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        =?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>,
        Richard Weinberger <richard@nod.at>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000710b5905f75fd575"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000710b5905f75fd575
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Mar 2023 at 20:19, Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> > [ Upstream commit 8849818679478933dd1d9718741f4daa3f4e8b86 ]
> >
> > The kernel disables all SSE and similar FP/SIMD instructions on
> > x86-based architectures (partly because we shouldn't be using floats in
> > the kernel, and partly to avoid the need for stack alignment, see:
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383 )
> >
> > UML does not do the same thing, which isn't in itself a problem, but
> > does add to the list of differences between UML and "normal" x86 builds.
> >
> > In addition, there was a crash bug with LLVM < 15 / rustc < 1.65 when
> > building with SSE, so disabling it fixes rust builds with earlier
> > compiler versions, see:
> > https://github.com/Rust-for-Linux/linux/pull/881
>
> We don't have rust in 4.14, so cited problem can't hit us. This should
> not go to -stable.
>
> (Plus, KBUILD_RUSTFLAGS is not going to exist in -stable).
>


I agree, this is not a good fit for -stable. While I'd argue the
KBUILD_CFLAGS part is still technically valid:
- As noted, the KBUILD_RUSTFLAGS bit is useless without Rust support.
- It triggers a bug in older gcc versions (< 11), which is bad anyway,
and probably worse for -stable:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99652

There's a patch to work around the latter:
https://lore.kernel.org/linux-um/20230318041555.4192172-1-davidgow@google.com/

But I'd agree that excluding this change from -stable altogether is
the better option.

Cheers,
-- David

> Best regards,
>                                                                 Pavel
>
> > +# Disable SSE and other FP/SIMD instructions to match normal x86
> > +#
> > +KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
> > +KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
> > +
> >  ifeq ($(CONFIG_X86_32),y)
> >  START := 0x8048000
> >
>
> --
> People of Russia, stop Putin before his war on Ukraine escalates.

--000000000000710b5905f75fd575
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPnwYJKoZIhvcNAQcCoIIPkDCCD4wCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz5MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
64VRg2IjDI2fJVE9RD6aMEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQCMAAwgZoGCCsG
AQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9jYS9n
c2F0bGFzcjNzbWltZWNhMjAyMDBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3J0MB8GA1UdIwQYMBaAFHzMCmjXouse
LHIb0c1dlW+N+/JjMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20v
Y2EvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQA2lZLYRLu7foeR
cHo1VeNA974FZBiCm08Kd44/aCMEzdTJvxAE9xbUJf7hS1i6eW49qxuSp3/YLn6U7uatwAcmZcwp
Zma19ftf3LH+9Hvffk+X8fbPKe6uHkJhR2LktrhRzF159jj67NvXyGQv8J4n7UNeEVP0d5ByvRwv
tF2bJwlOwRGLoxasKSyDHIyUpwTfWYPq7XvjoGqQ/tDS7Khcc5WncJl0/ZEj7EKjtoGbsDbLdXEF
m/6vdcYKJzF9ghHewtV3YIU4RE3pEM4aCWWRtJwbExzeue6fI7RqURbNCAyQuSpWv0YQvzsX3ZX3
c1otrs50n1N0Sf8/rfJxq7sWMYICajCCAmYCAQEwaDBUMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
R2xvYmFsU2lnbiBudi1zYTEqMCgGA1UEAxMhR2xvYmFsU2lnbiBBdGxhcyBSMyBTTUlNRSBDQSAy
MDIwAhABxy1wm0tAmHKHFkLS9RWPMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCx
MxOUYJQg7uKCyQE14y/sHOxPC6P30Dmu+ZBSeWpCbjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMzAzMjEwMjMwNThaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsG
CSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEABU0d3j+NNBdlMenKSP+V
q0+xSpYw5aTy8n2vi63mRTs2rDIPcwziwapkbk6/eEjBvUp4AfMdodxO5/D3CNDEgk0cMOxyrMCU
yiIXW5Z2e9NfzE6OwjEdoKoO4TOX7ZNLR/1GYVguQooBULJ4rvn2YVO7IXfqRjy9FvRdJFnM8A+O
lKo0WWrRVDOvJQwyvgkgtom2GaJRMkzb9xowbRL+FeGqWrIjGrLPKw62JKW9PHsamSRtlvEyZZTS
ygCS/BAe2tMDz+7hBFldaAlrddWDcadJiMDCumJQkNppQNayE/SGyCp3d/KgSa38USwP8Z57Z/1Z
EgN2uvqcGQwOiIoDTA==
--000000000000710b5905f75fd575--
