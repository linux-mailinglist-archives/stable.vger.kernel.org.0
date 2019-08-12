Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA048A167
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfHLOnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 10:43:42 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:44509 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfHLOnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 10:43:41 -0400
Received: by mail-ot1-f48.google.com with SMTP id b7so109367734otl.11
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 07:43:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=1OmB4iwvhQPeAU/L2GPoWY4Uo/IMdHxe6xF50ADBtFo=;
        b=LJj0KzoL5/EdTq/6zDgv0zU4OGyLq1fVGPI3gU+s4vKaMeu/9vTQ9Wtrt4pu+YOfj2
         yCOnfKZEUlllTC8xiXrz5ojUR74VWzCRhkiDiHWqrURxpc4TJozhGem3++VBH4dUXc62
         62WFtPdTunvuzNsaU9rBk3R0IIa8fcYUFYJqKtRq5NOrs8RKTSIiBHmI8LoERZeABbxk
         dTabYIW3Z3yWQ6pkzZEZ7/y2EuQWkXAAe8+UEueORBmpQT3I1nLO/juYwEGBukHvCl9Z
         VYajPkZM8es7k6l1phZD38hvmGGwvnUIfoQPS+LfrDFHmPYVpzncDUI/bxO3RnowgHMU
         UgCQ==
X-Gm-Message-State: APjAAAUgCGiLjJ/qsqVFxxz454HwDwUMMXTeJG+Gx301gsQzhfTUgRT6
        c789XOEJLvgbFX2JafU/a86YlrjZFQw=
X-Google-Smtp-Source: APXvYqyQyEuPRZAryBlw9dDxQOwVdtDGk4aNW3y/c14VkwTzfGCCTj33VINc/4rZK2aJpR9lxjsULw==
X-Received: by 2002:aca:bc06:: with SMTP id m6mr15172443oif.65.1565621020418;
        Mon, 12 Aug 2019 07:43:40 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id q17sm35548262otf.54.2019.08.12.07.43.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 07:43:39 -0700 (PDT)
To:     Stable <stable@vger.kernel.org>
From:   Major Hayden <major@redhat.com>
Subject: Reports from the CKI Project are back!
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <166c8369-e09f-6395-ca0e-e8825767ca75@redhat.com>
Date:   Mon, 12 Aug 2019 09:43:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hello there,

The CKI is pleased to announce that we are enabling automated reports again for the stable mailing list! We now upload more logs to help with troubleshooting failures.

Build logs from a failed kernel compile are uploaded to our artifacts server instead of being sent with the report email as an attachment.

The logs from our testing phase (when we boot the kernel on a host and run tests) are also available on the artifacts server. This should make it easier to understand why a particular test failed. Take a look at a recent stable kernel test[0] to see the new test logs.

Our testing is focused heavily on the latest kernel updates, so we will keep tracking the latest stable kernel version. Testing against 4.19 has been challenging for us since it's not our main focus, so we dropped testing for 4.19 from our system.

Our team is eager to get your feedback! If you find something that you like, or if you find something that could be improved, please let us know anytime at cki-project@redhat.com.

[0] https://artifacts.cki-project.org/pipelines/94406/

- --
Major Hayden
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG/mSZJWWADNpjCUrc3BR4MEBH7EFAl1RexgACgkQc3BR4MEB
H7Fahw/+ODp9o56oa9RPxDUEBIHuviJ3/EcT6Y8wzmTwgLlBUbrtYuAHfRC8xG6q
piNTHa3bJpBbnXmL30BOaQnVgmpkdwFGGbBniGd6oLCmFBSWh60MO1f2lpVfeOfS
H0I5IyFT1o1diZ+BQCj9ptasuiVUH2OYmqdxfzA/mRP0wU7npyz70RdzCQ3lBxJb
wztD5gltZ3JpdDrZ6R5uhurM0FB6zsh5bY8MdX+dBIVvAnISlIxgcgfI21Q4b3x+
9DwG++idg1KdIyJGbEaAfwqB+7iJqhOKgtbISqyqNQXfbj6DeoicrP90Mb4Rwpmt
/yEOBkympp3o0/xsBLFjQxfoqLANimHakCh7PwJADFdcQXmE02qM4caLjujpLQyP
85ZyReJBqICIo/pA4OnuyB5zsvLQLemGIHaBhtw8loKgl4zEx3oAa6WoiuASGTWZ
Kpi42Eukahs44jo7BV7KSfuKRegUQ9Ut6FjoiD8VFlJWccsL/M+2Tb8VzcC+1jKh
iKaQTHStQO9n8ANNrvwnSLBBxTzbnqVNmaHy0lHzD926iRwukvIwf2qV9xD/UA24
3lnbglDCGZxm9LQTYUo4GVBl+b/FbhMSvnJe3+Ci2hdDalK+4/hBMohDNdOKg4wv
/FfvCg6VGz/0Bm/29j+XPySXS5WI1wjGtOlC+IbSCyu3kIBU6hE=
=jj+9
-----END PGP SIGNATURE-----
