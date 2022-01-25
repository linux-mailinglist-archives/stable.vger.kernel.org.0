Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF30B49B44A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 13:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356871AbiAYMuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384559AbiAYMpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:45:51 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8D6C061751
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 04:45:50 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e16so8872293pgn.4
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 04:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:user-agent:mime-version;
        bh=g8fPoNFbM2MKGQXuUpmaNAqe4Rt5cBc36ZwCaR5F95o=;
        b=dNoC//Ti2VpKHGQvJtgZMqrw/3iq4uQWDiYr9hp/8d+aAFgIdA4Y/WO4h/vyweRp4j
         ch0ZGngJdxi9Xbkq8P2uHRbiXTIkz4bl5Kqc4FAPP5s7l7OdI00x5oQ+iPAqWW7M/Lxn
         CsMOKyBjl4i6ePan2Aw5SaRn7TajJwL7a3a5PzRqaKnsIewIx7ftfk2BZ041+sRxs+lz
         ocNr5RdDJPeFYPIBqsnp6veMDZuIkDf5Jy6Q+Eb0MqVWkrm1BUqUOhgjZnpBYMQqq9Tt
         QD7/exb27ZLiOO4Jg1dow2ZOkAyMvr+ZO2TqvXGEIRX4GIyFQHiuWEfjsIqgAMI5PLPG
         3Mzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version;
        bh=g8fPoNFbM2MKGQXuUpmaNAqe4Rt5cBc36ZwCaR5F95o=;
        b=FJbwfFOWnsQFOCAfs4B34Q0371OlsqC+jGmksm8weItDbaD9K+HleA9EKvjYjUK5GS
         kLSeeCj1XUsFJmQkjLxr8M/iCmBXjUh2aPDnLydF7wwokfBVAUwjdBQJ/9QhMhF+JmF9
         ck/44hrNqjIy7prMZO87bFFb4tJXuGHsjBbB42dJU6/xGF2unrHazagu9itHvCGvNUBQ
         ovKCKNiwiRw3eUyiDwQDduaDjYLYEJXv9Cx4h8e4sFPRKPq7qlXjO+lX6Qyd2NFOiSoC
         Z2hb+Yafp5H9QL/97f/J1szANPzOohQuWFHUhpE9O99qfPiqxADQ9Qrvc3GmtdA3xH/c
         VSmw==
X-Gm-Message-State: AOAM531fwQXcBLHII7m9gFe4ntyklpfmqOOyl5wDQygaLbLTGi/POPdE
        GybjQmOJtuKjmo+sWgGIe89ROzUy21l86vtr
X-Google-Smtp-Source: ABdhPJw7vfyggNO09DCqL25gUQwAaCS0IWO8zAjg0K/+L8URMePIy1z5j0CBiq5Y118WTwfgGCvobw==
X-Received: by 2002:a05:6a00:114d:b0:4c4:3df:edf8 with SMTP id b13-20020a056a00114d00b004c403dfedf8mr18365857pfm.54.1643114750098;
        Tue, 25 Jan 2022 04:45:50 -0800 (PST)
Received: from [192.168.1.32] ([122.178.19.178])
        by smtp.gmail.com with ESMTPSA id s3sm348125pji.31.2022.01.25.04.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 04:45:49 -0800 (PST)
Message-ID: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
Subject: review for  5.16.3-rc2
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg KH <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 25 Jan 2022 18:15:46 +0530
Content-Type: multipart/mixed; boundary="=-a4u6oguv8pYyTbmRWk8O"
User-Agent: Evolution 3.42.3-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-a4u6oguv8pYyTbmRWk8O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

hello greg,

compile failed for  5.16.3-rc2 related.
a relevent file attached.

Tested-by : Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


-- 
software engineer
rajagiri school of engineering and technology - autonomous



--=-a4u6oguv8pYyTbmRWk8O
Content-Disposition: attachment; filename="5.16.3-rc2.txt"
Content-Type: text/plain; name="5.16.3-rc2.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

CWNoYXIgKiAgICAgICAgICAgICAgICAgICAgIHR5cGV0YWI7ICAgICAgICAgICAgICAvKiAgICAy
NCAgICAgOCAqLwoKCS8qIHNpemU6IDMyLCBjYWNoZWxpbmVzOiAxLCBtZW1iZXJzOiA0ICovCgkv
KiBzdW0gbWVtYmVyczogMjgsIGhvbGVzOiAxLCBzdW0gaG9sZXM6IDQgKi8KCS8qIGxhc3QgY2Fj
aGVsaW5lOiAzMiBieXRlcyAqLwp9OwpzdHJ1Y3Qga2xwX21vZGluZm8gewoJRWxmNjRfRWhkciAg
ICAgICAgICAgICAgICAgaGRyOyAgICAgICAgICAgICAgICAgIC8qICAgICAwICAgIDY0ICovCgkv
KiAtLS0gY2FjaGVsaW5lIDEgYm91bmRhcnkgKDY0IGJ5dGVzKSAtLS0gKi8KCUVsZjY0X1NoZHIg
KiAgICAgICAgICAgICAgIHNlY2hkcnM7ICAgICAgICAgICAgICAvKiAgICA2NCAgICAgOCAqLwoJ
Y2hhciAqICAgICAgICAgICAgICAgICAgICAgc2Vjc3RyaW5nczsgICAgICAgICAgIC8qICAgIDcy
ICAgICA4ICovCgl1bnNpZ25lZCBpbnQgICAgICAgICAgICAgICBzeW1uZHg7ICAgICAgICAgICAg
ICAgLyogICAgODAgICAgIDQgKi8KCgkvKiBzaXplOiA4OCwgY2FjaGVsaW5lczogMiwgbWVtYmVy
czogNCAqLwoJLyogcGFkZGluZzogNCAqLwoJLyogbGFzdCBjYWNoZWxpbmU6IDI0IGJ5dGVzICov
Cn07ClNlZ21lbnRhdGlvbiBmYXVsdAogIExEICAgICAgLnRtcF92bWxpbnV4LmthbGxzeW1zMQog
IEtTWU1TICAgLnRtcF92bWxpbnV4LmthbGxzeW1zMS5TCiAgQVMgICAgICAudG1wX3ZtbGludXgu
a2FsbHN5bXMxLlMKICBMRCAgICAgIC50bXBfdm1saW51eC5rYWxsc3ltczIKICBLU1lNUyAgIC50
bXBfdm1saW51eC5rYWxsc3ltczIuUwogIEFTICAgICAgLnRtcF92bWxpbnV4LmthbGxzeW1zMi5T
CiAgTEQgICAgICB2bWxpbnV4CiAgQlRGSURTICB2bWxpbnV4CkZBSUxFRDogbG9hZCBCVEYgZnJv
bSB2bWxpbnV4OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Cm1ha2U6ICoqKiBbTWFrZWZpbGU6
MTE2MTogdm1saW51eF0gRXJyb3IgMjU1Cm1ha2U6ICoqKiBEZWxldGluZyBmaWxlICd2bWxpbnV4
JwokCgo=


--=-a4u6oguv8pYyTbmRWk8O--
