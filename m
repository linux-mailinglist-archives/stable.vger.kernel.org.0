Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A946F63F486
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 16:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiLAPwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 10:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiLAPwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 10:52:36 -0500
Received: from smtpauth.rollernet.us (smtpauth.rollernet.us [IPv6:2607:fe70:0:3::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732B1B53
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 07:52:33 -0800 (PST)
Received: from smtpauth.rollernet.us (localhost [127.0.0.1])
        by smtpauth.rollernet.us (Postfix) with ESMTP id E27CC280004E;
        Thu,  1 Dec 2022 07:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aronetics.com;
         h=from:to:cc:references:in-reply-to:subject:date:message-id
        :mime-version:content-type; s=roll2210; t=1669909952; bh=7ztrzaD
        NVG93s25z7Fx5+VOK4GRN+2ZQvzf2HJvpnN8=; b=IXjaJGYOkp3R9xs7QqbmzSW
        qnNlE1oIeEvyDxKtux9EaBl6emfm4PX4k2Gt6vEgtFM/3r8dKDzhT055X2Q1GLpX
        oSx3lxcV8NKlmlUbRp2mKyc2XcbQUHFLupG64zxrT3JiazqDs4QpeIajbiag06P/
        ZglI2JI9zLak5fpH2+7zoTNDLvRT7L1OXmSUlU+6kHYtf3PpANQWENgcLb2LnV0S
        tYgXp6IHqOLyPNo1DD0bR0IGwF8IEUo+Z1iBktg25Eo2KhcOooMLmE/xjQL+TRB4
        X92l9B8vW9fkghQQfmjII1kvfUtqTK+VHvLzYTJi6H3g5VMIoFlyzBSlxD5Y2yQ=
        =
From:   "John Aron" <john@aronetics.com>
To:     "'Greg KH'" <gregkh@linuxfoundation.org>
Cc:     "'Mark Salter'" <mark.salter@canonical.com>,
        "'Mark Lewis'" <mark.lewis@canonical.com>,
        <regressions@lists.linux.dev>, <stable@vger.kernel.org>,
        <kernelnewbies@kernelnewbies.org>
References: <041601d90035$4f738de0$ee5aa9a0$@aronetics.com> <Y3/c73nZVdHCBdZo@kroah.com> <0be301d90514$9250bd70$b6f23850$@aronetics.com> <Y4hCVMrg9oZt+YAL@kroah.com>
In-Reply-To: <Y4hCVMrg9oZt+YAL@kroah.com>
Subject: RE: OBJTOOL Build error
Date:   Thu, 1 Dec 2022 10:52:16 -0500
Message-ID: <002e01d9059c$eb052400$c10f6c00$@aronetics.com>
X-Mailer: Microsoft Outlook 16.0
MIME-Version: 1.0
Thread-Index: AQKf6RgJ5J/J2MTr/YB4gdWkzgfzGAHVZOk2AlzVO6oCMYW+yqyYR34g
Content-Language: en-us
Content-Type: multipart/signed;
        protocol="application/x-pkcs7-signature";
        micalg=SHA1;
        boundary="----=_NextPart_000_0029_01D90572.F8F1FF40"
X-Rollernet-Modified: Received headers cleared at submission by user request
X-Rollernet-Abuse: Contact abuse@rollernet.us to report. Abuse policy: http://www.rollernet.us/policy
X-Rollernet-Submit: Submit ID 5bbe.6388cdb5.7fb78.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_0029_01D90572.F8F1FF40
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Oh Dear -

This wiki page brings my mind back to a hacker listserv conversation about
semantics of discourse and Kevin Mitnick isms. Please accept my inline or
outline apologies.

John

-----Original Message-----
From: Greg KH <gregkh@linuxfoundation.org> 
Sent: Thursday, December 1, 2022 12:58 AM
To: John Aron <john@aronetics.com>
Cc: 'Mark Salter' <mark.salter@canonical.com>; 'Mark Lewis'
<mark.lewis@canonical.com>; regressions@lists.linux.dev;
stable@vger.kernel.org; kernelnewbies@kernelnewbies.org
Subject: Re: OBJTOOL Build error

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Nov 30, 2022 at 06:36:19PM -0500, John Aron wrote:
> One C file and a few header files.

Can you provide a link to them so that we can see what might be the problem?
Without that, it's impossible to help, sorry.
--
The repo is in a private repo online, the entry is:
static int __init kernel_module_start(void)
{
    Configuration* configuration = NULL;
    // enable the logger
    Logger_set_enabled(true);
    log_info("Starting Aronetics kernel module (configuration file name:
\"%s\")...\n", _FILE_NAME_CONFIGURATION);
    controller = Controller_new(_FILE_NAME_CONFIGURATION);
    if (controller != NULL)
    {
        configuration = Controller_get_configuration(controller);
        String_dump_and_delete(Configuration_to_string(configuration));
        log_verbose("    Initializing mutex...\n");
        mutex_init(&controller_mutex);
        switch (Configuration_get_execution_mode(configuration))
        {
//          case TestExecutionMode:
//              run_tests();
//              break;
            default:
                log_verbose("    Initializing controller...\n");
                if (Controller_initialize(controller) == 0)
                {
                    log_verbose("    Setting up timer...\n");
                    timer_setup(&controller_timer, on_timer, 0);
                    log_verbose("    Initalizing timer...\n");
                    mod_timer(&controller_timer, jiffies +
msecs_to_jiffies(DELAY_ITERATION));
                    log_verbose("Aronetics kernel module started\n");
                }
                else
                {
                    log_error("Initialization failed.");
                }
                break;
        }
    }
    return 0;
}

thanks,

greg k-h

------=_NextPart_000_0029_01D90572.F8F1FF40
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIXlzCCA1cw
ggI/oAMCAQICAQEwDQYJKoZIhvcNAQELBQAwTTELMAkGA1UEBhMCVVMxGDAWBgNVBAoTD1UuUy4g
R292ZXJubWVudDEMMAoGA1UECxMDRUNBMRYwFAYDVQQDEw1FQ0EgUm9vdCBDQSA0MB4XDTEyMDMy
MDE2MTMwNFoXDTI5MTIzMDE2MTMwNFowTTELMAkGA1UEBhMCVVMxGDAWBgNVBAoTD1UuUy4gR292
ZXJubWVudDEMMAoGA1UECxMDRUNBMRYwFAYDVQQDEw1FQ0EgUm9vdCBDQSA0MIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuHBpV72AWkHAGeaV59SCE9wsOEuKgsociF2OfjwMb2Xh2rgc
cRi23hQIedvGipnt+iHdYhgALfAUzFpOd57y6HcUAxTGqf2yEqBn/x83etBwj5bXcCQOLZ1FXjwA
E+6gOjEakCBXZeQwF8bJBHndHv+gyO9frAAlOgG/lpwElY6tUrORcPT07DPhDwgXgriGCj850dyQ
Occ+uTMpg9kK6BPgXj0NJYDEbM8sLoAq0C1ASRvEnLbzNikm7DEAcxrNd5Wt5SxL8RQpNugxXN71
XI92W6sB1s/nzSer9LRzUEI0JYdXWh5UmTubAerF3ZWjsHK27HChKqqF+vGpOJQVBwIDAQABo0Iw
QDAdBgNVHQ4EFgQUM1ulb3pVYCuBSyYUzHm/SrqLMr0wDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB
/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBALYfYXiGvrV6cReK8ddFAhX3uiDF5ZNpJV4VcTlO
wdHY6HtDu40Z0cAg3+dNq4pdf4AgjY3vAmiK1QCcIbcFrOe3j7GUUz25bvj36IJV0SgkZYDlFsew
RAvThFJDI8ja+172AYbZN7/9brhQyA3mPHT6C26P8ozD31C3nyj4rlAcmsy+dm5K2vS1KDWhHXKR
dhog7zrIRJDAHQZ7sM24weayW09IFVojo2rJBlp8jIhEcYma52rePQmv0cu8lacIV45RoTER03Hw
g+9Qx+55bDsjY/iaZm4OKSAbrSXNubi/G9JzQADDTayJZPFzoIOJDhp0mKiUPLZ07JROAhXrMW4w
ggSSMIIDeqADAgECAgIC9TANBgkqhkiG9w0BAQsFADBNMQswCQYDVQQGEwJVUzEYMBYGA1UEChMP
VS5TLiBHb3Zlcm5tZW50MQwwCgYDVQQLEwNFQ0ExFjAUBgNVBAMTDUVDQSBSb290IENBIDQwHhcN
MTkwNTA3MTI1NTI4WhcNMjUwNTA3MTI1NTI4WjB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5T
LiBHb3Zlcm5tZW50MQwwCgYDVQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9y
aXRpZXMxGjAYBgNVBAMTEUlkZW5UcnVzdCBFQ0EgUzIyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAt6DTxW5yDAER5mqwNjBumWj29f1myTOf5jY+hFnWGTHaJd/V9DcX12FxPaAgOsj8
q3k9NOOYIPQO6woEVFFf31rNmuE7b5lmhOtjGP8BUUOQIq0lBZxH+Kx6yXQ0gDtDZkpVQMDkxMOx
Ko8cRcc65DjecWG006CCLcTBN/nIhykX8cXlxIk8klIkkuC7j6ymjTnMHCAhKGpu1AbDIjyC+RhF
hkrhuYNsw9Bpqm941owaLCeiHky8K/mWLfYYv3Yysz6aUJcWdwZUoEStjClzMDPsRyJD9CbxQ0ZC
rSa1NK9HSGc0teT088t21uLDvkWBzGr7hCOPXJqQGZ4F3oS4IQIDAQABo4IBUjCCAU4wHwYDVR0j
BBgwFoAUM1ulb3pVYCuBSyYUzHm/SrqLMr0wHQYDVR0OBBYEFOikBAKeSdIV0aVfu+uUOQS7gilu
MA4GA1UdDwEB/wQEAwIBhjAzBgNVHSAELDAqMAwGCmCGSAFlAwIBDAQwDAYKYIZIAWUDAgEMBTAM
BgpghkgBZQMCAQwKMBIGA1UdEwEB/wQIMAYBAf8CAQAwDAYDVR0kBAUwA4ABADA3BgNVHR8EMDAu
MCygKqAohiZodHRwOi8vY3JsLmRpc2EubWlsL2NybC9FQ0FST09UQ0E0LmNybDBsBggrBgEFBQcB
AQRgMF4wOgYIKwYBBQUHMAKGLmh0dHA6Ly9jcmwuZGlzYS5taWwvaXNzdWVkdG8vRUNBUk9PVENB
NF9JVC5wN2MwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3NwLmRpc2EubWlsMA0GCSqGSIb3DQEBCwUA
A4IBAQBIB/AYjrPQr2Jh/qkcECcjetqBrhU8SsNRI42IW2xdfRqBODnKxWDFkkBtfNd/8+g5/76e
6c8f0Zw9fn8UTqdMaU0H9ylZt9ngc8aM6BhcaOyK1ClZwHohTpZHemhlI8nw6o7VRgIWl8E0Om/A
OOuNxPOYJ1DeG4XfGKqbTMwXVLVYE1M9PO3kNQpVFiXzwtw5WxCoQjkXd6aq1PWWehMF+r54/O4+
Ycu/Gr5y66EEFPnqLKXjJnJcOVDzwQ/k/7sGpQW7kxHeY/+YbBVdG0R0MvCyKIBWgIwimt0viqqq
a3oOCnYP3J1vB7vu+GH9d1bZKB64WZGknXyHK3QS8DArMIIHqDCCBpCgAwIBAgIQQAFu/9vH1Hi9
faHFlIkOwDANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zl
cm5tZW50MQwwCgYDVQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9yaXRpZXMx
GjAYBgNVBAMTEUlkZW5UcnVzdCBFQ0EgUzIyMB4XDTE5MTIxMzE1MjM0M1oXDTIyMTIxMjE1MjM0
M1owgZUxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw9VLlMuIEdvdmVybm1lbnQxDDAKBgNVBAsTA0VD
QTESMBAGA1UECxMJSWRlblRydXN0MRYwFAYDVQQLEw1Bcm9uZXRpY3MgTExDMTIwMAYDVQQDEylK
b2huIEFyb246QTAxMDlCMzAwMDAwMTZFQTg2RjNGMjMwMDAwMUQyNTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALEOcknUWWvkkaX1oKZfNlKj3CgBICGb1GoeE1rnUQvcEDuVeAtP+zsW
5rxqusImavijhTwckMzo6QFNkUaInis462cAK+fDVL8btNBl0RatZuW6LJpFwYJBJ9mI5yXVAv+Q
tQ3USTwDU29OH5E4s1+SUrX31Ts2P+iq3nEc4XFNYjBn8KAeDBkJg9rrxvqZh5mxMpuUkDNfH+ZM
pVXVHvRk7sTYLYJXc6mG8EKk1tllw8czhaLvxQxse1w+PPWbVsluf2Bqv5eU1JvS5MXHnK2A/NmS
aa/chm46GdRr9Jh32rKCQcw+BCEa4HG4NyvibXiSD/OKasb6/U+xnIAjnsUCAwEAAaOCBBEwggQN
MA4GA1UdDwEB/wQEAwIFIDCCATEGCCsGAQUFBwEBBIIBIzCCAR8wKwYIKwYBBQUHMAGGH2h0dHA6
Ly9lY2FzMi5vY3NwLmlkZW50cnVzdC5jb20wgagGCCsGAQUFBzAChoGbbGRhcDovL2xkYXBlY2Eu
aWRlbnRydXN0LmNvbS9jbiUzRElkZW5UcnVzdCUyMEVDQSUyMFMyMiUyQ291JTNEQ2VydGlmaWNh
dGlvbiUyMEF1dGhvcml0aWVzJTJDb3UlM0RFQ0ElMkNvJTNEVS5TLiUyMEdvdmVybm1lbnQlMkNj
JTNEVVM/Y0FDZXJ0aWZpY2F0ZTtiaW5hcnkwRQYIKwYBBQUHMAKGOWh0dHA6Ly92YWxpZGF0aW9u
LmlkZW50cnVzdC5jb20vY2VydHMvaWRlbnRydXN0ZWNhczIyLmNlcjAfBgNVHSMEGDAWgBTopAQC
nknSFdGlX7vrlDkEu4IpbjAbBgNVHQkEFDASMBAGCCsGAQUFBwkEMQQTAlVTMIIBMwYDVR0gBIIB
KjCCASYwggEiBgpghkgBZQMCAQwFMIIBEjBLBggrBgEFBQcCARY/aHR0cHM6Ly9zZWN1cmUuaWRl
bnRydXN0LmNvbS9jZXJ0aWZpY2F0ZXMvcG9saWN5L2VjYS9pbmRleC5odG1sMIHCBggrBgEFBQcC
AjCBtQyBskNlcnRpZmljYXRlIHVzZSByZXN0cmljdGVkIHRvIFJlbHlpbmcgUGFydHkocykgaW4g
YWNjb3JkYW5jZSB3aXRoIEVDQS1DUCAoc2VlIGh0dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20v
Y2VydGlmaWNhdGVzL3BvbGljeS9FQ0EvaW5kZXguaHRtbCkuIEVDQS1DUFMgaW5jb3Jwb3JhdGVk
IGJ5IHJlZmVyZW5jZS4wgf0GA1UdHwSB9TCB8jCBsKCBraCBqoaBp2xkYXA6Ly9sZGFwZWNhLmlk
ZW50cnVzdC5jb20vY24lM0RJZGVuVHJ1c3QlMjBFQ0ElMjBTMjIlMkNvdSUzRENlcnRpZmljYXRp
b24lMjBBdXRob3JpdGllcyUyQ291JTNERUNBJTJDbyUzRFUuUy4lMjBHb3Zlcm5tZW50JTJDYyUz
RFVTP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q7YmluYXJ5MD2gO6A5hjdodHRwOi8vdmFsaWRh
dGlvbi5pZGVudHJ1c3QuY29tL2NybC9pZGVudHJ1c3RlY2FzMjIuY3JsMB0GA1UdEQQWMBSBEmpv
aG5AYXJvbmV0aWNzLmNvbTAdBgNVHQ4EFgQUubvtwtL7mOqQ4xQAAHBOKiFE0VQwEwYDVR0lBAww
CgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBAB3CQjE6kc6J1T0nCka4EQPQbHrrjEYcoY26
oX1gtxgpkmL7V3NakWycjwzLOIFD9PipfK61TT/j6UNvNHg2GUatdipfIZ+oXGEkq3LG16dOl/On
FpY6qTT2PF1hZUrUAPXTSq6syomsTzP4BNc02+X5BNNIn6302q63+RfjZFUUKEozP+XEFANxwccJ
Z6w9oB6w+nk+u55dCRmPxEw+6iPVEpn/V1BDt/9wu7GR6kbne0n9JUs0ChT6lGYsd1OZGyWb4L5i
BeZ8433zFdeaMQMgZNFEpzcYtTLOOV94KVdsQbEAVjuy5ys3LueB+TmHp54Sek2jm76gzVR8EF0F
os4wggf2MIIG3qADAgECAhBAAW7/3NMKJM1U1yqHjdeXMA0GCSqGSIb3DQEBCwUAMHUxCzAJBgNV
BAYTAlVTMRgwFgYDVQQKEw9VLlMuIEdvdmVybm1lbnQxDDAKBgNVBAsTA0VDQTEiMCAGA1UECxMZ
Q2VydGlmaWNhdGlvbiBBdXRob3JpdGllczEaMBgGA1UEAxMRSWRlblRydXN0IEVDQSBTMjIwHhcN
MTkxMjEzMTUyNDUyWhcNMjIxMjEyMTUyNDUyWjCBlTELMAkGA1UEBhMCVVMxGDAWBgNVBAoTD1Uu
Uy4gR292ZXJubWVudDEMMAoGA1UECxMDRUNBMRIwEAYDVQQLEwlJZGVuVHJ1c3QxFjAUBgNVBAsT
DUFyb25ldGljcyBMTEMxMjAwBgNVBAMTKUpvaG4gQXJvbjpBMDEwOUIzMDAwMDAxNkVBODZGM0Yy
MzAwMDAxRDI1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy3NpPOFjY6VLGiFUeCtC
iOyNmDyeV3lOnaDNRsdk603M+o6f+ZFinFnp2bvBt1WfOz4zGu2Nd7Mk5c788MOSk26M2KzpjS10
giyYYEaCDbBE9Z/owhySIRLVeSo1A6CiRHcTEBAaNfYpLGqXYXbELZDk2E1H5vmnVKcrWRxG2YZR
lxw4sAhLi8fmHQDvYPofsDKcebAUAbf7gpsMhtXFimCna3YgJvpGTR+BZ0ipONkp5wjz8l8V4b6g
1xFGdWufwEd0ct33ZY3BZVIaRypc3Jr3T6IcvjA4k9HwUzkcjSuCLe+So2ur7gTmY2FO6yoEDfIw
pBQU06QD5Pot7BnzdQIDAQABo4IEXzCCBFswDgYDVR0PAQH/BAQDAgbAMIIBMQYIKwYBBQUHAQEE
ggEjMIIBHzArBggrBgEFBQcwAYYfaHR0cDovL2VjYXMyLm9jc3AuaWRlbnRydXN0LmNvbTCBqAYI
KwYBBQUHMAKGgZtsZGFwOi8vbGRhcGVjYS5pZGVudHJ1c3QuY29tL2NuJTNESWRlblRydXN0JTIw
RUNBJTIwUzIyJTJDb3UlM0RDZXJ0aWZpY2F0aW9uJTIwQXV0aG9yaXRpZXMlMkNvdSUzREVDQSUy
Q28lM0RVLlMuJTIwR292ZXJubWVudCUyQ2MlM0RVUz9jQUNlcnRpZmljYXRlO2JpbmFyeTBFBggr
BgEFBQcwAoY5aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRydXN0LmNvbS9jZXJ0cy9pZGVudHJ1c3Rl
Y2FzMjIuY2VyMB8GA1UdIwQYMBaAFOikBAKeSdIV0aVfu+uUOQS7giluMBsGA1UdCQQUMBIwEAYI
KwYBBQUHCQQxBBMCVVMwggEzBgNVHSAEggEqMIIBJjCCASIGCmCGSAFlAwIBDAUwggESMEsGCCsG
AQUFBwIBFj9odHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kv
ZWNhL2luZGV4Lmh0bWwwgcIGCCsGAQUFBwICMIG1DIGyQ2VydGlmaWNhdGUgdXNlIHJlc3RyaWN0
ZWQgdG8gUmVseWluZyBQYXJ0eShzKSBpbiBhY2NvcmRhbmNlIHdpdGggRUNBLUNQIChzZWUgaHR0
cHM6Ly9zZWN1cmUuaWRlbnRydXN0LmNvbS9jZXJ0aWZpY2F0ZXMvcG9saWN5L0VDQS9pbmRleC5o
dG1sKS4gRUNBLUNQUyBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlLjCB/QYDVR0fBIH1MIHyMIGw
oIGtoIGqhoGnbGRhcDovL2xkYXBlY2EuaWRlbnRydXN0LmNvbS9jbiUzRElkZW5UcnVzdCUyMEVD
QSUyMFMyMiUyQ291JTNEQ2VydGlmaWNhdGlvbiUyMEF1dGhvcml0aWVzJTJDb3UlM0RFQ0ElMkNv
JTNEVS5TLiUyMEdvdmVybm1lbnQlMkNjJTNEVVM/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdDti
aW5hcnkwPaA7oDmGN2h0dHA6Ly92YWxpZGF0aW9uLmlkZW50cnVzdC5jb20vY3JsL2lkZW50cnVz
dGVjYXMyMi5jcmwwVQYDVR0RBE4wTIESam9obkBhcm9uZXRpY3MuY29toDYGCisGAQQBgjcUAgOg
KAwmQTAxMDlCMzAwMDAwMTZFQTg2RjNGMjMwMDAwMUQyNUBET0RFQ0EwHQYDVR0OBBYEFNxheynV
IGu32/+BAJUls+Xd5lguMCkGA1UdJQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQC
AjANBgkqhkiG9w0BAQsFAAOCAQEAZ5P1oC44GLasrCz7mLzBbu8EcBtVK2drq7Kr0b1HBt/YS+MZ
egtyCcoQeutwheALquDsTm4BcaIBo5kxghOjm+cTQLPfthDbi7gjM36vdFtlysSiFjiPLgqWN+yA
uJjbdc3oXfE+FyPDbo8nMBJN8PQc2v77/OYPJ0UhYuvdsNt+t3NHhJVjDCOLuSEQAZw32D05nhiY
E/GmF2CLmWQMyuxKQVaT+H2bjp8/2MSqD0BWffXN7RJJWPIO1xhj6DVYJW93IYWTJwcomrK0GxFy
cR4+SQEkY+ImADwdNNxkHgCvU8ej4Jv2aFYVfVGZ8W4B7KumCFTYAdte8OgA2xwS7TGCA+QwggPg
AgEBMIGJMHUxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw9VLlMuIEdvdmVybm1lbnQxDDAKBgNVBAsT
A0VDQTEiMCAGA1UECxMZQ2VydGlmaWNhdGlvbiBBdXRob3JpdGllczEaMBgGA1UEAxMRSWRlblRy
dXN0IEVDQSBTMjICEEABbv/c0wokzVTXKoeN15cwCQYFKw4DAhoFAKCCAi8wGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIxMjAxMTU1MjE0WjAjBgkqhkiG9w0BCQQx
FgQUkXCPwt6VIiOSXj9ImQsbD0BgOt8wgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglghkgBZQME
AgEwgZoGCSsGAQQBgjcQBDGBjDCBiTB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zl
cm5tZW50MQwwCgYDVQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9yaXRpZXMx
GjAYBgNVBAMTEUlkZW5UcnVzdCBFQ0EgUzIyAhBAAW7/28fUeL19ocWUiQ7AMIGcBgsqhkiG9w0B
CRACCzGBjKCBiTB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zlcm5tZW50MQwwCgYD
VQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9yaXRpZXMxGjAYBgNVBAMTEUlk
ZW5UcnVzdCBFQ0EgUzIyAhBAAW7/28fUeL19ocWUiQ7AMA0GCSqGSIb3DQEBAQUABIIBAGq+NUvD
ERx2w7+slToNo/620RlHot8iKhblo7Kq8M4A87XCADKBANTJEzatJ5NGZszLCw4HwQl4sa6bqS+/
l9humP2jzqTI/JJlzcmLOKJk6skeaijVi4C8Xpp+6AksT2K4glFCRGro21VGltjjv3H5k52bBQdQ
osGizHR8kjEtApWk8bZPwvcomV1PAF4/7FCoG1TZYrjNcM7Npl6l+uBzkhtEnzuOMaRtz0C1ImqM
NBmBGCDe1bqB0HNWT/PzjsWrsoEefar5UhFLLYVrfI2nud4ipIWjNGHmPnwNnfRXTld23/y+5Jmk
mMT3lvJaWVDS64KzXPX+wkbTHEHVD9QAAAAAAAA=

------=_NextPart_000_0029_01D90572.F8F1FF40--

