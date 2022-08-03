Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22353588696
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 06:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiHCEi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 00:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiHCEi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 00:38:56 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58C64E602
        for <stable@vger.kernel.org>; Tue,  2 Aug 2022 21:38:55 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w3so4346884edc.2
        for <stable@vger.kernel.org>; Tue, 02 Aug 2022 21:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=K947UOsdN60MrZae2a/4OgrmeXGbcrPXEIrPwJl6+qA=;
        b=d8iwqLYggv02V7LycpZzSWfjSAd9ukp+MdgXHILAZf9swTj09wIuz8stposdbmFY4V
         HOgHeAmfZ1npf3icPpslnVLniMWDebD/TvQZL+DbJzYpSnzn6hPiaqp+c34UwTK9ZaNz
         Xpe6mpDwSk4eXnqY+n1X3424aXP/8OWSj0RJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=K947UOsdN60MrZae2a/4OgrmeXGbcrPXEIrPwJl6+qA=;
        b=D8oUUfVSXMsGfUW2WW9bvTFl/6zVtflRBryayPBQQK1yUiDo4DHJSTlg1nWGrTYRVh
         7AHjmkGoJLWaNpunvjya4UMJsx1Mq+4cQQOSo16idf1zfY2hVe6KMwBiL+q8vK7BIO6j
         S39zeb5tvLELJBcAPM4wjk7EIGWSCc/+50nJTDTmv5geb9pt3lhFaozvSH4nCU6c1lzl
         ZuBxXCkWFFnlN3LWCh0OYXimGuGADV6/9qq1MgiWbRGSRIYe2RnqQXLLjl8RZBhxSqTl
         g8cbIUpH8Z8GEG/Xvv+B2xJm5301Wa+gVGnkSSaV0U17lYCjhPLc/0nMpXqdwyDBHGG8
         saag==
X-Gm-Message-State: ACgBeo2DVDTckjsoq7k++vPbMEcDGhT0982eShHdJ4bE0K1QTVWh1jg3
        KneYnTjzXmxwIvn2O1fO2Kg49U3aTGyrJKqNugp0giZ+HyXYSm4uK4/yFEG7XG7XvPDTnZP/MoS
        Zxwv5Vhmdsf7ufOwLJ9LZ1Dz8MrPK
X-Google-Smtp-Source: AA6agR6c6Zp9CxwEtVP/1Fs7Q1nLs0Ta3/Cvzw2srNjiFh73fMovFGRX+FIg1crmwhQTJTWxbNTH86SEtcXn62eXlQc=
X-Received: by 2002:a05:6402:3482:b0:43e:dd2:52a3 with SMTP id
 v2-20020a056402348200b0043e0dd252a3mr4722636edc.386.1659501534293; Tue, 02
 Aug 2022 21:38:54 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <20220801162713.17324-1-emilne@redhat.com> <20220801182714.GA17613@lst.de>
 <0b5001ed-050f-f5d0-72ee-3cc2ffc7f9b8@gmail.com>
In-Reply-To: <0b5001ed-050f-f5d0-72ee-3cc2ffc7f9b8@gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKTGqs69RcEgjtZquImtL2TObdjXwMZ4NEjAxYvvMir9i9VwA==
Date:   Wed, 3 Aug 2022 10:08:48 +0530
Message-ID: <6c03a873a639253c8af685b0e4849fb5@mail.gmail.com>
Subject: RE: [PATCH] Revert "nvme-fc: fold t fc_update_appid into fc_appid_store"
To:     James Smart <jsmart2021@gmail.com>, Christoph Hellwig <hch@lst.de>,
        "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-nvme@lists.infradead.org,
        James Smart <james.smart@broadcom.com>, stable@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000077c70105e54ecf66"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000077c70105e54ecf66
Content-Type: text/plain; charset="UTF-8"

I have tested the below changes suggested by Christoph and it is working as
expected.


Tested-by: <muneendra.kumar@broadcom.com>



-----Original Message-----
From: James Smart [mailto:jsmart2021@gmail.com]
Sent: Tuesday, August 2, 2022 2:33 AM
To: Christoph Hellwig <hch@lst.de>; Ewan D. Milne <emilne@redhat.com>
Cc: linux-nvme@lists.infradead.org; muneendra.kumar@broadcom.com;
james.smart@broadcom.com; stable@vger.kernel.org
Subject: Re: [PATCH] Revert "nvme-fc: fold t fc_update_appid into
fc_appid_store"

