Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD1E1EB25A
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 01:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgFAXsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 19:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFAXsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 19:48:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519ABC05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 16:48:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t7so3370086pgt.3
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 16:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=PT/nDqzdqu3HHXlzoZ7rhswDnHkCb/GVIsX6sp0+nTg=;
        b=ixwWKNYmRQ7PLGkP7zBluVDtyvO7JI8a1j3iuzpObls6QM7ykD+/hSp8pwk9FokIWl
         3/HtvIx1mTghwnN9deixxusB7lMc/4dxNpYt7WzhmBldcSspiBt9H29iUbtmcgdaIewF
         D2KCkFZhBWHYAMk4oOk5lHbiePw2NGay/wlidSKNtrI5i2xIbapa8pq4tkPxU5rMPV9Z
         nyTwC5SLXeownYm8+jVwGyfKbSx4RatYXRO6pthxymoaAXeNfglDsTXI7+PiAkUr47D3
         RggdvYJDQ7yPv/YY36blYuDeo4p2o5qiwfspQqjfudCo6Eyu6ySWiT2pCjbefjy57BfE
         6xrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=PT/nDqzdqu3HHXlzoZ7rhswDnHkCb/GVIsX6sp0+nTg=;
        b=hWJp/Lv9RFvZixWaHeHp9zB9X5fE+r4H7+RL0N3BbEK9MsVtxKr3bheHNdwEzZqaRx
         3IBuLLYrEeaylG7LHiFohQTy1DlYe2s1P/pOF1rLS0bBemmirgDBV3vgVXvhKChlIoH0
         wqO36+cD8EBuc3auzDOuv0QKebjtfKCwk9DzJiU2sk+1b4AID0jFKUHHPURv6z8BsOfE
         JPiiA/0Ck3sYD+U23GY5T+4lCR5N/XBeKox1lfK2GZW9u6yhdolnja9JfKRfzoO8wRPD
         xkdK/p9UyqBGlg2aXoLfC8LvpE+PPbpeMeqcJ42uwgo41Dg0a6oVuf1/t/AbVqc8G2HN
         4Zug==
X-Gm-Message-State: AOAM5332781K4hU7kwzgStMcKyyiuSJoTD1NzGZ3HZsg4fs2dW0NFhHj
        Srv9rxbqktY6Tp6eB/xXK878DA==
X-Google-Smtp-Source: ABdhPJwk+3c6p44VFSBek7g2KUt3R6FBLaMDtulRc3LFDsLfErb8cUO0IrJB5ZZukG2bf5LRX10hpQ==
X-Received: by 2002:a62:4e91:: with SMTP id c139mr3893637pfb.18.1591055286443;
        Mon, 01 Jun 2020 16:48:06 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:200:db56:ecca:5ade:2f85])
        by smtp.gmail.com with ESMTPSA id q25sm448943pff.69.2020.06.01.16.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 16:48:05 -0700 (PDT)
Date:   Mon, 1 Jun 2020 16:47:56 -0700
From:   Bob Haarman <inglorion@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Andi Kleen <ak@linux.intel.com>, Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alistair Delva <adelva@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Baoquan He <bhe@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Ross Zwisler <zwisler@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] x86_64: fix jiffies ODR violation
Message-ID: <20200601234756.GA10511@google.com>
References: <20200515180544.59824-1-inglorion@google.com>
 <20200519031742.GB499505@tassilo.jf.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200519031742.GB499505@tassilo.jf.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000035170905a70e6d41"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000035170905a70e6d41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 18, 2020 at 08:17:42PM -0700, Andi Kleen wrote:
> > Instead, we can avoid the ODR violation by matching other arch's by
> > defining jiffies only by linker script.  For -fno-semantic-interposition
> > + Full LTO, there is no longer a global definition of jiffies for the
> > compiler to produce a local symbol which the linker script won't ensure
> > aliases to jiffies_64.
> 
> I guess it was an historical accident.
> 
> Reviewed-by: Andi Kleen <ak@linux.intel.com>

Thank you, Andi. Do any other reviewers have comments?

