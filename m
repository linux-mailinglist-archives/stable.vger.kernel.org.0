Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C03F50E97E
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244942AbiDYTc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 15:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiDYTc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 15:32:58 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6A0110971
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:29:53 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id e128so11581840qkd.7
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPdK3pMpu1M5+FJaU3vANrwWaBo+jJ5jFJcq67eIWd8=;
        b=OgQDK7dC5LiD+Eqp2e3hIIYjQGvd+OjXJDIMwsWLPJGKOSTFJTqfxzNatNE9Hz8ZCT
         jjOLjxnXw8SSen7einkq4Pc7Zk0y+k5Ne5Tq9QxUwr9zIFnmoRytF6kk7uzTDQq1o6Qd
         8CJeB87B85kZaJfHCra6AmBQqnZwMuBFpdxhONWJ6bcDUHxlD2g9HU7B/RvlBDsgrL8A
         XowEzDnHYJzFnnz4Ogi/+dCH1fjvm181HIrW6V2s/unx7wBgXCSESxdWyokvGGwCqc0/
         e3q0CpSgXW6wgdcrU+EY93yt6IPmI4uOOyQeTlaLBMcYeV9ed75lkUnfG82w0a18Zjm2
         fR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPdK3pMpu1M5+FJaU3vANrwWaBo+jJ5jFJcq67eIWd8=;
        b=wI4UtsbueAHcFC8NKt38BbCSfl1amST+iU0MnOdRjoos4JhQ15zOor0pS4IGt+WKmv
         k9JDsdiYbbGAGObke7OkNvFmDWnrJbUlipm3MHXgwYOnAi+mJ7RgzJ6gNP0QK9C4cm52
         UWAlCjdN9xdM5LUl1te+IXrLvwM0kMBBckxH2Qj8NF8sQ4Ig6LbahVHRN6m0NueAO4Ff
         cdH15wbM3BPkCmdOoHGiLkyrinZBv0LNMX+grUAPVbLuerfNCOPmvEUwbvnbkmx1riks
         IBuZlbqDqz2BTfpVW5M9bbjFdfcEbD928V9vFUtFZ09eBChjyLFvepfGxZvKk2NbjbF1
         OeAg==
X-Gm-Message-State: AOAM531qheo2ckJoQe5HV9Qjt9E97lU4pER1SmnCh0ueWN17jofVX5EN
        ecWepC/IAJfo+43nlFKkOT33qO0kdd5rITODjKtRHg==
X-Google-Smtp-Source: ABdhPJwCDZm+TKy8uxs72fwHi9FiWphzxXCRGdRaXzO7Cgt7jZw6sNEGRLWkqcbyX3UnZhG7P0YQdfjnxP3EDnFfV4w=
X-Received: by 2002:a37:f508:0:b0:69b:ed2f:e56 with SMTP id
 l8-20020a37f508000000b0069bed2f0e56mr11403434qkk.384.1650914992705; Mon, 25
 Apr 2022 12:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220419191239.588421-1-khazhy@google.com> <YmErsSY45MQu/Ks4@kroah.com>