On 8/1/2022 11:27 AM, Christoph Hellwig wrote:
> On Mon, Aug 01, 2022 at 12:27:13PM -0400, Ewan D. Milne wrote:
>> This reverts commit c814153c83a892dfd42026eaa661ae2c1f298792.
>>
>> The commit c814153c83a8 "nvme-fc: fold t fc_update_appid into
>> fc_appid_store"
>> changed the userspace interface, because the code that decrements "count"
>> to remove a trailing '\n' in the parsing results in the decremented
>> value being incorrectly be returned from the sysfs write.  Fix this by
>> revering the commit.
>
> Wouldn't something like the patch below be much simpler and cleaner:
>
>
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c index
> 9987797620b6d..e24ab688f00d5 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -3878,6 +3878,7 @@ static int fc_parse_cgrpid(const char *buf, u64 *id)
>   static ssize_t fc_appid_store(struct device *dev,
>   		struct device_attribute *attr, const char *buf, size_t count)
>   {
> +	size_t orig_count = count;
>   	u64 cgrp_id;
>   	int appid_len = 0;
>   	int cgrpid_len = 0;
> @@ -3902,7 +3903,7 @@ static ssize_t fc_appid_store(struct device *dev,
>   	ret = blkcg_set_fc_appid(app_id, cgrp_id, sizeof(app_id));
>   	if (ret < 0)
>   		return ret;
> -	return count;
> +	return orig_count;
>   }
>   static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
>   #endif /* CONFIG_BLK_CGROUP_FC_APPID */
>

Reviewed-by: James Smart <jsmart2021@gmail.com>

looks good on my end.

-- james

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--00000000000077c70105e54ecf66
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQeAYJKoZIhvcNAQcCoIIQaTCCEGUCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3PMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVcwggQ/oAMCAQICDHE+9dgalq0zfRWBQDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwODMxMjlaFw0yMjA5MDUwODM1MjlaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGjAYBgNVBAMTEU11bmVlbmRyYSBLdW1hciBNMSswKQYJKoZI
hvcNAQkBFhxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA2oRP8OxO2NYieH4Xx4Y8eNi7mMVy4G5hkvXCCZjonnBX4NjglxtpbckcFqMx
eegLjY0Nkq4IL7dhAef5Ddh0xQpzp/hQEkuGJUCqrMSH57NS6lZ33/ez2C4N0axr/dcxtxe+JtCm
K6hmmo1cEotLOgFnu7njR+VCvNdgsDzksd406ohAucjWgI50uKU+vpkmckEWa+gKwhDUz6xOUhkt
6dyIRB5g0cWmkcO89O0W56d+wWwa7GeeTIJHMzJ0rco8nzcXkz/oeEmXSjZU3erpKBaLCQBkZud1
iNM/8mFL1vZxCwUACcMw+a8FhrHJq29QwrBHqDJ1ocrJlDaZcn1UDQIDAQABo4IB3TCCAdkwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsG
AQUFBwMEMB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBTMJfPJzmVP
1lwJptwb21ozx4G7wzANBgkqhkiG9w0BAQsFAAOCAQEAmz4/3oyLhfXMYVZWtDEKcP5Bk/6JAhfa
9q4eZDy1W/1FSuRfEWMq7xi9T3DvxUQqJtpJ8bM6SU37fZAvvMdRF23qdKRy6gBZ9NkYOCP7Tr2u
wNYznMfaHEGY/aa65EiywAsbVn1X7vKMKqSj3cmpEUO2I+FcRtPdyicqyU2E3856b5d+fMc01FRg
pQQRz3kWlIpG/CJ2SiOg0gpkZIkUde0r4e6ipDi+xVSoBdOOJzirs8IkwOeJ4w9GPS9uOkB1bRvJ
RU+Nz1h4p9eH2nsPAq7S5l6y/n3+g/olazbUoiEx8GRFqzoHLudsqmnzISDPoe+rczkpYreF/mEU
Y6pL2DGCAm0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDHE+
9dgalq0zfRWBQDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgRIzOgVlhBHGkgYs6
7RQObVoxGd4tnnMrmk+cdgFGwXUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjIwODAzMDQzODU0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAI4wOVjhU5MapD38Yd8gpJAFzxXwKrwWr7O/
4zBmeaTWatmSDAEnBQXexKnwMHIC0EGVF/FpMiZTRwVKWTBf4Uh8510GOenDotba2DQ45Nrq8NBi
RGMapR4SYCw3AkaEOp7aweUZHFnyZju4PlXaJ0coJXT+6EYsMSM0G7YlTzvm8tIScUaocFdq7HtI
mkAwmeguUV/Oqgs4Amr0ZDYwpb4qPQDA3gBSbnYtKRNyslQ45lbPNDqmTtxgTCwtNmhDeRY8US0u
VVEuRnCsNNNfya+WQWxWrdbmCZYQzd8IhxRT6S/aZ5JBlNOWvW+1NP2YBBIqEyl5+DmtYVAhBJoI
HDg=
--00000000000077c70105e54ecf66--
