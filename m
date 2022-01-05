Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1023F48553F
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 16:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbiAEPCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 10:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbiAEPCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 10:02:41 -0500
Received: from sequoia-grove.ad.secure-endpoints.com (sequoia-grove.secure-endpoints.com [IPv6:2001:470:1f07:f77:70f5:c082:a96a:5685])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E929C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 07:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/relaxed;
        d=auristor.com; s=MDaemon; r=y; t=1641394959; x=1641999759;
        i=jaltman@auristor.com; q=dns/txt; h=Message-ID:Date:
        MIME-Version:User-Agent:Subject:Content-Language:To:Cc:
        References:From:Organization:In-Reply-To:Content-Type; bh=nJ5IQ5
        ajSDAGPpsGehXADKqsHVWcCOaHUdmK7CgvK/c=; b=Xu9dUyVQBfATsgd76mH7pA
        r/x0ZtrBTnJniu84JwtjeFWucNDcN/zfLr68TSirOGQiMrJ7Gyr0dC2Qv6wcXZbe
        hUfWae284wtDOF8Y+xJJZX1tvp8plEtChfshcjntrR0nHYuDKdjd7B3onWn7qMDY
        FYNAuHWfIiNyF22pkGqn8=
X-MDAV-Result: clean
X-MDAV-Processed: sequoia-grove.ad.secure-endpoints.com, Wed, 05 Jan 2022 10:02:39 -0500
Received: from [IPV6:2603:7000:73d:4f22:c552:312a:d6eb:a5e0] by auristor.com (IPv6:2001:470:1f07:f77:28d9:68fb:855d:c2a5) (MDaemon PRO v21.5.1) 
        with ESMTPSA id md5001003050903.msg; Wed, 05 Jan 2022 10:02:39 -0500
X-Spam-Processed: sequoia-grove.ad.secure-endpoints.com, Wed, 05 Jan 2022 10:02:39 -0500
        (not processed: message from trusted or authenticated source)
