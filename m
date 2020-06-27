Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA0E20C0EA
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 13:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgF0LCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 07:02:05 -0400
Received: from sonic307-1.consmr.mail.bf2.yahoo.com ([74.6.134.40]:41324 "EHLO
        sonic307-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgF0LCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jun 2020 07:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1593255723; bh=UXgtDsRN7lwk5hslMhDS77KoWasIDbV8j6zhJXeW8ys=; h=Date:From:Reply-To:Subject:References:From:Subject; b=PgOwB9zsVZhpstLOvg0beYAs0KRxMTsYeoK9KyQlydbeWRNrySWnjM0MmBg+lkzm+Eq/O2piULnthJokCDE8DTjtIrxdfc6g/6UhIB/8obaegkmbHOhEiB2GBxlCdG+gDQW/zBDGF9Jf1CddfDFqcdDTR2skndGXsM0PdW+KNn9ibnxIaSDETztbJU1KdbbMY4U9YXVHLL0ft4aRz8h5ducwzvZsAlmDMmlBZ1xA95X3aQcSbvXfYK9ABq9jVATNK4HrTz71W4K+rOgamDu0h4bLJLDWsiAkOkwSfbiMH0ED58uSj4n3YL5iNU35nwuEMVfU8aLGzwaM2y2cv0JDcA==
X-YMail-OSG: BCsoXsEVM1kPxc5X5TiPmmwhsl_Sq3ODD3Arl036uZBV4BG_Wl7ALgbeOjGd.As
 osd_DcqwypzTwP6ccZ.vx5OTTya7TDKtzVXuA.8NfD7iBf04NS9NSLFry4VyehTQutDx1D2yQyiU
 GAyMFWyRUM2yddCa8ouLcTqjishcOCyCqzGPI5T8zpG8PQxfwTE0ouItMAeIdroI.8qx20dRxAxK
 0sjhH1BZzkfEvJOcua17hwyqt2lR8xeYCXQDKxP1vXjqlIiU24UwX8_xonKQRAdUQtzA3KRdv7nl
 .UtHdERT6gveQJKf85.QOIKk9LUp.pIOBVLTeq8kcvSRCrqO_.m7OVqmxvdrRyCL5hDyypnVP8Ak
 UxCkd0SdJZq1nZIgCOnO6jmz4FxJ7da44_Ek0gad.Odf.7ibxfKPV.0gSfd4lhIXGh40Dl54Dgda
 9ErI9T2Hq48e0fhiI2Y8LEaG3ej1yyce8mXEfs8xl_v8qPwZkbv03W40oUQag6XxbhwvS_3HxySP
 TW1hqHIPIxc_hE4iaPR8EzolOs1Y9w2zMo1B5fCalLyvW9dJH6kTBtN_Aiorf0a0tGqQ0hfIa19d
 GTfnW7rdL.NO0Y.vqY89NjPhi9HyrP0redhrnNI2FLORuYeO6AxlUteRnYqRhN7.RCNTtOBBa.Su
 C6D0KlRZEo4iInKzHT8VOS.6JXFwMn_U.UEx3eYbKMoQ..CU9TJKTvlCioWCfzSBxLTJSWdm3pNU
 KKpzvXhKadzuWFcj7zqd5yq9qL5cbzfomg3zmnmw4iLoD4pld5KjFrEtVeHG_93y9pkbIH6CgFHC
 e6uOrqyxvnhTTWBUt5MtmLq_wVrKEHEyAaBbpIEstYxUA2g10IjhUkKQXLwJ.cieawuvKjwr9qox
 8gB7dPWez8ybSjfyk7chgY3OMMj_cszI0hhqwMpi1opWMchHoff0ZZfSt.lCCjoVYjNvK34Qjk7E
 Cd441aCyCgwS70j_nkF_0_xAG43I.z3JWdtOhuUuTyTLg0oxxocyFPmWwmV.u6bWkZKlDlRjrbPx
 tfNgtexkdiCCXw7IGtWTrV4_0pfnpuljJsYs9RsGUoX13EDv9L7JuXlkIYuKi0dxlRm_s0fLvgvV
 YBLJ.FvYUyE5m78DwbIj6NI0iK..VscpyEmUS2.Wd.xVFszTlpqacUVzsRCIS1aAyDYgHAdT09xW
 5RgJLbHh_cI6VQvnbaUrz7C7wa4tzcKqN9PShSzHw58QEPNSSbgVpnRqgt0Mckk_5tLrxLmIEsHK
 wlU1izXel016z9Mb0hHIM6No71gTtfYHUHOXth9ItYbVKN5AKzHslkSX1jDtR4qyQu_WLU0I-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Sat, 27 Jun 2020 11:02:03 +0000
Date:   Sat, 27 Jun 2020 11:01:58 +0000 (UTC)
From:   Miss Abibatu Ali <abibatuali01@gmail.com>
Reply-To: abibatu22ali@gmail.com
Message-ID: <1430393398.3201143.1593255718669@mail.yahoo.com>
Subject: Dear.Friend
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1430393398.3201143.1593255718669.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:77.0) Gecko/20100101 Firefox/77.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear.Friend
I am Mrs. Abibatu. I am sending this brief letter to solicit
your partnership to transfer a sum of 11.9 Million Dollars into your
reliable account as my business partner. However, it's my urgent need
for foreign partner that made me to contact you for this transaction.
Further details of the transfer will be forwarded to you if you are
ready to assist me.
Best Regards.
Mrs.Abibatu Ali