In-Reply-To: <YmErsSY45MQu/Ks4@kroah.com>
From:   Khazhy Kumykov <khazhy@google.com>
Date:   Mon, 25 Apr 2022 12:29:41 -0700
Message-ID: <CACGdZYJR=pAjb2FMQEuGK2ucXKK4_zjwSgs5caTUv88_CrC4-A@mail.gmail.com>
Subject: Re: [PATCH] block/compat_ioctl: fix range check in BLKGETSIZE
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b9156805dd7f99e0"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000b9156805dd7f99e0
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 21, 2022 at 3:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 19, 2022 at 12:12:39PM -0700, Khazhismel Kumykov wrote:
> > [ Upstream commit ccf16413e520164eb718cf8b22a30438da80ff23 ]
> >
> > kernel ulong and compat_ulong_t may not be same width. Use type directly
> > to eliminate mismatches.
> >
> > This would result in truncation rather than EFBIG for 32bit mode for
> > large disks.
> >
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> > Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> > Link: https://lore.kernel.org/r/20220414224056.2875681-1-khazhy@google.com
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > [compat_ioctl is it's own file in 5.4-stable and earlier]
> > ---
> >
> > The original commit should apply to the newer stables
>
> It does not, it only applied to 5.17.y.
>
> Please provide working backports for all of the others.
>
> > this should apply
> > to all the older stables.
>
> I'll wait for the 5.10.y and 5.15.y backport first before applying this
> one.
I double checked and the above patch applied to 4.9-5.4 for me
>
> thanks,
>
> greg k-h

--000000000000b9156805dd7f99e0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPmwYJKoZIhvcNAQcCoIIPjDCCD4gCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz1MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
LmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5n
bG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG9w0BAQsFAAOCAQEANyYcO+9JZYyqQt41
TMwvFWAw3vLoLOQIfIn48/yea/ekOcParTb0mbhsvVSZ6sGn+txYAZb33wIb1f4wK4xQ7+RUYBfI
TuTPL7olF9hDpojC2F6Eu8nuEf1XD9qNI8zFd4kfjg4rb+AME0L81WaCL/WhP2kDCnRU4jm6TryB
CHhZqtxkIvXGPGHjwJJazJBnX5NayIce4fGuUEJ7HkuCthVZ3Rws0UyHSAXesT/0tXATND4mNr1X
El6adiSQy619ybVERnRi5aDe1PTwE+qNiotEEaeujz1a/+yYaaTY+k+qJcVxi7tbyQ0hi0UB3myM
A/z2HmGEwO8hx7hDjKmKbDCCA18wggJHoAMCAQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUA
MEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9vdCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWdu
MRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEg
MB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzAR
BgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4
Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0EXyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuu
l9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+JJ5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJ
pij2aTv2y8gokeWdimFXN6x0FNx04Druci8unPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh
6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTvriBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti
+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5NUPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEA
S0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigHM8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9u
bG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmUY/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaM
ld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88
q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcya5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/f
hO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/XzCCBNQwggO8oAMCAQICEAFEftjde/YEIFcjUXqh
cBUwDQYJKoZIhvcNAQELBQAwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjMgU01JTUUgQ0EgMjAyMDAeFw0yMjAzMTUw
MzQ4MTFaFw0yMjA5MTEwMzQ4MTFaMCIxIDAeBgkqhkiG9w0BCQEWEWtoYXpoeUBnb29nbGUuY29t
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnSc4QiMo3U8X7waRXSjbdBPbktNNtBqh
S/5u+fj/ZKSgI2yE4sLMwA/+mKwg/7sa7w5AfZHezcsNdoPtSg+Fdps/FlA7XruMWcjotJZkl0XU
Kx8oRkC5IzIs4yCPbKjJjPnLLB6kscJHeFsONw1dB1LD/I/mXWBMVULRshygEklce7NMMBEgMELQ
HA8prVkASBCQcTBI9b1/dCaMkqs1pbI1S+jMQDPTVqJ6yHssJtwELHTH1ObZwi2Cx3q60b0sXYS0
18OjY3VYaZUXTOSFP5PN/OmbGt2smYKKCLujb0wJm06bFotBaJhVw5xdMAfCD+2cPvmYXDCF+7ng
AYBCcQIDAQABo4IB0jCCAc4wHAYDVR0RBBUwE4ERa2hhemh5QGdvb2dsZS5jb20wDgYDVR0PAQH/
BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjAdBgNVHQ4EFgQU8bNUGSaYlhLY
h3dPtFviTyG11HYwTAYDVR0gBEUwQzBBBgkrBgEEAaAyASgwNDAyBggrBgEFBQcCARYmaHR0cHM6
Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDAYDVR0TAQH/BAIwADCBmgYIKwYBBQUH
AQEEgY0wgYowPgYIKwYBBQUHMAGGMmh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2NhL2dzYXRs
YXNyM3NtaW1lY2EyMDIwMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29t
L2NhY2VydC9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcnQwHwYDVR0jBBgwFoAUfMwKaNei6x4schvR
zV2Vb4378mMwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9jYS9n
c2F0bGFzcjNzbWltZWNhMjAyMC5jcmwwDQYJKoZIhvcNAQELBQADggEBAE0ANr7NUOqEcZce4KYP
SjzlrshSC8sgJ8dKDDbe35PL86vDuMIrytVjiV10p/YUofun9GeHBY6r5kTyh4be5FgftiiNtWzn
U1W5cxLYMT1hKYxXxnM2sWMQGFl4TkxxbRoVZa3ou/NxFdAZeiQSwGnzk5oIDTBZQc8q3wMa1svm
A5Rd4MVaIUt+hyk6seAldN6k4/O34O1l2V6D+/BwagyzLWvOeMEM9hClVF+F6a20yy4dcDsprFZZ
Sk9JzUy9F6FM7L1wT2ndjTNDja4Y2tixf31KuisZLGKmDZsW/fXF1GgWDaM0DbYJwtE3kHylWnMk
CN4PfYgIa15C5A9lXhExggJqMIICZgIBATBoMFQxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFzIFIzIFNNSU1FIENBIDIwMjAC
EAFEftjde/YEIFcjUXqhcBUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC3RWpLD
czb+rDXhalaccNUQWQJCWWZYW6hrkLRNE2e0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIyMDQyNTE5Mjk1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAGCwDZW1FTsDnPVXKYfLaMX/wq
3rAG0o6hS9p6yxVCWt8h+EmTVMVvccnH9DOL3EeG+lDFxfi5pouz3Hg1zT68tVY2j7lwU08J4Ne2
yaZyAxKsxTxXnCAlku4ZbQZTk83az2/UR1v985pYnQJZGkn4bCVL4W+rJYWpFl+aRB5EndYgnilA
YLG11MZhIpZkE9kK2QrW2xmsLLI/3gwi1Njqiy7Ojzpc/lHNX5ACWXqNbhXq3D1uOebK+hKVv8Ym
6Z4QIaBw9YTZ8FY3QkDYbeEknIQ6vW5yPVKf7H3/aSDmi3E1zppO43tObdsAlL0stjsbVscGtvLA
C24TTR1mnpgS
--000000000000b9156805dd7f99e0--
