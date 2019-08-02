Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D2D7FBED
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 16:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436644AbfHBOTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 10:19:08 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44770 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfHBOTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 10:19:08 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so72487666edr.11;
        Fri, 02 Aug 2019 07:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S+20xmULIleEgfurI+8J/o6iN60n5mNoEMYMpzqwBn0=;
        b=I5R/SbOCUyNpGi/j5ETYAUO8K7/Z+fCVItbSmqyN79qPhkMCfaoRZnqC1ZNRtL0/QP
         YsF0FSkOb75Qgelvv0hD2fQF8hh2Y5lWRg4gYFtpcMZcBrNd6rstIxVNbqeiAfbn/PQy
         PphA5CmAwCX+3uzCii5HPuO/3QOkqr9+bXOAhxQ4+PMEiSXCOJArrW+qyeD9DO1wf6Qu
         CzuDPMCXEmere7MHNMEEH8eSfRUolI/g1X8vwtQnaGjvwBYglDxB/NLGtBHv45S28FNS
         xTmxZt0A6Ff3CYcg9nIXeVQsz05JXDxS1SNbAfXN2owwZFFj/dlpsDRnLWaYSUlksYIR
         JajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=S+20xmULIleEgfurI+8J/o6iN60n5mNoEMYMpzqwBn0=;
        b=UMwOSXXc5Wguv+lGDvCJCFCcsO7jSMWp1+QQrm47E6BxTB339SrevkyyLJZJ71xxMc
         brxdy1Wz6A1fSG6Ast25hFSmvKWUjV6ajuUq7EKaYdgcP+81mlwFVVNdIxrZIlkC964k
         lYpHabS/Aa/0iCDACEMBJTf2arn7lPY1AEyxkETvkw2q/9RctkWT5dhYqvasgdUKQ0Eg
         ZqpoGBD8pbbMzYMYCFWFO2K8q4DzWG/0X47QN48EC8S3j6qbQQQmBqfJCdWEEWVg2NmX
         MGHazQdL+8EzaEOwDqqACklR+YpJTkwTtlQz0KgGEoz06Co6g1cyWtEPiCg6bSToUke5
         Tc6Q==
X-Gm-Message-State: APjAAAW8ID0yKPZnE9oOdfya/K26hGK2hEOHOfdEMZ6FZxS9WZh3PuzI
        aaDEkzAQ1KEpH930kwqmYgI=
X-Google-Smtp-Source: APXvYqy5YJPKTxgGPhjH5kwyrm9Ly98QXxCID8DOnXDCaD0/Lm5hWk8MsjiIsiPNPEhadgoxC319rg==
X-Received: by 2002:a17:906:e2c2:: with SMTP id gr2mr105900563ejb.284.1564755546154;
        Fri, 02 Aug 2019 07:19:06 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id k5sm13005950eja.41.2019.08.02.07.19.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 07:19:05 -0700 (PDT)
Date:   Fri, 2 Aug 2019 16:19:04 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        Jon Hunter <jonathanh@nvidia.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.9 000/223] 4.9.187-stable review
Message-ID: <20190802141904.GA11962@ulmo>
References: <20190802092238.692035242@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 02, 2019 at 11:33:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.187 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.187=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.9.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra...

Test results for stable-v4.9:
    8 builds:   8 pass, 0 fail
    16 boots:   16 pass, 0 fail
    24 tests:   24 pass, 0 fail

Linux version:  4.9.187-rc1-g5380ded2525d
Boards tested:  tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl1ERlMACgkQ3SOs138+
s6G5vhAAgZZWGODGGHY5R4k9PVj954QvJEyPIf8BK9D016s0YV9ki06E3d9unoMh
JbOzHZrwCEWP4Af4s1J64DaxA5OVnAx9+6m+WcDjdZHYvNPodb3ILHzLcWGoV+PZ
yJkTP9WTv+Mk91BOvQqYdRp0CDSSrpDFXNUcP2UPVzo495R61A0qfJAtg5XtmiA9
FScV4ceQjWpoDA81sThSgNquUinZsGAeV4At7ovvM2XDIU++SIrIugVY0WxqtEc5
exMwzhNvKNxGoR1rBNYC3k4DfaOtyBpVogK8JsNQoM6bIvrlTHjTucqaSdoCON6n
Df8a5EiR0X81zIPyeQFROWfL2bcQQt+rK+tcCXjgGEk8ODSZWN7nnwjgfr3iw4ag
8qSjJnD6jIsgpFvhC5a//c5qSLWy2ResoN5eD5G7pSbTrZmiNDGaW12kcJat9GVV
sraa9gmIkMcSyHHI1G9r4fMA4ZEQcEaoLr8dHmHexUMI+0KhmCJQ7pXqwKP8txOh
zWfocPBthLS2hes3JYhOsJDUhMFnxlWRYEBcLxf4kSmMN0G9x+0/7Bp2k24UeufN
qKGC5b24qiu9Je9EOWOmvRGbVuzi+HXX0CJ5BB4Gj7qUQboIEtXmXIisw8EbYJFM
9jySs4LwlQHnplX1pV3PymqNPwDxmcl4NqY7/ubrBhzUxDzmZX0=
=fv1b
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
