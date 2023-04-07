Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A976DA888
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 07:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjDGFfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 01:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDGFfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 01:35:11 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD09383CE
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 22:35:10 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id l11so1341017qtj.4
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 22:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680845710;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hlBbZOK/yS2JtjyHytP0uElRbQtRrIX5P2+4m2sD1WE=;
        b=MfmkaqB2Q2hts1YNVBfvVsls58I1/V7RUHVmJFJqJKllaf1ZHqB6D4SDM8tP68XMaT
         1BhdMXv1FfdLbBxQRT81n3ON1I3ClN01MFn0G4EXFCY7B4Ob7HxV++ONgiFTJ7zpyS4h
         lXOutGYmCyyGYDRLWM4wdfgqUEBmw7rY9jUln4XWDNTpKKsyp8+J4bTWibcaB44a7f6b
         lR1M8YVFJlvvrSQsMMg/2k64pT4fKlRKGQA5MVT2h5dBdCLwIGcs4Gcc0HHmmfFA9i4h
         RyuM3mNUxZgQmDOGCqMBJluFXCHwwA9vLikdfLduF++ioJ44DEvgsP0mB3VSDhaaqunr
         skbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680845710;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hlBbZOK/yS2JtjyHytP0uElRbQtRrIX5P2+4m2sD1WE=;
        b=oQl1r4792YNaSV07Ro4PuJJj7KQF3viBuMmuYakXBfzvh3f1hU22Ame3R962JbyCxH
         jeU+/M6ifzgl5LcRuGtxEJ7F+vXihw8yUmHVPl0uJ0mXS5pr/Tx6GluWvJkonPaaxJua
         XrMw8U3aIn8uN2vV/LzbBvizUcfElE0amvSl4dBMz6iiD4qpRvRXwORAo9mjAyLmuvbQ
         nN/+2FPaNeTZw+YP6dAtody8QyS4/M6pZXeXbg1+28zzEHe4mqRshMTkuneYxuqt1p0K
         krXubF8G8nKl2h3a4j1SRzCdZQafTXhjE0vqTda3f053Ah2WTHj1H6btXHXlMiyX65Ar
         neJQ==
X-Gm-Message-State: AAQBX9evavIp7jAKvNxBcI2Fy2cs7iSpJIb/kiliczV8l4qb2wSqcmLa
        +WWV4tdI8JDWE4hn0S/ajLHf6+33DpOeJilDSXbLyYxJAbI9h3xI6Vlm4A==
X-Google-Smtp-Source: AKy350YRNy4ZqxVOES1jE+f9fvmRW8A+Gv8SCijN2J/tj7O7f3KIjD5cuXvmxx1MfND7ZUaMaK7yrkXKlKKvaFabf0c=
X-Received: by 2002:a05:622a:152:b0:3de:d15a:847f with SMTP id
 v18-20020a05622a015200b003ded15a847fmr528638qtw.0.1680845709596; Thu, 06 Apr
 2023 22:35:09 -0700 (PDT)
MIME-Version: 1.0
From:   Khazhy Kumykov <khazhy@google.com>
Date:   Thu, 6 Apr 2023 22:34:56 -0700
Message-ID: <CACGdZYJ97rBX5JO-605WT50uEYefF4MW5HLq30cHz6QskqKPPg@mail.gmail.com>
Subject: blk-throttle hierarchical throttling fix
To:     stable@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000077dd2905f8b863eb"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000077dd2905f8b863eb
Content-Type: text/plain; charset="UTF-8"

Please take 84aca0a7e039 ("blk-throttle: Fix that bps of child could
exceed bps limited in parent") for stable 6.1

Cherry pick claims that the patch applies cleanly to previous trees.
Don't believe it. This fixes a regression introduced in 5.18 abouts

--00000000000077dd2905f8b863eb
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
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
79dydvRvmvj3iOMwTAYDVR0gBEUwQzBBBgkrBgEEAaAyASgwNDAyBggrBgEFBQcCARYmaHR0cHM6
Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDAYDVR0TAQH/BAIwADCBmgYIKwYBBQUH
AQEEgY0wgYowPgYIKwYBBQUHMAGGMmh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2NhL2dzYXRs
YXNyM3NtaW1lY2EyMDIwMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29t
L2NhY2VydC9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcnQwHwYDVR0jBBgwFoAUfMwKaNei6x4schvR
zV2Vb4378mMwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9jYS9n
c2F0bGFzcjNzbWltZWNhMjAyMC5jcmwwDQYJKoZIhvcNAQELBQADggEBAAGnXU1ZiVtfDel8V5Gu
zLG4WAXkeOocZbaQLxMU5feXzEkBi9FsW/dimVGtpWlhHCt6EFKWj47cJIAf4FbcsZGksqwaEanw
AnYkE13+a2FcNcY39KIX2Jq+WEIaqJMZdEHUNgMA6RZ57HHfuwwYv0vpuH7wPZq+g86FLEAdWMf8
jOTcRWOfNGc1TvLIunL1SLCwWbxvmz7XbXvHBeesFACzShCWrLWLJU2ynbWPQ50fD7VyLF1hmoh1
yRYhUSah9MWOcjE2cv+RaQ4tpZFaylpeF3MKpzfV/oTBD4fc+fOvhrc4jTTZ4jifPwmXnH6+XP4V
DTqxVuiAl9HipVxiQnoxggJqMIICZgIBATBoMFQxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFzIFIzIFNNSU1FIENBIDIwMjAC
EAEurwvH4YF1ESpB5qmUbowwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIP3FwzZ2
drXFw4SyeG9sAcvc6Hem8rNA2DGU5dRD4UpRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMDQwNzA1MzUxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBi9itChCEsNogWIRRLxAMo4Cdu
pXW9vlyQiAHcPLtptt2xbiS5sibBxUxSXodioOOd2JX0WpYyPVUFfDY1FfWyKomiUvFEqtqlJgew
KCsAOQoWD7GGkSWC9JJaeGBbmEtDK9jBINMnbS7wCGDhN7N9czrv1XrvUphrdFFcxtEf0RywkVPE
ibYEyLN9QCkb69nXXtxkbO2AbVI4UlVOAd9+X6qaj63CVcogMddQZWY+RR3J3+Oaxcr8Iox27ycn
f+SJiXnJgL8TCB017yzYFNHifrk1THaMbNRFK7I8acHsReb4/CQgxfZHR2aryYnIQXvAHillqpLB
RUWwQ+heIjT9
--00000000000077dd2905f8b863eb--