--00000000000035170905a70e6d41
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPDAYJKoZIhvcNAQcCoIIO/TCCDvkCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggxvMIIEkjCCA3qgAwIBAgINAewckktV4F6Q7sAtGDANBgkqhkiG9w0BAQsFADBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjAeFw0xODA2MjAwMDAwMDBaFw0yODA2MjAwMDAwMDBaMEsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSEwHwYDVQQDExhHbG9iYWxTaWduIFNNSU1FIENB
IDIwMTgwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCUeobu8FdB5oJg6Fz6SFf8YsPI
dNcq4rBSiSDAwqMNYbeTpRrINMBdWuPqVWaBX7WHYMsKQwCOvAF1b7rkD+ROo+CCTJo76EAY25Pp
jt7TYP/PxoLesLQ+Ld088+BeyZg9pQaf0VK4tn23fOCWbFWoM8hdnF86Mqn6xB6nLsxJcz4CUGJG
qAhC3iedFiCfZfsIp2RNyiUhzPAqalkrtD0bZQvCgi5aSNJseNyCysS1yA58OuxEyn2e9itZJE+O
sUeD8VFgz+nAYI5r/dmFEXu5d9npLvTTrSJjrEmw2/ynKn6r6ONueZnCfo6uLmP1SSglhI/SN7dy
L1rKUCU7R1MjAgMBAAGjggFyMIIBbjAOBgNVHQ8BAf8EBAMCAYYwJwYDVR0lBCAwHgYIKwYBBQUH
AwIGCCsGAQUFBwMEBggrBgEFBQcDCTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRMtwWJ
1lPNI0Ci6A94GuRtXEzs0jAfBgNVHSMEGDAWgBSP8Et/qC5FJK5NUPpjmove4t0bvDA+BggrBgEF
BQcBAQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9yb290cjMw
NgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIzLmNybDBn
BgNVHSAEYDBeMAsGCSsGAQQBoDIBKDAMBgorBgEEAaAyASgKMEEGCSsGAQQBoDIBXzA0MDIGCCsG
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
BggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wUQYIKwYB
BQUHAQEERTBDMEEGCCsGAQUFBzAChjVodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2Vy
dC9nc3NtaW1lY2EyMDE4LmNydDAfBgNVHSMEGDAWgBRMtwWJ1lPNI0Ci6A94GuRtXEzs0jA/BgNV
HR8EODA2MDSgMqAwhi5odHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dzc21pbWVjYTIwMTgu
Y3JsMA0GCSqGSIb3DQEBCwUAA4IBAQCB8hJrRbW4aoR++6DS51XVSm7Xlb7bz7Ow5WPLVOiuVI3d
tq/OTAbsdReypY8Dw3+/FXLKa3q9BVtaCuHPXRMtBW1YdR3Xt9eH3ri1dP1nfzzF4iRwmTMrzG70
tLB0Rm+aqZtfoF1zt/ZvaQW+pfbELAh2TazUSguVRFZudpOzZsCsA/uL/gVMvrZc+LGG3M81s2+S
Lpt2aAXO5sEMEti+CjIKRSwIC3PGkRALu1O3Y+RxuPrdcCc6zdjqR2Ge/KXgRyvHlgwKpyJRSozt
qM7RsyNchlszR607DTfv4AkCuDGFp+2/lu1Pr90nos1lYQB7EM7bT/hvrnXK4veLjrKiMYICYTCC
Al0CAQEwXzBLMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEhMB8GA1UE
AxMYR2xvYmFsU2lnbiBTTUlNRSBDQSAyMDE4AhABaFRvfPg6SNdBt9YyDOljMA0GCWCGSAFlAwQC
AQUAoIHUMC8GCSqGSIb3DQEJBDEiBCAR5zY2qeGzyfkxNcxQccymZjtr5i46b2UXF+M9GApZujAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA2MDEyMzQ4MDdaMGkG
CSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYI
KoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAljxbW/hC2qVJYvLocvfUSOYTdydynYEhDc1FGbDoYs8DraFZbcLOWaewCkNaj4Y8
+d6t6KLofi2+j/lk6M6nF+mPQpIujFk+q41VT3yfEG6dGE/cX6koYZtyV4v3kIttSEJFsHChLTGL
1YwnQ433HsQYhoE9ZI2/NI2MGTKyc0ECVqwHkM/mgpGDhPQsqwT6qBGS8XN1LmRb2dMA+JDFaa79
mIX//jr2fGcrvoyhOzSrtr88jZfQ/ktCtHi7+Tc1+atKHQl/PmWpBItQQ0nFBmqpB/nrMIz+FPMN
ErBdATFuCxdZKq4dBMmppY86a3Be0zgGMW0+jpw6u7+MOaeGMg==
--00000000000035170905a70e6d41--