X-MDRemoteIP: 2603:7000:73d:4f22:c552:312a:d6eb:a5e0
X-MDHelo: [IPV6:2603:7000:73d:4f22:c552:312a:d6eb:a5e0]
X-MDArrival-Date: Wed, 05 Jan 2022 10:02:39 -0500
X-MDOrigin-Country: US, NA
X-Authenticated-Sender: jaltman@auristor.com
X-Return-Path: prvs=100475f806=jaltman@auristor.com
X-Envelope-From: jaltman@auristor.com
X-MDaemon-Deliver-To: stable@vger.kernel.org
Message-ID: <6e1507d3-8a0c-1a51-c5a3-29a5800cf56f@auristor.com>
Date:   Wed, 5 Jan 2022 10:00:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: Backport request: commit 0dc54bd4d6e0 ("fscache_cookie_enabled:
 check cookie is valid before accessing it")
Content-Language: en-US
To:     "Greg KH (greg@kroah.com)" <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-afs@lists.infradead.org
References: <8b47354f-ff8f-4dfe-6c1e-813ffefbcf79@auristor.com>
 <YdWyJuRus3zknfak@kroah.com>
From:   Jeffrey E Altman <jaltman@auristor.com>
Organization: AuriStor, Inc.
In-Reply-To: <YdWyJuRus3zknfak@kroah.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060707010908050303080905"
X-MDCFSigsAdded: auristor.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060707010908050303080905
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/5/2022 9:58 AM, Greg KH (greg@kroah.com) wrote:
> On Tue, Jan 04, 2022 at 05:29:34PM -0500, Jeffrey E Altman wrote:
>> Please backport commit 0dc54bd4d6e03be1f0b678c4297170b79f1a44ab
>> ("fscache_cookie_enabled: check cookie is valid before accessing it") to
>> the 5.13, 5.14, and 5.15 kernel series.
> Only 5.15 is still alive, see the front page of kernel.org to see the
> active kernel verisons.

Got it.  Thank you for the prompt response.

Thank you.

Jeffrey


--------------ms060707010908050303080905
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DGswggXSMIIEuqADAgECAhBAAW0B1qVVQ32wvx2EXYU6MA0GCSqGSIb3DQEBCwUAMDoxCzAJ
BgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEy
MB4XDTE5MDkwNTE0MzE0N1oXDTIyMTEwMTE0MzE0N1owcDEvMC0GCgmSJomT8ixkAQETH0Ew
MTQxMEMwMDAwMDE2RDAxRDZBNTQwMDAwMDQ0NDcxGTAXBgNVBAMTEEplZmZyZXkgRSBBbHRt
YW4xFTATBgNVBAoTDEF1cmlTdG9yIEluYzELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCY1TC9QeWnUgEoJ81FcAVnhGn/AWuzvkYRUG5/ZyXDdaM212e8
ybCklgSmZweqNdrfaaHXk9vwjpvpD4YWgb07nJ1QBwlvRV/VPAaDdneIygJJWBCzaMVLttKO
0VimH/I/HUwFBQT2mrktucCEf2qogdi2P+p5nuhnhIUiyZ71Fo43gF6cuXIMV/1rBNIJDuwM
Q3H8zi6GL0p4mZFZDDKtbYq2l8+MNxFvMrYcLaJqejQNQRBuZVfv0Fq9pOGwNLAk19baIw3U
xdwx+bGpTtS63Py1/57MQ0W/ZXE/Ocnt1qoDLpJeZIuEBKgMcn5/iN9+Ro5zAuOBEKg34wBS
8QCTAgMBAAGjggKcMIICmDAOBgNVHQ8BAf8EBAMCBPAwgYQGCCsGAQUFBwEBBHgwdjAwBggr
BgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVudHJ1c3QuY29tMEIGCCsGAQUF
BzAChjZodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NlcnRzL3RydXN0aWRjYWEx
Mi5wN2MwHwYDVR0jBBgwFoAUpHPa72k1inXMoBl7CDL4a4nkQuwwCQYDVR0TBAIwADCCASsG
A1UdIASCASIwggEeMIIBGgYLYIZIAYb5LwAGAgEwggEJMEoGCCsGAQUFBwIBFj5odHRwczov
L3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRt
bDCBugYIKwYBBQUHAgIwga0MgapUaGlzIFRydXN0SUQgQ2VydGlmaWNhdGUgaGFzIGJlZW4g
aXNzdWVkIGluIGFjY29yZGFuY2Ugd2l0aCBJZGVuVHJ1c3QncyBUcnVzdElEIENlcnRpZmlj
YXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRp
ZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDBFBgNVHR8EPjA8MDqgOKA2hjRodHRwOi8v
dmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NybC90cnVzdGlkY2FhMTIuY3JsMB8GA1UdEQQY
MBaBFGphbHRtYW5AYXVyaXN0b3IuY29tMB0GA1UdDgQWBBR7pHsvL4H5GdzNToI9e5BuzV19
bzAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBAFlm
JYk4Ff1v/n0foZkv661W4LCRtroBaVykOXetrDDOQNK2N6JdTa146uIZVgBeU+S/0DLvJBKY
tkUHQ9ovjXJTsuCBmhIIw3YlHoFxbku0wHEpXMdFUHV3tUodFJJKF3MbC8j7dOMkag59/Mdz
Sjszdvit0av9nTxWs/tRKKtSQQlxtH34TouIke2UgP/Nn901QLOrJYJmtjzVz8DW3IYVxfci
SBHhbhJTdley5cuEzphELo5NR4gFjBNlxH7G57Hno9+EWILpx302FJMwTgodIBJbXLbPMHou
xQbOL2anOTUMKO8oH0QdQHCtC7hpgoQa7UJYJxDBI+PRaQ/HObkwggaRMIIEeaADAgECAhEA
+d5Wf8lNDHdw+WAbUtoVOzANBgkqhkiG9w0BAQsFADBKMQswCQYDVQQGEwJVUzESMBAGA1UE
ChMJSWRlblRydXN0MScwJQYDVQQDEx5JZGVuVHJ1c3QgQ29tbWVyY2lhbCBSb290IENBIDEw
HhcNMTUwMjE4MjIyNTE5WhcNMjMwMjE4MjIyNTE5WjA6MQswCQYDVQQGEwJVUzESMBAGA1UE
ChMJSWRlblRydXN0MRcwFQYDVQQDEw5UcnVzdElEIENBIEExMjCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBANGRTTzPCic0kq5L6ZrUJWt5LE/n6tbPXPhGt2Egv7plJMoEpvVJ
JDqGqDYymaAsd8Hn9ZMAuKUEFdlx5PgCkfu7jL5zgiMNnAFVD9PyrsuF+poqmlxhlQ06sFY2
hbhQkVVQ00KCNgUzKcBUIvjv04w+fhNPkwGW5M7Ae5K5OGFGwOoRck9GG6MUVKvTNkBw2/vN
MOd29VGVTtR0tjH5PS5yDXss48Yl1P4hDStO2L4wTsW2P37QGD27//XGN8K6amWB6F2XOgff
/PmlQjQOORT95PmLkwwvma5nj0AS0CVp8kv0K2RHV7GonllKpFDMT0CkxMQKwoj+tWEWJTiD
KSsCAwEAAaOCAoAwggJ8MIGJBggrBgEFBQcBAQR9MHswMAYIKwYBBQUHMAGGJGh0dHA6Ly9j
b21tZXJjaWFsLm9jc3AuaWRlbnRydXN0LmNvbTBHBggrBgEFBQcwAoY7aHR0cDovL3ZhbGlk
YXRpb24uaWRlbnRydXN0LmNvbS9yb290cy9jb21tZXJjaWFscm9vdGNhMS5wN2MwHwYDVR0j
BBgwFoAU7UQZwNPwBovupHu+QucmVMiONnYwDwYDVR0TAQH/BAUwAwEB/zCCASAGA1UdIASC
ARcwggETMIIBDwYEVR0gADCCAQUwggEBBggrBgEFBQcCAjCB9DBFFj5odHRwczovL3NlY3Vy
ZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDADAgEB
GoGqVGhpcyBUcnVzdElEIENlcnRpZmljYXRlIGhhcyBiZWVuIGlzc3VlZCBpbiBhY2NvcmRh
bmNlIHdpdGggSWRlblRydXN0J3MgVHJ1c3RJRCBDZXJ0aWZpY2F0ZSBQb2xpY3kgZm91bmQg
YXQgaHR0cHM6Ly9zZWN1cmUuaWRlbnRydXN0LmNvbS9jZXJ0aWZpY2F0ZXMvcG9saWN5L3Rz
L2luZGV4Lmh0bWwwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRy
dXN0LmNvbS9jcmwvY29tbWVyY2lhbHJvb3RjYTEuY3JsMB0GA1UdJQQWMBQGCCsGAQUFBwMC
BggrBgEFBQcDBDAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0OBBYEFKRz2u9pNYp1zKAZewgy+GuJ
5ELsMA0GCSqGSIb3DQEBCwUAA4ICAQAN4YKu0vv062MZfg+xMSNUXYKvHwvZIk+6H1pUmivy
DI4I6A3wWzxlr83ZJm0oGIF6PBsbgKJ/fhyyIzb+vAYFJmyI8I/0mGlc+nIQNuV2XY8cypPo
VJKgpnzp/7cECXkX8R4NyPtEn8KecbNdGBdEaG4a7AkZ3ujlJofZqYdHxN29tZPdDlZ8fR36
/mAFeCEq0wOtOOc0Eyhs29+9MIZYjyxaPoTS+l8xLcuYX3RWlirRyH6RPfeAi5kySOEhG1qu
NHe06QIwpigjyFT6v/vRqoIBr7WpDOSt1VzXPVbSj1PcWBgkwyGKHlQUOuSbHbHcjOD8w8wH
SDbL+L2he8hNN54doy1e1wJHKmnfb0uBAeISoxRbJnMMWvgAlH5FVrQWlgajeH/6NbYbBSRx
ALuEOqEQepmJM6qz4oD2sxdq4GMN5adAdYEswkY/o0bRKyFXTD3mdqeRXce0jYQbWm7oapqS
ZBccFvUgYOrB78tB6c1bxIgaQKRShtWR1zMM0JfqUfD9u8Fg7G5SVO0IG/GcxkSvZeRjhYcb
TfqF2eAgprpyzLWmdr0mou3bv1Sq4OuBhmTQCnqxAXr4yVTRYHkp5lCvRgeJAme1OTVpVPth
/O7HJ7VuEP9GOr6kCXCXmjB4P3UJ2oU0NqfoQdcSSSt9hliALnExTEjii20B2nSDojGCAxQw
ggMQAgEBME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUGA1UEAxMO
VHJ1c3RJRCBDQSBBMTICEEABbQHWpVVDfbC/HYRdhTowDQYJYIZIAWUDBAIBBQCgggGXMBgG
CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEwNTE1MDAzM1ow
LwYJKoZIhvcNAQkEMSIEIFw+evjAGz0tHZOJ8EkWjHG8CRQMI9ItrW5XFYQ9nB75MF0GCSsG
AQQBgjcQBDFQME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUGA1UE
AxMOVHJ1c3RJRCBDQSBBMTICEEABbQHWpVVDfbC/HYRdhTowXwYLKoZIhvcNAQkQAgsxUKBO
MDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQg
Q0EgQTEyAhBAAW0B1qVVQ32wvx2EXYU6MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAgxg7dn+xHOqx
vXK3/eR7Mtddeb6rXrK/gGzaUHGr3HABa0UspKSskNEZm925ebVAXKXkfYaIXJghF4bUhAT0
0hGFt4vn/dVlqiHC7iHv3TqymciVVX74K8/ylj+hSS6lzoOIx+gyB+VlMoeEiyKVboVkls4D
KD3QmysMGsNFbM3slXpULBU1CjvgODTYlAvKNXoMd2qwFFtq8zCvd16zZ8RBPBM/AKKWCbpN
7CWDnu9tDJ3j996tQ1mquhXxD3n9gWYRw37BWcM61I5UB/z8lhBIeGwz7AmHDhi2Z4+kZhBy
H6+RVzM5L0I+FBZdyGrbCN6mY/FMxxeXTf0KH2muUwAAAAAAAA==
--------------ms060707010908050303080905--

